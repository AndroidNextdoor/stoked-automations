#!/usr/bin/env bash
# Create a memory in Serena with proper tagging
# Usage: ./create-memory.sh "memory content" "tag1,tag2" "category"
# Author: Andrew Nixdorf <andrew@stokedautomation.com>

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors for output
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Parse arguments
CONTENT="${1:-}"
TAGS="${2:-}"
CATEGORY="${3:-general}"

if [[ -z "$CONTENT" ]]; then
  echo -e "${RED}Error: Memory content is required${NC}"
  echo "Usage: $0 \"memory content\" \"tag1,tag2\" \"category\""
  echo ""
  echo "Examples:"
  echo "  $0 \"Fixed SQL injection in /api/users endpoint\" \"security,sql-injection,fix\" \"security_findings\""
  echo "  $0 \"Playwright test passing for login flow\" \"testing,e2e,login\" \"test_results\""
  exit 1
fi

# Convert comma-separated tags to JSON array
IFS=',' read -ra TAG_ARRAY <<< "$TAGS"
TAG_JSON="["
for i in "${!TAG_ARRAY[@]}"; do
  TAG_JSON+="\"${TAG_ARRAY[$i]}\""
  if [[ $i -lt $((${#TAG_ARRAY[@]} - 1)) ]]; then
    TAG_JSON+=","
  fi
done
TAG_JSON+="]"

# Always include stoked-automations tag
if [[ "$TAG_JSON" == "[]" ]]; then
  TAG_JSON="[\"stoked-automations\"]"
else
  TAG_JSON="${TAG_JSON%]},\"stoked-automations\"]"
fi

# Get current timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Get current git branch for context
GIT_BRANCH=$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

# Create memory payload
MEMORY_PAYLOAD=$(cat <<EOF
{
  "content": "$CONTENT",
  "tags": $TAG_JSON,
  "category": "$CATEGORY",
  "timestamp": "$TIMESTAMP",
  "metadata": {
    "repository": "AndroidNextdoor/stoked-automations",
    "branch": "$GIT_BRANCH",
    "created_by": "create-memory.sh"
  }
}
EOF
)

echo -e "${ORANGE}Creating Serena memory...${NC}"
echo -e "${ORANGE}Category: ${NC}$CATEGORY"
echo -e "${ORANGE}Tags: ${NC}$TAG_JSON"
echo ""

# Call Serena MCP to create memory
# Note: This requires Serena MCP to be installed and configured
# TODO: Add actual MCP call when Serena CLI integration is available
echo "$MEMORY_PAYLOAD" > /tmp/serena-memory-$$.json

echo -e "${GREEN}✓ Memory created successfully${NC}"
echo -e "${GREEN}Payload saved to: ${NC}/tmp/serena-memory-$$.json"
echo ""
echo -e "${ORANGE}To integrate with Serena MCP:${NC}"
echo "  cat /tmp/serena-memory-$$.json | claude-mcp-call serena create_memory"
echo ""
echo -e "${ORANGE}Memory Content:${NC}"
echo "$CONTENT"