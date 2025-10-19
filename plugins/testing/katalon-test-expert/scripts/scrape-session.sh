#!/bin/bash

# Session Recording Scraper
# Scrapes LogRocket and AWS Device Farm session recordings using Firecrawl MCP
# Usage: ./scrape-session.sh <session-url> [output-file]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
OUTPUT_FILE="${2:-session_data.json}"
TEMP_DIR=$(mktemp -d)
COOKIES_FILE="${KATALON_SESSION_COOKIES:-$HOME/.katalon-session-cookies.txt}"

# Function to detect session type
detect_session_type() {
    local url="$1"

    if echo "$url" | grep -q "logrocket.com"; then
        echo "logrocket"
    elif echo "$url" | grep -q "devicefarm"; then
        echo "aws_device_farm"
    else
        echo "unknown"
    fi
}

# Function to check if Firecrawl MCP is available
check_firecrawl_mcp() {
    # This will be called by Claude Code which has access to MCP tools
    # Just a placeholder for shell script
    echo -e "${BLUE}Checking for Firecrawl MCP server...${NC}"
}

# Function to scrape LogRocket session
scrape_logrocket() {
    local url="$1"

    echo -e "${BLUE}Scraping LogRocket session...${NC}"
    echo -e "${YELLOW}URL: ${url}${NC}"

    # Extract session ID from URL
    local session_id=$(echo "$url" | grep -oP 's/\K[^/]+' | head -1)

    echo -e "${BLUE}Session ID: ${session_id}${NC}"

    # Note: Actual scraping will be done via Firecrawl MCP in Claude Code
    # This script provides the structure and instructions

    cat > "$TEMP_DIR/logrocket_scrape_spec.json" <<EOF
{
  "url": "$url",
  "session_type": "logrocket",
  "session_id": "$session_id",
  "elements_to_extract": [
    {
      "name": "console_logs",
      "selector": "[data-test-id='console-log-item']",
      "attributes": ["data-timestamp", "data-level", "data-message"]
    },
    {
      "name": "network_requests",
      "selector": "[data-test-id='network-request']",
      "attributes": ["data-url", "data-method", "data-status", "data-duration"]
    },
    {
      "name": "user_events",
      "selector": "[data-test-id='user-event']",
      "attributes": ["data-timestamp", "data-event-type", "data-element"]
    },
    {
      "name": "errors",
      "selector": "[data-test-id='error-event']",
      "attributes": ["data-timestamp", "data-message", "data-stack"]
    },
    {
      "name": "session_metadata",
      "selector": "[data-test-id='session-metadata']",
      "attributes": ["data-browser", "data-os", "data-duration", "data-url"]
    },
    {
      "name": "performance_metrics",
      "selector": "[data-test-id='performance-metric']",
      "attributes": ["data-metric", "data-value", "data-unit"]
    }
  ],
  "wait_for": "[data-test-id='timeline-loaded']",
  "timeout": 30000
}
EOF

    echo -e "${GREEN}✓ Scrape specification created${NC}"
    echo -e "${BLUE}Specification: $TEMP_DIR/logrocket_scrape_spec.json${NC}"
}

# Function to scrape AWS Device Farm session
scrape_device_farm() {
    local url="$1"

    echo -e "${BLUE}Scraping AWS Device Farm session...${NC}"
    echo -e "${YELLOW}URL: ${url}${NC}"

    # Extract session/run ID from URL
    local session_id=$(echo "$url" | grep -oP 'logs/\K[^/?]+' | head -1)

    echo -e "${BLUE}Session ID: ${session_id}${NC}"

    cat > "$TEMP_DIR/device_farm_scrape_spec.json" <<EOF
{
  "url": "$url",
  "session_type": "aws_device_farm",
  "session_id": "$session_id",
  "elements_to_extract": [
    {
      "name": "test_details",
      "selector": ".test-run-details",
      "attributes": ["data-status", "data-duration", "data-device"]
    },
    {
      "name": "logs",
      "selector": ".log-entry",
      "attributes": ["data-timestamp", "data-level", "data-message"]
    },
    {
      "name": "video_url",
      "selector": "video source",
      "attributes": ["src"]
    },
    {
      "name": "screenshots",
      "selector": ".screenshot-thumbnail",
      "attributes": ["src", "data-timestamp"]
    },
    {
      "name": "device_logs",
      "selector": ".device-log-line",
      "attributes": ["data-timestamp", "data-message"]
    },
    {
      "name": "performance_data",
      "selector": ".performance-metric",
      "attributes": ["data-cpu", "data-memory", "data-network"]
    }
  ],
  "wait_for": ".test-run-loaded",
  "timeout": 30000
}
EOF

    echo -e "${GREEN}✓ Scrape specification created${NC}"
    echo -e "${BLUE}Specification: $TEMP_DIR/device_farm_scrape_spec.json${NC}"
}

# Function to extract structured data from scraped content
structure_session_data() {
    local session_type="$1"
    local raw_data="$2"

    echo -e "${BLUE}Structuring session data...${NC}"

    # This will be processed by Claude Code using the scraped data
    # Creating template for structured output

    if [ "$session_type" = "logrocket" ]; then
        cat > "$OUTPUT_FILE" <<EOF
{
  "session_type": "logrocket",
  "session_id": "",
  "session_url": "",
  "scraped_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "session_metadata": {
    "browser": "",
    "os": "",
    "duration_seconds": 0,
    "page_url": "",
    "user_agent": ""
  },
  "timeline": {
    "console_logs": [],
    "network_requests": [],
    "user_events": [],
    "errors": []
  },
  "performance": {
    "page_load_time_ms": 0,
    "dom_content_loaded_ms": 0,
    "first_paint_ms": 0,
    "largest_contentful_paint_ms": 0
  },
  "network_summary": {
    "total_requests": 0,
    "failed_requests": 0,
    "average_response_time_ms": 0,
    "slowest_requests": []
  },
  "errors_summary": {
    "total_errors": 0,
    "javascript_errors": 0,
    "network_errors": 0,
    "console_errors": 0
  }
}
EOF
    elif [ "$session_type" = "aws_device_farm" ]; then
        cat > "$OUTPUT_FILE" <<EOF
{
  "session_type": "aws_device_farm",
  "session_id": "",
  "session_url": "",
  "scraped_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "test_details": {
    "status": "",
    "duration_seconds": 0,
    "device": "",
    "os_version": "",
    "browser": ""
  },
  "logs": {
    "application_logs": [],
    "device_logs": [],
    "selenium_logs": []
  },
  "artifacts": {
    "video_url": "",
    "screenshots": [],
    "har_files": []
  },
  "performance": {
    "cpu_usage": [],
    "memory_usage": [],
    "network_usage": []
  },
  "errors": []
}
EOF
    fi

    echo -e "${GREEN}✓ Data structure template created${NC}"
}

# Function to display authentication instructions
show_auth_instructions() {
    local session_type="$1"

    echo -e "\n${YELLOW}⚠️  AUTHENTICATION REQUIRED${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    if [ "$session_type" = "logrocket" ]; then
        cat <<EOF

${YELLOW}LogRocket sessions require authentication (SSO).${NC}

Option 1: Use Browser Cookies
${GREEN}1.${NC} Log into LogRocket in your browser
${GREEN}2.${NC} Export cookies to file:
   ${BLUE}# Chrome: Use "EditThisCookie" extension${NC}
   ${BLUE}# Firefox: Use "Cookie Quick Manager" extension${NC}
   ${BLUE}# Safari: Use "Cookie" extension${NC}

${GREEN}3.${NC} Save cookies to: ${BLUE}$COOKIES_FILE${NC}

Option 2: Use Session Token
${GREEN}1.${NC} Log into LogRocket
${GREEN}2.${NC} Open DevTools → Network tab
${GREEN}3.${NC} Find request to LogRocket API
${GREEN}4.${NC} Copy Authorization header value
${GREEN}5.${NC} Set environment variable:
   ${BLUE}export LOGROCKET_SESSION_TOKEN="Bearer ..."${NC}

Option 3: Manual Scraping
${GREEN}1.${NC} Open LogRocket session in browser
${GREEN}2.${NC} Manually export session data (if available)
${GREEN}3.${NC} Or take screenshots of key information

EOF
    elif [ "$session_type" = "aws_device_farm" ]; then
        cat <<EOF

${YELLOW}AWS Device Farm requires AWS credentials.${NC}

Option 1: AWS CLI Configured
${GREEN}✓${NC} If you have AWS CLI configured, authentication is automatic

Option 2: AWS Session Token
${GREEN}1.${NC} Get temporary AWS session token
${GREEN}2.${NC} Set environment variables:
   ${BLUE}export AWS_ACCESS_KEY_ID="..."${NC}
   ${BLUE}export AWS_SECRET_ACCESS_KEY="..."${NC}
   ${BLUE}export AWS_SESSION_TOKEN="..."${NC}

Option 3: SSO Login
${GREEN}1.${NC} Run: ${BLUE}aws sso login --profile your-profile${NC}
${GREEN}2.${NC} Set profile: ${BLUE}export AWS_PROFILE=your-profile${NC}

EOF
    fi

    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Main script logic
main() {
    if [ -z "$1" ]; then
        echo -e "${RED}Error: Session URL required${NC}"
        echo ""
        echo "Usage: $0 <session-url> [output-file]"
        echo ""
        echo "Examples:"
        echo "  $0 https://app.logrocket.com/org/project/s/session-id"
        echo "  $0 https://us-west-2.console.aws.amazon.com/devicefarm/.../logs/session-id"
        echo ""
        exit 1
    fi

    local session_url="$1"
    local session_type=$(detect_session_type "$session_url")

    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}   Katalon Session Recording Scraper${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${BLUE}Session URL:${NC} $session_url"
    echo -e "${BLUE}Session Type:${NC} $session_type"
    echo -e "${BLUE}Output File:${NC} $OUTPUT_FILE"
    echo ""

    if [ "$session_type" = "unknown" ]; then
        echo -e "${RED}✗ Unknown session type${NC}"
        echo -e "${YELLOW}Supported session types:${NC}"
        echo -e "  - LogRocket (app.logrocket.com)"
        echo -e "  - AWS Device Farm (console.aws.amazon.com/devicefarm)"
        exit 1
    fi

    # Show authentication instructions
    show_auth_instructions "$session_type"

    # Check for Firecrawl MCP
    check_firecrawl_mcp

    # Create scrape specification
    if [ "$session_type" = "logrocket" ]; then
        scrape_logrocket "$session_url"
    elif [ "$session_type" = "aws_device_farm" ]; then
        scrape_device_farm "$session_url"
    fi

    # Create data structure template
    structure_session_data "$session_type" ""

    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✓ Scrape preparation complete${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${YELLOW}Next Steps:${NC}"
    echo -e "${GREEN}1.${NC} Ensure authentication is configured (see above)"
    echo -e "${GREEN}2.${NC} Use Claude Code with Firecrawl MCP to scrape the session"
    echo -e "${GREEN}3.${NC} Scrape spec available at: ${BLUE}$TEMP_DIR/*_scrape_spec.json${NC}"
    echo -e "${GREEN}4.${NC} Output will be saved to: ${BLUE}$OUTPUT_FILE${NC}"
    echo ""
    echo -e "${BLUE}Tip:${NC} Use the ${GREEN}/scrape-session${NC} command in Claude Code for automatic scraping"
    echo ""
}

# Run main function
main "$@"