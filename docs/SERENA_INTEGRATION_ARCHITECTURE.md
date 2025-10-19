# Serena Integration Architecture
## Centralized Memory & Context Management for Stoked Automations

**Author:** Andrew Nixdorf (andrew@stokedautomation.com)
**Version:** 2025.0.0
**Last Updated:** October 2025

---

## Vision

Serena MCP acts as the **central nervous system** for the entire Stoked Automations repository, providing:

- **Persistent Context**: All test results, security findings, and development insights stored with semantic search
- **Cross-Workflow Intelligence**: Knowledge from Kali MCP security tests informs code reviews; test failures guide documentation
- **Project Memory**: Every mode switch, plugin usage, and workflow execution contributes to growing repository intelligence
- **AI-Guided Development**: Context-aware prompts that understand your entire development history

---

## Core Integration Points

### 1. **Mode System Integration**

Each development mode automatically syncs with Serena to maintain context across mode switches.

#### Mode-Specific Memory Patterns

```yaml
# ~/.serena/stoked-automations/modes/pr-review.yml
mode: pr-review
active_since: 2025-10-18T16:00:00Z

memories:
  - type: code_review_standards
    content: "Always check for security vulnerabilities using OWASP Top 10"
    tags: [security, code-review, standards]

  - type: recent_findings
    content: "Last PR had SQL injection vulnerability in query builder"
    tags: [security, vulnerability, sql-injection]
    related_plugins: [kali-mcp, security-auditor]

custom_prompts:
  - role: system
    content: |
      You are in PR Review Mode. Focus on:
      - Security vulnerabilities (reference recent findings in memory)
      - Code quality and maintainability
      - Test coverage

      Recent context: {serena.search("recent security findings")}
```

#### Mode Switch Workflow

```bash
# When switching modes, Serena captures context
scripts/modes/enable-security-audit-mode.sh
  ↓
  1. Store current mode context to Serena
  2. Retrieve security-audit mode memories
  3. Load relevant past audit findings
  4. Generate mode-specific prompts
```

### 2. **Kali MCP + Serena: Security Intelligence Loop**

Every security test result feeds into Serena for future reference and pattern detection.

#### Workflow Pattern

```
User: "Scan the API for vulnerabilities"
  ↓
Kali MCP: Runs nmap, nikto, sqlmap
  ↓
Test Results: [Findings: Open ports, SQL injection, XSS]
  ↓
Serena: create_memory({
  content: "API vulnerability scan found: SQL injection in /api/users, XSS in /search",
  tags: ["security", "vulnerability", "api", "sql-injection", "xss"],
  severity: "high",
  timestamp: "2025-10-18T16:30:00Z",
  related_files: ["src/api/users.ts", "src/components/Search.tsx"]
})
  ↓
Future PR Review: Serena reminds about these vulnerabilities when reviewing related files
```

#### Security Memory Schema

```typescript
interface SecurityMemory {
  type: 'vulnerability' | 'scan_result' | 'exploit_attempt' | 'remediation';
  severity: 'critical' | 'high' | 'medium' | 'low' | 'info';
  tool_used: 'nmap' | 'sqlmap' | 'nikto' | 'metasploit' | string;
  target: string;  // URL, IP, or file path
  findings: string[];
  remediation_status: 'open' | 'in_progress' | 'fixed' | 'accepted_risk';
  related_memories: string[];  // IDs of related memories
  tags: string[];
}
```

### 3. **Testing Integration (Browser Testing Suite + Serena)**

Test results become persistent knowledge that guides future development.

#### Test Failure Memory Pattern

```yaml
# Playwright test failure stored in Serena
type: test_failure
test_suite: e2e-marketplace
test_name: "User can complete checkout flow"
failure_reason: "Element '#checkout-button' not found"
failure_screenshot: "/tmp/test-screenshots/checkout-failure-2025-10-18.png"
stack_trace: |
  Error: Timeout 30000ms exceeded.
  waiting for locator('#checkout-button')
    at /tests/checkout.spec.ts:45:21
related_files:
  - "marketplace/src/pages/checkout.tsx"
  - "marketplace/src/components/CheckoutButton.tsx"
tags: [test-failure, e2e, checkout, ui]
context: "Testing after recent UI redesign with warm color palette"
suggested_fix: "Check if button ID changed during redesign"
```

#### Test Intelligence Workflow

```
Test Run: npm run test:e2e
  ↓
Failures Detected: 3 tests failed
  ↓
Serena Integration:
  1. Store each failure with full context
  2. Link to related code files
  3. Search for similar past failures
  4. Generate fix suggestions based on history
  ↓
Developer Query: "Why is checkout test failing?"
  ↓
Serena: search_memories("checkout test failure")
  → Returns: Historical failures, recent code changes, suggested fixes
```

### 4. **AI Experiment Logger + Serena: ML Context**

Track all ML experiments, model performance, and hyperparameter tuning with persistent context.

#### ML Memory Pattern

```yaml
type: ml_experiment
experiment_id: "exp-20251018-001"
model_type: "transformer"
task: "code-review-automation"
dataset: "stoked-automations-prs"
hyperparameters:
  learning_rate: 0.001
  batch_size: 32
  epochs: 10
results:
  accuracy: 0.89
  f1_score: 0.85
  precision: 0.87
  recall: 0.83
insights:
  - "Model performs better on security-related PRs"
  - "Struggles with complex TypeScript generics"
tags: [ml, experiment, code-review, transformer]
related_experiments: ["exp-20251017-003", "exp-20251016-001"]
```

### 5. **Project Health Auditor + Serena: Repository Intelligence**

Health checks become longitudinal data showing repository evolution.

#### Health Audit Memory

```yaml
type: health_audit
audit_date: 2025-10-18
overall_score: 85/100
metrics:
  code_quality: 90
  test_coverage: 78
  security_score: 88
  documentation: 82
  dependency_health: 85
issues_found:
  - type: "outdated_dependency"
    package: "astro"
    current: "5.14.5"
    latest: "5.15.0"
    severity: "low"
  - type: "missing_tests"
    file: "src/components/PluginCard.tsx"
    coverage: "45%"
    severity: "medium"
trends:
  - "Code quality improving (was 85 last week)"
  - "Test coverage decreased 5% since redesign"
tags: [health-audit, metrics, trends]
```

### 6. **Workflow Orchestrator + Serena: Automated Context Sharing**

Complex workflows can query Serena for context before execution.

#### Workflow with Serena Integration

```yaml
# Example: Full-Stack Feature Development Workflow
name: feature-development
steps:
  - id: gather_context
    tool: serena
    action: search_memories
    params:
      query: "recent architecture decisions, coding standards, test patterns"
      max_results: 10
    output: feature_context

  - id: design_phase
    tool: claude
    prompt: |
      Design a new feature: {{ feature_name }}

      Context from Serena:
      {{ feature_context }}

      Previous similar features:
      {{ serena.search("feature similar to " + feature_name) }}
    output: feature_design

  - id: implementation
    depends_on: design_phase
    tool: claude
    prompt: "Implement feature based on design: {{ feature_design }}"
    output: feature_code

  - id: store_decisions
    tool: serena
    action: create_memory
    params:
      content: "Implemented {{ feature_name }}: {{ feature_design }}"
      tags: [feature, implementation, {{ feature_name }}]
```

---

## Serena Configuration for Stoked Automations

### Repository-Level Configuration

Create `.serena/stoked-automations.yml` in the repository root:

```yaml
name: "Stoked Automations"
description: "Claude Code plugin marketplace with 231 plugins and comprehensive development workflows"

# Memory organization
memory_categories:
  - security_findings
  - test_results
  - code_reviews
  - ml_experiments
  - health_audits
  - architecture_decisions
  - mode_contexts
  - workflow_executions

# Custom prompts for repository
custom_prompts:
  code_review:
    system: |
      You are reviewing code in the Stoked Automations repository.
      This repository contains 231 Claude Code plugins across 15 categories.

      Context to consider:
      - Recent security findings: {{ serena.search("security findings last 7 days") }}
      - Active mode: {{ current_mode }}
      - Recent test failures: {{ serena.search("test failures") }}

      Focus on:
      1. Plugin architecture best practices
      2. MCP server integration patterns
      3. Security considerations for plugin distribution
      4. Test coverage for new features

  feature_development:
    system: |
      You are developing a feature for Stoked Automations.

      Repository standards:
      - JetBrains versioning (YYYY.MAJOR.MINOR)
      - Author: Andrew Nixdorf (andrew@stokedautomation.com)
      - License: MIT
      - Warm color palette: tan, beige, orange, brown

      Architecture patterns:
      {{ serena.search("architecture patterns", max_results=5) }}

  security_audit:
    system: |
      You are conducting a security audit.

      Historical vulnerabilities:
      {{ serena.search("vulnerabilities fixed", max_results=10) }}

      Current threat landscape:
      {{ serena.search("security trends 2025") }}

# Language server integration
language_servers:
  typescript:
    enabled: true
    paths:
      - "marketplace/src/**/*.ts"
      - "marketplace/src/**/*.tsx"
      - "plugins/mcp/**/*.ts"

  python:
    enabled: true
    paths:
      - "scripts/**/*.py"
      - "plugins/mcp/**/*.py"

  bash:
    enabled: true
    paths:
      - "scripts/**/*.sh"

# Search configuration
search:
  similarity_threshold: 0.65  # Lower for broader matches
  max_results: 15
  time_decay_factor: 0.9  # Recent memories weighted higher

# Auto-tagging rules
auto_tags:
  - pattern: "**/test*.{ts,tsx,js,jsx}"
    tags: [testing, unit-tests]

  - pattern: "**/e2e/**/*"
    tags: [testing, e2e]

  - pattern: "**/security/**/*"
    tags: [security]

  - pattern: "**/mcp/**/*"
    tags: [mcp, integration]

  - pattern: "scripts/modes/**/*"
    tags: [modes, workflow]
```

---

## Practical Usage Patterns

### Pattern 1: Security-Aware Development

```
# Developer workflow
1. Enable security audit mode
   → Serena loads: past vulnerabilities, OWASP patterns, recent scans

2. Run Kali MCP scan
   → Results automatically stored in Serena with tags

3. Code review
   → Claude references Serena: "This endpoint was flagged for SQL injection last month"

4. Fix and verify
   → Serena updates: remediation_status: "fixed"

5. Future reference
   → Next security audit queries: "Show me previously fixed SQL injection patterns"
```

### Pattern 2: Test-Driven Development with Memory

```
# TDD workflow with persistent context
1. Write failing test
   → Serena stores: test intent, expected behavior

2. Test fails
   → Serena captures: failure reason, stack trace, screenshot

3. Implement feature
   → Claude queries Serena: "Show me similar test patterns"

4. Test passes
   → Serena updates: test_status: "passing", related_memories: [implementation details]

5. Future refactoring
   → Serena provides: "This test was tricky, here's why it failed initially"
```

### Pattern 3: Mode-Aware Context

```
# Mode switching with full context
1. Working in fullstack mode
   → Serena tracks: components built, APIs created, database schema changes

2. Switch to testing mode
   → Serena provides: "You just built these 5 components, here are test patterns"

3. Switch to documentation mode
   → Serena generates: "Document these APIs based on implementation context"

4. Switch to security mode
   → Serena highlights: "These new endpoints need security review"
```

### Pattern 4: Cross-Plugin Intelligence

```
# Plugins working together through Serena
1. Browser Testing Suite finds UI bug
   → Serena stores: bug details, screenshot, related components

2. Design-to-Code plugin proposes fix
   → Queries Serena: "What UI patterns work for this component?"

3. Project Health Auditor runs
   → References Serena: "Recent UI changes decreased test coverage"

4. Code Review plugin activates
   → Checks Serena: "Are we addressing the UI bugs from testing?"
```

---

## Implementation Roadmap

### Phase 1: Core Integration (Week 1-2)

- [ ] Create `.serena/stoked-automations.yml` repository configuration
- [ ] Add Serena initialization to mode scripts
- [ ] Document memory schema for each plugin category
- [ ] Create helper scripts for common Serena operations

### Phase 2: Plugin Integration (Week 3-4)

- [ ] Integrate Kali MCP → Serena (security findings)
- [ ] Integrate Browser Testing Suite → Serena (test results)
- [ ] Integrate AI Experiment Logger → Serena (ML experiments)
- [ ] Integrate Project Health Auditor → Serena (health metrics)

### Phase 3: Workflow Automation (Week 5-6)

- [ ] Create mode-aware prompts with Serena context
- [ ] Build automated memory creation hooks
- [ ] Implement cross-reference linking between memories
- [ ] Add intelligent memory pruning and archival

### Phase 4: Advanced Features (Week 7-8)

- [ ] Trend detection across memories
- [ ] Predictive insights (e.g., "This code pattern previously had bugs")
- [ ] Automatic documentation generation from memories
- [ ] Cross-repository memory sharing (if multiple projects)

---

## Helper Scripts

### scripts/serena/create-memory.sh

```bash
#!/usr/bin/env bash
# Create a memory in Serena with proper tagging

CONTENT="$1"
TAGS="$2"
CATEGORY="$3"

cat << EOF | claude-mcp-call serena create_memory
{
  "content": "$CONTENT",
  "tags": ["stoked-automations", $TAGS],
  "category": "$CATEGORY",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "repository": "AndroidNextdoor/stoked-automations"
}
EOF
```

### scripts/serena/search-context.sh

```bash
#!/usr/bin/env bash
# Search Serena for relevant context

QUERY="$1"
MAX_RESULTS="${2:-10}"

cat << EOF | claude-mcp-call serena search_memories
{
  "query": "$QUERY",
  "max_results": $MAX_RESULTS,
  "filter": {
    "repository": "AndroidNextdoor/stoked-automations"
  }
}
EOF
```

### scripts/serena/mode-context.sh

```bash
#!/usr/bin/env bash
# Load context for current development mode

MODE="$1"

cat << EOF | claude-mcp-call serena get_project_context
{
  "mode": "$MODE",
  "include": ["custom_prompts", "recent_memories", "active_workflows"]
}
EOF
```

---

## Best Practices

### 1. **Consistent Memory Structure**

Always use structured data when creating memories:

```typescript
{
  type: 'test_failure' | 'security_finding' | 'code_review' | 'experiment',
  severity?: 'critical' | 'high' | 'medium' | 'low',
  status?: 'open' | 'in_progress' | 'resolved',
  tags: string[],  // Always include category tags
  related_files?: string[],
  related_memories?: string[]
}
```

### 2. **Tag Taxonomy**

Use consistent tagging:

- **Category**: `security`, `testing`, `ml`, `health`, `architecture`
- **Component**: `frontend`, `backend`, `mcp`, `plugin`, `marketplace`
- **Language**: `typescript`, `python`, `bash`, `markdown`
- **Status**: `open`, `fixed`, `wontfix`, `investigating`
- **Severity**: `critical`, `high`, `medium`, `low`, `info`

### 3. **Memory Lifecycle**

- **Create**: When events occur (test fails, vulnerability found, decision made)
- **Update**: When status changes (bug fixed, experiment completed)
- **Link**: Connect related memories for context
- **Archive**: Move old memories to historical context (after 90 days)

### 4. **Context-Aware Queries**

Always provide context when querying:

```typescript
// Good: Specific query with filters
serena.search("SQL injection vulnerabilities in API endpoints", {
  tags: ["security", "api"],
  time_range: "last_30_days"
})

// Bad: Vague query
serena.search("bugs")
```

---

## Metrics & KPIs

Track the effectiveness of Serena integration:

### Memory Usage Metrics

- Total memories stored
- Memories by category
- Most frequently accessed memories
- Memory search accuracy
- Average retrieval time

### Development Impact Metrics

- Reduction in repeated mistakes (vulnerabilities, bugs)
- Time saved on context gathering
- Increase in cross-plugin workflow efficiency
- Developer satisfaction with context retrieval

### Intelligence Metrics

- Prediction accuracy (e.g., "This code pattern tends to fail")
- Automated documentation quality
- Cross-reference relevance score
- Trend detection accuracy

---

## Troubleshooting

### Issue: Memories not being created

**Check:**
1. Serena MCP server is running: `/plugin list`
2. Configuration exists: `~/.serena/serena_config.yml`
3. Storage path is writable: `~/.serena/memories/`

### Issue: Search returns irrelevant results

**Solutions:**
1. Lower similarity threshold in config
2. Add more specific tags to memories
3. Use more detailed queries
4. Check embedding model is loaded

### Issue: Mode context not loading

**Check:**
1. Mode-specific config exists: `.serena/stoked-automations/modes/`
2. Mode name matches exactly
3. Custom prompts are properly formatted (YAML syntax)

---

## Future Vision

### Serena as Repository Consciousness

Imagine asking:

- "What security patterns have we fixed before?"
  → Serena returns all historical security fixes with code examples

- "Why did we choose this architecture?"
  → Serena provides the discussion, alternatives considered, and decision rationale

- "Show me all test failures related to the checkout flow"
  → Serena returns chronological history with fixes

- "What plugins work well together?"
  → Serena analyzes usage patterns and suggests combinations

- "Predict where bugs are likely to occur"
  → Serena uses historical data to flag risky code patterns

This isn't just memory storage—it's **institutional knowledge** that makes every developer more effective.

---

## Resources

- **Serena MCP Documentation**: [plugins/mcp/serena/README.md](../plugins/mcp/serena/README.md)
- **Mode System Guide**: [MODE_SYSTEM_GUIDE.md](MODE_SYSTEM_GUIDE.md)
- **MCP Servers Status**: [MCP-SERVERS-STATUS.md](../MCP-SERVERS-STATUS.md)

---

**Version:** 2025.0.0
**Last Updated:** October 2025
**Maintainer:** Andrew Nixdorf (andrew@stokedautomation.com)