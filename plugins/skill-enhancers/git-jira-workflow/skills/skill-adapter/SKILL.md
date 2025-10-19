---
name: Git-Jira Workflow Automation
description: |
  Automates Enterprise GitLab Flow with Jira integration. Activates when users mention:
  - Creating branches from Jira tickets
  - Starting work on Jira issues
  - Committing code with ticket references
  - Creating merge requests
  - Hotfix workflows
  - Jira status updates
  Uses Atlassian MCP Server for Jira integration and GitLab MCP Server for repository operations.
---

# Git-Jira Workflow Automation Skill

## Overview

This skill implements **Enterprise GitLab Flow** with seamless Jira integration using the Atlassian MCP Server and GitLab MCP Server. It automatically manages branch creation, commit validation, merge request creation, and Jira status updates throughout the development lifecycle.

### Visual Workflow Reference

📊 **Interactive Workflow Diagram Available**: See `workflow.html` in the plugin directory for a complete visual guide showing:
- Branch validation and creation decision trees
- Jira ticket linking and status automation
- Hotfix workflow with priority handling
- Merge request creation with Jira integration
- All MCP server operations at each workflow step

The diagram provides a comprehensive visual representation of how this skill automates the entire development workflow from ticket creation to merge request completion.

## Branching Strategy: Enterprise GitLab Flow

### Branch Types

1. **main** - Production-ready code
2. **JIRA-123-description** - Feature development (NO `feature/` prefix)
3. **HOTFIX/JIRA-123-description** - Production hotfixes (WITH `HOTFIX/` prefix)
4. **2025.1.1** - Release versioning (Year, Version, Patch)

### Branch Naming Convention

**Format**: `JIRA-123-description` (feature branches) or `HOTFIX/JIRA-123-description` (hotfixes)

- Jira ticket ID as prefix
- Hyphen separator
- Lowercase, hyphenated description
- NO `feature/` prefix for regular features

**Examples**:
- `JIRA-1234-user-authentication` (feature)
- `JIRA-5678-payment-integration` (feature)
- `HOTFIX/JIRA-9999-security-patch` (hotfix)

## When This Skill Activates

This skill proactively activates when users say:

- "Start working on JIRA-123"
- "Create a branch for this Jira ticket"
- "I need to work on [Jira ticket]"
- "Create a hotfix for JIRA-456"
- "Open a merge request for JIRA-789"
- "Update Jira status"
- "Commit this change with Jira reference"

## How It Works

### 1. Branch Creation from Jira Tickets

**User Intent**: "Start working on JIRA-1234"

**Workflow**:
1. Use Atlassian MCP to fetch Jira ticket details (`mcp__atlassian__getIssue`)
2. Extract ticket summary and type
3. Determine branch type:
   - `Bug` → `JIRA-1234-description`
   - `Story/Task` → `JIRA-1234-description`
   - `Hotfix` → `HOTFIX/JIRA-1234-description`
4. Generate branch name: sanitize summary to lowercase-hyphenated format
5. Create branch from appropriate base:
   - Features: branch from `main` or `develop` or `test` (`test` preferred)
   - Hotfixes: branch from `main` (production)
6. Update Jira status to "In Progress" (`mcp__atlassian__updateIssue`)

**Example**:
```bash
# User: "Start working on JIRA-1234"
# Jira ticket: "Add user authentication"

# Assistant actions:
git checkout main
git pull origin main
git checkout -b JIRA-1234-add-user-authentication

# Update Jira status to "In Progress"
```

### 2. Commit Validation (Jira Reference Required)

**User Intent**: "Commit this code"

**Workflow**:
1. Check if commit message includes Jira ticket reference
2. If missing, extract from current branch name
3. Validate format: `JIRA-####` pattern
4. Generate commit message format:
   ```
   [JIRA-1234] Brief description

   Detailed changes...
   ```
5. After commit, optionally update Jira with comment about progress

**Commit Message Template**:
```
[JIRA-1234] Add OAuth2 authentication endpoint

- Implement OAuth2 flow with Google provider
- Add JWT token generation
- Update user model with auth tokens

Refs: JIRA-1234
```

### 3. Merge Request (MR) Creation with Jira Integration

**User Intent**: "Create a merge request for this work"

**Workflow**:
1. Detect current branch and extract Jira ticket ID
2. Fetch Jira ticket details (`mcp__atlassian__getIssue`)
3. Generate MR title from Jira: `[JIRA-1234] Add user authentication`
4. Generate MR description:
   ```markdown
   ## Jira Ticket
   [JIRA-1234](https://your-jira.atlassian.net/browse/JIRA-1234)

   ## Summary
   [Jira ticket summary]

   ## Changes
   - [List of changes from commits]

   ## Test Plan
   - [ ] Unit tests pass
   - [ ] Integration tests pass
   - [ ] Manual testing completed
   ```
5. Create MR using `gh` CLI or GitLab API
6. Update Jira status to "In Review" (`mcp__atlassian__updateIssue`)
7. Add MR link to Jira ticket as comment

**Example**:
```bash
# User: "Create MR for JIRA-1234"

# Assistant actions:
git push origin JIRA-1234-add-user-authentication

# Create GitLab MR if test branch exists
glab mr create \
  --title "[JIRA-1234] Add user authentication" \
  --description "[Generated description with Jira details]" \
  --source-branch JIRA-1234-add-user-authentication \
  --target-branch test

# Create GitLab MR if test branch does not exists
glab mr create \
  --title "[JIRA-1234] Add user authentication" \
  --description "[Generated description with Jira details]" \
  --source-branch JIRA-1234-add-user-authentication \
  --target-branch main

# Update Jira status to "In Review"
```

### 4. Hotfix Workflow (Priority)

**User Intent**: "Create hotfix for JIRA-9999"

**Workflow**:
1. Validate ticket is marked as `Bug` or `Hotfix` in Jira
2. Create branch from `main` (production):
   ```bash
   git checkout main
   git pull origin main
   git checkout -b JIRA-9999-security-patch
   ```
3. Update Jira priority to "Critical" if not already
4. Set Jira status to "In Progress"
5. After fix, fast-track MR process:
   - Create MR to `main`
   - Notify team of critical fix
   - Update Jira with hotfix details

### 5. Jira Status Automation

**Automatic Status Updates**:
- Feature branch created → "In Progress"
- MR opened → "In Review"
- MR merged → "Done" or "Resolved"
- Feature branch deleted → Update Jira with completion note

**MCP Tools Used**:

Atlassian MCP:
- `mcp__atlassian__getIssue` - Fetch ticket details
- `mcp__atlassian__updateIssue` - Update status, add comments
- `mcp__atlassian__searchIssues` - Find related tickets
- `mcp__atlassian__addComment` - Add progress notes

GitLab MCP:
- `mcp__gitlab__create_merge_request` - Create MR programmatically
- `mcp__gitlab__get_project` - Get project details
- `mcp__gitlab__list_branches` - List repository branches
- `mcp__gitlab__get_merge_request` - Get MR status
- `mcp__gitlab__update_merge_request` - Update MR details

## Command Reference

### Available Slash Commands

Users can invoke commands manually:

- `/git-jira-start JIRA-1234` - Start work on Jira ticket (create branch)
- `/git-jira-commit` - Create commit with Jira reference validation
- `/git-jira-mr` - Create merge request with Jira integration
- `/git-jira-hotfix JIRA-9999` - Start hotfix workflow
- `/git-jira-status` - Sync Jira status with Git state

## Configuration Requirements

### MCP Server Setup

Ensure both Atlassian and GitLab MCP servers are configured in Claude Code settings:

```json
{
  "mcpServers": {
    "mcp-atlassian": {
      "command": "docker",
      "args": [
        "run", "-i", "--rm",
        "-e", "CONFLUENCE_URL",
        "-e", "CONFLUENCE_USERNAME",
        "-e", "CONFLUENCE_API_TOKEN",
        "-e", "JIRA_URL",
        "-e", "JIRA_USERNAME",
        "-e", "JIRA_API_TOKEN",
        "ghcr.io/sooperset/mcp-atlassian:latest"
      ],
      "env": {
        "JIRA_API_TOKEN": "${ATLASSIAN_API_TOKEN}",
        "JIRA_URL": "${JIRA_URL}",
        "JIRA_USERNAME": "${ATLASSIAN_EMAIL}",
        "CONFLUENCE_API_TOKEN": "${ATLASSIAN_API_TOKEN}",
        "CONFLUENCE_URL": "${CONFLUENCE_URL}",
        "CONFLUENCE_USERNAME": "${ATLASSIAN_EMAIL}"
      },
      "disabled": false,
      "autoApprove": []
    },
    "gitlab": {
      "command": "docker",
      "args": [
        "run", "--rm", "-i",
        "-e", "GITLAB_PERSONAL_ACCESS_TOKEN",
        "-e", "GITLAB_API_URL",
        "mcp/gitlab"
      ],
      "env": {
        "GITLAB_PERSONAL_ACCESS_TOKEN": "${GITLAB_TOKEN}",
        "GITLAB_API_URL": "https://gitlab.com/api/v4"
      },
      "disabled": false,
      "autoApprove": []
    }
  }
}
```

**Required Environment Variables**:

Atlassian:
- `JIRA_URL` - Your Jira instance URL (e.g., https://company.atlassian.net)
- `ATLASSIAN_EMAIL` - Your Atlassian account email
- `ATLASSIAN_API_TOKEN` - API token from Atlassian account settings

GitLab:
- `GITLAB_TOKEN` - GitLab personal access token with API access
- `GITLAB_API_URL` - GitLab API endpoint (default: https://gitlab.com/api/v4)

## Best Practices

1. **Always reference Jira tickets** in commits and branches
2. **Use descriptive branch names** beyond just the ticket ID
3. **Update Jira status** as work progresses (automated by this skill)
4. **Hotfixes branch from main** and merge back to main + develop
5. **Create small, focused MRs** linked to single Jira tickets
6. **Include test plans** in MR descriptions

## Error Handling

### Common Issues

**"Jira ticket not found"**:
- Verify Atlassian MCP is running: check `mcp__atlassian__*` tools available
- Check JIRA_URL and credentials in environment variables
- Confirm ticket ID format: `JIRA-####` (project key + number)

**"Branch name validation failed"**:
- Branch must include Jira ticket ID: `JIRA-123-description`
- Use only lowercase letters, numbers, hyphens
- Avoid special characters: `!@#$%^&*()`
- NO `feature/` prefix for regular features

**"Cannot update Jira status"**:
- Verify Atlassian API token has write permissions
- Check Jira workflow allows status transition
- Confirm user has permission to update ticket

## Examples

### Example 1: Start Feature Development

**User**: "I need to start working on JIRA-1234 for adding user authentication"

**Assistant Actions**:
1. Fetch Jira ticket details
2. Create branch: `JIRA-1234-add-user-authentication`
3. Update Jira status to "In Progress"
4. Provide confirmation with next steps

### Example 2: Create Merge Request

**User**: "Create a merge request for JIRA-5678"

**Assistant Actions**:
1. Extract ticket from current branch: `JIRA-5678-payment-integration`
2. Fetch Jira ticket details
3. Generate MR description with ticket summary
4. Create GitLab MR
5. Update Jira status to "In Review"
6. Add MR link to Jira comments

### Example 3: Hotfix Workflow

**User**: "We have a critical bug JIRA-9999, need hotfix now"

**Assistant Actions**:
1. Verify ticket is marked as Bug/Hotfix in Jira
2. Create branch from main: `HOTFIX-critical-security-fix` or `HOTFIX/JIRA-999-critical-security-fix`
3. Update Jira priority to "Critical"
4. Set status to "In Progress"
5. Guide user through hotfix process

## Skill Deactivation

To disable this skill temporarily:
```bash
/plugin disable git-jira-workflow
```

To re-enable:
```bash
/plugin enable git-jira-workflow
```

---

**Skill Version**: 2025.1.0
**Last Updated**: 2025-10-18
**Author**: Andrew Nixdorf