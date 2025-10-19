# GitLab MCP Server

GitLab integration via MCP (Model Context Protocol) - manage repositories, branches, merge requests, CI/CD pipelines, and issues directly from Claude Code using GitLab's REST API.

## Overview

This MCP server provides comprehensive GitLab integration, enabling you to:

- **Repository Management**: Create repos, manage files, push commits
- **Branch Operations**: List, create, and manage branches
- **Merge Requests**: Create, update, and review MRs
- **CI/CD Pipelines**: Monitor pipeline status and builds
- **Issue Tracking**: Create and manage GitLab issues
- **File Operations**: Read, write, and update files in repositories

## Features

- Full GitLab REST API integration via Docker containerized MCP server
- Support for both GitLab.com and self-hosted instances
- Bulk file operations with multi-file commits
- Pipeline status monitoring and CI/CD integration
- Secure credential management via environment variables

## Prerequisites

Before using this plugin, you need:

1. **Docker Desktop**
   ```bash
   # Verify Docker is installed and running
   docker --version
   docker ps
   ```

2. **GitLab Account**
   - GitLab.com account OR self-hosted GitLab instance
   - Project access with appropriate permissions

3. **Personal Access Token**
   ```bash
   # Create a personal access token:
   # For GitLab.com: https://gitlab.com/-/profile/personal_access_tokens
   # For self-hosted: https://your-gitlab.com/-/profile/personal_access_tokens

   # Required scopes:
   # ✓ api (full API access)
   # ✓ read_api (read API)
   # ✓ read_repository (read repositories)
   # ✓ write_repository (write to repositories)

   # Optional scopes:
   # - read_user (read user profile)
   # - write_webhook (create webhooks)
   ```

4. **Environment Variables**

   Add these to your shell profile (`~/.zshrc` or `~/.bashrc`):

   ```bash
   # GitLab Configuration
   export GITLAB_TOKEN="glpat-your-token-here"

   # For GitLab.com:
   export GITLAB_API_URL="https://gitlab.com/api/v4"

   # For self-hosted GitLab:
   # export GITLAB_API_URL="https://your-gitlab.com/api/v4"
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
/plugin install gitlab-mcp@stoked-automations
```

### Step 3: Pull Docker Image

```bash
docker pull mcp/gitlab:latest
```

### Step 4: Restart Claude Code

Completely exit and restart Claude Code for the MCP server to activate.

### Step 5: Verify Installation

```bash
# Check that MCP tools are available
/mcp list

# You should see:
# - mcp__gitlab__create_or_update_file
# - mcp__gitlab__search_repositories
# - mcp__gitlab__create_repository
# - mcp__gitlab__get_file_contents
# - mcp__gitlab__push_files
# - mcp__gitlab__create_merge_request
# - mcp__gitlab__get_merge_request
# - mcp__gitlab__update_merge_request
# - mcp__gitlab__list_branches
# - mcp__gitlab__get_project
# - mcp__gitlab__list_commits
# - mcp__gitlab__create_issue
# - mcp__gitlab__get_pipeline_status
```

## Usage

### Listing Branches

```
List all branches in username/repository-name
```

Returns branches with:
- Branch name
- Last commit SHA
- Protected status
- Default branch indicator

### Creating Merge Requests

```
Create a merge request:
- Source branch: JIRA-123-new-feature
- Target branch: main
- Title: [JIRA-123] Add new feature
- Description: Implementation of new feature with tests
```

### Checking Pipeline Status

```
Get the CI/CD pipeline status for username/repository-name on branch main
```

Returns:
- Pipeline status (success, failed, running, pending)
- Job statuses
- Failed job details (if any)

### Reading Files

```
Get the contents of README.md from username/repository-name
```

### Pushing Multiple Files

```
Push these files to username/repository-name:
- src/index.ts: (file content)
- tests/index.test.ts: (test content)
Commit message: Add TypeScript implementation with tests
```

### Creating Issues

```
Create a GitLab issue in username/repository-name:
- Title: Fix authentication bug
- Description: Users unable to login on mobile
- Labels: bug, priority::high
```

### Searching Repositories

```
Find GitLab repositories related to "authentication"
```

## Available MCP Tools

| Tool | Description |
|------|-------------|
| `create_or_update_file` | Create or modify a single file in a repository |
| `search_repositories` | Search for repositories by name or criteria |
| `create_repository` | Create a new GitLab repository/project |
| `get_file_contents` | Read file contents from a repository |
| `push_files` | Commit multiple files in a single operation |
| `create_merge_request` | Create a new MR with title and description |
| `get_merge_request` | Fetch MR details, status, and approvals |
| `update_merge_request` | Modify MR title, description, or state |
| `list_branches` | List all branches in a repository |
| `get_project` | Get project details and statistics |
| `list_commits` | View commit history for a branch |
| `create_issue` | Create GitLab issues with labels |
| `get_pipeline_status` | Check CI/CD pipeline execution status |

## Configuration

The MCP server is configured via `~/.config/claude/config.json` (automatically managed by the plugin):

```json
{
  "mcpServers": {
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
        "GITLAB_API_URL": "${GITLAB_API_URL}"
      }
    }
  }
}
```

## Troubleshooting

### "401 Unauthorized" Error

- Verify GITLAB_TOKEN is correct and hasn't expired
- Check token has required scopes (api, read_repository, write_repository)
- Regenerate token if needed

### "404 Not Found" Error

- Verify project path format: `namespace/project-name`
- Check you have access to the repository
- Ensure GITLAB_API_URL is correct

### "403 Forbidden" Error

- Verify you're a member of the project
- Check token has write permissions for the operation
- Confirm project visibility settings allow access

### "Docker not running" Error

- Start Docker Desktop
- Verify with: `docker ps`

### MCP Tools Not Appearing

- Restart Claude Code completely (not just reload)
- Check config.json syntax: `jq . ~/.config/claude/config.json`
- Verify environment variables: `echo $GITLAB_TOKEN`

### Cannot Create Merge Request

- Verify source and target branches exist
- Check you have Developer+ role in the project
- Ensure branches are different (no changes = no MR)

## Security Best Practices

1. **Never commit tokens** - Always use environment variables
2. **Use minimal scopes** - Only grant necessary permissions
3. **Rotate tokens regularly** - Create new tokens every 90-180 days
4. **Store tokens securely** - Use a password manager
5. **Review token usage** - Check GitLab access logs periodically
6. **Revoke unused tokens** - Clean up old tokens from settings

## GitLab.com vs Self-Hosted

### GitLab.com Configuration

```bash
export GITLAB_API_URL="https://gitlab.com/api/v4"
export GITLAB_TOKEN="glpat-your-token-here"
```

### Self-Hosted GitLab Configuration

```bash
export GITLAB_API_URL="https://your-gitlab.company.com/api/v4"
export GITLAB_TOKEN="your-token-here"
```

**Note**: Always include `/api/v4` at the end of the URL.

## Examples

### Example 1: Feature Branch Workflow

```
User: "List branches in myproject"
→ Shows: main, develop, feature/auth-v2

User: "Create a merge request from feature/auth-v2 to develop"
→ Creates MR with auto-generated description
→ Returns MR number and URL

User: "Get pipeline status for the MR"
→ Shows: CI pipeline running, tests passing
```

### Example 2: Quick File Update

```
User: "Update README.md in myproject with the new installation instructions"
→ Reads current README.md
→ Updates content
→ Commits with message: "Update installation instructions"
```

### Example 3: Bulk Code Push

```
User: "Push these three files to myproject:
- src/auth.ts (implementation)
- tests/auth.test.ts (tests)
- docs/auth.md (documentation)"

→ Creates single commit with all files
→ Triggers CI pipeline
→ Returns commit SHA
```

### Example 4: CI/CD Monitoring

```
User: "Check if the main branch pipeline passed in myproject"
→ Fetches latest pipeline for main
→ Shows: ✓ All jobs passed (build, test, deploy)
```

## Related Plugins

- **atlassian-mcp** - Jira integration for issue tracking
- **git-jira-workflow** - Automated Git branching with Jira tickets
- **serena** - AI memory management with project context

## Resources

- **GitLab MCP GitHub**: https://github.com/modelcontextprotocol/servers/tree/main/src/gitlab
- **GitLab REST API Docs**: https://docs.gitlab.com/ee/api/
- **Personal Access Tokens**: https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html
- **MCP Protocol**: https://modelcontextprotocol.io/

## License

MIT License - see [LICENSE](./LICENSE) for details

## Author

**Model Context Protocol**
- Website: https://modelcontextprotocol.io
- Repository: https://github.com/modelcontextprotocol/servers

---

**Plugin Version**: 1.0.0
**Category**: devops
**Last Updated**: 2025-10-18