# Mode Enhancers

**Advanced techniques for supercharging Claude Code development modes with intelligent context and automation**

**Author:** Andrew Nixdorf <andrew@stokedautomation.com>
**Version:** 2025.0.0
**Last Updated:** October 2025

---

## Overview

Mode Enhancers are patterns, plugins, and workflows that amplify the power of Claude Code's development modes. Rather than just switching token limits and recommended agents, Mode Enhancers create an **intelligent development environment** that learns, adapts, and provides context-aware assistance.

### Philosophy

Traditional modes are static configurations. **Enhanced modes** are dynamic systems that:

- **Remember** - Store context from past sessions (via Serena MCP)
- **Learn** - Analyze patterns in failures, successes, and decisions
- **Adapt** - Adjust recommendations based on project history
- **Predict** - Surface relevant context before you ask for it
- **Automate** - Run workflows automatically based on mode activation

---

## Core Enhancement Strategies

### 1. Memory-Enhanced Modes (Serena Integration)

Every mode becomes smarter by storing and retrieving relevant memories.

**Pattern:**
```bash
# When entering a mode
1. Load historical context for that mode
2. Execute mode-specific memory queries
3. Display relevant past decisions/failures
4. Proceed with enhanced context
```

**Implementation:**

```bash
# scripts/modes/enable-pr-review-mode.sh

# Standard mode activation
echo "Activating PR Review Mode..."

# ENHANCEMENT: Load Serena context
"${SCRIPT_DIR}/../serena/mode-context.sh" pr-review

# This automatically queries:
# - Security findings from last 7 days
# - Recent test failures
# - Code review patterns
# - Architecture decisions

# Now PR reviews benefit from accumulated knowledge
```

**Benefits:**
- **Never repeat mistakes** - Past vulnerabilities surface during reviews
- **Pattern recognition** - Common code smells identified automatically
- **Historical context** - "We tried this approach 2 weeks ago and it failed"
- **Trend analysis** - "Login tests have been flaky for 3 days"

---

### 2. Workflow-Enhanced Modes

Modes that automatically run workflows on activation.

**Pattern:**
```bash
# When entering a mode
1. Run pre-checks (tests, security scans, linting)
2. Store results in Serena
3. Display summary to user
4. Continue with mode work
```

**Implementation:**

```bash
# scripts/modes/enable-security-audit-mode.sh

echo "🔒 Security Audit Mode - Running pre-audit checks..."

# ENHANCEMENT: Automatic security scan
./scripts/workflows/security-scan-workflow.sh localhost:4321 quick

# Results stored in Serena and displayed
echo "✓ Pre-audit baseline established"
echo "  - Open ports: 3 (22, 80, 443)"
echo "  - Missing headers: X-Frame-Options, CSP"
echo "  - Hardcoded secrets: 0"
echo ""
echo "Begin security audit with historical context loaded..."
```

**Benefits:**
- **Instant baseline** - Know the current state immediately
- **Automated checks** - Don't forget to run scans
- **Persistent tracking** - Compare results over time
- **Context-aware** - Start work with full knowledge

---

### 3. Plugin-Enhanced Modes

Modes that automatically install and configure relevant plugins.

**Pattern:**
```bash
# When entering a mode
1. Check for recommended plugins
2. Install missing plugins automatically
3. Configure plugin settings for mode
4. Verify plugin health
```

**Implementation:**

```bash
# scripts/modes/enable-testing-mode.sh

echo "🧪 Testing Mode - Setting up testing stack..."

# ENHANCEMENT: Auto-install testing plugins
REQUIRED_PLUGINS=(
  "code-review-ai@stoked-automations"
  "katalon-test-analyzer@stoked-automations"
  "browser-testing-suite@stoked-automations"
)

for plugin in "${REQUIRED_PLUGINS[@]}"; do
  if ! /plugin list | grep -q "$plugin"; then
    echo "Installing $plugin..."
    /plugin install "$plugin"
  fi
done

echo "✓ Testing stack ready"
```

**Benefits:**
- **Zero setup friction** - Plugins installed automatically
- **Consistency** - Same tools across team members
- **Version control** - Pin specific plugin versions
- **Health checks** - Verify plugins work before starting

---

### 4. Agent-Enhanced Modes

Modes that pre-load relevant AI agents with custom instructions.

**Pattern:**
```bash
# When entering a mode
1. Identify required agents for mode
2. Load agent-specific prompts from Serena
3. Configure agent token limits
4. Set agent specializations
```

**Implementation:**

```bash
# scripts/modes/enable-documentation-mode.sh

echo "📝 Documentation Mode - Loading AI agents..."

# ENHANCEMENT: Pre-configure documentation agents
cat > /tmp/docs-agent-config.json <<EOF
{
  "agents": [
    {
      "name": "docs-architect",
      "prompt": "$(${SCRIPT_DIR}/../serena/search-context.sh 'documentation standards' 1)",
      "output_tokens": 48000
    },
    {
      "name": "api-documenter",
      "prompt": "Focus on OpenAPI 3.1 specs and interactive examples",
      "output_tokens": 32000
    },
    {
      "name": "tutorial-engineer",
      "prompt": "Create step-by-step tutorials with code examples",
      "output_tokens": 24000
    }
  ]
}
EOF

echo "✓ Documentation agents configured with historical best practices"
```

**Benefits:**
- **Specialized expertise** - Agents tuned for mode tasks
- **Historical wisdom** - Agents know past documentation decisions
- **Token optimization** - Right limits for each agent type
- **Consistent output** - Agents follow established patterns

---

### 5. MCP-Enhanced Modes

Modes that leverage MCP servers for extended capabilities.

**Pattern:**
```bash
# When entering a mode
1. Activate relevant MCP servers
2. Configure MCP server settings
3. Establish data flow between MCP and Serena
4. Set up automatic result storage
```

**Implementation:**

```bash
# scripts/modes/enable-security-audit-mode.sh

echo "🔒 Security Audit Mode - Activating MCP servers..."

# ENHANCEMENT: Configure Kali MCP for security testing
cat > /tmp/kali-mcp-config.json <<EOF
{
  "auto_store_results": true,
  "result_category": "security_findings",
  "severity_threshold": "medium",
  "tools_enabled": ["nmap", "nikto", "sqlmap", "gobuster"]
}
EOF

# Activate Kali MCP with config
echo "✓ Kali MCP ready for security testing"
echo "  - Nmap: Network reconnaissance"
echo "  - Nikto: Web server scanning"
echo "  - SQLMap: SQL injection testing"
echo "  - Gobuster: Directory enumeration"
echo ""
echo "All scan results will be stored in Serena automatically"
```

**Benefits:**
- **Extended capabilities** - Access specialized tools
- **Automatic logging** - All results stored persistently
- **Tool orchestration** - MCP servers work together
- **Enterprise integration** - Connect to company tools

---

## Mode Enhancement Patterns

### Pattern 1: Context Loading Pipeline

**Goal:** Provide maximum relevant context when entering a mode.

```bash
#!/usr/bin/env bash
# Mode context loading pipeline

MODE_NAME="$1"

# 1. Load mode-specific memories
./scripts/serena/mode-context.sh "$MODE_NAME"

# 2. Load project health metrics
./scripts/workflows/health-check.sh --quiet

# 3. Load git context
echo "📊 Repository Context:"
echo "  Branch: $(git rev-parse --abbrev-ref HEAD)"
echo "  Last commit: $(git log -1 --pretty=format:'%h - %s (%ar)')"
echo "  Uncommitted changes: $(git status --short | wc -l) files"

# 4. Load dependency status
echo "📦 Dependencies:"
if [[ -f package.json ]]; then
  echo "  Outdated: $(npm outdated --json | jq '. | length') packages"
fi

# 5. Load test status
echo "🧪 Tests:"
echo "  Last run: $(cat /tmp/last-test-run.txt 2>/dev/null || echo 'Never')"
echo "  Status: $(cat /tmp/last-test-status.txt 2>/dev/null || echo 'Unknown')"

# 6. Display relevant warnings
./scripts/serena/search-context.sh "critical issues unresolved" 3
```

---

### Pattern 2: Pre-Flight Checks

**Goal:** Verify system is ready before starting mode work.

```bash
#!/usr/bin/env bash
# Pre-flight checks for modes

MODE_NAME="$1"

echo "🚦 Pre-flight checks for $MODE_NAME mode..."

ISSUES=()

# Check 1: Git status
if [[ -n "$(git status --porcelain)" ]]; then
  ISSUES+=("Uncommitted changes - consider stashing")
fi

# Check 2: Dependencies
if [[ -f package-lock.json ]]; then
  if [[ package-lock.json -ot package.json ]]; then
    ISSUES+=("Dependencies out of sync - run npm install")
  fi
fi

# Check 3: Test status
if ! npm test --silent 2>/dev/null; then
  ISSUES+=("Tests failing - fix before starting work")
fi

# Check 4: Required tools
REQUIRED_TOOLS=(jq git node npm)
for tool in "${REQUIRED_TOOLS[@]}"; do
  if ! command -v "$tool" &>/dev/null; then
    ISSUES+=("Missing tool: $tool")
  fi
done

# Display results
if [[ ${#ISSUES[@]} -eq 0 ]]; then
  echo "✅ All pre-flight checks passed"
  return 0
else
  echo "⚠️  Pre-flight issues detected:"
  for issue in "${ISSUES[@]}"; do
    echo "  - $issue"
  done
  echo ""
  read -p "Continue anyway? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    return 0
  else
    return 1
  fi
fi
```

---

### Pattern 3: Post-Mode Actions

**Goal:** Store learnings and clean up when exiting a mode.

```bash
#!/usr/bin/env bash
# Post-mode actions

MODE_NAME="$1"
DURATION="$2"  # seconds in mode

echo "📝 Storing session summary in Serena..."

# Gather session statistics
FILES_CHANGED=$(git diff --name-only | wc -l)
LINES_ADDED=$(git diff --numstat | awk '{s+=$1} END {print s}')
LINES_DELETED=$(git diff --numstat | awk '{s+=$2} END {print s}')
COMMITS_MADE=$(git log --since="$DURATION seconds ago" --oneline | wc -l)

# Create session summary
SESSION_SUMMARY="$MODE_NAME session completed: ${DURATION}s, $FILES_CHANGED files, +$LINES_ADDED/-$LINES_DELETED lines, $COMMITS_MADE commits"

# Store in Serena
./scripts/serena/create-memory.sh \
  "$SESSION_SUMMARY" \
  "mode,session,$MODE_NAME,productivity" \
  "mode_contexts"

# Ask for session notes
echo ""
read -p "Any notes to remember from this session? " SESSION_NOTES

if [[ -n "$SESSION_NOTES" ]]; then
  ./scripts/serena/create-memory.sh \
    "$SESSION_NOTES" \
    "mode,session-notes,$MODE_NAME" \
    "mode_contexts"
fi

echo "✅ Session logged successfully"
```

---

## Advanced Enhancement Techniques

### 1. Mode Chaining

**Concept:** Automatically transition between modes based on work phase.

```bash
# Example: Full development lifecycle chain

1. START: Full-Stack Mode
   ↓ (feature implementation complete)
2. AUTO-SWITCH: Testing Mode
   ↓ (tests passing)
3. AUTO-SWITCH: Security Audit Mode
   ↓ (no vulnerabilities)
4. AUTO-SWITCH: Documentation Mode
   ↓ (docs updated)
5. AUTO-SWITCH: PR Review Mode
   ↓ (review passed)
6. COMPLETE: Merge ready
```

**Implementation:**
```bash
# scripts/modes/mode-chain.sh

#!/usr/bin/env bash
CURRENT_MODE="fullstack"

while true; do
  case "$CURRENT_MODE" in
    fullstack)
      ./scripts/modes/enable-fullstack-mode.sh
      read -p "Feature complete? (y/n) " -n 1 -r
      [[ $REPLY =~ ^[Yy]$ ]] && CURRENT_MODE="testing"
      ;;
    testing)
      ./scripts/workflows/test-workflow.sh all true
      [[ $? -eq 0 ]] && CURRENT_MODE="security-audit" || break
      ;;
    security-audit)
      ./scripts/workflows/security-scan-workflow.sh
      [[ $? -eq 0 ]] && CURRENT_MODE="documentation" || break
      ;;
    documentation)
      ./scripts/modes/enable-documentation-mode.sh
      read -p "Docs complete? (y/n) " -n 1 -r
      [[ $REPLY =~ ^[Yy]$ ]] && CURRENT_MODE="pr-review"
      ;;
    pr-review)
      echo "✅ Ready to create PR!"
      break
      ;;
  esac
done
```

---

### 2. Intelligent Mode Suggestions

**Concept:** AI suggests which mode to use based on current context.

```bash
# scripts/modes/suggest-mode.sh

#!/usr/bin/env bash

# Analyze current context
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
FAILING_TESTS=$(npm test 2>&1 | grep -c "FAIL" || echo 0)
SECURITY_ISSUES=$(./scripts/workflows/security-scan-workflow.sh 2>&1 | grep -c "vulnerability")
UNCOMMITTED=$(git status --short | wc -l)

# Suggest mode based on context
if [[ $FAILING_TESTS -gt 0 ]]; then
  echo "🧪 Suggested: Testing Mode"
  echo "   Reason: $FAILING_TESTS failing tests detected"
elif [[ $SECURITY_ISSUES -gt 0 ]]; then
  echo "🔒 Suggested: Security Audit Mode"
  echo "   Reason: $SECURITY_ISSUES security issues found"
elif [[ "$GIT_BRANCH" == *"feature/"* ]]; then
  echo "🌐 Suggested: Full-Stack Mode"
  echo "   Reason: Feature branch detected"
elif [[ "$GIT_BRANCH" == *"hotfix/"* ]]; then
  echo "🔧 Suggested: Quick Fix Mode"
  echo "   Reason: Hotfix branch detected"
elif [[ "$GIT_BRANCH" == *"docs/"* ]]; then
  echo "📝 Suggested: Documentation Mode"
  echo "   Reason: Documentation branch detected"
else
  echo "🚀 Suggested: 30-Hour Mode"
  echo "   Reason: General development work"
fi
```

---

### 3. Mode Performance Analytics

**Concept:** Track which modes are most productive for different tasks.

```bash
# scripts/modes/mode-analytics.sh

#!/usr/bin/env bash

# Query Serena for mode usage statistics
./scripts/serena/search-context.sh "mode session" 100 "mode_contexts" > /tmp/mode-stats.json

# Analyze mode effectiveness
echo "📊 Mode Performance Analytics"
echo ""
echo "Most Used Modes:"
jq -r '.results[] | .content' /tmp/mode-stats.json | \
  grep -oP '(pr-review|testing|security-audit|documentation|fullstack)' | \
  sort | uniq -c | sort -rn | head -5

echo ""
echo "Average Session Duration:"
# Calculate average duration per mode

echo ""
echo "Mode with Most Productivity (lines changed):"
# Analyze lines changed per mode

echo ""
echo "Recommendation: Use Testing Mode more frequently (highest success rate)"
```

---

## Mode Enhancer Plugins

### Recommended Plugins for Enhanced Modes

| Plugin | Enhances | Purpose |
|--------|----------|---------|
| **serena@stoked-automations** | All modes | Persistent memory and context |
| **kali-mcp@stoked-automations** | Security Audit | Advanced security testing tools |
| **code-review-ai@stoked-automations** | PR Review, Testing | AI-powered code analysis |
| **skills-powerkit@stoked-automations** | All modes | Plugin management automation |
| **browser-testing-suite@stoked-automations** | Testing | E2E browser testing |
| **ai-experiment-logger@stoked-automations** | Data Science | ML experiment tracking |
| **project-health-auditor@stoked-automations** | All modes | Code health metrics |
| **workflow-orchestrator@stoked-automations** | All modes | Automated workflow execution |

---

## Creating Custom Mode Enhancers

### Step 1: Define Enhancement Goal

```
What problem does this enhancement solve?
Example: "PR reviews miss security vulnerabilities from past scans"
```

### Step 2: Design Enhancement Pattern

```bash
# Pattern: Security-Enhanced PR Review

1. Load recent security findings from Serena
2. Cross-reference PR files with vulnerable files
3. Display warnings for files with known issues
4. Auto-block PRs touching critical security files
```

### Step 3: Implement Enhancement Script

```bash
# scripts/mode-enhancers/security-enhanced-pr-review.sh

#!/usr/bin/env bash
PR_NUMBER="$1"

# Get PR files
PR_FILES=$(gh pr view "$PR_NUMBER" --json files -q '.files[].path')

# Load security findings
VULNERABLE_FILES=$(./scripts/serena/search-context.sh \
  "security vulnerability file path" 20 "security_findings" | \
  jq -r '.results[].metadata.file_path')

# Cross-reference
MATCHES=()
for pr_file in $PR_FILES; do
  if echo "$VULNERABLE_FILES" | grep -q "$pr_file"; then
    MATCHES+=("$pr_file")
  fi
done

# Display warnings
if [[ ${#MATCHES[@]} -gt 0 ]]; then
  echo "⚠️  SECURITY WARNING: PR modifies files with known vulnerabilities"
  for file in "${MATCHES[@]}"; do
    echo "  - $file"
  done
  echo ""
  echo "Review security findings:"
  ./scripts/serena/search-context.sh "vulnerability $file" 5
fi
```

### Step 4: Integrate with Mode

```bash
# scripts/modes/enable-pr-review-mode.sh

# ... existing mode setup ...

# ENHANCEMENT: Security cross-check
if [[ -n "$PR_NUMBER" ]]; then
  ./scripts/mode-enhancers/security-enhanced-pr-review.sh "$PR_NUMBER"
fi
```

---

## Best Practices

### 1. Keep Enhancements Optional

Allow users to disable enhancements via config:

```bash
# .mode-config
ENABLE_SERENA_CONTEXT=true
ENABLE_AUTO_WORKFLOWS=true
ENABLE_PLUGIN_INSTALL=false
```

### 2. Fail Gracefully

Enhancements should never block mode activation:

```bash
# Bad: Hard failure
./scripts/serena/mode-context.sh pr-review || exit 1

# Good: Soft failure
./scripts/serena/mode-context.sh pr-review || {
  echo "⚠️  Serena context unavailable - continuing without enhancement"
}
```

### 3. Provide Performance Metrics

Show users the value of enhancements:

```bash
echo "✅ Mode enhanced with:"
echo "  - 15 relevant memories loaded (0.3s)"
echo "  - Security baseline established (1.2s)"
echo "  - 3 plugins auto-configured (0.5s)"
echo "  Total enhancement time: 2.0s"
```

### 4. Cache Expensive Operations

Don't repeat expensive operations within a session:

```bash
# Cache security scan results for 1 hour
SCAN_CACHE="/tmp/security-scan-cache-$(date +%Y%m%d%H).json"
if [[ -f "$SCAN_CACHE" ]]; then
  echo "Using cached security scan ($(stat -f%Sm "$SCAN_CACHE"))"
else
  ./scripts/workflows/security-scan-workflow.sh > "$SCAN_CACHE"
fi
```

---

## Future Enhancements

Planned mode enhancer features:

- [ ] **AI Mode Coach** - GPT-4 suggests optimizations during mode usage
- [ ] **Cross-Mode Learning** - Transfer learnings between related modes
- [ ] **Team Mode Sync** - Share mode enhancements across team
- [ ] **Mode Templates** - Save custom mode configurations
- [ ] **Visual Mode Dashboard** - GUI for mode management and analytics
- [ ] **Mode Replay** - Re-execute past successful mode sessions
- [ ] **Predictive Enhancements** - ML predicts which enhancements you'll need

---

## Resources

- **Serena Integration Architecture:** `docs/SERENA_INTEGRATION_ARCHITECTURE.md`
- **Mode System Guide:** `docs/MODE_SYSTEM_GUIDE.md`
- **Workflow Automation:** `scripts/workflows/README.md`
- **Serena Helper Scripts:** `scripts/serena/README.md`

---

**Last Updated:** October 2025
**Repository Version:** 2025.0.0
**Status:** Active development