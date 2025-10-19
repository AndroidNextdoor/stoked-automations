---
name: test-mcp-servers
description: Test suite to verify Atlassian and GitLab MCP server configuration
model: sonnet
---

# Test MCP Servers

Run comprehensive tests to verify both Atlassian MCP and GitLab MCP servers are properly configured and functioning.

## Overview

This command will guide you through testing:
1. **Atlassian MCP Server** - Jira connectivity and operations
2. **GitLab MCP Server** - Repository access and MR operations
3. **Integration** - Both servers working together

## Prerequisites Check

First, verify the prerequisites are met:

### 1. Docker Status
```bash
docker ps
```
Expected: Docker is running (should show container list or empty table)

### 2. Environment Variables
```bash
echo "JIRA_URL: $JIRA_URL"
echo "ATLASSIAN_EMAIL: $ATLASSIAN_EMAIL"
echo "GITLAB_API_URL: $GITLAB_API_URL"
```
Expected: All variables should show values (not empty)

### 3. Claude Code Configuration
```bash
jq '.mcpServers' ~/.config/claude/config.json
```
Expected: Should show both `mcp-atlassian` and `gitlab` configurations

If any prerequisites fail, run the setup commands first:
- `/setup-atlassian-mcp` - Set up Jira integration
- `/setup-gitlab-mcp` - Set up GitLab integration

## Test 1: MCP Tools Discovery

Check if MCP tools are available in Claude Code:

```
/mcp list
```

**Expected Atlassian MCP Tools:**
- `mcp__atlassian__getIssue`
- `mcp__atlassian__createIssue`
- `mcp__atlassian__updateIssue`
- `mcp__atlassian__addComment`
- `mcp__atlassian__searchIssues`
- `mcp__atlassian__transitionIssue`

**Expected GitLab MCP Tools:**
- `mcp__gitlab__get_project`
- `mcp__gitlab__list_branches`
- `mcp__gitlab__create_merge_request`
- `mcp__gitlab__get_merge_request`
- `mcp__gitlab__update_merge_request`

**If tools are missing:**
1. Check config.json syntax: `jq . ~/.config/claude/config.json`
2. Restart Claude Code completely
3. Verify Docker images are pulled:
   ```bash
   docker images | grep atlassian
   docker images | grep gitlab
   ```

## Test 2: Atlassian MCP Server - Jira Connectivity

### Test 2a: Fetch Jira Ticket

Ask the user for a Jira ticket ID they know exists (e.g., PROJ-123):

```
Can you fetch details for Jira ticket [TICKET-ID]?
```

**Expected behavior:**
- MCP tool `mcp__atlassian__getIssue` is called
- Ticket details are returned (summary, status, description, assignee)
- No authentication errors

**Common issues:**
- **401 Unauthorized**: API token is invalid or expired
- **404 Not Found**: Ticket doesn't exist or user lacks permissions
- **Connection timeout**: JIRA_URL is incorrect

### Test 2b: Search Jira Tickets

```
Search for Jira tickets in project [PROJECT-KEY] with status "In Progress"
```

**Expected behavior:**
- `mcp__atlassian__searchIssues` is called
- Returns list of matching tickets
- Shows ticket keys, summaries, and statuses

### Test 2c: Create Test Comment

Ask for a test ticket to add a comment to:

```
Add a comment to Jira ticket [TICKET-ID]: "Testing MCP server integration - please ignore"
```

**Expected behavior:**
- `mcp__atlassian__addComment` is called
- Comment is added successfully
- User can verify in Jira web UI

**Note**: Have them delete the test comment afterward from Jira

## Test 3: GitLab MCP Server - Repository Access

### Test 3a: Get Project Information

Ask the user for their GitLab project path (e.g., username/repository):

```
Get information about my GitLab project [username/repository]
```

**Expected behavior:**
- `mcp__gitlab__get_project` is called
- Returns project details (name, description, default branch, visibility)
- Shows project statistics

**Common issues:**
- **401 Unauthorized**: Token is invalid or expired
- **404 Not Found**: Project doesn't exist or user lacks access
- **403 Forbidden**: Token lacks required scopes

### Test 3b: List Branches

```
List all branches in my GitLab project [username/repository]
```

**Expected behavior:**
- `mcp__gitlab__list_branches` is called
- Returns list of branches with names and last commit info
- Shows main/master branch and others

### Test 3c: Check Specific Branch

```
Does the branch "main" exist in [username/repository]?
```

**Expected behavior:**
- Confirms branch existence
- Shows latest commit information

## Test 4: Integration Test - Complete Workflow Simulation

This tests both MCP servers working together.

### Step 1: Fetch Jira Ticket for Branch Creation

```
I want to start working on Jira ticket [TICKET-ID]. What should the branch name be?
```

**Expected behavior:**
1. Fetches Jira ticket via `mcp__atlassian__getIssue`
2. Reads ticket summary
3. Suggests branch name: `JIRA-123-sanitized-summary`

### Step 2: Check if Branch Already Exists

```
Does branch "JIRA-123-feature-name" exist in [username/repository]?
```

**Expected behavior:**
1. Calls `mcp__gitlab__list_branches`
2. Confirms whether branch exists

### Step 3: Simulate Status Update (Read-Only Test)

```
What would happen if I update Jira ticket [TICKET-ID] status to "In Progress"?
```

**Expected behavior:**
1. Explains the status transition
2. Shows available transitions via `mcp__atlassian__getIssue`
3. Doesn't actually update (unless user confirms)

## Test 5: Error Handling Tests

Test how the system handles various error conditions:

### Test 5a: Invalid Jira Ticket

```
Fetch details for Jira ticket INVALID-99999
```

**Expected behavior:**
- Graceful error message
- Suggests checking ticket ID format
- Doesn't crash or hang

### Test 5b: Invalid GitLab Project

```
Get information about GitLab project invalid/nonexistent
```

**Expected behavior:**
- Clear error message about project not found
- Suggests verifying project path

### Test 5c: Permission Error

Try an operation the user doesn't have permission for:

```
Try to update [RESTRICTED-TICKET]
```

**Expected behavior:**
- Clear permission denied message
- Suggests checking user permissions

## Test Results Summary

After running all tests, summarize the results:

### ✅ Passing Tests

List which tests passed successfully:
- [ ] MCP tools discovered
- [ ] Atlassian connectivity verified
- [ ] Jira ticket fetched
- [ ] Jira search working
- [ ] GitLab connectivity verified
- [ ] GitLab project accessed
- [ ] Branch listing working
- [ ] Integration test successful

### ❌ Failing Tests

List any tests that failed and why:
- Specific error messages
- Recommended fixes

### 🔧 Configuration Issues

Note any configuration problems:
- Missing environment variables
- Invalid tokens
- Incorrect URLs
- Permission issues

## Quick Diagnostic Commands

### Check Docker Containers
```bash
docker ps -a | grep -E "(atlassian|gitlab)"
```

### View Docker Logs
```bash
# Find container IDs
docker ps

# View logs (replace CONTAINER_ID)
docker logs CONTAINER_ID
```

### Test Environment Variables
```bash
# Test Jira API
curl -u "${ATLASSIAN_EMAIL}:${ATLASSIAN_API_TOKEN}" \
  "${JIRA_URL}/rest/api/2/myself"

# Test GitLab API
curl --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
  "${GITLAB_API_URL}/user"
```

### Validate Config JSON
```bash
jq . ~/.config/claude/config.json
# Should return formatted JSON (no errors)
```

## Troubleshooting Guide

### Issue: No MCP Tools Appear

**Solutions:**
1. Restart Claude Code completely
2. Verify config.json syntax
3. Check Docker is running
4. Pull images manually:
   ```bash
   docker pull ghcr.io/sooperset/mcp-atlassian:latest
   docker pull mcp/gitlab:latest
   ```

### Issue: Authentication Failures

**Atlassian:**
- Regenerate API token at https://id.atlassian.com/manage-profile/security/api-tokens
- Update environment variable
- Restart shell and Claude Code

**GitLab:**
- Check token hasn't expired
- Verify scopes include: `api`, `read_repository`, `write_repository`
- Regenerate at https://gitlab.com/-/profile/personal_access_tokens

### Issue: Connection Timeouts

**Solutions:**
- Verify URLs are correct (no trailing slashes)
- Check firewall/VPN isn't blocking
- Test with curl commands above
- Verify Docker has network access

### Issue: Permission Errors

**Solutions:**
- Check user has appropriate Jira permissions
- Verify GitLab project access level
- Confirm token scopes are sufficient
- Contact admin if enterprise restrictions exist

## Performance Tests

### Response Time Check

Measure typical operation times:

```
Fetch Jira ticket [TICKET-ID]
```
**Expected**: < 2 seconds

```
List branches in [project]
```
**Expected**: < 3 seconds

If slower:
- Check network connection
- Verify Docker resources
- Test Jira/GitLab API directly

## Next Steps

### All Tests Passing ✅

Congratulations! Your MCP servers are fully configured. You can now:

1. Start using the git-jira-workflow plugin
2. Try: "Start working on JIRA-1234"
3. Create branches linked to Jira tickets
4. Automatically create merge requests
5. Keep Jira status synchronized with Git

### Some Tests Failing ⚠️

1. Review the specific failures above
2. Re-run setup commands for failing components:
   - `/setup-atlassian-mcp` for Jira issues
   - `/setup-gitlab-mcp` for GitLab issues
3. Check troubleshooting section
4. Verify environment variables and tokens

### Need Help? 🆘

- **Plugin Issues**: https://github.com/AndroidNextdoor/stoked-automations/issues
- **Atlassian MCP**: https://github.com/sooperset/mcp-atlassian
- **GitLab MCP**: https://github.com/modelcontextprotocol/servers
- **Claude Code Docs**: https://docs.claude.com/en/docs/claude-code/

## Test Completion Checklist

- [ ] Docker is running
- [ ] Environment variables are set
- [ ] Config.json is valid
- [ ] MCP tools are discovered
- [ ] Atlassian MCP server responds
- [ ] GitLab MCP server responds
- [ ] Integration test passed
- [ ] Error handling works
- [ ] Ready to use git-jira-workflow plugin

Your MCP servers are now ready for production use! 🚀