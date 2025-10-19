# Workflow Automation Scripts

Automated development workflows with Serena MCP integration for intelligent context management.

**Author:** Andrew Nixdorf <andrew@stokedautomation.com>
**Version:** 2025.0.0

## Overview

These workflow scripts automate common development tasks while intelligently storing and retrieving context from Serena MCP. Each workflow learns from past executions to provide increasingly valuable insights.

## Philosophy

Traditional automation runs tasks in isolation. **Serena-enhanced workflows** create a persistent memory layer that connects executions across time:

- **Security scans** remember past vulnerabilities
- **Test runs** track failure patterns and flaky tests
- **PR reviews** reference similar past reviews
- **Context accumulation** makes each execution smarter than the last

## Workflows

### 1. security-scan-workflow.sh

Comprehensive security scanning with historical vulnerability tracking.

**Usage:**
```bash
./security-scan-workflow.sh [target] [scan_type]
```

**Arguments:**
- `target` (optional): Target URL or hostname (default: `localhost:4321`)
- `scan_type` (optional): `full` or `quick` (default: `full`)

**What It Does:**

1. **Loads Historical Context** - Reviews past security findings from Serena
2. **Network Reconnaissance** - Runs nmap for port scanning
3. **Web Security Checks** - Validates HTTPS, security headers (CSP, HSTS, X-Frame-Options)
4. **Static Code Analysis** - Scans for hardcoded secrets, SQL injection patterns
5. **Report Generation** - Creates comprehensive security report
6. **Memory Storage** - Stores findings in Serena for future reference

**Security Checks Performed:**

| Check | Detection Pattern | Severity |
|-------|-------------------|----------|
| Hardcoded Secrets | `password\|api_key\|secret\|token` | Critical |
| SQL Injection | `execute(.*+.*)\|query(.*+.*)` | High |
| Missing HTTPS | Non-HTTPS URLs | High |
| Security Headers | CSP, HSTS, X-Frame-Options, X-Content-Type-Options | Medium |
| Open Ports | Nmap scan results | Varies |

**Examples:**

```bash
# Scan localhost development server
./security-scan-workflow.sh localhost:4321

# Scan production website
./security-scan-workflow.sh https://stokedautomations.com full

# Quick scan for CI/CD
./security-scan-workflow.sh staging.example.com quick
```

**Output:**
- Security report saved to `/tmp/security-scan-report-YYYYMMDD-HHMMSS.txt`
- Findings stored in Serena category: `security_findings`
- Recommendations for remediation

**Integration with Serena:**
```bash
# Before scan: Load historical vulnerabilities
serena.search("security vulnerabilities target_name", max_results=5)

# After scan: Store new findings
serena.create_memory({
  content: "Security scan found SQL injection in /api/users",
  tags: ["security", "sql-injection", "vulnerability"],
  category: "security_findings"
})
```

---

### 2. test-workflow.sh

Automated testing suite with failure pattern analysis.

**Usage:**
```bash
./test-workflow.sh [test_type] [coverage]
```

**Arguments:**
- `test_type` (optional): `all`, `unit`, or `e2e` (default: `all`)
- `coverage` (optional): `true` to enable coverage reports (default: `false`)

**What It Does:**

1. **Loads Test History** - Reviews past failures and flaky tests from Serena
2. **Unit Tests** - Runs Jest/Vitest unit tests
3. **E2E Tests** - Executes Playwright browser tests
4. **Type Checking** - Validates TypeScript types
5. **Linting** - Checks code quality with ESLint
6. **Pattern Analysis** - Identifies flaky tests and recurring failures
7. **Report Generation** - Creates detailed test report
8. **Memory Storage** - Stores results in Serena

**Test Categories:**

| Type | Framework | Files | Coverage |
|------|-----------|-------|----------|
| Unit | Jest/Vitest | `*.test.{ts,js}` | Yes |
| E2E | Playwright | `e2e/**/*.spec.ts` | No |
| Type Check | TypeScript | All `.ts` files | N/A |
| Linting | ESLint | All source files | N/A |

**Examples:**

```bash
# Run all tests without coverage
./test-workflow.sh

# Run only unit tests with coverage
./test-workflow.sh unit true

# Run only E2E tests
./test-workflow.sh e2e false

# Full CI/CD test suite
./test-workflow.sh all true
```

**Output:**
- Test report saved to `/tmp/test-report-YYYYMMDD-HHMMSS.txt`
- Individual logs: `/tmp/unit-tests.txt`, `/tmp/e2e-tests.txt`
- Results stored in Serena category: `test_results`

**Flaky Test Detection:**

The workflow automatically detects flaky tests by:
1. Searching Serena for historical intermittent failures
2. Analyzing error patterns (timeouts, race conditions)
3. Tagging new failures as potentially flaky
4. Recommending stabilization strategies

**Integration with Serena:**
```bash
# Before tests: Load failure history
serena.search("test failures last 7 days", max_results=10, category="test_results")
serena.search("flaky test intermittent", max_results=5)

# After tests: Store results
serena.create_memory({
  content: "E2E test failed: timeout on login redirect",
  tags: ["testing", "e2e", "failure", "flaky", "timeout"],
  category: "test_results"
})
```

---

### 3. pr-review-workflow.sh

Automated PR review with intelligent context loading.

**Usage:**
```bash
./pr-review-workflow.sh [pr_number] [base_branch]
```

**Arguments:**
- `pr_number` (required): GitHub PR number
- `base_branch` (optional): Base branch for comparison (default: `main`)

**Prerequisites:**
- GitHub CLI (`gh`) installed and authenticated
- Access to repository

**What It Does:**

1. **Loads Review Context** - Retrieves relevant past reviews from Serena
2. **Fetches PR Details** - Gets PR title, author, files changed via GitHub API
3. **Analyzes Changes** - Counts additions/deletions, identifies file types
4. **Security Checks** - Scans for vulnerabilities in diff
5. **Test Coverage Check** - Verifies tests were added for code changes
6. **Similar Reviews Search** - Finds past reviews of similar code
7. **Report Generation** - Creates comprehensive review report
8. **Memory Storage** - Stores review in Serena

**Review Checks:**

| Check | Purpose | Action |
|-------|---------|--------|
| Hardcoded Secrets | Security | Block merge |
| SQL Injection | Security | Request changes |
| XSS Vulnerabilities | Security | Request changes |
| Console Statements | Code quality | Comment |
| Missing Tests | Coverage | Request changes |
| Documentation Updates | Maintainability | Suggest |

**Examples:**

```bash
# Review PR #123 against main
./pr-review-workflow.sh 123

# Review PR #456 against develop branch
./pr-review-workflow.sh 456 develop

# Review and auto-comment (future feature)
./pr-review-workflow.sh 789 main --auto-comment
```

**Output:**
- Review report saved to `/tmp/pr-review-{PR_NUMBER}-YYYYMMDD-HHMMSS.txt`
- Review status: `APPROVED` or `REQUEST_CHANGES`
- Results stored in Serena category: `code_reviews`

**Review Outcomes:**

| Status | Condition | Action |
|--------|-----------|--------|
| `APPROVED` | No security issues, tests included | Ready to merge |
| `REQUEST_CHANGES` | Security issues or missing tests | Block merge |

**Integration with Serena:**
```bash
# Before review: Load PR review context
serena.mode_context("pr-review")
serena.search("code review authentication security", max_results=5)

# After review: Store findings
serena.create_memory({
  content: "PR #123: Found XSS vulnerability in search component",
  tags: ["code-review", "pr", "security", "xss", "vulnerability"],
  category: "code_reviews"
})
```

---

## Workflow Integration Patterns

### Pattern 1: Pre-commit Hook

Run security and test workflows before committing:

```bash
# .git/hooks/pre-commit
#!/bin/bash

echo "Running pre-commit checks..."

# Security scan
./scripts/workflows/security-scan-workflow.sh localhost:4321 quick || exit 1

# Tests
./scripts/workflows/test-workflow.sh unit false || exit 1

echo "✓ Pre-commit checks passed"
```

### Pattern 2: CI/CD Pipeline

Integrate workflows into GitHub Actions:

```yaml
# .github/workflows/ci.yml
name: CI Pipeline

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run test workflow
        run: ./scripts/workflows/test-workflow.sh all true

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run security scan
        run: ./scripts/workflows/security-scan-workflow.sh localhost:4321
```

### Pattern 3: Nightly Security Audits

Schedule comprehensive security scans:

```bash
# crontab -e
0 2 * * * /path/to/scripts/workflows/security-scan-workflow.sh production.com full
```

### Pattern 4: PR Review Bot

Automate PR reviews on GitHub:

```bash
# Webhook handler or GitHub Action
gh pr list --state open --json number -q '.[].number' | while read -r pr; do
  ./scripts/workflows/pr-review-workflow.sh "$pr" main
done
```

---

## Serena Memory Schema

### Security Findings

```json
{
  "content": "Nmap scan of localhost:4321 found 3 open ports: 22, 80, 443",
  "tags": ["security", "nmap", "ports", "network"],
  "category": "security_findings",
  "severity": "medium",
  "timestamp": "2025-10-18T16:30:00Z"
}
```

### Test Results

```json
{
  "content": "E2E test failed: timeout waiting for login redirect",
  "tags": ["testing", "e2e", "playwright", "failure", "flaky"],
  "category": "test_results",
  "test_name": "login-flow.spec.ts",
  "exit_code": 1
}
```

### Code Reviews

```json
{
  "content": "PR #123: XSS vulnerability in search component - innerHTML usage",
  "tags": ["code-review", "pr", "security", "xss"],
  "category": "code_reviews",
  "pr_number": 123,
  "review_status": "REQUEST_CHANGES"
}
```

---

## Configuration

### Environment Variables

```bash
# Serena MCP endpoint (optional)
export SERENA_MCP_ENDPOINT="http://localhost:3000"

# Security scan targets
export SECURITY_SCAN_TARGET="localhost:4321"

# Test coverage threshold
export TEST_COVERAGE_THRESHOLD=80
```

### Workflow Customization

Edit workflow scripts to customize behavior:

```bash
# security-scan-workflow.sh
SCAN_TYPE="${2:-full}"  # Change default to "quick"

# test-workflow.sh
COVERAGE="${2:-true}"   # Enable coverage by default

# pr-review-workflow.sh
BASE_BRANCH="${2:-develop}"  # Change default base branch
```

---

## Troubleshooting

### Workflows Not Finding Serena

```bash
# Verify Serena is installed
/plugin list | grep serena

# Check Serena helper scripts exist
ls -la scripts/serena/

# Make scripts executable
chmod +x scripts/serena/*.sh
chmod +x scripts/workflows/*.sh
```

### Security Scan Fails

```bash
# Install missing dependencies
brew install nmap        # macOS
apt-get install nmap     # Linux

# Check network connectivity
ping target.com
```

### Test Workflow Errors

```bash
# Install test dependencies
npm install

# Check test script exists
grep -i "test" package.json

# Run tests manually
npm test
```

### PR Review Fails

```bash
# Install GitHub CLI
brew install gh          # macOS
apt install gh           # Linux

# Authenticate
gh auth login

# Verify repository access
gh repo view
```

---

## Best Practices

1. **Run workflows locally first** - Test before committing
2. **Review Serena context** - Check historical patterns before major changes
3. **Store detailed failures** - Include error messages and context
4. **Tag consistently** - Use standard tags for easier search
5. **Automate in CI/CD** - Run workflows on every commit
6. **Schedule security scans** - Weekly comprehensive scans
7. **Archive old memories** - Prune test results older than 30 days
8. **Cross-reference findings** - Link related security issues and fixes

---

## Metrics & KPIs

Track workflow effectiveness with these metrics:

### Security Workflow
- Vulnerabilities detected per scan
- Time to remediation
- Repeat vulnerability rate
- False positive rate

### Test Workflow
- Test pass rate
- Flaky test count
- Time to fix failed tests
- Coverage percentage

### PR Review Workflow
- Reviews per week
- Issues caught before merge
- Review time reduction
- Security blocks per 100 PRs

---

## Integration with Modes

Workflows automatically integrate with development modes:

```bash
# Enable PR review mode (includes workflow setup)
./scripts/modes/enable-pr-review-mode.sh

# Mode automatically configures:
# - Serena context loading
# - PR review workflow
# - Security scan workflow
# - Test workflow
```

---

## Future Enhancements

Planned features for workflow scripts:

- [ ] **AI-powered insights** - GPT-4 analysis of security findings
- [ ] **Automated PR comments** - Post review findings directly to GitHub
- [ ] **Slack notifications** - Alert on critical security issues
- [ ] **Trend analysis** - Visualize metrics over time
- [ ] **Custom workflow builder** - Generate workflows from templates
- [ ] **Multi-repo support** - Run workflows across multiple repositories
- [ ] **Performance profiling** - Identify slow tests and optimize

---

## Resources

- **Serena Integration Architecture:** `docs/SERENA_INTEGRATION_ARCHITECTURE.md`
- **Serena Helper Scripts:** `scripts/serena/README.md`
- **Mode System Guide:** `docs/MODE_SYSTEM_GUIDE.md`
- **Security Best Practices:** `SECURITY.md`

---

**Last Updated:** October 2025
**Repository Version:** 2025.0.0
**Status:** Active development