#!/bin/bash
# Post-webhook analysis hook
# Automatically triggered after webhook-receiver.sh processes test results
# Provides additional analysis and actionable insights

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$SCRIPT_DIR/..}"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [POST-HOOK] $*" >&2
}

# Extract report directory from webhook receiver output
report_dir="${1:-}"

if [[ -z "$report_dir" || ! -d "$report_dir" ]]; then
    log "No valid report directory provided, skipping post-analysis"
    exit 0
fi

log "Post-webhook analysis triggered for: $report_dir"

# Check if analysis results exist
analysis_json="$report_dir/analysis-results.json"

if [[ ! -f "$analysis_json" ]]; then
    log "⚠️  No analysis results found, skipping post-processing"
    exit 0
fi

# Extract key metrics
failed_count=$(jq -r '.summary.failed // 0' "$analysis_json")
error_count=$(jq -r '.summary.errors // 0' "$analysis_json")

log "Test Results: Failed=$failed_count, Errors=$error_count"

# If there are failures, provide additional context
if [[ "$failed_count" -gt 0 || "$error_count" -gt 0 ]]; then
    log "⚠️  Failures detected - additional analysis recommended"

    # Check for HAR files
    har_files=$(find "$report_dir" -name "*.har" -type f 2>/dev/null | wc -l | tr -d ' ')

    if [[ "$har_files" -gt 0 ]]; then
        log "📊 Found $har_files HAR files for network analysis"
    fi

    # Check for screenshots
    screenshots=$(find "$report_dir" -name "*.png" -type f 2>/dev/null | wc -l | tr -d ' ')

    if [[ "$screenshots" -gt 0 ]]; then
        log "📸 Found $screenshots screenshots for visual debugging"
    fi

    # Check for session recording links
    if grep -q "logrocket\|devicefarm" "$report_dir"/*.log 2>/dev/null; then
        log "🎥 Session recordings available for replay"
    fi
fi

log "✅ Post-webhook analysis complete"