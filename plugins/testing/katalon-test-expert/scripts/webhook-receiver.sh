#!/bin/bash
# Katalon Test Results Webhook Receiver
# Receives webhook payload from Teams containing signed S3 URL with test results
# Downloads and processes the test results automatically

set -euo pipefail

# ============================================================================
# Configuration
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$SCRIPT_DIR/..}"
DOWNLOAD_DIR="${KATALON_DOWNLOAD_DIR:-$PLUGIN_ROOT/resources/webhook-downloads}"
PARSER_SCRIPT="$PLUGIN_ROOT/scripts/katalon-report-parser.py"

# ============================================================================
# Helper Functions
# ============================================================================

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >&2
}

error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $*" >&2
}

# Extract S3 URL from webhook payload
extract_s3_url() {
    local payload="$1"

    # Try multiple JSON paths where the URL might be
    local s3_url=""

    # Try common webhook payload structures
    if echo "$payload" | jq -e '.s3_url' &>/dev/null; then
        s3_url=$(echo "$payload" | jq -r '.s3_url')
    elif echo "$payload" | jq -e '.url' &>/dev/null; then
        s3_url=$(echo "$payload" | jq -r '.url')
    elif echo "$payload" | jq -e '.testResults.url' &>/dev/null; then
        s3_url=$(echo "$payload" | jq -r '.testResults.url')
    elif echo "$payload" | jq -e '.data.s3Url' &>/dev/null; then
        s3_url=$(echo "$payload" | jq -r '.data.s3Url')
    elif echo "$payload" | jq -e '.attachments[0].contentUrl' &>/dev/null; then
        # Teams adaptive card attachment format
        s3_url=$(echo "$payload" | jq -r '.attachments[0].contentUrl')
    else
        # Try to find any URL-like string that contains s3 or amazonaws
        s3_url=$(echo "$payload" | grep -oP 'https://[^"]*\.s3[^"]*\.amazonaws\.com[^"]*' | head -1 || echo "")
    fi

    if [[ -z "$s3_url" || "$s3_url" == "null" ]]; then
        error "Could not extract S3 URL from webhook payload"
        log "Payload received: $payload"
        return 1
    fi

    echo "$s3_url"
}

# Extract metadata from webhook payload
extract_metadata() {
    local payload="$1"

    # Extract useful metadata
    local test_suite=$(echo "$payload" | jq -r '.testSuite // .suite // "Unknown"' 2>/dev/null || echo "Unknown")
    local environment=$(echo "$payload" | jq -r '.environment // .env // "Unknown"' 2>/dev/null || echo "Unknown")
    local timestamp=$(echo "$payload" | jq -r '.timestamp // .executionTime // empty' 2>/dev/null || date -u +"%Y-%m-%dT%H:%M:%SZ")
    local build_id=$(echo "$payload" | jq -r '.buildId // .build // "Unknown"' 2>/dev/null || echo "Unknown")

    cat <<EOF
{
    "testSuite": "$test_suite",
    "environment": "$environment",
    "timestamp": "$timestamp",
    "buildId": "$build_id"
}
EOF
}

# Download file from S3 URL
download_from_s3() {
    local s3_url="$1"
    local download_dir="$2"

    # Create download directory with timestamp
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local report_dir="$download_dir/test-results-$timestamp"
    mkdir -p "$report_dir"

    log "Downloading test results from S3..."
    log "URL: $s3_url"

    # Determine file type from URL
    local filename=$(basename "$s3_url" | cut -d'?' -f1)
    local extension="${filename##*.}"

    local download_path="$report_dir/$filename"

    # Download using curl with retry logic
    local max_retries=3
    local retry_count=0

    while [ $retry_count -lt $max_retries ]; do
        if curl -L -f -o "$download_path" "$s3_url" 2>&1; then
            log "✅ Download successful: $download_path"
            break
        else
            retry_count=$((retry_count + 1))
            if [ $retry_count -lt $max_retries ]; then
                log "⚠️  Download failed, retrying ($retry_count/$max_retries)..."
                sleep 2
            else
                error "❌ Download failed after $max_retries attempts"
                return 1
            fi
        fi
    done

    # Extract if it's a zip/tar file
    if [[ "$extension" == "zip" ]]; then
        log "Extracting ZIP archive..."
        unzip -q "$download_path" -d "$report_dir"
        rm "$download_path"
    elif [[ "$extension" == "tar" || "$extension" == "gz" || "$extension" == "tgz" ]]; then
        log "Extracting TAR archive..."
        tar -xzf "$download_path" -C "$report_dir"
        rm "$download_path"
    fi

    echo "$report_dir"
}

# Process Katalon test results
process_test_results() {
    local report_dir="$1"
    local metadata="$2"

    log "Processing Katalon test results..."

    # Check if parser script exists
    if [[ ! -f "$PARSER_SCRIPT" ]]; then
        error "Katalon report parser not found at: $PARSER_SCRIPT"
        return 1
    fi

    # Find the report directory (might be nested)
    local actual_report_dir="$report_dir"

    # Look for common Katalon report indicators
    if [[ ! -f "$report_dir/execution.properties" ]]; then
        # Try to find execution.properties in subdirectories
        local found_dir=$(find "$report_dir" -name "execution.properties" -type f | head -1)
        if [[ -n "$found_dir" ]]; then
            actual_report_dir=$(dirname "$found_dir")
            log "Found Katalon report in: $actual_report_dir"
        else
            error "Could not find Katalon report (no execution.properties found)"
            return 1
        fi
    fi

    # Save metadata alongside report
    echo "$metadata" > "$actual_report_dir/webhook-metadata.json"

    # Parse the report
    log "Running Katalon report parser..."
    python3 "$PARSER_SCRIPT" "$actual_report_dir"

    local parser_exit_code=$?

    if [[ $parser_exit_code -eq 0 ]]; then
        log "✅ Test results processed successfully"

        # Export results as JSON for further processing
        local json_output="$actual_report_dir/analysis-results.json"
        python3 "$PARSER_SCRIPT" "$actual_report_dir" --json "$json_output" 2>/dev/null || true

        if [[ -f "$json_output" ]]; then
            log "Results exported to: $json_output"

            # Print summary
            log "=== Test Results Summary ==="
            jq -r '
                "Total Tests: \(.summary.total // "N/A")",
                "Passed: \(.summary.passed // "N/A")",
                "Failed: \(.summary.failed // "N/A")",
                "Errors: \(.summary.errors // "N/A")",
                "Duration: \(.summary.duration // "N/A")"
            ' "$json_output" 2>/dev/null || log "Could not parse summary"
        fi
    else
        error "❌ Test results processing failed (exit code: $parser_exit_code)"
        return $parser_exit_code
    fi

    echo "$actual_report_dir"
}

# ============================================================================
# Main Execution
# ============================================================================

main() {
    log "Katalon webhook receiver triggered"

    # Ensure download directory exists
    mkdir -p "$DOWNLOAD_DIR"

    # Read webhook payload from stdin or first argument
    local webhook_payload=""

    if [[ $# -gt 0 ]]; then
        # Payload passed as argument
        webhook_payload="$1"
    else
        # Read from stdin
        if [ -t 0 ]; then
            error "No webhook payload provided"
            echo "Usage: $0 '<json-payload>'"
            echo "   or: echo '<json-payload>' | $0"
            exit 1
        else
            webhook_payload=$(cat)
        fi
    fi

    log "Received webhook payload"

    # Validate JSON
    if ! echo "$webhook_payload" | jq . &>/dev/null; then
        error "Invalid JSON payload"
        log "Payload: $webhook_payload"
        exit 1
    fi

    # Extract S3 URL
    log "Extracting S3 URL from payload..."
    s3_url=$(extract_s3_url "$webhook_payload")

    if [[ -z "$s3_url" ]]; then
        error "Failed to extract S3 URL"
        exit 1
    fi

    log "Found S3 URL: $s3_url"

    # Extract metadata
    metadata=$(extract_metadata "$webhook_payload")

    # Download test results
    report_dir=$(download_from_s3 "$s3_url" "$DOWNLOAD_DIR")

    if [[ -z "$report_dir" ]]; then
        error "Failed to download test results"
        exit 1
    fi

    # Process test results
    final_report_dir=$(process_test_results "$report_dir" "$metadata")

    log "=== Processing Complete ==="
    log "Report location: $final_report_dir"
    log "Metadata: $metadata"

    # Output the report directory for Claude Code to use
    echo "$final_report_dir"
}

# ============================================================================
# Entry Point
# ============================================================================

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi