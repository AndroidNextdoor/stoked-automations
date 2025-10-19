# Claude Code Settings Guide

## Recommended Claude Code Configuration for Repository Management

This guide provides recommended Claude Code settings and approved commands for managing the Stoked Automations repository.

## Approved Commands for Repository Operations

### 1. File Operations

```bash
# Reading files (always safe)
cat
head
tail
less
more

# Finding files
find
locate
fd

# File content search
grep
rg (ripgrep)
ag (the silver searcher)

# Directory listing
ls
tree
```

### 2. Git Operations

```bash
# Safe git commands (read-only)
git status
git diff
git log
git show
git branch
git remote -v
git config --list

# Git operations requiring approval
git add
git commit
git push
git pull
git fetch
git merge
git rebase
git cherry-pick
git stash
git tag
```

### 3. Package Management

```bash
# Node.js / pnpm
pnpm install
pnpm build
pnpm test
pnpm run <script>
npm install
npm run
npm test

# Package info (read-only)
pnpm list
npm list
```

### 4. Repository Management Commands

```bash
# Validation scripts
./scripts/validate-all.sh
./scripts/test-installation.sh
python3 scripts/check-frontmatter.py

# Marketplace sync
pnpm run sync-marketplace
node scripts/sync-marketplace.cjs

# Mode switching
./scripts/modes/enable-pr-review-mode.sh
./scripts/modes/enable-30-hour-mode.sh

# Repository rebranding
./scripts/rebrand-repository.sh
./scripts/rebrand-repository.sh --dry-run

# File permissions
chmod +x <script>
find . -type f -name "*.sh" -exec chmod +x {} \;
```

### 5. JSON Validation

```bash
# Validate JSON files
jq empty <file.json>
jq . <file.json>

# Find and validate all JSON
find . -name "*.json" -exec sh -c 'jq empty {}' \;
```

### 6. Build and Development

```bash
# Astro marketplace
cd marketplace/
npm run dev
npm run build
npm run preview

# MCP plugin development
cd plugins/mcp/<plugin-name>/
pnpm build
pnpm test
pnpm typecheck
```

### 7. Security Scanning

```bash
# Check for secrets
grep -r "password\|secret\|api_key" plugins/ | grep -v placeholder

# NPM audit
npm audit
pnpm audit
```

## Claude Code Settings Configuration

### settings.json Location

Claude Code settings are stored in `~/.config/claude-code/settings.json` (Linux/macOS) or `%APPDATA%\claude-code\settings.json` (Windows).

### Recommended Settings for Repository Management

```json
{
  "approvedCommands": {
    "description": "Commands that don't require approval for Stoked Automations repository",
    "patterns": [
      "^cat ",
      "^head ",
      "^tail ",
      "^less ",
      "^more ",
      "^ls ",
      "^tree ",
      "^find ",
      "^fd ",
      "^grep ",
      "^rg ",
      "^ag ",
      "^git status$",
      "^git diff",
      "^git log",
      "^git show",
      "^git branch",
      "^git remote -v$",
      "^git config --list$",
      "^pnpm list",
      "^npm list",
      "^jq empty ",
      "^jq \\. ",
      "^chmod \\+x ",
      "^./scripts/validate-all\\.sh",
      "^./scripts/test-installation\\.sh",
      "^python3 scripts/check-frontmatter\\.py",
      "^pnpm run sync-marketplace$",
      "^node scripts/sync-marketplace\\.cjs$",
      "^./scripts/modes/enable-pr-review-mode\\.sh$",
      "^./scripts/modes/enable-30-hour-mode\\.sh$",
      "^./scripts/rebrand-repository\\.sh --dry-run$",
      "^pnpm install$",
      "^pnpm build$",
      "^pnpm test$",
      "^pnpm typecheck$",
      "^cd marketplace/ && npm run dev$",
      "^cd marketplace/ && npm run build$",
      "^grep -r .* plugins/ \\| grep -v placeholder$"
    ]
  },
  "requireApprovalCommands": {
    "description": "Commands that always require user approval",
    "patterns": [
      "^git add",
      "^git commit",
      "^git push",
      "^git pull",
      "^git merge",
      "^git rebase",
      "^git cherry-pick",
      "^git stash",
      "^git tag",
      "^rm ",
      "^rmdir ",
      "^mv ",
      "^cp ",
      "^sudo ",
      "^./scripts/rebrand-repository\\.sh$",
      "^pnpm publish",
      "^npm publish"
    ]
  },
  "tokenLimits": {
    "maxOutputTokens": 32000,
    "maxThinkingTokens": 16000
  },
  "workingDirectory": "/Users/andrew.nixdorf/Projects/stoked-automations",
  "autoSync": {
    "enabled": true,
    "syncMarketplaceAfterChanges": true
  }
}
```

## Workflow-Specific Settings

### PR Review Mode

Optimized for code review with higher thinking tokens and lower output tokens:

```json
{
  "tokenLimits": {
    "maxOutputTokens": 20000,
    "maxThinkingTokens": 20000
  }
}
```

### 30-Hour Deep Work Mode

Maximum token limits for extended deep work sessions:

```json
{
  "tokenLimits": {
    "maxOutputTokens": 64000,
    "maxThinkingTokens": 32000
  }
}
```

### Documentation Mode

Optimized for comprehensive documentation generation:

```json
{
  "tokenLimits": {
    "maxOutputTokens": 48000,
    "maxThinkingTokens": 16000
  }
}
```

## Safety Guardrails

### Commands That Should ALWAYS Require Approval

1. **Destructive Operations:**
   - `rm -rf`
   - `rmdir`
   - File deletion operations

2. **Git Operations That Modify Remote:**
   - `git push`
   - `git push --force`
   - `git tag` (when pushing tags)

3. **Publishing Operations:**
   - `pnpm publish`
   - `npm publish`
   - Any deployment commands

4. **System-Wide Operations:**
   - `sudo` commands
   - Operations outside the repository directory

5. **Rebranding Operations:**
   - `./scripts/rebrand-repository.sh` (without --dry-run)
   - Bulk file modifications

### Safe Commands (Can Be Auto-Approved)

1. **Read-Only Operations:**
   - File reading (`cat`, `head`, `tail`)
   - Directory listing (`ls`, `tree`)
   - Git status checking (`git status`, `git log`)

2. **Validation Operations:**
   - `./scripts/validate-all.sh`
   - JSON validation with `jq`
   - Security scans with `grep`

3. **Build Operations (Repository-Local):**
   - `pnpm install`
   - `pnpm build`
   - `pnpm test`

4. **Marketplace Sync:**
   - `pnpm run sync-marketplace`

## Environment Variables

Set these environment variables for optimal Claude Code usage:

```bash
# Token limits (set by mode scripts)
export CLAUDE_CODE_MAX_OUTPUT_TOKENS=32000
export MAX_THINKING_TOKENS=16000

# Repository root
export STOKED_AUTOMATIONS_ROOT=/Users/andrew.nixdorf/Projects/stoked-automations

# Add to ~/.bashrc or ~/.zshrc for persistence
echo 'export STOKED_AUTOMATIONS_ROOT=/Users/andrew.nixdorf/Projects/stoked-automations' >> ~/.bashrc
```

## Best Practices

### 1. Always Run Validation Before Committing

```bash
# Comprehensive validation workflow
pnpm run sync-marketplace
./scripts/validate-all.sh
find . -type f -name "*.sh" -exec chmod +x {} \;
find . -name "*.json" -exec sh -c 'jq empty {}' \;
```

### 2. Use Dry-Run Mode for Risky Operations

```bash
# Always test with --dry-run first
./scripts/rebrand-repository.sh --dry-run

# Review changes, then run for real
./scripts/rebrand-repository.sh
```

### 3. Monitor Context Usage

```bash
# Check token usage regularly
/context

# Optimize context by disabling unused agents if needed
```

### 4. Incremental Changes

- Make small, focused changes
- Commit frequently with descriptive messages
- Test after each significant change
- Use feature branches for major updates

### 5. Security First

- Never hardcode secrets
- Always validate user inputs in scripts
- Use `${CLAUDE_PLUGIN_ROOT}` for portable paths
- Run security scans before committing

## Troubleshooting

### Command Approval Issues

If Claude Code keeps asking for approval for safe commands:

1. Check your `settings.json` approvedCommands patterns
2. Ensure patterns use proper regex escaping
3. Test patterns match your actual commands
4. Restart Claude Code after settings changes

### Token Limit Issues

If you're hitting token limits:

1. Run `/context` to see usage
2. Disable unused plugins with `/plugin disable <name>`
3. Switch to a mode with higher limits
4. Clear conversation history and start fresh

### Marketplace Sync Failures

If marketplace sync fails:

```bash
# Check for JSON syntax errors
find .claude-plugin -name "*.json" -exec jq empty {} \;

# Manually run sync
pnpm run sync-marketplace

# Check git status
git status
git diff .claude-plugin/marketplace.json
```

## Quick Reference

### Daily Development Workflow

```bash
# 1. Pull latest changes
git pull

# 2. Make your changes
# ... edit files ...

# 3. Validate everything
pnpm run sync-marketplace
./scripts/validate-all.sh

# 4. Commit changes
git add -A
git commit -m "Description of changes"

# 5. Push to remote
git push origin main
```

### Plugin Development Workflow

```bash
# 1. Create plugin structure
mkdir -p plugins/community/my-plugin/.claude-plugin
mkdir -p plugins/community/my-plugin/commands

# 2. Add to marketplace.extended.json
# ... edit .claude-plugin/marketplace.extended.json ...

# 3. Sync and validate
pnpm run sync-marketplace
./scripts/validate-all.sh plugins/community/my-plugin/

# 4. Test locally
/plugin marketplace add ~/test-marketplace
/plugin install my-plugin@test
```

### Emergency Recovery

```bash
# Restore marketplace.json if corrupted
pnpm run sync-marketplace

# Restore file permissions if lost
find . -type f -name "*.sh" -exec chmod +x {} \;

# Validate all JSON files
find . -name "*.json" -exec sh -c 'jq empty {} || echo "Error in: {}"' \;

# Reset to last known good state
git reset --hard HEAD
```

---

**Last Updated:** October 2025
**Repository:** stoked-automations
**Owner:** Andrew Nixdorf ([email protected])