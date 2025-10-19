---
name: setup-workflow
description: End-to-end setup wizard for git-jira-workflow with both MCP servers
model: sonnet
---

# Complete Git-Jira Workflow Setup

Welcome! This command will guide you through the complete setup of the git-jira-workflow plugin, including both MCP servers and all necessary configuration.

## Setup Overview

We'll configure:
1. ✅ Docker and prerequisites
2. ✅ Atlassian MCP Server (Jira integration)
3. ✅ GitLab MCP Server (Repository operations)
4. ✅ Environment variables
5. ✅ Claude Code configuration
6. ✅ Test and verify everything works

**Estimated time**: 15-20 minutes

## Phase 1: Prerequisites Check

### Step 1.1: Verify Docker

Check if Docker is installed and running:

```bash
docker --version
docker ps
```

**If Docker is not installed:**
- **macOS**: `brew install --cask docker` or https://www.docker.com/products/docker-desktop
- **Linux**: `sudo apt-get install docker.io`
- **Windows**: Download from https://www.docker.com/products/docker-desktop

After installing, ensure Docker Desktop is running.

### Step 1.2: Check Current Configuration

See if any MCP servers are already configured:

```bash
cat ~/.config/claude/config.json
```

If the file doesn't exist, we'll create it. If it exists, we'll add to it.

### Step 1.3: Verify Git Configuration

Ensure Git is configured with your details:

```bash
git config --global user.name
git config --global user.email
```

If not set:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@company.com"
```

## Phase 2: Atlassian MCP Server Setup

### Step 2.1: Gather Jira Information

You'll need:

1. **Jira URL**: Your Atlassian instance
   - Example: `https://yourcompany.atlassian.net`
   - Find it by logging into Jira and copying the URL

2. **Your Email**: The email you use for Atlassian
   - Example: `you@company.com`

3. **API Token**: Create one at https://id.atlassian.com/manage-profile/security/api-tokens
   - Click "Create API token"
   - Name it: "Claude Code MCP"
   - **Copy it immediately** (shown only once!)

### Step 2.2: Set Atlassian Environment Variables

Add these to your shell profile (`~/.zshrc` or `~/.bashrc`):

```bash
# Atlassian/Jira Configuration
export JIRA_URL="https://yourcompany.atlassian.net"
export ATLASSIAN_EMAIL="you@company.com"
export ATLASSIAN_API_TOKEN="your-api-token-here"
export CONFLUENCE_URL="https://yourcompany.atlassian.net/wiki"
```

Then reload:
```bash
source ~/.zshrc  # or ~/.bashrc
```

Verify:
```bash
echo $JIRA_URL
echo $ATLASSIAN_EMAIL
```

## Phase 3: GitLab MCP Server Setup

### Step 3.1: Create GitLab Personal Access Token

Go to https://gitlab.com/-/profile/personal_access_tokens (or your self-hosted instance)

1. Click "Add new token"
2. Name: "Claude Code MCP Server"
3. Expiration: 1 year (recommended)
4. Scopes (check these):
   - ✓ **api**
   - ✓ **read_api**
   - ✓ **read_repository**
   - ✓ **write_repository**
5. Click "Create personal access token"
6. **Copy the token immediately!**

### Step 3.2: Determine GitLab API URL

**For GitLab.com:**
```bash
GITLAB_API_URL="https://gitlab.com/api/v4"
```

**For self-hosted GitLab:**
```bash
GITLAB_API_URL="https://your-gitlab.com/api/v4"
```

### Step 3.3: Set GitLab Environment Variables

Add to your shell profile:

```bash
# GitLab Configuration
export GITLAB_TOKEN="glpat-your-token-here"
export GITLAB_API_URL="https://gitlab.com/api/v4"
```

Reload and verify:
```bash
source ~/.zshrc
echo $GITLAB_TOKEN
echo $GITLAB_API_URL
```

## Phase 4: Configure Claude Code

### Step 4.1: Create/Update Configuration File

Edit or create `~/.config/claude/config.json`:

```bash
mkdir -p ~/.config/claude
nano ~/.config/claude/config.json
```

### Step 4.2: Add MCP Server Configuration

Use this complete configuration (replace with your values if file doesn't exist):

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

### Step 4.3: Validate Configuration

Check the JSON is valid:
```bash
jq . ~/.config/claude/config.json
```

If there are errors, the jq command will show them. Fix any syntax issues.

## Phase 5: Pull Docker Images

Pre-download the MCP server Docker images:

```bash
# Pull Atlassian MCP
docker pull ghcr.io/sooperset/mcp-atlassian:latest

# Pull GitLab MCP
docker pull mcp/gitlab:latest
```

This may take a few minutes depending on your connection.

## Phase 6: Test Configuration

### Step 6.1: Test API Connectivity (Before Restart)

Test Jira API:
```bash
curl -u "${ATLASSIAN_EMAIL}:${ATLASSIAN_API_TOKEN}" \
  "${JIRA_URL}/rest/api/2/myself"
```

Expected: JSON with your user info

Test GitLab API:
```bash
curl --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
  "${GITLAB_API_URL}/user"
```

Expected: JSON with your user info

If either fails, verify your tokens and URLs.

### Step 6.2: Restart Claude Code

**Important**: Completely exit and restart Claude Code for changes to take effect.

### Step 6.3: Verify MCP Tools

In Claude Code, run:
```
/mcp list
```

You should see tools from both servers:

**Atlassian MCP:**
- mcp__atlassian__getIssue
- mcp__atlassian__createIssue
- mcp__atlassian__updateIssue
- mcp__atlassian__addComment
- mcp__atlassian__searchIssues

**GitLab MCP:**
- mcp__gitlab__get_project
- mcp__gitlab__list_branches
- mcp__gitlab__create_merge_request
- mcp__gitlab__get_merge_request

### Step 6.4: Run Comprehensive Tests

Run the test suite:
```
/test-mcp-servers
```

Follow the prompts to test each MCP server thoroughly.

## Phase 7: First Workflow Test

Let's test the complete workflow with a real Jira ticket:

### Step 7.1: Choose a Test Ticket

Pick an existing Jira ticket you have access to (e.g., PROJ-123)

### Step 7.2: Start Work on Ticket

```
I want to start working on JIRA-[YOUR-TICKET-ID]
```

**Expected behavior:**
1. Fetches ticket details from Jira
2. Shows ticket summary
3. Suggests branch name
4. Ready to create branch

### Step 7.3: Verify Branch Suggestion

Check that the suggested branch name follows the format:
- `JIRA-123-descriptive-name` (NO prefix for features)
- `HOTFIX/JIRA-123-descriptive-name` (WITH prefix for hotfixes)

### Step 7.4: Test Status Update (Optional)

```
Update the status of JIRA-[TICKET-ID] to "In Progress"
```

This tests the Jira status automation.

### Step 7.5: Test MR Creation Simulation

```
If I were to create a merge request from branch JIRA-123-test to main, what would the MR description include?
```

This tests GitLab MCP integration without actually creating an MR.

## Setup Complete! 🎉

### Configuration Summary

You now have:

✅ Docker installed and running
✅ Atlassian MCP Server configured
✅ GitLab MCP Server configured
✅ Environment variables set
✅ Claude Code config.json updated
✅ Docker images pulled
✅ MCP tools verified
✅ Workflow tested

### What You Can Do Now

**Branch Management:**
```
Start working on JIRA-1234
```

**Jira Operations:**
```
Fetch details for JIRA-5678
Update JIRA-9999 status to "In Progress"
Add comment to JIRA-4321: "Work in progress"
```

**GitLab Operations:**
```
List branches in my-project
Create a merge request from JIRA-1234-feature to main
Get status of merge request #42
```

**Complete Workflow:**
```
I need to start working on JIRA-1234 for user authentication
[... do work ...]
Create a merge request for JIRA-1234
```

The plugin will automatically:
- Create properly named branches
- Update Jira status to "In Progress"
- Generate MRs with Jira details
- Link MRs back to Jira tickets
- Transition Jira status to "In Review"

### Visual Workflow Reference

Open the interactive workflow diagram:
```bash
open plugins/skill-enhancers/git-jira-workflow/workflow.html
```

Or view it at: `./workflow.html` in the plugin directory

This shows the complete workflow with MCP integration points.

## Troubleshooting

### Issue: MCP Tools Not Appearing

1. Verify config.json syntax: `jq . ~/.config/claude/config.json`
2. Restart Claude Code completely (not just reload)
3. Check Docker is running: `docker ps`
4. Check environment variables are set

### Issue: Authentication Failures

**Atlassian:**
- Verify ATLASSIAN_API_TOKEN is correct
- Check token hasn't been revoked
- Test with curl command from Phase 6

**GitLab:**
- Verify GITLAB_TOKEN hasn't expired
- Check token has required scopes
- Test with curl command from Phase 6

### Issue: Docker Errors

```bash
# Check Docker service
docker ps

# View container logs
docker ps -a
docker logs [container-id]

# Restart Docker Desktop (macOS/Windows)
# Or restart docker service (Linux)
sudo systemctl restart docker
```

### Need More Help?

Run specific setup commands:
- `/setup-atlassian-mcp` - Atlassian-only setup
- `/setup-gitlab-mcp` - GitLab-only setup
- `/test-mcp-servers` - Comprehensive testing

Visit the documentation:
- Plugin: https://github.com/AndroidNextdoor/stoked-automations
- Claude Code: https://docs.claude.com/en/docs/claude-code/
- Atlassian MCP: https://github.com/sooperset/mcp-atlassian
- GitLab MCP: https://github.com/modelcontextprotocol/servers

## Next Steps

### Learn the Workflow

Read the comprehensive skill documentation:
```
cat plugins/skill-enhancers/git-jira-workflow/skills/skill-adapter/SKILL.md
```

### Try Common Operations

**Create Feature Branch:**
```
Start working on JIRA-1234
```

**Create Hotfix:**
```
Create hotfix for JIRA-9999
```

**Open Merge Request:**
```
Create MR for JIRA-5678
```

### Branch Naming Convention

The workflow uses these formats:
- **Features**: `JIRA-123-description` (no prefix)
- **Hotfixes**: `HOTFIX/JIRA-123-description` (with HOTFIX prefix)

Examples:
- `JIRA-1234-add-user-authentication` (feature)
- `JIRA-5678-payment-integration` (feature)
- `HOTFIX/JIRA-9999-security-patch` (hotfix)

### Monitor Jira Status

The plugin automatically updates Jira status:
- Branch created → "In Progress"
- MR opened → "In Review"
- MR merged → "Done"

## Security Reminders

🔒 **Protect Your Tokens:**
- Never commit tokens to Git
- Use environment variables only
- Rotate tokens every 90 days
- Review access logs periodically

🔒 **Token Permissions:**
- Use minimal required scopes
- Revoke unused tokens
- Keep tokens in password manager

## Welcome to Streamlined Development! 🚀

Your git-jira-workflow is fully configured and ready to automate your development process. Enjoy seamless integration between Jira tickets, Git branches, and merge requests!

Happy coding! 💻