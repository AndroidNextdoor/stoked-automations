# Serena Helper Scripts

Bash utilities for integrating Serena MCP with Stoked Automations workflows.

**Author:** Andrew Nixdorf <andrew@stokedautomation.com>
**Version:** 2025.0.0

## Overview

These scripts enable seamless interaction with Serena MCP for memory management, context search, and mode-specific intelligence. They bridge the gap between development workflows and persistent AI memory.

## Prerequisites

- Serena MCP plugin installed and configured
- Claude Code CLI with MCP support
- Bash 4.0+ (macOS ships with 3.2, use `brew install bash` for 5.x)
- `jq` for JSON processing

## Scripts

### 1. create-memory.sh

Store important context in Serena's persistent memory.

**Usage:**
```bash
./create-memory.sh "memory content" "tag1,tag2,tag3" "category"
```

**Arguments:**
- `content` (required): The memory content to store
- `tags` (optional): Comma-separated tags for categorization
- `category` (optional): Memory category (default: `general`)

**Valid Categories:**
- `security_findings` - Vulnerability scans, penetration tests
- `test_results` - Test failures, coverage reports
- `code_reviews` - PR feedback, architecture reviews
- `ml_experiments` - Model training, experiment results
- `health_audits` - Project health metrics
- `architecture_decisions` - ADRs, design patterns
- `mode_contexts` - Development mode histories
- `workflow_executions` - Automation results
- `plugin_usage` - Plugin installation patterns
- `deployment_history` - Deployment logs, rollbacks

**Examples:**

```bash
# Store security finding
./create-memory.sh \
  "Fixed SQL injection in /api/users endpoint by parameterizing queries" \
  "security,sql-injection,fix,api" \
  "security_findings"

# Store test result
./create-memory.sh \
  "Playwright login test now passing after fixing async timing issue" \
  "testing,e2e,playwright,login,fix" \
  "test_results"

# Store architecture decision
./create-memory.sh \
  "Decided to use React Server Components for better performance" \
  "architecture,react,rsc,performance" \
  "architecture_decisions"

# Store mode context
./create-memory.sh \
  "PR review mode identified 3 OWASP violations in authentication flow" \
  "pr-review,security,owasp,authentication" \
  "mode_contexts"
```

**Output:**
- Creates JSON payload with memory metadata
- Saves to `/tmp/serena-memory-$$.json`
- Displays command for MCP integration
- Shows confirmation with memory details

---

### 2. search-context.sh

Search Serena's memory bank using semantic similarity.

**Usage:**
```bash
./search-context.sh "query" [max_results] [category]
```

**Arguments:**
- `query` (required): Search query for semantic matching
- `max_results` (optional): Number of results to return (default: 10)
- `category` (optional): Limit search to specific category

**Search Features:**
- Semantic similarity matching (not exact keyword matching)
- Time decay factor (recent memories weighted higher)
- Configurable similarity threshold (default: 0.65)
- Category filtering for focused results

**Examples:**

```bash
# Find recent security vulnerabilities
./search-context.sh "security vulnerabilities" 5 "security_findings"

# Search test failures from last week
./search-context.sh "test failures last week" 10

# Find API design decisions
./search-context.sh "architecture decisions API design" 15 "architecture_decisions"

# Search for SQL injection patterns
./search-context.sh "SQL injection prevention patterns" 8 "security_findings"

# Find deployment issues
./search-context.sh "deployment failures production" 10 "deployment_history"
```

**Output:**
- Displays search parameters
- Saves search payload to `/tmp/serena-search-$$.json`
- Shows example output format
- Provides MCP integration command

**Example Results:**
```json
{
  "results": [
    {
      "content": "Fixed SQL injection vulnerability in /api/users endpoint",
      "tags": ["security", "sql-injection", "fix"],
      "category": "security_findings",
      "timestamp": "2025-10-15T14:30:00Z",
      "similarity_score": 0.89
    }
  ]
}
```

---

### 3. mode-context.sh

Load relevant historical context for development modes.

**Usage:**
```bash
./mode-context.sh [mode_name]
```

**Supported Modes:**
- `pr-review` - Code review context
- `security-audit` - Security findings and trends
- `testing` - Test patterns and failures
- `documentation` - Architecture decisions and gaps
- `performance` - Optimization patterns
- `devops` - Deployment and infrastructure
- `data-science` - ML experiments and pipelines
- `30-hour` / `full-stack` / `quick-fix` - General context

**Mode-Specific Queries:**

| Mode | Context Loaded |
|------|----------------|
| **pr-review** | Security findings (7 days), test failures, code review patterns, architecture decisions |
| **security-audit** | Historical vulnerabilities, security trends, penetration tests, OWASP compliance |
| **testing** | Test failures (7 days), successful patterns, flaky tests, coverage improvements |
| **documentation** | Architecture decisions, documentation gaps, user feedback, API changes |
| **performance** | Performance bottlenecks, optimization wins, load tests, DB query performance |
| **devops** | Deployment failures, infrastructure changes, CI/CD issues, monitoring alerts |
| **data-science** | ML experiment results, model metrics, feature engineering, data pipelines |

**Examples:**

```bash
# Load context for PR review
./mode-context.sh pr-review

# Load context for security audit
./mode-context.sh security-audit

# Load context for testing session
./mode-context.sh testing

# Load context for documentation work
./mode-context.sh documentation
```

**Output:**
- Displays mode activation summary
- Executes 4 contextual searches per mode
- Saves search payloads to `/tmp/serena-mode-search-{mode}-*.json`
- Shows MCP integration commands
- Displays mode-specific context guidelines

**Example Output:**
```
Loading context for pr-review mode...

[1/4] Searching: security findings last 7 days (security_findings)
[2/4] Searching: test failures unresolved (test_results)
[3/4] Searching: code review feedback patterns (code_reviews)
[4/4] Searching: architecture decisions recent (architecture_decisions)

✓ Context queries prepared for pr-review mode

Context Guidelines for pr-review mode:
- Focus on security vulnerabilities from recent scans
- Check for patterns in previous code reviews
- Verify test coverage for changed files
- Reference architecture decisions for consistency
```

---

## Integration with Modes

To integrate Serena context loading into mode scripts, add this to mode activation:

```bash
# In scripts/modes/enable-pr-review-mode.sh
echo "Loading Serena context for PR review..."
"${SCRIPT_DIR}/../serena/mode-context.sh" pr-review
```

This automatically loads relevant historical context when switching modes.

---

## Integration with Test Runners

Store test results automatically:

```bash
# After Playwright test run
if [[ $TEST_EXIT_CODE -ne 0 ]]; then
  "${SCRIPT_DIR}/serena/create-memory.sh" \
    "Playwright test failed: $TEST_NAME with error: $ERROR_MESSAGE" \
    "testing,e2e,playwright,failure" \
    "test_results"
fi
```

---

## Integration with Security Scans

Store Kali MCP scan results:

```bash
# After nmap scan
SCAN_RESULTS=$(nmap -sV target.com)
"${SCRIPT_DIR}/serena/create-memory.sh" \
  "Nmap scan of target.com: $SCAN_RESULTS" \
  "security,nmap,scan,network" \
  "security_findings"
```

---

## Workflow Examples

### PR Review Workflow

```bash
# 1. Switch to PR review mode
./scripts/modes/enable-pr-review-mode.sh

# 2. Load relevant context (runs automatically)
./scripts/serena/mode-context.sh pr-review

# 3. Search for specific security context
./scripts/serena/search-context.sh "SQL injection patterns" 5

# 4. After review, store findings
./scripts/serena/create-memory.sh \
  "PR #123: Found XSS vulnerability in search component" \
  "security,xss,pr-review,vulnerability" \
  "code_reviews"
```

### Security Audit Workflow

```bash
# 1. Switch to security audit mode
./scripts/modes/enable-security-audit-mode.sh

# 2. Load security context
./scripts/serena/mode-context.sh security-audit

# 3. Run Kali MCP scans
kali-nmap target.com

# 4. Store scan results
./scripts/serena/create-memory.sh \
  "Nmap scan found open ports: 22, 80, 443, 3306" \
  "security,nmap,ports,network" \
  "security_findings"

# 5. Search for similar past vulnerabilities
./scripts/serena/search-context.sh "open MySQL port" 10
```

### Testing Workflow

```bash
# 1. Switch to testing mode
./scripts/modes/enable-testing-mode.sh

# 2. Load test context
./scripts/serena/mode-context.sh testing

# 3. Run tests
npm test

# 4. Store failures
./scripts/serena/create-memory.sh \
  "Login test failing: Timeout waiting for redirect" \
  "testing,unit,login,timeout" \
  "test_results"

# 5. Search for similar failures
./scripts/serena/search-context.sh "login timeout" 5 "test_results"
```

---

## Architecture

### Data Flow

```
Development Activity
    ↓
Helper Scripts (create-memory.sh, search-context.sh, mode-context.sh)
    ↓
JSON Payloads (/tmp/serena-*.json)
    ↓
Serena MCP (claude-mcp-call serena create_memory/search_memories)
    ↓
Persistent Memory Store (~/.serena/memories/)
    ↓
Future Context Retrieval (semantic search with time decay)
```

### Memory Lifecycle

1. **Creation** - Event occurs (test, scan, review)
2. **Storage** - create-memory.sh stores with tags and category
3. **Indexing** - Serena creates semantic embeddings
4. **Retrieval** - search-context.sh or mode-context.sh queries
5. **Decay** - Time decay factor reduces relevance over time
6. **Retention** - Memories expire based on category TTL

---

## Configuration

Serena configuration is stored in `.serena/stoked-automations.yml`:

```yaml
# Memory retention policy
retention:
  default_ttl: 90  # days
  categories:
    security_findings: 365    # Keep security data longer
    architecture_decisions: -1  # Keep forever
    test_results: 30          # Keep test results 30 days

# Search configuration
search:
  similarity_threshold: 0.65  # Lower = broader matches
  max_results: 15
  time_decay_factor: 0.9      # Recent memories weighted 90% higher

# Auto-tagging rules
auto_tags:
  - pattern: "**/test*.{ts,tsx}"
    tags: ["testing", "unit-tests"]
  - pattern: "**/security/**/*"
    tags: ["security"]
```

---

## Troubleshooting

### Scripts Not Executing

```bash
# Ensure scripts are executable
chmod +x scripts/serena/*.sh

# Verify bash version (need 4.0+)
bash --version
```

### MCP Integration Not Working

```bash
# Verify Serena MCP is installed
/plugin list | grep serena

# Install if missing
/plugin install serena@stoked-automations

# Check MCP server status
claude-mcp-status serena
```

### Search Returns No Results

- Lower similarity threshold in `.serena/stoked-automations.yml`
- Try broader search queries
- Check if memories exist in category: `ls ~/.serena/memories/`

### Memory Creation Fails

- Verify JSON syntax in generated payload
- Check disk space: `df -h ~/.serena/`
- Review Serena MCP logs

---

## Best Practices

1. **Tag Consistently** - Use lowercase, hyphenated tags (`sql-injection`, not `SQL_Injection`)
2. **Categorize Correctly** - Choose appropriate category for easier retrieval
3. **Be Specific** - Include context like file paths, error messages, timestamps
4. **Search Semantically** - Use natural language queries, not exact keywords
5. **Review Context** - Run mode-context.sh before starting work
6. **Store Failures** - Document what went wrong to avoid repeating mistakes
7. **Link Related Memories** - Use consistent tags to create connections

---

## Resources

- **Serena Integration Architecture:** `docs/SERENA_INTEGRATION_ARCHITECTURE.md`
- **Serena Configuration:** `.serena/stoked-automations.yml`
- **Serena MCP Plugin:** `plugins/mcp/serena/`
- **Mode System Guide:** `docs/MODE_SYSTEM_GUIDE.md`

---

**Last Updated:** October 2025
**Repository Version:** 2025.0.0
**Status:** Active development