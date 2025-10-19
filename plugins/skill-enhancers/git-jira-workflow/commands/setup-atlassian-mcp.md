---
name: setup-atlassian-mcp
description: Set up Atlassian MCP server for Jira integration
model: sonnet
---

# Setup Atlassian MCP Server

Guide the user through setting up the Atlassian MCP server for Jira integration with this workflow plugin.

## Step 1: Check Prerequisites

First, verify the user has the necessary tools installed:

1. **Docker** - Check if Docker is installed and running:
   ```bash
   docker --version
   docker ps
   ```

2. **Jira Access** - Verify they have:
   - Jira instance URL (e.g., `https://company.atlassian.net`)
   - Jira account email
   - Admin or appropriate permissions to create API tokens

If Docker is not installed, guide them to:
- **macOS**: `brew install --cask docker` or download from https://www.docker.com/products/docker-desktop
- **Linux**: `sudo apt-get install docker.io` or distribution-specific package manager
- **Windows**: Download Docker Desktop from https://www.docker.com/products/docker-desktop

## Step 2: Create Atlassian API Token

Guide the user to create an API token:

1. Navigate to: https://id.atlassian.com/manage-profile/security/api-tokens
2. Click "Create API token"
3. Give it a name like "Claude Code MCP Server"
4. Copy the token (it will only be shown once!)

**Important**: Store this token securely. They'll need it for the environment variables.

## Step 3: Gather Required Information

Ask the user to provide:

1. **JIRA_URL**: Their Jira instance URL
   - Example: `https://company.atlassian.net`
   - Don't include `/browse/` or project paths

2. **JIRA_USERNAME** (their Atlassian email):
   - Example: `user@company.com`

3. **JIRA_API_TOKEN**: The token they just created
   - This will be stored as `ATLASSIAN_API_TOKEN` environment variable

## Step 4: Set Environment Variables

Guide them to add these to their shell profile (`~/.zshrc`, `~/.bashrc`, or `~/.profile`):

```bash
# Atlassian MCP Server Configuration
export JIRA_URL="https://their-company.atlassian.net"
export ATLASSIAN_EMAIL="their-email@company.com"
export ATLASSIAN_API_TOKEN="their-api-token-here"
export CONFLUENCE_URL="https://their-company.atlassian.net/wiki"  # Optional
```

After adding, have them reload their shell:
```bash
source ~/.zshrc  # or ~/.bashrc
```

Verify the variables are set:
```bash
echo $JIRA_URL
echo $ATLASSIAN_EMAIL
echo $ATLASSIAN_API_TOKEN
```

## Step 5: Configure Claude Code MCP Server

Guide them to edit their Claude Code configuration file at `~/.config/claude/config.json`.

If the file doesn't exist, create it with this structure:

```json
{
  "mcpServers": {
    "mcp-atlassian": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
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
      },
      "disabled": false,
      "autoApprove": []
    }
  }
}
```

If `mcpServers` already exists, add the `mcp-atlassian` section to it.

## Step 6: Pull Docker Image

Have them pre-pull the Docker image to avoid delays during first use:

```bash
docker pull ghcr.io/sooperset/mcp-atlassian:latest
```

This may take a few minutes depending on their internet connection.

## Step 7: Test the Connection

Run the test command to verify the MCP server is working:

```bash
# This will be tested in the next step via Claude Code
/test-mcp-servers
```

Or manually test with Docker:

```bash
docker run -i --rm \
  -e JIRA_URL="${JIRA_URL}" \
  -e JIRA_USERNAME="${ATLASSIAN_EMAIL}" \
  -e JIRA_API_TOKEN="${ATLASSIAN_API_TOKEN}" \
  ghcr.io/sooperset/mcp-atlassian:latest
```

## Step 8: Verify in Claude Code

1. Restart Claude Code completely (exit and restart)
2. Check available MCP tools:
   ```
   /mcp list
   ```

3. You should see Atlassian MCP tools like:
   - `mcp__atlassian__getIssue`
   - `mcp__atlassian__createIssue`
   - `mcp__atlassian__updateIssue`
   - `mcp__atlassian__addComment`
   - `mcp__atlassian__searchIssues`

## Troubleshooting

### "Docker command not found"
- Install Docker Desktop and ensure it's running
- Verify with: `docker ps`

### "Authentication failed"
- Verify your API token is correct
- Check your email matches your Atlassian account
- Ensure the token has proper permissions

### "Cannot connect to Jira"
- Verify your JIRA_URL is correct (no trailing slash)
- Check you're using the correct Atlassian instance
- Test access in browser: `${JIRA_URL}/rest/api/2/myself`

### "MCP tools not appearing"
- Ensure config.json syntax is valid (use `jq . ~/.config/claude/config.json`)
- Restart Claude Code completely
- Check Docker container logs: `docker ps` then `docker logs <container-id>`

### "Permission denied errors"
- Verify your Jira account has permissions to create/update issues
- Check the API token hasn't expired
- Ensure you're using the correct project key

## Security Best Practices

1. **Never commit tokens to git** - Always use environment variables
2. **Rotate tokens regularly** - Create new tokens every 90 days
3. **Use minimal permissions** - Only grant necessary Jira permissions
4. **Store tokens securely** - Consider using a password manager
5. **Review access logs** - Check Atlassian security logs periodically

## Next Steps

Once the Atlassian MCP server is configured:

1. Set up GitLab MCP server: `/setup-gitlab-mcp`
2. Test both servers: `/test-mcp-servers`
3. Start using the workflow: Try "Start working on JIRA-1234"

## Configuration Summary

After successful setup, you should have:

✓ Docker installed and running
✓ Atlassian API token created
✓ Environment variables set in shell profile
✓ Claude Code config.json configured
✓ Atlassian MCP Docker image pulled
✓ MCP tools visible in `/mcp list`

The Atlassian MCP server is now ready to use with the git-jira-workflow plugin! 🎉