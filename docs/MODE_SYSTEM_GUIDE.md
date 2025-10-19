# Mode System Guide

## Overview

The Stoked Automations repository features a comprehensive mode system that optimizes Claude Code for different development scenarios. Each mode configures token limits, recommends specific plugins, and provides guidance for specialized workflows.

## Available Modes

### 1. 🔍 PR Review Mode
**Purpose:** Code review, security analysis, and pull request evaluation

**Token Strategy:** High thinking, moderate output
**Best For:** Pull request reviews, code audits, security analysis

**Activation:**
```bash
./scripts/modes/enable-pr-review-mode.sh
```

**Recommended Agents:**
- code-reviewer - Elite code review expert
- architect-review - Architecture patterns review
- security-auditor - Security and compliance
- performance-engineer - Performance optimization
- debugger - Error analysis

---

### 2. 🚀 30-Hour Deep Work Mode
**Purpose:** Extended deep work sessions and complex problem-solving

**Token Strategy:** Maximum output and thinking
**Best For:** Full-stack development, large-scale refactoring, system design

**Activation:**
```bash
./scripts/modes/enable-30-hour-mode.sh
```

**Recommended Agents:**
- architect-review, cloud-architect, backend-architect
- database-architect, kubernetes-architect
- docs-architect, api-documenter, tutorial-engineer
- code-reviewer, security-auditor, performance-engineer

---

### 3. ✅ Testing Mode
**Purpose:** Comprehensive testing workflows including TDD and QA

**Token Strategy:** Balanced (moderate output and thinking)
**Best For:** Writing tests, test automation, TDD workflows

**Activation:**
```bash
./scripts/modes/enable-testing-mode.sh
```

**Recommended Agents:**
- test-automator - AI-powered test automation
- tdd-orchestrator - TDD workflow coordination
- debugger - Error analysis
- code-reviewer - Test quality review

---

### 4. 📝 Documentation Mode
**Purpose:** Technical writing and comprehensive documentation generation

**Token Strategy:** High output, moderate thinking
**Best For:** API docs, tutorials, architecture documentation

**Activation:**
```bash
./scripts/modes/enable-documentation-mode.sh
```

**Recommended Agents:**
- docs-architect - Technical documentation from code
- api-documenter - OpenAPI 3.1 & API documentation
- tutorial-engineer - Step-by-step tutorials
- mermaid-expert - Diagrams for visual documentation
- reference-builder - Exhaustive technical references

---

### 5. 🔒 Security Audit Mode
**Purpose:** Security analysis, vulnerability scanning, compliance auditing

**Token Strategy:** High thinking for deep security analysis
**Best For:** Security reviews, vulnerability scanning, compliance audits

**Activation:**
```bash
./scripts/modes/enable-security-audit-mode.sh
```

**Recommended Agents:**
- security-auditor - Comprehensive security analysis
- backend-security-coder - Backend security implementations
- frontend-security-coder - Frontend security patterns
- mobile-security-coder - Mobile security

---

### 6. ⚡ Performance Optimization Mode
**Purpose:** Performance analysis, profiling, and optimization

**Token Strategy:** High output, high thinking
**Best For:** Performance tuning, profiling, optimization

**Activation:**
```bash
./scripts/modes/enable-performance-mode.sh
```

**Recommended Agents:**
- performance-engineer - Performance optimization expert
- database-optimizer - Database performance tuning
- observability-engineer - Monitoring and observability

---

### 7. ⚙️ DevOps Mode
**Purpose:** Infrastructure, CI/CD pipelines, deployment automation

**Token Strategy:** High thinking for infrastructure decisions
**Best For:** Infrastructure setup, CI/CD pipelines, incident response

**Activation:**
```bash
./scripts/modes/enable-devops-mode.sh
```

**Recommended Agents:**
- deployment-engineer - CI/CD pipelines & GitOps
- terraform-specialist - Advanced IaC automation
- kubernetes-architect - K8s cloud-native architecture
- incident-responder - SRE incident management
- devops-troubleshooter - Incident response & debugging

---

### 8. 📊 Data Science Mode
**Purpose:** Data analysis, machine learning, and analytics

**Token Strategy:** High output for analysis results
**Best For:** Data analysis, ML model training, pipeline creation

**Activation:**
```bash
./scripts/modes/enable-data-science-mode.sh
```

**Recommended Agents:**
- data-scientist - Advanced analytics and modeling
- ml-engineer - Production ML systems
- mlops-engineer - ML pipelines and deployment
- data-engineer - Data pipelines & warehouses

---

### 9. 🌐 Full-Stack Development Mode
**Purpose:** Complete application development from frontend to backend

**Token Strategy:** Maximum tokens (similar to 30-hour mode)
**Best For:** Building complete applications from scratch

**Activation:**
```bash
./scripts/modes/enable-fullstack-mode.sh
```

**Recommended Agents:**
- frontend-developer - React, Next.js, modern frontend
- backend-architect - Backend system architecture
- database-architect - Database design from scratch
- api-documenter - API documentation
- test-automator - Testing automation

---

### 10. 🔧 Quick Fix Mode
**Purpose:** Fast bug fixes and small changes

**Token Strategy:** Conservative token limits
**Best For:** Hot fixes, debugging, small patches

**Activation:**
```bash
./scripts/modes/enable-quick-fix-mode.sh
```

**Recommended Agents:**
- debugger - Error analysis specialist
- error-detective - Log analysis & root cause
- code-reviewer - Quick code quality check

---

## Mode Manager

The unified mode management system makes it easy to switch between modes and view information.

### Usage

```bash
# List all available modes
./scripts/modes/mode-manager.sh list

# Show current active mode
./scripts/modes/mode-manager.sh current

# Get detailed information about a mode
./scripts/modes/mode-manager.sh info testing

# Switch to a different mode
./scripts/modes/mode-manager.sh switch documentation
```

### Configuration

All mode configurations are centralized in `config/modes.json`, which includes:
- Token limit specifications (high/medium/low)
- Recommended plugins and agents
- Use cases and descriptions
- Activation scripts

## Token Limit Philosophy

### System Resource Detection

All mode scripts automatically detect your system's RAM and adjust token limits accordingly:

- **High-end (16GB+):** Maximum token limits
- **Mid-range (8-16GB):** Balanced configuration
- **Low-end (<8GB):** Conservative limits

### Token Strategy by Mode Type

1. **High Output Modes** (Documentation, Data Science, Full-Stack)
   - Focus on generating comprehensive content
   - Lower thinking tokens, higher output tokens

2. **High Thinking Modes** (Security Audit, DevOps, PR Review)
   - Focus on deep analysis and decision-making
   - Higher thinking tokens for complex reasoning

3. **Balanced Modes** (Testing, Performance, 30-Hour)
   - Equal emphasis on analysis and generation
   - Balanced token distribution

4. **Conservative Modes** (Quick Fix)
   - Fast, focused work
   - Lower token limits for efficiency

## Best Practices

### Choosing the Right Mode

1. **Match mode to task complexity:**
   - Simple fixes → Quick Fix Mode
   - Comprehensive projects → 30-Hour or Full-Stack Mode
   - Specific workflows → Specialized modes

2. **Consider time investment:**
   - Short tasks (< 1 hour) → Quick Fix, Testing
   - Medium tasks (1-8 hours) → Specialized modes
   - Long tasks (8+ hours) → 30-Hour, Full-Stack

3. **Match to deliverable type:**
   - Code changes → PR Review, Testing, Quick Fix
   - Documentation → Documentation Mode
   - Infrastructure → DevOps Mode
   - Data work → Data Science Mode

### Workflow Integration

1. **Start of day:** Switch to your primary mode
2. **Quick interruptions:** Use Quick Fix Mode
3. **Context switch:** Use mode-manager to switch modes
4. **End of day:** Document which mode you used in commits

### Plugin Installation

After switching modes, install recommended plugins:

```bash
# In Claude Code session:
/plugin marketplace add AndroidNextdoor/stoked-automations
/plugin install code-review-ai@stoked-automations

# Enable agents as recommended by the mode
/plugin enable code-review-ai@stoked-automations
```

### Monitoring Token Usage

Always monitor your token usage:

```bash
# In Claude Code:
/context
```

This shows:
- Current token usage
- Active plugins and agents
- Available free space

## Creating Custom Modes

You can create your own custom modes by:

1. **Create mode script** in `scripts/modes/enable-your-mode.sh`
2. **Add configuration** to `config/modes.json`
3. **Make script executable:** `chmod +x scripts/modes/enable-your-mode.sh`
4. **Test:** `./scripts/modes/mode-manager.sh switch your-mode`

### Example Custom Mode

```bash
#!/usr/bin/env bash
# enable-mobile-dev-mode.sh
set -e

# Detect system and set tokens
if [[ "$OSTYPE" == "darwin"* ]]; then
    TOTAL_RAM_GB=$(($(sysctl -n hw.memsize) / 1024 / 1024 / 1024))
else
    TOTAL_RAM_GB=$(free -g | awk '/^Mem:/{print $2}')
fi

# Configure for mobile development
MAX_OUTPUT_TOKENS=40000
MAX_THINKING_TOKENS=20000

export CLAUDE_CODE_MAX_OUTPUT_TOKENS=$MAX_OUTPUT_TOKENS
export MAX_THINKING_TOKENS=$MAX_THINKING_TOKENS

echo "Mobile Development Mode Enabled"
echo "Recommended: ios-developer, mobile-developer, flutter-expert"
```

## Troubleshooting

### Mode not activating

1. Check script is executable: `ls -l scripts/modes/*.sh`
2. Verify mode exists: `./scripts/modes/mode-manager.sh list`
3. Check script output for errors

### Token limits not applying

1. Restart Claude Code after switching modes
2. Verify environment variables: `echo $CLAUDE_CODE_MAX_OUTPUT_TOKENS`
3. Check `/context` in Claude Code session

### Plugins not loading

1. Verify marketplace is added: `/plugin marketplace list`
2. Check plugin is installed: `/plugin list`
3. Enable plugin: `/plugin enable <plugin-name>`

## Mode Combinations

Some workflows benefit from switching modes mid-session:

### Example: Feature Development Workflow

1. **Planning:** 30-Hour Mode (architecture design)
2. **Implementation:** Full-Stack Mode (coding)
3. **Testing:** Testing Mode (write tests)
4. **Documentation:** Documentation Mode (write docs)
5. **Review:** PR Review Mode (final review)

### Example: Bug Fix Workflow

1. **Investigation:** Quick Fix Mode (find the bug)
2. **Fix:** Testing Mode (write failing test, then fix)
3. **Review:** PR Review Mode (ensure quality)

## Resources

- **Mode Configuration:** `config/modes.json`
- **Mode Scripts:** `scripts/modes/`
- **Mode Manager:** `scripts/modes/mode-manager.sh`
- **Plugin Marketplace:** https://stokedautomations.com/

---

**Version:** 2025.0.0
**Last Updated:** October 2025
**Maintainer:** Andrew Nixdorf ([email protected])