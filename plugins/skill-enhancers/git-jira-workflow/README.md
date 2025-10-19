# Git-Jira Workflow Automation

**Enterprise GitLab Flow with seamless Jira integration**

[![Version](https://img.shields.io/badge/version-2025.1.0-blue.svg)](https://github.com/AndroidNextdoor/stoked-automations)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE)
[![Category](https://img.shields.io/badge/category-skill--enhancers-purple.svg)](https://stokedautomations.com/)

Automate your development workflow with intelligent Git branching, Jira ticket management, and merge request creation—all powered by MCP servers for real-time integration.

## Overview

This plugin implements **Enterprise GitLab Flow** with automatic Jira integration using:
- **Atlassian MCP Server** for Jira operations
- **GitLab MCP Server** for repository management

It proactively activates when you:
- Start work on Jira tickets
- Create branches with ticket references
- Commit code with validation
- Open merge requests
- Handle hotfixes

### Visual Workflow

📊 **[View Interactive Workflow Diagram](./workflow.html)** - Complete visual guide showing all automation steps, decision points, and MCP integrations.

The workflow diagram shows:
- **Branch validation** and creation logic
- **Jira ticket** linking and status updates
- **Hotfix workflow** with priority handling
- **Merge request** automation with Jira integration
- **MCP server** operations at each step

## Features

✓ **Automatic Branch Creation** - Create properly named branches from Jira tickets
✓ **Jira Status Sync** - Auto-update ticket status (In Progress → In Review → Done)
✓ **Commit Validation** - Enforce Jira ticket references in commits
✓ **MR Automation** - Generate merge requests with Jira details
✓ **Hotfix Workflow** - Fast-track critical production fixes
✓ **Enterprise GitLab Flow** - Professional branching strategy

## Installation

### Prerequisites

1. **Claude Code** installed and configured
2. **Atlassian MCP Server** configured with Jira credentials
3. **GitLab MCP Server** configured with GitLab token
4. Git repository using GitLab

### Install Plugin

```bash
# Add stoked-automations marketplace
/plugin marketplace add AndroidNextdoor/stoked-automations

# Install git-jira-workflow
/plugin install git-jira-workflow@stoked-automations

# Enable the plugin
/plugin enable git-jira-workflow
```

### Configure MCP Servers

Add to your Claude Code settings (`~/.config/claude/config.json`):

```json
{
  "mcpServers": {
    "mcp-atlassian": {
      "command": "docker",
      "args": [
        "run", "-i", "--rm",
        "-e", "JIRA_URL",
        "-e", "JIRA_USERNAME",
        "-e", "JIRA_API_TOKEN",
        "ghcr.io/sooperset/mcp-atlassian:latest"
      ],
      "env": {
        "JIRA_API_TOKEN": "${ATLASSIAN_API_TOKEN}",
        "JIRA_URL": "${JIRA_URL}",
        "JIRA_USERNAME": "${ATLASSIAN_EMAIL}"
      }
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
      }
    }
  }
}
```

**Environment Variables Required**:
- `JIRA_URL` - Your Jira instance URL
- `ATLASSIAN_EMAIL` - Your Atlassian account email
- `ATLASSIAN_API_TOKEN` - Atlassian API token
- `GITLAB_TOKEN` - GitLab personal access token
- `GITLAB_API_URL` - GitLab API endpoint

## Usage

### Proactive Activation

The skill automatically activates when you use natural language:

```
"Start working on JIRA-1234"
→ Creates branch: JIRA-1234-add-user-authentication
→ Updates Jira status to "In Progress"

"Create a merge request"
→ Pushes branch
→ Creates GitLab MR with Jira details
→ Updates Jira status to "In Review"
→ Links MR in Jira comments

"I need to hotfix JIRA-9999"
→ Creates branch: HOTFIX/JIRA-9999-critical-fix
→ Sets Jira priority to "Critical"

"I need a hotfix for a big fuck up"
→ Asks what the issue is. Clarifies details until a Jira Ticket can be created.
→ Sets Jira priority to "Critical"
```

### Manual Commands

Use slash commands for explicit control:

```bash
/git-jira-start JIRA-1234     # Start work on ticket
/git-jira-commit               # Commit with validation
/git-jira-mr                   # Create merge request
/git-jira-hotfix JIRA-9999     # Start hotfix workflow
/git-jira-status               # Sync Jira status
```

## Branching Strategy

### Enterprise GitLab Flow

```
main (production)
  ├── JIRA-1234-add-auth                 # Feature development
  ├── JIRA-5678-payment-api              # Another feature
  ├── HOTFIX/JIRA-9999-security-patch    # Production hotfix
  └── 2025.1.0                           # Release branch
```

### Branch Naming Convention

**Format**: `JIRA-123-description` (feature branches) or `HOTFIX/JIRA-123-description` (hotfixes)

Examples:
- `JIRA-1234-user-authentication` (feature)
- `JIRA-5678-payment-gateway` (feature)
- `HOTFIX/JIRA-9999-security-patch` (hotfix)

## Workflows

### 1. Start Feature Development

**User**: "I need to work on JIRA-1234"

**Automated Actions**:
1. Fetch Jira ticket details via Atlassian MCP
2. Determine branch type from ticket type (Story/Task/Bug)
3. Generate branch name: `JIRA-1234-sanitized-summary` (NO prefix)
4. Create branch from `main`
5. Update Jira status to "In Progress"

### 2. Create Merge Request

**User**: "Create a merge request for JIRA-5678"

**Automated Actions**:
1. Extract Jira ticket from branch name
2. Fetch ticket details and description
3. Generate MR title: `[JIRA-5678] Feature description`
4. Create MR description with:
   - Jira ticket link
   - Summary from Jira
   - List of commits
   - Test plan checklist
5. Create MR using GitLab MCP
6. Update Jira status to "In Review"
7. Add MR link to Jira comments

### 3. Hotfix Workflow

**User**: "Critical bug JIRA-9999 needs immediate fix"

**Automated Actions**:
1. Verify ticket is Bug type in Jira
2. Create branch from `main`: `HOTFIX/JIRA-9999-description`
3. Set Jira priority to "Critical"
4. Update status to "In Progress"
5. After fix, fast-track MR to `main`

## Commit Message Format

Commits are validated and formatted with Jira references:

```
[JIRA-1234] Add OAuth2 authentication endpoint

- Implement OAuth2 flow with Google provider
- Add JWT token generation
- Update user model with auth tokens

Refs: JIRA-1234
```

## Jira Status Automation

| Git Action | Jira Status |
|------------|-------------|
| Branch created | In Progress |
| MR opened | In Review |
| MR merged | Done |
| Branch deleted | Resolved |

## MCP Tools Used

### Atlassian MCP
- `mcp__atlassian__getIssue` - Fetch ticket details
- `mcp__atlassian__updateIssue` - Update status/priority
- `mcp__atlassian__addComment` - Add progress notes
- `mcp__atlassian__searchIssues` - Find related tickets

### GitLab MCP
- `mcp__gitlab__create_merge_request` - Create MRs
- `mcp__gitlab__get_project` - Get project info
- `mcp__gitlab__list_branches` - List branches
- `mcp__gitlab__get_merge_request` - Get MR status

## Examples

### Example 1: Complete Feature Workflow

```
User: "Start working on JIRA-1234"
→ Branch created: JIRA-1234-add-user-authentication
→ Jira status: In Progress

[... development work ...]

User: "Commit the authentication changes"
→ Commit created with [JIRA-1234] prefix
→ Jira updated with commit comment

User: "Create MR for JIRA-1234"
→ MR created with Jira details
→ Jira status: In Review
→ MR link added to Jira

[... code review ...]

User: "Merge the MR"
→ Jira status: Done
```

### Example 2: Hotfix Workflow

```
User: "Critical security bug JIRA-9999, need hotfix"
→ Branch created: HOTFIX/JIRA-9999-security-patch
→ Jira priority: Critical
→ Jira status: In Progress

[... fix applied ...]

User: "Create hotfix MR"
→ MR to main branch
→ Jira status: In Review
→ Team notified of critical fix
```

## Troubleshooting

### "Jira ticket not found"
- Verify Atlassian MCP is running: check `/mcp list`
- Confirm `JIRA_URL` and credentials in environment
- Check ticket ID format: `PROJECT-####`

### "Cannot create MR"
- Verify GitLab MCP is running
- Check `GITLAB_TOKEN` has API access
- Ensure branch is pushed to remote

### "Jira status not updating"
- Verify API token has write permissions
- Check Jira workflow allows status transition
- Confirm user has ticket update permissions

## Configuration

### Custom Jira Project Keys

If your Jira uses a custom project key (not "JIRA"), the plugin automatically detects it from ticket IDs (e.g., `PROJ-123`, `ACME-456`).

### Branch Naming Patterns

The plugin uses these branch patterns:
- `JIRA-123-description` - Features (NO prefix)
- `HOTFIX/JIRA-123-description` - Production hotfixes (WITH prefix)
- `2025.1.0` - Release versioning (Annual-style: YYYY.R.P)

## Best Practices

1. **Always reference Jira tickets** in branches and commits
2. **Use descriptive branch names** beyond just the ticket ID
3. **Create small, focused MRs** linked to single tickets
4. **Include test plans** in MR descriptions
5. **Hotfixes branch from main** for production fixes
6. **Update Jira regularly** (automated by this plugin)

## Contributing

Found a bug or have a feature request?

- **Issues**: [GitHub Issues](https://github.com/AndroidNextdoor/stoked-automations/issues)
- **Discussions**: [GitHub Discussions](https://github.com/AndroidNextdoor/stoked-automations/discussions)

## License

MIT License - see [LICENSE](./LICENSE) for details

## Author

**Andrew Nixdorf**
Email: Andrew@StokedAutomation.com
GitHub: [@AndroidNextdoor](https://github.com/AndroidNextdoor)

## Links

- **Plugin Marketplace**: https://stokedautomations.com/
- **Documentation**: https://docs.claude.com/en/docs/claude-code/plugins
- **Atlassian MCP**: https://github.com/sooperset/mcp-atlassian
- **GitLab MCP**: https://github.com/modelcontextprotocol/servers/tree/main/src/gitlab

---

**Plugin Version**: 2025.1.0
**Category**: skill-enhancers
**Last Updated**: 2025-10-18