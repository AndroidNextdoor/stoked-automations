#!/usr/bin/env bash
# Automated testing workflow with Serena memory integration
# Runs tests and stores results for pattern analysis
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
echo -e "${ORANGE}║  Testing Workflow with Serena Integration                 ║${NC}"
echo -e "${ORANGE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Parse arguments
TEST_TYPE="${1:-all}"
COVERAGE="${2:-false}"

echo -e "${BLUE}Test Type:${NC} $TEST_TYPE"
echo -e "${BLUE}Coverage:${NC} $COVERAGE"
echo ""

# Load test failure patterns from Serena
echo -e "${ORANGE}[1/6] Loading historical test failure patterns...${NC}"
"${SCRIPT_DIR}/../serena/search-context.sh" "test failures last 7 days" 10 "test_results" > /tmp/test-context.txt 2>&1
echo -e "${GREEN}✓ Historical context loaded${NC}"

# Check for flaky tests
echo -e "${BLUE}  → Checking for known flaky tests...${NC}"
"${SCRIPT_DIR}/../serena/search-context.sh" "flaky test intermittent" 5 "test_results" > /tmp/flaky-tests.txt 2>&1
FLAKY_COUNT=$(grep -c "similarity_score" /tmp/flaky-tests.txt 2>/dev/null || echo "0")
if [[ $FLAKY_COUNT -gt 0 ]]; then
  echo -e "${CYAN}  ℹ Found $FLAKY_COUNT known flaky test(s) in history${NC}"
fi
echo ""

# Run unit tests
if [[ "$TEST_TYPE" == "all" || "$TEST_TYPE" == "unit" ]]; then
  echo -e "${ORANGE}[2/6] Running unit tests...${NC}"

  # Check if package.json has test script
  if [[ -f "$REPO_ROOT/package.json" ]] && grep -q '"test"' "$REPO_ROOT/package.json"; then
    cd "$REPO_ROOT"

    # Run tests with coverage if requested
    if [[ "$COVERAGE" == "true" ]]; then
      npm test -- --coverage > /tmp/unit-tests.txt 2>&1 || UNIT_EXIT_CODE=$?
    else
      npm test > /tmp/unit-tests.txt 2>&1 || UNIT_EXIT_CODE=$?
    fi

    if [[ ${UNIT_EXIT_CODE:-0} -eq 0 ]]; then
      echo -e "${GREEN}✓ Unit tests passed${NC}"

      # Store success in Serena
      "${SCRIPT_DIR}/../serena/create-memory.sh" \
        "Unit tests passed successfully - all tests passing" \
        "testing,unit,success,pass" \
        "test_results" > /dev/null 2>&1
    else
      echo -e "${RED}✗ Unit tests failed${NC}"

      # Extract failure details
      FAILURES=$(grep -A 5 "FAIL" /tmp/unit-tests.txt 2>/dev/null || echo "No failure details")

      # Store failures in Serena
      "${SCRIPT_DIR}/../serena/create-memory.sh" \
        "Unit tests FAILED. Failures: $FAILURES" \
        "testing,unit,failure,regression" \
        "test_results" > /dev/null 2>&1

      echo -e "${RED}Failure details:${NC}"
      echo "$FAILURES"
    fi
  else
    echo -e "${CYAN}ℹ No unit test script found in package.json${NC}"
  fi
  echo ""
fi

# Run E2E tests
if [[ "$TEST_TYPE" == "all" || "$TEST_TYPE" == "e2e" ]]; then
  echo -e "${ORANGE}[3/6] Running E2E tests (Playwright)...${NC}"

  if command -v playwright &> /dev/null || [[ -f "$REPO_ROOT/node_modules/.bin/playwright" ]]; then
    cd "$REPO_ROOT"

    # Run Playwright tests
    npx playwright test > /tmp/e2e-tests.txt 2>&1 || E2E_EXIT_CODE=$?

    if [[ ${E2E_EXIT_CODE:-0} -eq 0 ]]; then
      echo -e "${GREEN}✓ E2E tests passed${NC}"

      # Store success in Serena
      "${SCRIPT_DIR}/../serena/create-memory.sh" \
        "E2E Playwright tests passed successfully" \
        "testing,e2e,playwright,success,pass" \
        "test_results" > /dev/null 2>&1
    else
      echo -e "${RED}✗ E2E tests failed${NC}"

      # Extract failure details
      E2E_FAILURES=$(grep -B 2 -A 5 "Error:" /tmp/e2e-tests.txt 2>/dev/null || echo "No error details")

      # Check if this is a known flaky test
      IS_FLAKY=$(echo "$E2E_FAILURES" | grep -i "timeout\|intermittent\|race condition" || echo "")

      if [[ -n "$IS_FLAKY" ]]; then
        echo -e "${CYAN}ℹ Failure pattern suggests flaky test${NC}"
        "${SCRIPT_DIR}/../serena/create-memory.sh" \
          "E2E test FAILED (flaky): $E2E_FAILURES" \
          "testing,e2e,playwright,failure,flaky,timeout" \
          "test_results" > /dev/null 2>&1
      else
        "${SCRIPT_DIR}/../serena/create-memory.sh" \
          "E2E test FAILED: $E2E_FAILURES" \
          "testing,e2e,playwright,failure,regression" \
          "test_results" > /dev/null 2>&1
      fi

      echo -e "${RED}Failure details:${NC}"
      echo "$E2E_FAILURES"
    fi
  else
    echo -e "${CYAN}ℹ Playwright not installed${NC}"
    echo "Install: npm install -D @playwright/test"
  fi
  echo ""
fi

# Run type checking
echo -e "${ORANGE}[4/6] Running TypeScript type checking...${NC}"
if [[ -f "$REPO_ROOT/tsconfig.json" ]]; then
  cd "$REPO_ROOT"
  npx tsc --noEmit > /tmp/type-check.txt 2>&1 || TYPE_EXIT_CODE=$?

  if [[ ${TYPE_EXIT_CODE:-0} -eq 0 ]]; then
    echo -e "${GREEN}✓ No type errors${NC}"
  else
    echo -e "${RED}✗ Type errors found${NC}"
    TYPE_ERRORS=$(cat /tmp/type-check.txt)
    ERROR_COUNT=$(echo "$TYPE_ERRORS" | grep -c "error TS" || echo "0")

    echo -e "${RED}Found $ERROR_COUNT type error(s)${NC}"

    # Store type errors in Serena
    "${SCRIPT_DIR}/../serena/create-memory.sh" \
      "TypeScript type check FAILED with $ERROR_COUNT errors: $TYPE_ERRORS" \
      "testing,typescript,type-errors,failure" \
      "test_results" > /dev/null 2>&1

    # Show first 10 errors
    echo "$TYPE_ERRORS" | head -20
  fi
else
  echo -e "${CYAN}ℹ No tsconfig.json found - skipping type check${NC}"
fi
echo ""

# Run linting
echo -e "${ORANGE}[5/6] Running linter...${NC}"
if [[ -f "$REPO_ROOT/package.json" ]] && grep -q '"lint"' "$REPO_ROOT/package.json"; then
  cd "$REPO_ROOT"
  npm run lint > /tmp/lint.txt 2>&1 || LINT_EXIT_CODE=$?

  if [[ ${LINT_EXIT_CODE:-0} -eq 0 ]]; then
    echo -e "${GREEN}✓ No linting errors${NC}"
  else
    echo -e "${RED}✗ Linting errors found${NC}"
    LINT_ERRORS=$(cat /tmp/lint.txt)

    # Store linting errors in Serena
    "${SCRIPT_DIR}/../serena/create-memory.sh" \
      "Linting FAILED: $LINT_ERRORS" \
      "testing,linting,code-quality,failure" \
      "test_results" > /dev/null 2>&1

    echo "$LINT_ERRORS" | head -20
  fi
else
  echo -e "${CYAN}ℹ No lint script found in package.json${NC}"
fi
echo ""

# Generate test report
echo -e "${ORANGE}[6/6] Generating test report...${NC}"

REPORT_FILE="/tmp/test-report-$(date +%Y%m%d-%H%M%S).txt"

# Count results
UNIT_STATUS="${GREEN}PASS${NC}"
[[ ${UNIT_EXIT_CODE:-0} -ne 0 ]] && UNIT_STATUS="${RED}FAIL${NC}"

E2E_STATUS="${GREEN}PASS${NC}"
[[ ${E2E_EXIT_CODE:-0} -ne 0 ]] && E2E_STATUS="${RED}FAIL${NC}"

TYPE_STATUS="${GREEN}PASS${NC}"
[[ ${TYPE_EXIT_CODE:-0} -ne 0 ]] && TYPE_STATUS="${RED}FAIL${NC}"

LINT_STATUS="${GREEN}PASS${NC}"
[[ ${LINT_EXIT_CODE:-0} -ne 0 ]] && LINT_STATUS="${RED}FAIL${NC}"

cat > "$REPORT_FILE" <<EOF
╔════════════════════════════════════════════════════════════╗
║            Test Execution Report                           ║
╚════════════════════════════════════════════════════════════╝

Timestamp: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
Repository: AndroidNextdoor/stoked-automations
Branch: $(git -C "$REPO_ROOT" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
Commit: $(git -C "$REPO_ROOT" rev-parse --short HEAD 2>/dev/null || echo "unknown")

════════════════════════════════════════════════════════════

TEST RESULTS

Unit Tests:       $([[ ${UNIT_EXIT_CODE:-0} -eq 0 ]] && echo "PASS" || echo "FAIL")
E2E Tests:        $([[ ${E2E_EXIT_CODE:-0} -eq 0 ]] && echo "PASS" || echo "FAIL")
Type Checking:    $([[ ${TYPE_EXIT_CODE:-0} -eq 0 ]] && echo "PASS" || echo "FAIL")
Linting:          $([[ ${LINT_EXIT_CODE:-0} -eq 0 ]] && echo "PASS" || echo "FAIL")

════════════════════════════════════════════════════════════

HISTORICAL CONTEXT

Known Flaky Tests: $FLAKY_COUNT
Recent Failures:   $(grep -c "similarity_score" /tmp/test-context.txt 2>/dev/null || echo "0")

════════════════════════════════════════════════════════════

RECOMMENDATIONS

EOF

# Add recommendations based on failures
if [[ ${UNIT_EXIT_CODE:-0} -ne 0 ]]; then
  cat >> "$REPORT_FILE" <<EOF
• Unit Test Failures:
  - Review test output in /tmp/unit-tests.txt
  - Check for recent code changes that may have broken tests
  - Search Serena for similar past failures: ./scripts/serena/search-context.sh "unit test failure"

EOF
fi

if [[ ${E2E_EXIT_CODE:-0} -ne 0 ]]; then
  cat >> "$REPORT_FILE" <<EOF
• E2E Test Failures:
  - Review Playwright output in /tmp/e2e-tests.txt
  - Check if failure is flaky (timeout/race condition)
  - Review screenshots in playwright-report/ directory
  - Search for similar E2E failures in Serena

EOF
fi

if [[ ${TYPE_EXIT_CODE:-0} -ne 0 ]]; then
  cat >> "$REPORT_FILE" <<EOF
• Type Errors:
  - Review TypeScript errors in /tmp/type-check.txt
  - Run: npx tsc --noEmit for detailed output
  - Check recent type definition changes

EOF
fi

cat >> "$REPORT_FILE" <<EOF
════════════════════════════════════════════════════════════

Next Steps:
1. Fix any failing tests immediately
2. Update Serena with remediation actions
3. Re-run tests to verify fixes
4. Consider adding tests to prevent regression

════════════════════════════════════════════════════════════

Full logs available:
- Unit Tests:    /tmp/unit-tests.txt
- E2E Tests:     /tmp/e2e-tests.txt
- Type Check:    /tmp/type-check.txt
- Linting:       /tmp/lint.txt
- This Report:   $REPORT_FILE
EOF

echo -e "${GREEN}✓ Test report generated${NC}"
echo ""

# Display summary
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Test Summary:${NC}"
echo -e "  Unit Tests:       $UNIT_STATUS"
echo -e "  E2E Tests:        $E2E_STATUS"
echo -e "  Type Checking:    $TYPE_STATUS"
echo -e "  Linting:          $LINT_STATUS"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"

# Store complete summary in Serena
OVERALL_STATUS="PASS"
[[ ${UNIT_EXIT_CODE:-0} -ne 0 ]] || [[ ${E2E_EXIT_CODE:-0} -ne 0 ]] || [[ ${TYPE_EXIT_CODE:-0} -ne 0 ]] || [[ ${LINT_EXIT_CODE:-0} -ne 0 ]] && OVERALL_STATUS="FAIL"

"${SCRIPT_DIR}/../serena/create-memory.sh" \
  "Test workflow completed with status: $OVERALL_STATUS. Unit: ${UNIT_EXIT_CODE:-0}, E2E: ${E2E_EXIT_CODE:-0}, Types: ${TYPE_EXIT_CODE:-0}, Lint: ${LINT_EXIT_CODE:-0}. Report: $REPORT_FILE" \
  "testing,workflow,automation,summary,$OVERALL_STATUS" \
  "test_results" > /dev/null 2>&1

echo ""
echo -e "${BLUE}Report saved:${NC} $REPORT_FILE"
echo -e "${BLUE}Results stored in Serena for future analysis${NC}"

# Exit with failure if any tests failed
if [[ "$OVERALL_STATUS" == "FAIL" ]]; then
  exit 1
fi