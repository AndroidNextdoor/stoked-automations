# Plugin Development Standards

**Official standards and best practices for Stoked Automations plugin development**

**Author:** Andrew Nixdorf <andrew@stokedautomation.com>
**Version:** 2025.0.0
**Last Updated:** October 2025

---

## Overview

This document defines the official standards for developing plugins in the Stoked Automations marketplace. All plugins must adhere to these standards to ensure quality, security, and maintainability.

---

## Plugin Types

### 1. Command Plugins

**Purpose:** Provide slash commands that users explicitly invoke

**Structure:**
```
plugin-name/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   ├── command1.md
│   ├── command2.md
│   └── command3.md
├── README.md
└── LICENSE
```

**Requirements:**
- Command markdown files must have YAML frontmatter
- Each command must have: `name`, `description`, `model`
- Commands should be idempotent when possible

---

### 2. Skill Plugins

**Purpose:** Auto-activate based on conversation context

**Structure:**
```
plugin-name/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── skill-adapter/
│       └── SKILL.md
├── README.md
└── LICENSE
```

**Requirements:**
- Skills must include trigger phrases in description
- Must explain WHEN to activate clearly
- Should provide comprehensive usage examples

---

### 3. Agent Plugins

**Purpose:** Provide specialized AI agents with specific expertise

**Structure:**
```
plugin-name/
├── .claude-plugin/
│   └── plugin.json
├── agents/
│   ├── agent1.md
│   └── agent2.md
├── README.md
└── LICENSE
```

**Requirements:**
- Agents must have clear role definitions
- Should specify model (sonnet, opus, haiku)
- Must include expertise areas

---

### 4. MCP Server Plugins

**Purpose:** Run as separate processes providing tools/capabilities

**Structure:**
```
plugin-name/
├── .claude-plugin/
│   ├── plugin.json
│   └── mcp/
│       └── server.json
├── src/
│   └── index.ts
├── dist/  (generated)
├── package.json
├── tsconfig.json
├── README.md
└── LICENSE
```

**Requirements:**
- Must use TypeScript or Python
- Must implement Model Context Protocol spec
- Must handle errors gracefully
- Must provide health check endpoint

---

## File Standards

### plugin.json

**Required Fields:**
```json
{
  "name": "plugin-name",
  "version": "2025.0.0",
  "description": "Clear one-line description",
  "category": "productivity",
  "keywords": ["keyword1", "keyword2", "keyword3"],
  "author": {
    "name": "Author Name",
    "email": "email@stokedautomations.com"
  },
  "repository": "https://github.com/owner/repo",
  "license": "MIT"
}
```

**Optional Fields:**
```json
{
  "prerequisites": {
    "description": "What user needs before installing",
    "steps": [
      "Step 1",
      "Step 2"
    ]
  },
  "homepage": "https://plugin-site.com",
  "bugs": "https://github.com/owner/repo/issues"
}
```

---

### README.md

**Required Sections:**
1. Title and one-line description
2. Overview with key features
3. Installation instructions
4. Usage examples
5. Configuration (if applicable)
6. Troubleshooting
7. License

**Optional Sections:**
- API Reference
- Examples Gallery
- Benchmarks/Performance
- Roadmap
- Contributing guidelines

**Template:** See `templates/plugin-templates/README-TEMPLATE.md`

---

### LICENSE

**Approved Licenses:**
- MIT (Recommended)
- Apache 2.0
- BSD 3-Clause

**Not Allowed:**
- Proprietary licenses
- GPL (conflicts with marketplace distribution)
- Licenses restricting commercial use

---

## Coding Standards

### Markdown Files (Commands/Skills/Agents)

**Frontmatter:**
```yaml
---
name: command-name
description: Brief description
model: sonnet  # or opus, haiku
---
```

**Structure:**
1. Main heading matching name
2. Purpose/Overview
3. Detailed instructions
4. Examples
5. Best practices
6. Common issues

---

### TypeScript (MCP Servers)

**Style:**
```typescript
// Use strict typing
const config: ServerConfig = {
  timeout: 30000,
  retries: 3
};

// Async/await preferred over callbacks
async function getTool(name: string): Promise<Tool> {
  return await toolRegistry.get(name);
}

// Error handling required
try {
  await riskyOperation();
} catch (error) {
  logger.error(`Operation failed: ${error.message}`);
  throw new McpError("Operation failed", error);
}
```

**Configuration:**
```json
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "target": "ES2020",
    "module": "commonjs",
    "outDir": "./dist",
    "rootDir": "./src"
  }
}
```

---

### Shell Scripts

**Standards:**
```bash
#!/usr/bin/env bash
# Clear shebang

set -euo pipefail  # Strict mode

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Use ${CLAUDE_PLUGIN_ROOT} for paths
SCRIPT_DIR="${CLAUDE_PLUGIN_ROOT}/scripts"

# Validate inputs
if [[ -z "${1:-}" ]]; then
  echo "Error: Argument required"
  exit 1
fi

# Make scripts executable
# chmod +x scripts/*.sh
```

---

## Security Standards

### Input Validation

**Required:**
- Validate all user inputs
- Sanitize file paths
- Escape shell commands
- Validate URLs before fetching

**Example:**
```typescript
function validateEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    throw new Error("Invalid email format");
  }
  return true;
}
```

---

### Secrets Management

**Never:**
- Hardcode API keys
- Commit credentials to repository
- Log sensitive data

**Always:**
- Use environment variables
- Provide clear .env.example
- Document required secrets

**Example:**
```typescript
const apiKey = process.env.API_KEY;
if (!apiKey) {
  throw new Error("API_KEY environment variable required");
}
```

---

### File Operations

**Safe Patterns:**
```bash
# Validate path is within expected directory
SAFE_DIR="/Users/user/.plugin-data"
TARGET_FILE="$SAFE_DIR/$USER_INPUT"

# Resolve to absolute path
RESOLVED=$(realpath "$TARGET_FILE")

# Ensure still within safe directory
if [[ "$RESOLVED" != "$SAFE_DIR"* ]]; then
  echo "Error: Path traversal detected"
  exit 1
fi
```

---

## Testing Standards

### Unit Tests

**Required Coverage:**
- Critical functions: 90%+
- Overall codebase: 80%+

**Framework:**
- TypeScript: Jest or Vitest
- Python: pytest
- Shell: bats

**Example:**
```typescript
describe("Tool Execution", () => {
  it("should execute tool successfully", async () => {
    const result = await executeTool("test-tool", {});
    expect(result.status).toBe("success");
  });

  it("should handle errors gracefully", async () => {
    await expect(executeTool("invalid-tool", {}))
      .rejects.toThrow("Tool not found");
  });
});
```

---

### Integration Tests

**Required For:**
- MCP servers
- Plugins with external dependencies
- Multi-step workflows

**Example:**
```typescript
describe("MCP Server Integration", () => {
  beforeAll(async () => {
    server = await startServer();
  });

  it("should respond to health check", async () => {
    const response = await request(server).get("/health");
    expect(response.status).toBe(200);
  });

  afterAll(async () => {
    await server.close();
  });
});
```

---

## Documentation Standards

### Code Comments

**When to Comment:**
- Complex algorithms
- Non-obvious optimizations
- Security-critical sections
- Public APIs

**Style:**
```typescript
/**
 * Executes a tool with the given parameters
 * @param toolName - Name of the tool to execute
 * @param params - Tool-specific parameters
 * @returns Promise resolving to tool execution result
 * @throws McpError if tool not found or execution fails
 */
async function executeTool(
  toolName: string,
  params: Record<string, unknown>
): Promise<ToolResult> {
  // Implementation
}
```

---

### README Documentation

**Must Include:**
- Installation steps
- Configuration examples
- Usage examples (3+ scenarios)
- Troubleshooting section

**Should Include:**
- Architecture diagrams (Mermaid)
- API reference
- Performance benchmarks
- Contribution guidelines

---

## Performance Standards

### Response Time

**Command Plugins:**
- Simple commands: < 2 seconds
- Complex commands: < 10 seconds

**MCP Servers:**
- Tool execution: < 5 seconds
- Health checks: < 100ms

**Skills:**
- Activation detection: < 500ms
- Full execution: < 30 seconds

---

### Resource Usage

**Memory:**
- Commands/Skills: < 100MB
- MCP Servers: < 500MB
- Background processes: < 200MB

**CPU:**
- Should not peg CPU constantly
- Long-running operations should yield
- Use async I/O where possible

---

### Token Optimization

**Guidelines:**
- Keep prompts concise
- Use examples sparingly
- Cache frequently accessed data
- Stream large responses

---

## Versioning Standards

**Semantic Versioning (SemVer):**
- `MAJOR.MINOR.PATCH`
- MAJOR: Breaking changes
- MINOR: New features (backward compatible)
- PATCH: Bug fixes

**Annual Style (Repository-level):**
- `YYYY.MAJOR.MINOR`
- Used for overall marketplace versioning

**Examples:**
```
1.0.0 → Initial release
1.1.0 → Added new command
1.1.1 → Fixed bug
2.0.0 → Breaking API change
```

---

## CI/CD Standards

### Required Checks

**Every PR Must Pass:**
1. JSON validation (plugin.json, marketplace.json)
2. Markdown linting
3. Shell script permissions check
4. Security scanning (secrets, vulnerabilities)
5. Test suite execution
6. Build verification (for MCP servers)

**GitHub Actions Workflow:**
```yaml
name: Plugin Validation
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Validate JSON
        run: find . -name "*.json" -exec jq empty {} \;
      - name: Check Scripts
        run: find . -name "*.sh" -exec test -x {} \;
      - name: Run Tests
        run: npm test
```

---

## Marketplace Submission

### Pre-Submission Checklist

- [ ] plugin.json valid and complete
- [ ] README.md comprehensive
- [ ] LICENSE file present (MIT/Apache 2.0)
- [ ] No hardcoded secrets
- [ ] Scripts executable (`chmod +x`)
- [ ] Tests passing
- [ ] Documentation complete
- [ ] Examples provided
- [ ] Entry in marketplace.extended.json

### Submission Process

1. **Fork Repository**
2. **Create Plugin** in appropriate category folder
3. **Add to Marketplace** - Edit `marketplace.extended.json`
4. **Run Validation** - `./scripts/validate-all.sh`
5. **Sync Catalogs** - `pnpm run sync-marketplace`
6. **Submit PR** using template

---

## Maintenance Standards

### Regular Updates

**Required:**
- Security patches: Immediate
- Bug fixes: Within 1 week
- Dependency updates: Monthly
- Feature requests: Quarterly

### Deprecation Policy

**Process:**
1. Announce deprecation 90 days in advance
2. Mark as deprecated in plugin.json
3. Provide migration guide
4. Remove after deprecation period

---

## Best Practices

### Command Design

✅ **DO:**
- Use descriptive command names
- Provide helpful error messages
- Support --help flag
- Be idempotent when possible

❌ **DON'T:**
- Use generic names (e.g., "run", "do")
- Require complex arguments
- Make destructive actions without confirmation
- Depend on specific directory structures

---

### Skill Design

✅ **DO:**
- Be specific about activation triggers
- Provide context in responses
- Fail gracefully
- Document limitations

❌ **DON'T:**
- Activate on vague keywords
- Assume user intent
- Perform actions without confirmation
- Conflict with other skills

---

### MCP Server Design

✅ **DO:**
- Implement health checks
- Log errors comprehensively
- Handle connection failures
- Provide clear tool descriptions

❌ **DON'T:**
- Block on synchronous I/O
- Ignore errors
- Leak resources
- Run without proper authentication

---

## Resources

- **Plugin Templates:** `templates/plugin-templates/`
- **Example Plugins:** `plugins/examples/`
- **Contributing Guide:** `CONTRIBUTING.md`
- **Security Policy:** `SECURITY.md`

---

**Last Updated:** October 2025
**Repository Version:** 2025.0.0
**Status:** Active development