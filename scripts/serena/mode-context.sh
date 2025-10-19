#!/usr/bin/env bash
# Load relevant context from Serena for the current development mode
# Usage: ./mode-context.sh [mode_name]
# Author: Andrew Nixdorf <andrew@stokedautomation.com>

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors for output
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Parse arguments
MODE_NAME="${1:-}"

if [[ -z "$MODE_NAME" ]]; then
  echo -e "${RED}Error: Mode name is required${NC}"
  echo "Usage: $0 [mode_name]"
  echo ""
  echo "Available modes:"
  echo "  pr-review"
  echo "  30-hour"
  echo "  testing"
  echo "  documentation"
  echo "  security-audit"
  echo "  performance"
  echo "  devops"
  echo "  data-science"
  echo "  full-stack"
  echo "  quick-fix"
  exit 1
fi

echo -e "${ORANGE}Loading context for ${CYAN}${MODE_NAME}${ORANGE} mode...${NC}"
echo ""

# Define mode-specific search queries
case "$MODE_NAME" in
  "pr-review")
    QUERIES=(
      "security findings last 7 days"
      "test failures unresolved"
      "code review feedback patterns"
      "architecture decisions recent"
    )
    CATEGORIES=("security_findings" "test_results" "code_reviews" "architecture_decisions")
    ;;
  "security-audit")
    QUERIES=(
      "vulnerabilities fixed historical"
      "security trends 2025"
      "penetration test results"
      "OWASP compliance checks"
    )
    CATEGORIES=("security_findings" "security_findings" "security_findings" "security_findings")
    ;;
  "testing")
    QUERIES=(
      "test failures last 7 days"
      "successful test patterns"
      "flaky test issues"
      "coverage improvements"
    )
    CATEGORIES=("test_results" "test_results" "test_results" "test_results")
    ;;
  "documentation")
    QUERIES=(
      "architecture decisions"
      "documentation gaps identified"
      "user feedback on docs"
      "API changes requiring docs"
    )
    CATEGORIES=("architecture_decisions" "mode_contexts" "mode_contexts" "architecture_decisions")
    ;;
  "performance")
    QUERIES=(
      "performance bottlenecks identified"
      "optimization wins"
      "load test results"
      "database query performance"
    )
    CATEGORIES=("mode_contexts" "mode_contexts" "test_results" "mode_contexts")
    ;;
  "30-hour"|"full-stack"|"quick-fix")
    QUERIES=(
      "recent architecture decisions"
      "common bug patterns"
      "test failures last 3 days"
      "technical debt items"
    )
    CATEGORIES=("architecture_decisions" "mode_contexts" "test_results" "mode_contexts")
    ;;
  "devops")
    QUERIES=(
      "deployment failures"
      "infrastructure changes"
      "CI/CD pipeline issues"
      "monitoring alerts"
    )
    CATEGORIES=("deployment_history" "workflow_executions" "workflow_executions" "mode_contexts")
    ;;
  "data-science")
    QUERIES=(
      "ML experiment results"
      "model performance metrics"
      "feature engineering patterns"
      "data pipeline issues"
    )
    CATEGORIES=("ml_experiments" "ml_experiments" "ml_experiments" "workflow_executions")
    ;;
  *)
    echo -e "${RED}Unknown mode: $MODE_NAME${NC}"
    exit 1
    ;;
esac

# Create combined context payload
CONTEXT_PAYLOAD="{"
CONTEXT_PAYLOAD+="\"mode\": \"$MODE_NAME\","
CONTEXT_PAYLOAD+="\"timestamp\": \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\","
CONTEXT_PAYLOAD+="\"queries\": ["

# Execute searches and collect results
for i in "${!QUERIES[@]}"; do
  QUERY="${QUERIES[$i]}"
  CATEGORY="${CATEGORIES[$i]}"

  echo -e "${BLUE}[$((i+1))/${#QUERIES[@]}]${NC} Searching: ${CYAN}$QUERY${NC} (${CATEGORY})"

  SEARCH_PAYLOAD=$(cat <<EOF
{
  "query": "$QUERY",
  "max_results": 5,
  "category": "$CATEGORY",
  "similarity_threshold": 0.65
}
EOF
)

  echo "$SEARCH_PAYLOAD" > /tmp/serena-mode-search-$MODE_NAME-$i.json

  CONTEXT_PAYLOAD+="{\"query\": \"$QUERY\", \"category\": \"$CATEGORY\"}"
  if [[ $i -lt $((${#QUERIES[@]} - 1)) ]]; then
    CONTEXT_PAYLOAD+=","
  fi
done

CONTEXT_PAYLOAD+="]}"

echo ""
echo -e "${GREEN}✓ Context queries prepared for ${CYAN}${MODE_NAME}${GREEN} mode${NC}"
echo ""
echo -e "${ORANGE}To load context with Serena MCP:${NC}"
for i in "${!QUERIES[@]}"; do
  echo "  cat /tmp/serena-mode-search-$MODE_NAME-$i.json | claude-mcp-call serena search_memories"
done
echo ""

# Save mode context activation
MODE_ACTIVATION=$(cat <<EOF
{
  "mode": "$MODE_NAME",
  "activated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "context_queries": ${#QUERIES[@]},
  "branch": "$(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")"
}
EOF
)

echo "$MODE_ACTIVATION" > /tmp/serena-mode-activation-$MODE_NAME.json

echo -e "${ORANGE}Mode activation context saved to:${NC}"
echo "  /tmp/serena-mode-activation-$MODE_NAME.json"
echo ""

# Display relevant context guidelines
echo -e "${CYAN}Context Guidelines for ${MODE_NAME} mode:${NC}"
case "$MODE_NAME" in
  "pr-review")
    cat <<'GUIDELINES'
- Focus on security vulnerabilities from recent scans
- Check for patterns in previous code reviews
- Verify test coverage for changed files
- Reference architecture decisions for consistency
GUIDELINES
    ;;
  "security-audit")
    cat <<'GUIDELINES'
- Review historical vulnerability patterns
- Check for common attack vectors (OWASP Top 10)
- Validate input sanitization and output encoding
- Verify secrets management practices
GUIDELINES
    ;;
  "testing")
    cat <<'GUIDELINES'
- Analyze recent test failure patterns
- Identify flaky tests requiring stabilization
- Review successful test patterns to replicate
- Check test coverage gaps
GUIDELINES
    ;;
  "documentation")
    cat <<'GUIDELINES'
- Review recent architecture decisions needing docs
- Check for API changes requiring documentation
- Identify user-facing features without guides
- Update examples with recent patterns
GUIDELINES
    ;;
esac
echo ""