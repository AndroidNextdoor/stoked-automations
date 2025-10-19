#!/usr/bin/env bash
# Automated PR review workflow with Serena memory integration
# Loads relevant context and performs comprehensive code review
# Author: Andrew Nixdorf <andrew@stokedautomation.com>

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${ORANGE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${ORANGE}║  PR Review Workflow with Serena Integration               ║${NC}"
echo -e "${ORANGE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Parse arguments
PR_NUMBER="${1:-}"
BASE_BRANCH="${2:-main}"

if [[ -z "$PR_NUMBER" ]]; then
  echo -e "${RED}Error: PR number is required${NC}"
  echo "Usage: $0 [pr_number] [base_branch]"
  echo "Example: $0 123 main"
  exit 1
fi

echo -e "${BLUE}PR Number:${NC} #$PR_NUMBER"
echo -e "${BLUE}Base Branch:${NC} $BASE_BRANCH"
echo ""

cd "$REPO_ROOT"

# Load PR review context from Serena
echo -e "${ORANGE}[1/7] Loading PR review context from Serena...${NC}"
"${SCRIPT_DIR}/../serena/mode-context.sh" pr-review > /tmp/pr-review-context.txt 2>&1
echo -e "${GREEN}✓ Historical context loaded${NC}"
echo ""

# Get PR details using GitHub CLI
echo -e "${ORANGE}[2/7] Fetching PR details...${NC}"
if command -v gh &> /dev/null; then
  gh pr view "$PR_NUMBER" > /tmp/pr-details.txt 2>&1 || {
    echo -e "${RED}✗ Failed to fetch PR details${NC}"
    echo "Ensure you have GitHub CLI installed and authenticated"
    exit 1
  }

  PR_TITLE=$(gh pr view "$PR_NUMBER" --json title -q .title)
  PR_AUTHOR=$(gh pr view "$PR_NUMBER" --json author -q .author.login)
  PR_FILES=$(gh pr view "$PR_NUMBER" --json files -q '.files[].path' | tr '\n' ' ')

  echo -e "${GREEN}✓ PR fetched${NC}"
  echo -e "${CYAN}  Title: ${NC}$PR_TITLE"
  echo -e "${CYAN}  Author: ${NC}$PR_AUTHOR"
  echo -e "${CYAN}  Files changed: ${NC}$(echo "$PR_FILES" | wc -w)"
else
  echo -e "${RED}✗ GitHub CLI not installed${NC}"
  echo "Install: brew install gh (macOS) or apt install gh (Linux)"
  exit 1
fi
echo ""

# Get PR diff
echo -e "${ORANGE}[3/7] Analyzing changes...${NC}"
gh pr diff "$PR_NUMBER" > /tmp/pr-diff.txt 2>&1

# Count changes
ADDITIONS=$(grep -c "^+" /tmp/pr-diff.txt || echo "0")
DELETIONS=$(grep -c "^-" /tmp/pr-diff.txt || echo "0")

echo -e "${GREEN}✓ Changes analyzed${NC}"
echo -e "${CYAN}  Additions: ${NC}+$ADDITIONS"
echo -e "${CYAN}  Deletions: ${NC}-$DELETIONS"
echo ""

# Check for security issues
echo -e "${ORANGE}[4/7] Running security checks...${NC}"

SECURITY_ISSUES=()

# Check for hardcoded secrets in diff
if grep -qiE "(password|api[_-]?key|secret|token)\s*=\s*['\"][^'\"]{8,}" /tmp/pr-diff.txt; then
  SECURITY_ISSUES+=("Potential hardcoded secrets detected")
  echo -e "${RED}  ✗ Hardcoded secrets detected${NC}"
fi

# Check for SQL injection patterns
if grep -qE "(execute|query)\(.*\+.*\)" /tmp/pr-diff.txt; then
  SECURITY_ISSUES+=("Potential SQL injection vulnerability")
  echo -e "${RED}  ✗ SQL injection pattern detected${NC}"
fi

# Check for XSS vulnerabilities
if grep -qE "innerHTML|dangerouslySetInnerHTML" /tmp/pr-diff.txt; then
  SECURITY_ISSUES+=("Potential XSS vulnerability (innerHTML usage)")
  echo -e "${RED}  ✗ XSS risk detected (innerHTML)${NC}"
fi

# Check for console.log left in code
if grep -qE "console\.(log|debug|info)" /tmp/pr-diff.txt; then
  SECURITY_ISSUES+=("Console statements left in code")
  echo -e "${CYAN}  ℹ Console statements detected${NC}"
fi

if [[ ${#SECURITY_ISSUES[@]} -eq 0 ]]; then
  echo -e "${GREEN}✓ No security issues detected${NC}"
else
  echo -e "${RED}  Found ${#SECURITY_ISSUES[@]} security concern(s)${NC}"
fi
echo ""

# Check test coverage
echo -e "${ORANGE}[5/7] Checking test coverage...${NC}"

TEST_FILES_CHANGED=0
SOURCE_FILES_CHANGED=0

for file in $PR_FILES; do
  if [[ "$file" =~ test|spec ]]; then
    ((TEST_FILES_CHANGED++))
  elif [[ "$file" =~ \.(ts|tsx|js|jsx|py)$ ]]; then
    ((SOURCE_FILES_CHANGED++))
  fi
done

if [[ $SOURCE_FILES_CHANGED -gt 0 ]] && [[ $TEST_FILES_CHANGED -eq 0 ]]; then
  echo -e "${RED}✗ No test files modified - consider adding tests${NC}"
  SECURITY_ISSUES+=("No tests added for code changes")
else
  echo -e "${GREEN}✓ Test files included in PR${NC}"
  echo -e "${CYAN}  Source files changed: ${NC}$SOURCE_FILES_CHANGED"
  echo -e "${CYAN}  Test files changed: ${NC}$TEST_FILES_CHANGED"
fi
echo ""

# Search for similar past reviews
echo -e "${ORANGE}[6/7] Searching for similar past code reviews...${NC}"
SEARCH_QUERY="code review $(echo "$PR_FILES" | head -3)"
"${SCRIPT_DIR}/../serena/search-context.sh" "$SEARCH_QUERY" 5 "code_reviews" > /tmp/similar-reviews.txt 2>&1

SIMILAR_REVIEWS=$(grep -c "similarity_score" /tmp/similar-reviews.txt 2>/dev/null || echo "0")
if [[ $SIMILAR_REVIEWS -gt 0 ]]; then
  echo -e "${CYAN}ℹ Found $SIMILAR_REVIEWS similar review(s) in history${NC}"
  echo -e "${CYAN}  Review /tmp/similar-reviews.txt for patterns${NC}"
else
  echo -e "${CYAN}ℹ No similar reviews found${NC}"
fi
echo ""

# Generate review report
echo -e "${ORANGE}[7/7] Generating review report...${NC}"

REPORT_FILE="/tmp/pr-review-$PR_NUMBER-$(date +%Y%m%d-%H%M%S).txt"

# Determine overall status
REVIEW_STATUS="APPROVED"
if [[ ${#SECURITY_ISSUES[@]} -gt 0 ]]; then
  REVIEW_STATUS="REQUEST_CHANGES"
fi

cat > "$REPORT_FILE" <<EOF
╔════════════════════════════════════════════════════════════╗
║            PR Review Report                                ║
╚════════════════════════════════════════════════════════════╝

PR: #$PR_NUMBER
Title: $PR_TITLE
Author: $PR_AUTHOR
Base Branch: $BASE_BRANCH
Review Status: $REVIEW_STATUS
Timestamp: $(date -u +"%Y-%m-%d %H:%M:%S UTC")

════════════════════════════════════════════════════════════

CHANGES SUMMARY

Files Changed: $(echo "$PR_FILES" | wc -w)
Lines Added: +$ADDITIONS
Lines Deleted: -$DELETIONS
Source Files: $SOURCE_FILES_CHANGED
Test Files: $TEST_FILES_CHANGED

════════════════════════════════════════════════════════════

SECURITY ANALYSIS

EOF

if [[ ${#SECURITY_ISSUES[@]} -eq 0 ]]; then
  cat >> "$REPORT_FILE" <<EOF
✓ No security issues detected

EOF
else
  cat >> "$REPORT_FILE" <<EOF
✗ Found ${#SECURITY_ISSUES[@]} security concern(s):

EOF
  for issue in "${SECURITY_ISSUES[@]}"; do
    cat >> "$REPORT_FILE" <<EOF
  • $issue
EOF
  done
  cat >> "$REPORT_FILE" <<EOF

EOF
fi

cat >> "$REPORT_FILE" <<EOF
════════════════════════════════════════════════════════════

CODE QUALITY CHECKS

EOF

# Add quality checks
if [[ $SOURCE_FILES_CHANGED -gt 0 ]] && [[ $TEST_FILES_CHANGED -eq 0 ]]; then
  cat >> "$REPORT_FILE" <<EOF
✗ Missing tests for code changes
  Recommendation: Add unit/integration tests for new functionality

EOF
else
  cat >> "$REPORT_FILE" <<EOF
✓ Test files included in PR

EOF
fi

# Check for documentation updates
DOC_FILES=$(echo "$PR_FILES" | grep -i "readme\|\.md" | wc -w || echo "0")
if [[ $DOC_FILES -gt 0 ]]; then
  cat >> "$REPORT_FILE" <<EOF
✓ Documentation updated

EOF
else
  cat >> "$REPORT_FILE" <<EOF
ℹ No documentation updates
  Consider updating README.md if new features were added

EOF
fi

cat >> "$REPORT_FILE" <<EOF
════════════════════════════════════════════════════════════

HISTORICAL CONTEXT

Similar past reviews: $SIMILAR_REVIEWS
$(cat /tmp/similar-reviews.txt 2>/dev/null | grep -A 3 "content" || echo "No similar reviews found")

════════════════════════════════════════════════════════════

RECOMMENDATIONS

EOF

if [[ "$REVIEW_STATUS" == "REQUEST_CHANGES" ]]; then
  cat >> "$REPORT_FILE" <<EOF
This PR requires changes before approval:

1. Address all security concerns listed above
2. Remove any hardcoded secrets immediately
3. Add parameterized queries for database operations
4. Sanitize all user inputs and outputs
5. Add tests for new functionality
6. Run security scan: ./scripts/workflows/security-scan-workflow.sh

EOF
else
  cat >> "$REPORT_FILE" <<EOF
This PR looks good! Minor suggestions:

1. Ensure all tests pass: npm test
2. Run type check: npx tsc --noEmit
3. Review linting: npm run lint
4. Consider adding more edge case tests

EOF
fi

cat >> "$REPORT_FILE" <<EOF
════════════════════════════════════════════════════════════

AUTOMATED CHECKS

Run these commands before merging:

  # Test suite
  ./scripts/workflows/test-workflow.sh all true

  # Security scan
  ./scripts/workflows/security-scan-workflow.sh localhost:4321

  # Validation
  ./scripts/validate-all.sh

════════════════════════════════════════════════════════════

FILES CHANGED

$(echo "$PR_FILES" | tr ' ' '\n' | nl)

════════════════════════════════════════════════════════════

Report: $REPORT_FILE
PR Details: /tmp/pr-details.txt
Diff: /tmp/pr-diff.txt
EOF

echo -e "${GREEN}✓ Review report generated${NC}"
echo ""

# Display summary
cat "$REPORT_FILE"

# Store review in Serena
"${SCRIPT_DIR}/../serena/create-memory.sh" \
  "PR #$PR_NUMBER review completed: $REVIEW_STATUS. Security issues: ${#SECURITY_ISSUES[@]}. Files: $(echo "$PR_FILES" | wc -w). Title: $PR_TITLE" \
  "code-review,pr,security,quality,$REVIEW_STATUS" \
  "code_reviews" > /dev/null 2>&1

echo ""
echo -e "${ORANGE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Review Status:${NC} $REVIEW_STATUS"
echo -e "${BLUE}Report:${NC} $REPORT_FILE"
echo -e "${BLUE}Results stored in Serena for future reference${NC}"
echo -e "${ORANGE}════════════════════════════════════════════════════════════${NC}"

# Exit with failure if changes requested
if [[ "$REVIEW_STATUS" == "REQUEST_CHANGES" ]]; then
  exit 1
fi