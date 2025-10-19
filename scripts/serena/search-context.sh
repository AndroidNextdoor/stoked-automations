#!/usr/bin/env bash
# Search Serena for relevant context using semantic search
# Usage: ./search-context.sh "query" [max_results] [category]
# Author: Andrew Nixdorf <andrew@stokedautomation.com>

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors for output
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Parse arguments
QUERY="${1:-}"
MAX_RESULTS="${2:-10}"
CATEGORY="${3:-}"

if [[ -z "$QUERY" ]]; then
  echo -e "${RED}Error: Search query is required${NC}"
  echo "Usage: $0 \"query\" [max_results] [category]"
  echo ""
  echo "Examples:"
  echo "  $0 \"security vulnerabilities\" 5 \"security_findings\""
  echo "  $0 \"test failures last week\" 10"
  echo "  $0 \"architecture decisions API design\" 15 \"architecture_decisions\""
  exit 1
fi

# Build search payload
SEARCH_PAYLOAD=$(cat <<EOF
{
  "query": "$QUERY",
  "max_results": $MAX_RESULTS,
  "similarity_threshold": 0.65,
  "time_decay_factor": 0.9
EOF
)

# Add category filter if specified
if [[ -n "$CATEGORY" ]]; then
  SEARCH_PAYLOAD+=",\"category\": \"$CATEGORY\""
fi

SEARCH_PAYLOAD+="}"

echo -e "${ORANGE}Searching Serena memories...${NC}"
echo -e "${ORANGE}Query: ${NC}$QUERY"
[[ -n "$CATEGORY" ]] && echo -e "${ORANGE}Category: ${NC}$CATEGORY"
echo -e "${ORANGE}Max Results: ${NC}$MAX_RESULTS"
echo ""

# Save search payload
echo "$SEARCH_PAYLOAD" > /tmp/serena-search-$$.json

# TODO: Add actual MCP call when Serena CLI integration is available
echo -e "${BLUE}To search with Serena MCP:${NC}"
echo "  cat /tmp/serena-search-$$.json | claude-mcp-call serena search_memories"
echo ""

# Example output format (for demonstration)
echo -e "${GREEN}Example Output Format:${NC}"
cat <<'EXAMPLE'
{
  "results": [
    {
      "content": "Fixed SQL injection vulnerability in /api/users endpoint",
      "tags": ["security", "sql-injection", "fix"],
      "category": "security_findings",
      "timestamp": "2025-10-15T14:30:00Z",
      "similarity_score": 0.89
    },
    {
      "content": "Added input validation to prevent XSS attacks",
      "tags": ["security", "xss", "validation"],
      "category": "security_findings",
      "timestamp": "2025-10-12T09:15:00Z",
      "similarity_score": 0.76
    }
  ]
}
EXAMPLE

echo ""
echo -e "${ORANGE}Search payload saved to: ${NC}/tmp/serena-search-$$.json"