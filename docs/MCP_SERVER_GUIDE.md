# MCP Server Configuration Guide

**Complete guide to installing, configuring, and integrating MCP servers with Stoked Automations**

**Author:** Andrew Nixdorf <andrew@stokedautomation.com>
**Version:** 2025.0.0
**Last Updated:** October 2025

---

## Table of Contents

1. [Overview](#overview)
2. [What are MCP Servers?](#what-are-mcp-servers)
3. [Available MCP Servers](#available-mcp-servers)
4. [Installation Guide](#installation-guide)
5. [Configuration](#configuration)
6. [Integration Patterns](#integration-patterns)
7. [Troubleshooting](#troubleshooting)
8. [Best Practices](#best-practices)

---

## Overview

MCP (Model Context Protocol) servers extend Claude Code's capabilities by connecting to external tools, APIs, and services. This guide covers the 15 MCP servers available in the Stoked Automations marketplace.

**Quick Stats:**
- **15 MCP Servers** available
- **21+ Tools** provided across all servers
- **5 Categories:** Security, Testing, AI/ML, Development, Integration
- **3 Deployment Options:** Local, Docker, Cloud

---

## What are MCP Servers?

MCP Servers are standalone processes that:

1. **Expose Tools** - Provide specialized capabilities (e.g., nmap scanning, memory storage)
2. **Run Independently** - Separate from Claude Code main process
3. **Communicate via Protocol** - Use Model Context Protocol for data exchange
4. **Persist State** - Can maintain data between Claude Code sessions
5. **Integrate with IDEs** - Work with Claude Code, Cursor, and other AI IDEs

### Architecture

```
┌─────────────────┐
│  Claude Code    │
│  (AI Assistant) │
└────────┬────────┘
         │ MCP Protocol
         │
         ├──────────┬──────────┬──────────┬──────────┐
         │          │          │          │          │
    ┌────▼────┐┌───▼────┐┌───▼────┐┌───▼────┐┌───▼────┐
    │ Serena  ││  Kali  ││Browser ││AI Exp. ││Project │
    │   MCP   ││  MCP   ││Testing ││Logger  ││Health  │
    └────┬────┘└───┬────┘└───┬────┘└───┬────┘└───┬────┘
         │         │         │         │         │
    ┌────▼────┐┌──▼─────┐┌──▼─────┐┌──▼─────┐┌──▼─────┐
    │ Memory  ││Security││Browser ││ML Exp. ││Code    │
    │ Storage ││ Tools  ││ Tests  ││Tracking││Metrics │
    └─────────┘└────────┘└────────┘└────────┘└────────┘
```

---

## Available MCP Servers

### 1. Serena MCP (Memory & Context)

**Category:** AI/ML
**Tools:** 6
**Author:** oraios

**Capabilities:**
- `create_memory` - Store context with semantic embeddings
- `search_memories` - Semantic search across stored memories
- `get_project_context` - Load project-specific configuration
- `create_prompt` - Generate AI prompts from templates
- `analyze_codebase` - Language server integration for code analysis
- `list_memories` - Browse all stored memories

**Use Cases:**
- Persistent context across sessions
- Historical decision tracking
- Pattern recognition in code reviews
- Project-specific AI behavior

**Prerequisites:**
```bash
# Python 3.8+
python3 --version

# uv package manager
curl -LsSf https://astral.sh/uv/install.sh | sh

# Optional: Language servers
npm install -g typescript-language-server
pip install pyright
```

**Installation:**
```bash
/plugin install serena@stoked-automations
```

**Configuration:**
```yaml
# ~/.serena/serena_config.yml
embedding_model: "sentence-transformers/all-MiniLM-L6-v2"
memory_dir: "~/.serena/memories"
similarity_threshold: 0.7
max_results: 15
```

---

### 2. Kali MCP (Security Testing)

**Category:** Security
**Tools:** 1 (command execution for 600+ Kali tools)
**Author:** Wh0am123

**Capabilities:**
- `execute_kali_command` - Run any Kali Linux security tool

**Common Tools Available:**
- `nmap` - Network scanning
- `nikto` - Web vulnerability scanning
- `gobuster` - Directory/file brute-forcing
- `sqlmap` - SQL injection testing
- `metasploit` - Exploitation framework
- `burpsuite` - Web application testing
- `john` - Password cracking
- `hashcat` - Password recovery

**Use Cases:**
- Penetration testing
- Vulnerability assessment
- CTF challenges
- Security audits
- Network reconnaissance

**Prerequisites:**
```bash
# Option 1: Docker (Recommended)
docker --version

# Option 2: Kali Linux local
# Must be running on Kali Linux with tools installed

# Environment variables
export KALI_API_URL="http://localhost:8000"
export KALI_API_TOKEN="your-secure-token"  # Optional
```

**Installation:**
```bash
/plugin install kali-mcp@stoked-automations

# Docker deployment
cd ~/.claude-plugins/kali-mcp
docker-compose up -d
```

**Configuration:**
```yaml
# kali-mcp-config.yml
api_url: "http://localhost:8000"
api_token: null  # Set for authenticated access
timeout: 300  # Command timeout in seconds
allowed_tools:
  - nmap
  - nikto
  - gobuster
  - sqlmap
dangerous_commands_require_confirmation: true
```

---

### 3. Browser Testing Suite MCP

**Category:** Testing
**Tools:** 5
**Author:** Andrew Nixdorf

**Capabilities:**
- `run_playwright_test` - Execute Playwright browser tests
- `capture_screenshot` - Take page screenshots
- `run_accessibility_scan` - WCAG compliance checking
- `measure_performance` - Core Web Vitals measurement
- `visual_regression_test` - Compare screenshots for changes

**Use Cases:**
- E2E browser testing
- Accessibility audits
- Performance monitoring
- Visual regression testing
- Cross-browser validation

**Prerequisites:**
```bash
# Node.js 18+
node --version

# Playwright
npm install -D @playwright/test
npx playwright install
```

**Installation:**
```bash
/plugin install browser-testing-suite@stoked-automations
```

**Configuration:**
```yaml
# browser-testing-config.yml
browsers:
  - chromium
  - firefox
  - webkit
viewport:
  width: 1920
  height: 1080
headless: true
screenshots_dir: "./test-results/screenshots"
trace_on_failure: true
```

---

### 4. AI Experiment Logger MCP

**Category:** AI/ML
**Tools:** 4
**Author:** Andrew Nixdorf

**Capabilities:**
- `log_experiment` - Track ML experiments with parameters
- `compare_experiments` - Compare multiple experiment runs
- `get_best_model` - Retrieve top-performing models
- `visualize_metrics` - Generate performance charts

**Use Cases:**
- ML model training tracking
- Hyperparameter tuning
- Model versioning
- Performance comparison
- Experiment reproducibility

**Prerequisites:**
```bash
# Python 3.8+
python3 --version

# ML libraries (optional)
pip install mlflow tensorboard
```

**Installation:**
```bash
/plugin install ai-experiment-logger@stoked-automations
```

**Configuration:**
```yaml
# experiment-logger-config.yml
storage_backend: "sqlite"  # or "postgres", "mlflow"
experiments_dir: "./ml-experiments"
auto_save_models: true
tracking_metrics:
  - accuracy
  - precision
  - recall
  - f1_score
  - loss
```

---

### 5. Project Health Auditor MCP

**Category:** Development
**Tools:** 4
**Author:** Andrew Nixdorf

**Capabilities:**
- `analyze_codebase` - Static code analysis
- `check_dependencies` - Outdated/vulnerable dependency scan
- `measure_complexity` - Cyclomatic complexity metrics
- `generate_health_report` - Comprehensive project health score

**Use Cases:**
- Technical debt tracking
- Code quality monitoring
- Dependency management
- Refactoring prioritization
- CI/CD health checks

**Prerequisites:**
```bash
# Node.js for JS/TS projects
node --version

# Python for Python projects
python3 --version

# Analysis tools
npm install -g eslint
pip install radon bandit
```

**Installation:**
```bash
/plugin install project-health-auditor@stoked-automations
```

**Configuration:**
```yaml
# health-auditor-config.yml
languages:
  - typescript
  - python
metrics:
  - code_coverage
  - test_pass_rate
  - cyclomatic_complexity
  - dependency_freshness
  - security_score
thresholds:
  overall_health: 80
  code_coverage: 80
  complexity: 10
```

---

### 6. Workflow Orchestrator MCP

**Category:** Development
**Tools:** 4
**Author:** Andrew Nixdorf

**Capabilities:**
- `create_workflow` - Define DAG-based workflows
- `execute_workflow` - Run multi-step automation
- `get_workflow_status` - Monitor execution progress
- `list_workflows` - Browse available workflows

**Use Cases:**
- CI/CD automation
- Multi-step deployments
- Data pipeline orchestration
- Testing workflows
- Release automation

**Prerequisites:**
```bash
# Node.js 18+
node --version

# Docker (for containerized tasks)
docker --version
```

**Installation:**
```bash
/plugin install workflow-orchestrator@stoked-automations
```

**Configuration:**
```yaml
# workflow-config.yml
workflows_dir: "./workflows"
max_parallel_tasks: 5
retry_failed_tasks: true
max_retries: 3
log_level: "info"
```

---

### 7. Conversational API Debugger MCP

**Category:** Development
**Tools:** 4
**Author:** Andrew Nixdorf

**Capabilities:**
- `test_api_endpoint` - Send HTTP requests
- `analyze_response` - Parse and validate responses
- `generate_curl_command` - Export as curl
- `mock_api_response` - Create mock responses

**Use Cases:**
- API development and testing
- Debugging API issues
- Documentation generation
- Integration testing
- Load testing

**Prerequisites:**
```bash
# Node.js 18+
node --version
```

**Installation:**
```bash
/plugin install conversational-api-debugger@stoked-automations
```

---

### 8. Design to Code MCP

**Category:** Development
**Tools:** 3
**Author:** Andrew Nixdorf

**Capabilities:**
- `analyze_design` - Extract components from Figma/screenshots
- `generate_component` - Create React/Vue components
- `optimize_styles` - Generate Tailwind CSS

**Use Cases:**
- Design-to-code automation
- Component generation
- Style extraction
- Prototyping

**Prerequisites:**
```bash
# Node.js 18+
node --version

# Figma API token (optional)
export FIGMA_API_TOKEN="your-token"
```

---

### 9-15. Additional MCP Servers

**9. Domain Memory Agent** - Project-specific knowledge base
**10. AWS Knowledge Base Retrieval** - AWS documentation search
**11. Context7** - Context management for long conversations
**12. Atlassian MCP** - Jira/Confluence integration
**13. GitLab MCP** - GitLab API integration
**14. Firecrawl MCP** - Web scraping and crawling

---

## Installation Guide

### Step 1: Install Prerequisites

Each MCP server has specific prerequisites. Check the server's documentation:

```bash
# Check Python version
python3 --version  # Should be 3.8+

# Check Node.js version
node --version  # Should be 18+

# Check Docker (for containerized servers)
docker --version
```

### Step 2: Install MCP Server Plugin

```bash
# Add Stoked Automations marketplace if not already added
/plugin marketplace add AndroidNextdoor/stoked-automations

# Install specific MCP server
/plugin install <server-name>@stoked-automations

# Examples:
/plugin install serena@stoked-automations
/plugin install kali-mcp@stoked-automations
/plugin install browser-testing-suite@stoked-automations
```

### Step 3: Configure MCP Server

Create configuration file in the server's config directory:

```bash
# Serena MCP
mkdir -p ~/.serena
vim ~/.serena/serena_config.yml

# Kali MCP
mkdir -p ~/.kali-mcp
vim ~/.kali-mcp/config.yml

# Browser Testing Suite
mkdir -p ~/.browser-testing
vim ~/.browser-testing/config.yml
```

### Step 4: Start MCP Server

Most MCP servers start automatically when Claude Code loads them. For manual control:

```bash
# Check MCP server status
claude-mcp-status <server-name>

# Start MCP server manually
claude-mcp-start <server-name>

# Stop MCP server
claude-mcp-stop <server-name>

# Restart MCP server
claude-mcp-restart <server-name>
```

### Step 5: Verify Installation

```bash
# List all MCP tools available
claude-mcp-list-tools

# Test specific MCP server
claude-mcp-call serena list_memories
claude-mcp-call kali-mcp execute_kali_command '{"command": "nmap --version"}'
```

---

## Configuration

### Environment Variables

MCP servers use environment variables for configuration:

```bash
# ~/.bashrc or ~/.zshrc

# Serena MCP
export SERENA_CONFIG_PATH="$HOME/.serena/serena_config.yml"
export SERENA_MEMORY_DIR="$HOME/.serena/memories"

# Kali MCP
export KALI_API_URL="http://localhost:8000"
export KALI_API_TOKEN="your-secure-token"

# Browser Testing Suite
export PLAYWRIGHT_BROWSERS_PATH="$HOME/.playwright"
export BROWSER_TESTING_CONFIG="$HOME/.browser-testing/config.yml"

# AI Experiment Logger
export MLFLOW_TRACKING_URI="file:///path/to/mlruns"
export EXPERIMENT_LOGGER_DB="sqlite:///experiments.db"

# Project Health Auditor
export HEALTH_AUDITOR_CONFIG="$HOME/.health-auditor/config.yml"
```

### Config File Locations

| MCP Server | Config File Location |
|------------|---------------------|
| Serena | `~/.serena/serena_config.yml` |
| Kali MCP | `~/.kali-mcp/config.yml` |
| Browser Testing | `~/.browser-testing/config.yml` |
| AI Experiment Logger | `~/.experiment-logger/config.yml` |
| Project Health Auditor | `~/.health-auditor/config.yml` |
| Workflow Orchestrator | `~/.workflow-orchestrator/config.yml` |

### Global MCP Configuration

Claude Code MCP settings:

```json
// ~/.claude-code/mcp-settings.json
{
  "servers": {
    "serena": {
      "enabled": true,
      "autostart": true,
      "config_path": "~/.serena/serena_config.yml"
    },
    "kali-mcp": {
      "enabled": true,
      "autostart": false,
      "config_path": "~/.kali-mcp/config.yml"
    },
    "browser-testing-suite": {
      "enabled": true,
      "autostart": true,
      "config_path": "~/.browser-testing/config.yml"
    }
  },
  "global": {
    "timeout": 300000,
    "max_retries": 3,
    "log_level": "info"
  }
}
```

---

## Integration Patterns

### Pattern 1: Serena + Workflow Automation

Store workflow results in Serena for historical context:

```bash
# Execute security scan workflow
./scripts/workflows/security-scan-workflow.sh localhost:4321

# Results automatically stored in Serena via:
# - create_memory() calls with scan findings
# - Tagging: security, scan, vulnerability
# - Category: security_findings

# Next security audit loads this context automatically
./scripts/modes/enable-security-audit-mode.sh
# Serena provides: "Last scan found 3 open ports, 2 missing headers"
```

### Pattern 2: Kali MCP + Serena

Security testing with persistent memory:

```bash
# Run nmap scan via Kali MCP
kali-mcp execute_kali_command "nmap -sV target.com"

# Store results in Serena
serena create_memory \
  "Nmap scan found ports 22, 80, 443 open on target.com" \
  "security,nmap,ports,target.com" \
  "security_findings"

# Future scans compare against baseline
```

### Pattern 3: Browser Testing + Health Auditor

E2E testing with code quality tracking:

```bash
# Run browser tests
browser-testing-suite run_playwright_test "./tests/e2e"

# If tests fail, analyze project health
project-health-auditor generate_health_report

# Cross-reference: Do code quality issues correlate with test failures?
```

### Pattern 4: AI Experiment Logger + Serena

ML experiment tracking with context:

```bash
# Log ML experiment
ai-experiment-logger log_experiment \
  --name "bert-finetuning-v3" \
  --params '{"lr": 0.001, "batch_size": 32}'

# Store experiment metadata in Serena
serena create_memory \
  "BERT fine-tuning v3: 0.89 accuracy, best model yet" \
  "ml,bert,experiment,success" \
  "ml_experiments"

# Future experiments load context of best hyperparameters
```

---

## Troubleshooting

### MCP Server Won't Start

**Symptoms:**
```
Error: MCP server 'serena' failed to start
```

**Solutions:**

```bash
# 1. Check prerequisites installed
python3 --version  # For Python-based servers
node --version     # For Node.js-based servers

# 2. Check config file exists
ls -la ~/.serena/serena_config.yml

# 3. Check logs
tail -f ~/.claude-code/logs/mcp-serena.log

# 4. Verify permissions
chmod 644 ~/.serena/serena_config.yml

# 5. Restart Claude Code
```

---

### Connection Timeout

**Symptoms:**
```
Error: MCP call timed out after 30000ms
```

**Solutions:**

```bash
# Increase timeout in global config
vim ~/.claude-code/mcp-settings.json
# Set: "timeout": 300000  # 5 minutes

# Or increase per-server
export SERENA_TIMEOUT=300000
```

---

### Tool Not Found

**Symptoms:**
```
Error: Tool 'create_memory' not found in server 'serena'
```

**Solutions:**

```bash
# 1. List available tools
claude-mcp-list-tools serena

# 2. Verify server is running
claude-mcp-status serena

# 3. Restart server
claude-mcp-restart serena

# 4. Reinstall plugin
/plugin uninstall serena@stoked-automations
/plugin install serena@stoked-automations
```

---

### Memory/Storage Issues

**Symptoms:**
```
Error: ENOSPC: no space left on device
```

**Solutions:**

```bash
# Check disk space
df -h ~/.serena/memories

# Clean old memories (Serena)
serena prune_memories --older-than 90d

# Clean test artifacts (Browser Testing)
rm -rf ./test-results/screenshots/*

# Clean experiment logs (AI Experiment Logger)
mlflow gc --backend-store-uri sqlite:///experiments.db
```

---

## Best Practices

### 1. Start Small

Begin with 1-2 MCP servers, master them, then expand:

```bash
# Recommended starter servers
/plugin install serena@stoked-automations  # Memory & context
/plugin install browser-testing-suite@stoked-automations  # E2E testing
```

### 2. Configure Retention Policies

Don't let storage grow unbounded:

```yaml
# ~/.serena/serena_config.yml
retention:
  default_ttl: 90  # days
  categories:
    security_findings: 365  # Keep security data longer
    test_results: 30        # Prune test results sooner
```

### 3. Use Environment-Specific Configs

Different configs for dev/staging/prod:

```bash
# ~/.bashrc
if [[ "$ENV" == "production" ]]; then
  export KALI_API_URL="https://prod-kali.example.com"
else
  export KALI_API_URL="http://localhost:8000"
fi
```

### 4. Monitor MCP Server Health

```bash
# Add health checks to cron
# crontab -e
*/15 * * * * claude-mcp-health-check --all --alert-on-failure
```

### 5. Version Pin Critical Servers

```bash
# Pin versions in package.json or requirements.txt
{
  "dependencies": {
    "serena-mcp": "2025.0.0",  # Exact version
    "kali-mcp": "^2025.0.0"    # Compatible versions
  }
}
```

### 6. Backup MCP Data

```bash
# Backup Serena memories
tar -czf serena-backup-$(date +%Y%m%d).tar.gz ~/.serena/memories/

# Backup experiments
tar -czf experiments-backup-$(date +%Y%m%d).tar.gz ./ml-experiments/

# Backup test results
tar -czf test-results-backup-$(date +%Y%m%d).tar.gz ./test-results/
```

---

## Resources

- **Serena Integration Architecture:** `docs/SERENA_INTEGRATION_ARCHITECTURE.md`
- **Workflow Automation:** `scripts/workflows/README.md`
- **Mode System Guide:** `docs/MODE_SYSTEM_GUIDE.md`
- **Mode Enhancers:** `docs/MODE_ENHANCERS.md`

---

**Last Updated:** October 2025
**Repository Version:** 2025.0.0
**Status:** Active development