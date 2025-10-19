---
name: setup-gitlab-mcp
description: Set up GitLab MCP server for repository and merge request operations
model: sonnet
---

# Setup GitLab MCP Server

Guide the user through setting up the GitLab MCP server for automated Git operations and merge request management.

## Step 1: Check Prerequisites

First, verify the user has the necessary tools installed:

1. **Docker** - Check if Docker is installed and running:
   ```bash
   docker --version
   docker ps
   ```

2. **GitLab Access** - Verify they have:
   - GitLab instance URL (gitlab.com or self-hosted)
   - GitLab account with project access
   - Permissions to create merge requests

If Docker is not installed, guide them to:
- **macOS**: `brew install --cask docker` or download from https://www.docker.com/products/docker-desktop
- **Linux**: `sudo apt-get install docker.io`
- **Windows**: Download Docker Desktop from https://www.docker.com/products/docker-desktop

## Step 2: Create GitLab Personal Access Token

Guide the user to create a personal access token:

### For GitLab.com:
1. Navigate to: https://gitlab.com/-/profile/personal_access_tokens
2. Click "Add new token"
3. Give it a name: "Claude Code MCP Server"
4. Set expiration date (recommended: 1 year)
5. Select scopes:
   - ✓ **api** - Full API access
   - ✓ **read_api** - Read API
   - ✓ **read_repository** - Read repositories
   - ✓ **write_repository** - Write to repositories
6. Click "Create personal access token"
7. **IMPORTANT**: Copy the token immediately (shown only once!)

### For Self-Hosted GitLab:
1. Navigate to: `https://your-gitlab.com/-/profile/personal_access_tokens`
2. Follow the same steps as above

**Security Note**: Store this token securely. It provides full API access to your GitLab account.

## Step 3: Determine GitLab API URL

Ask the user which GitLab instance they're using:

### GitLab.com (default):
```bash
GITLAB_API_URL="https://gitlab.com/api/v4"
```

### Self-Hosted GitLab:
```bash
GITLAB_API_URL="https://your-gitlab-instance.com/api/v4"
```

**Important**: Always include `/api/v4` at the end.

## Step 4: Set Environment Variables

Guide them to add these to their shell profile (`~/.zshrc`, `~/.bashrc`, or `~/.profile`):

```bash
# GitLab MCP Server Configuration
export GITLAB_TOKEN="glpat-xxxxxxxxxxxxxxxxxxxx"  # Their personal access token
export GITLAB_API_URL="https://gitlab.com/api/v4"  # Or their self-hosted URL
```

After adding, have them reload their shell:
```bash
source ~/.zshrc  # or ~/.bashrc
```

Verify the variables are set:
```bash
echo $GITLAB_TOKEN
echo $GITLAB_API_URL
```

## Step 5: Configure Claude Code MCP Server

Guide them to edit their Claude Code configuration file at `~/.config/claude/config.json`.

Add the GitLab MCP server configuration:

```json
{
  "mcpServers": {
    "gitlab": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "-e", "GITLAB_PERSONAL_ACCESS_TOKEN",
        "-e", "GITLAB_API_URL",
        "mcp/gitlab"
      ],
      "env": {
        "GITLAB_PERSONAL_ACCESS_TOKEN": "${GITLAB_TOKEN}",
        "GITLAB_API_URL": "${GITLAB_API_URL}"
      },
      "disabled": false,
      "autoApprove": []
    }
  }
}
```

If `mcpServers` already exists (e.g., with Atlassian MCP), add the `gitlab` section alongside existing servers.

**Example with both servers:**

```json
{
  "mcpServers": {
    "mcp-atlassian": {
      "command": "docker",
      "args": ["..."],
      "env": {"..."}
    },
    "gitlab": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "-e", "GITLAB_PERSONAL_ACCESS_TOKEN",
        "-e", "GITLAB_API_URL",
        "mcp/gitlab"
      ],
      "env": {
        "GITLAB_PERSONAL_ACCESS_TOKEN": "${GITLAB_TOKEN}",
        "GITLAB_API_URL": "${GITLAB_API_URL}"
      },
      "disabled": false,
      "autoApprove": []
    }
  }
}
```

## Step 6: Pull Docker Image

Have them pre-pull the Docker image:

```bash
docker pull mcp/gitlab:latest
```

This ensures the image is ready and avoids delays during first use.

## Step 7: Test GitLab API Access

Before testing the MCP server, verify their token works with a simple API call:

```bash
curl --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
  "${GITLAB_API_URL}/user"
```

**Expected response**: JSON with their user information (username, email, etc.)

If this fails:
- Check token is correct
- Verify API URL includes `/api/v4`
- Ensure token hasn't expired

## Step 8: Verify in Claude Code

1. Restart Claude Code completely (exit and restart)
2. Check available MCP tools:
   ```
   /mcp list
   ```

3. You should see GitLab MCP tools like:
   - `mcp__gitlab__get_project`
   - `mcp__gitlab__list_branches`
   - `mcp__gitlab__create_merge_request`
   - `mcp__gitlab__get_merge_request`
   - `mcp__gitlab__update_merge_request`

## Step 9: Test with a Real Project

Have them test with one of their actual GitLab projects:

1. Ask them for a project path (e.g., `username/repository-name`)
2. Test listing branches:
   ```
   Can you list the branches in my GitLab project username/repository-name?
   ```

3. If successful, the MCP server will fetch and display branches.

## Troubleshooting

### "Docker command not found"
- Install Docker Desktop and ensure it's running
- Verify with: `docker ps`

### "Authentication failed" or "401 Unauthorized"
- Verify token is correct and hasn't expired
- Check token has required scopes (api, read_repository, write_repository)
- Test token with curl command above

### "Cannot connect to GitLab API"
- Verify GITLAB_API_URL is correct (includes `/api/v4`)
- For self-hosted: Ensure URL is accessible
- Check firewall/VPN isn't blocking connection

### "MCP tools not appearing"
- Ensure config.json syntax is valid: `jq . ~/.config/claude/config.json`
- Restart Claude Code completely
- Check Docker container logs: `docker logs <container-id>`

### "Project not found"
- Verify project path format: `namespace/project-name`
- Check you have access to the project
- Ensure token has read permissions

### "Cannot create merge request"
- Verify token has `write_repository` scope
- Check you're a member of the project
- Ensure branch exists and differs from target

## Security Best Practices

1. **Never commit tokens to git** - Always use environment variables
2. **Use minimal scopes** - Only grant necessary permissions
3. **Rotate tokens regularly** - Create new tokens every 90-180 days
4. **Store tokens securely** - Consider using a password manager
5. **Review token usage** - Check GitLab access logs periodically
6. **Revoke unused tokens** - Remove old tokens from GitLab settings

## Token Scope Reference

Required scopes for git-jira-workflow plugin:

| Scope | Purpose | Required |
|-------|---------|----------|
| `api` | Full API access | ✓ Yes |
| `read_api` | Read API endpoints | ✓ Yes |
| `read_repository` | Read repository data | ✓ Yes |
| `write_repository` | Create branches, push code | ✓ Yes |

Optional scopes (if using additional features):
- `read_user` - Read user profile
- `write_webhook` - Create webhooks (future feature)

## Next Steps

Once the GitLab MCP server is configured:

1. If not done yet, set up Atlassian MCP: `/setup-atlassian-mcp`
2. Test both servers together: `/test-mcp-servers`
3. Start using the workflow: Try "Create a merge request for JIRA-1234"

## Configuration Summary

After successful setup, you should have:

✓ Docker installed and running
✓ GitLab personal access token created
✓ Environment variables set in shell profile
✓ Claude Code config.json configured
✓ GitLab MCP Docker image pulled
✓ MCP tools visible in `/mcp list`
✓ Token tested with real GitLab API

The GitLab MCP server is now ready to use with the git-jira-workflow plugin! 🎉

## Common Use Cases

Once configured, you can use natural language commands like:

**List branches:**
```
Show me all branches in my project
```

**Create merge request:**
```
Create a merge request from JIRA-1234-feature-branch to main
```

**Get MR status:**
```
What's the status of merge request #42?
```

**Update MR:**
```
Update the description of MR #42 to include the test results
```

All these operations will use the GitLab MCP server automatically!