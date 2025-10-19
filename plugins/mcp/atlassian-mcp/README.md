# Atlassian MCP Server

Jira and Confluence integration via MCP (Model Context Protocol) - manage Jira tickets, update statuses, search issues, add comments, and access Confluence documentation directly from Claude Code.

## Overview

This MCP server provides seamless integration with Atlassian products (Jira and Confluence), enabling you to:

- **Jira Issue Management**: Create, read, update, and search Jira issues
- **Status Transitions**: Move issues through your workflow (To Do → In Progress → Done)
- **Comments & Collaboration**: Add comments and collaborate on issues
- **JQL Search**: Use powerful Jira Query Language for advanced searches
- **Confluence Access**: Read and search Confluence documentation

## Features

- Full Jira REST API integration via Docker containerized MCP server
- Support for custom fields and issue types
- Workflow transitions with validation
- Confluence page retrieval and search
- Secure credential management via environment variables

## Prerequisites

Before using this plugin, you need:

1. **Docker Desktop**
   ```bash
   # Verify Docker is installed and running
   docker --version
   docker ps
   ```

2. **Atlassian Account with API Access**
   - Jira instance (Cloud or Server)
   - Valid Atlassian account with appropriate permissions

3. **API Token**
   ```bash
   # Create an API token at:
   # https://id.atlassian.com/manage-profile/security/api-tokens

   # Click "Create API token"
   # Name it: "Claude Code MCP"
   # Copy the token immediately (shown only once!)
   ```

4. **Environment Variables**

   Add these to your shell profile (`~/.zshrc` or `~/.bashrc`):

   ```bash
   # Atlassian/Jira Configuration
   export JIRA_URL="https://yourcompany.atlassian.net"
   export ATLASSIAN_EMAIL="your.email@company.com"
   export ATLASSIAN_API_TOKEN="your-api-token-here"

   # Optional: Confluence Configuration
   export CONFLUENCE_URL="https://yourcompany.atlassian.net/wiki"
   ```

   Then reload your shell:
   ```bash
   source ~/.zshrc  # or ~/.bashrc
   ```

## Installation

### Step 1: Add Stoked Automations Marketplace

```bash
/plugin marketplace add AndroidNextdoor/stoked-automations
```

### Step 2: Install Plugin

```bash
/plugin install atlassian-mcp@stoked-automations
```

### Step 3: Pull Docker Image

```bash
docker pull ghcr.io/sooperset/mcp-atlassian:latest
```

### Step 4: Restart Claude Code

Completely exit and restart Claude Code for the MCP server to activate.

### Step 5: Verify Installation

```bash
# Check that MCP tools are available
/mcp list

# You should see:
# - mcp__atlassian__getIssue
# - mcp__atlassian__createIssue
# - mcp__atlassian__updateIssue
# - mcp__atlassian__searchIssues
# - mcp__atlassian__addComment
# - mcp__atlassian__transitionIssue
# - mcp__atlassian__getConfluencePage
# - mcp__atlassian__searchConfluence
```

## Usage

### Fetching Jira Issues

```
Get details for Jira ticket PROJ-1234
```

The MCP server will fetch and display:
- Issue summary and description
- Current status and assignee
- Priority and labels
- Comments and attachments
- Custom fields

### Creating Issues

```
Create a Jira issue:
- Project: PROJ
- Type: Bug
- Summary: Login button not working on mobile
- Priority: High
- Description: Users on iOS cannot tap the login button...
```

### Searching Issues

```
Search Jira for all issues in project PROJ with status "In Progress"
```

Uses JQL (Jira Query Language) under the hood:
```jql
project = PROJ AND status = "In Progress"
```

### Updating Issues

```
Update PROJ-1234:
- Change status to "In Review"
- Assign to john.doe@company.com
- Set priority to Critical
```

### Adding Comments

```
Add a comment to PROJ-1234: "Fixed the authentication bug in commit abc123"
```

### Confluence Integration

```
Get the Confluence page titled "API Documentation"
```

```
Search Confluence for pages about "authentication"
```

## Available MCP Tools

| Tool | Description |
|------|-------------|
| `getIssue` | Fetch details for a specific Jira issue by key |
| `createIssue` | Create a new Jira issue with all required fields |
| `updateIssue` | Update fields on an existing issue |
| `searchIssues` | Search issues using JQL query language |
| `addComment` | Add a comment to an issue |
| `transitionIssue` | Move issue through workflow (status changes) |
| `getConfluencePage` | Retrieve a Confluence page by ID or title |
| `searchConfluence` | Search Confluence content |

## Configuration

The MCP server is configured via `~/.config/claude/config.json` (automatically managed by the plugin):

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
        "-e", "CONFLUENCE_URL",
        "-e", "CONFLUENCE_USERNAME",
        "-e", "CONFLUENCE_API_TOKEN",
        "ghcr.io/sooperset/mcp-atlassian:latest"
      ],
      "env": {
        "JIRA_API_TOKEN": "${ATLASSIAN_API_TOKEN}",
        "JIRA_URL": "${JIRA_URL}",
        "JIRA_USERNAME": "${ATLASSIAN_EMAIL}",
        "CONFLUENCE_API_TOKEN": "${ATLASSIAN_API_TOKEN}",
        "CONFLUENCE_URL": "${CONFLUENCE_URL}",
        "CONFLUENCE_USERNAME": "${ATLASSIAN_EMAIL}"
      }
    }
  }
}
```

## Troubleshooting

### "401 Unauthorized" Error

- Verify your API token is correct and hasn't expired
- Check that ATLASSIAN_EMAIL matches your Atlassian account
- Regenerate token at https://id.atlassian.com/manage-profile/security/api-tokens

### "404 Not Found" Error

- Verify JIRA_URL is correct (no trailing slash)
- Check that the issue key format is correct (e.g., PROJ-123)
- Ensure you have permission to view the issue

### "Docker not running" Error

- Start Docker Desktop
- Verify with: `docker ps`

### MCP Tools Not Appearing

- Restart Claude Code completely (not just reload)
- Check config.json syntax: `jq . ~/.config/claude/config.json`
- Verify environment variables are set: `echo $JIRA_URL`

### Permission Errors

- Verify your Jira account has appropriate permissions
- Check project access and issue security schemes
- Ensure API token has required scopes

## Security Best Practices

1. **Never commit API tokens** - Always use environment variables
2. **Rotate tokens regularly** - Create new tokens every 90 days
3. **Use minimal permissions** - Grant only necessary Jira/Confluence access
4. **Store tokens securely** - Consider using a password manager
5. **Review access logs** - Check Atlassian security logs periodically

## Examples

### Example 1: Bug Report Workflow

```
User: "Create a bug in PROJ for the login issue on mobile, assign it to me, and set priority to High"

MCP Server:
1. Creates issue with type: Bug
2. Sets summary and description
3. Assigns to current user
4. Sets priority to High
5. Returns issue key (e.g., PROJ-456)
```

### Example 2: Sprint Planning

```
User: "Show me all issues in PROJ with status 'To Do' and priority 'High' or 'Critical'"

MCP Server:
1. Constructs JQL query:
   project = PROJ AND status = "To Do" AND priority IN (High, Critical)
2. Executes search
3. Returns list of matching issues with key details
```

### Example 3: Documentation Lookup

```
User: "Find the Confluence page about our API authentication process"

MCP Server:
1. Searches Confluence with query: "API authentication"
2. Returns relevant pages with excerpts
3. Provides page URLs for full access
```

## Related Plugins

- **git-jira-workflow** - Automated Git branching with Jira integration
- **serena** - AI memory management with project context
- **gitlab-mcp** - GitLab repository and MR operations

## Resources

- **Atlassian MCP GitHub**: https://github.com/sooperset/mcp-atlassian
- **Jira REST API Docs**: https://developer.atlassian.com/cloud/jira/platform/rest/v3/
- **Confluence REST API**: https://developer.atlassian.com/cloud/confluence/rest/v2/
- **MCP Protocol**: https://modelcontextprotocol.io/

## License

MIT License - see [LICENSE](./LICENSE) for details

## Author

**Sooperset**
- GitHub: https://github.com/sooperset
- Repository: https://github.com/sooperset/mcp-atlassian

---

**Plugin Version**: 1.0.0
**Category**: productivity
**Last Updated**: 2025-10-18