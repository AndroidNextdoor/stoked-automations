---
name: GitLab Repository and CI/CD Management
description: |
  Activates when users need to manage GitLab repositories, branches, merge requests, CI/CD pipelines, or issues. Triggers on phrases like "create merge request", "list branches", "check pipeline status", "push files to GitLab", "create repository", "get file contents", "update MR", or "check CI status". Uses GitLab MCP server for full GitLab API integration via Docker.
---

## Overview

This skill leverages the GitLab MCP server to provide comprehensive repository management, version control operations, and CI/CD integration directly from Claude Code. It enables seamless GitLab workflows without leaving your development environment.

## How It Works

1. **Repository Operations**: Create, search, and manage GitLab projects
2. **File Management**: Read, write, and commit files with full Git integration
3. **Branch Management**: List, create, and manage branches
4. **Merge Requests**: Create, update, and review MRs with automated workflows
5. **CI/CD Integration**: Monitor pipeline status and build results
6. **Issue Tracking**: Create and manage GitLab issues

## When to Use This Skill

- When you need to create a merge request after completing work
- When checking if a branch exists before creating it
- When monitoring CI/CD pipeline status
- When pushing code changes to a repository
- When creating a new GitLab repository or project
- When reading file contents from a remote repository
- When checking MR status or updating MR details
- When creating GitLab issues for bugs or features

## MCP Tools Available

### Repository Tools

- **create_repository**: Create a new GitLab project/repository
- **search_repositories**: Find repositories by name or criteria
- **get_project**: Get detailed project information and statistics

### File Operations

- **get_file_contents**: Read file contents from a repository
- **create_or_update_file**: Modify a single file with a commit
- **push_files**: Commit multiple files in a single operation

### Branch Management

- **list_branches**: List all branches in a repository
- **list_commits**: View commit history for a branch

### Merge Requests

- **create_merge_request**: Create a new MR with title and description
- **get_merge_request**: Fetch MR details, approvals, and status
- **update_merge_request**: Modify MR title, description, or state

### CI/CD

- **get_pipeline_status**: Check pipeline execution status and job results

### Issues

- **create_issue**: Create GitLab issues with labels and descriptions

## Examples

### Example 1: Creating a Merge Request

User request: "Create a merge request from JIRA-1234-auth-feature to main with title '[JIRA-1234] Add authentication feature'"

The skill will:
1. Use `create_merge_request` with:
   - Source branch: JIRA-1234-auth-feature
   - Target branch: main
   - Title: [JIRA-1234] Add authentication feature
2. Return MR number and URL
3. Automatically trigger CI pipeline

### Example 2: Checking Branch Existence

User request: "Does the branch JIRA-5678-payment exist in myusername/myproject?"

The skill will:
1. Use `list_branches` for myusername/myproject
2. Search for branch name matching JIRA-5678-payment
3. Return branch details if exists, or confirm it doesn't exist

### Example 3: Monitoring CI/CD Pipeline

User request: "Check if the CI pipeline passed on the main branch of myproject"

The skill will:
1. Use `get_pipeline_status` for main branch
2. Return pipeline status (success, failed, running)
3. Show job details and failure reasons if applicable

### Example 4: Bulk File Push

User request: "Push these three files to myproject: src/auth.ts, tests/auth.test.ts, and README.md"

The skill will:
1. Use `push_files` to commit all three files at once
2. Create a single commit with descriptive message
3. Return commit SHA and trigger CI pipeline

### Example 5: Reading Remote Files

User request: "Get the contents of package.json from myusername/myproject"

The skill will:
1. Use `get_file_contents` to fetch package.json
2. Parse and display file contents
3. Identify file version/branch source

## Workflow Integration

### Complete Feature Workflow

```
1. Check if branch exists
   → Use list_branches

2. Create merge request
   → Use create_merge_request
   → Provide Jira ticket reference in title

3. Wait for CI to complete
   → Use get_pipeline_status
   → Monitor until success or failure

4. Update MR if needed
   → Use update_merge_request
   → Add test results or deployment notes
```

### Repository Setup Workflow

```
1. Create new repository
   → Use create_repository
   → Set visibility and description

2. Push initial files
   → Use push_files with:
     - README.md
     - .gitignore
     - LICENSE

3. Create issues for initial tasks
   → Use create_issue
   → Add labels (enhancement, documentation)
```

## Common Use Cases

### Use Case 1: Pre-MR Checklist

Before creating an MR:
```
1. List branches to verify source branch exists
2. Get file contents to review changes
3. Check pipeline status on source branch
4. Create MR with Jira ticket reference
```

### Use Case 2: CI/CD Monitoring

After pushing commits:
```
1. Get pipeline status immediately
2. Wait for jobs to complete
3. Check for test failures
4. Review failed job logs
```

### Use Case 3: Quick Fixes

For urgent production fixes:
```
1. Create hotfix branch
2. Push file changes
3. Create MR with "hotfix" label
4. Monitor pipeline for fast merge
```

## Project Path Format

All GitLab operations require the project path in format: `namespace/project-name`

Examples:
- `myusername/myrepo`
- `myorg/backend-api`
- `gitlab-org/gitlab-runner`

## Branch Naming

The skill works seamlessly with these branch patterns:
- `JIRA-123-description` (feature branches)
- `HOTFIX/JIRA-123-description` (hotfix branches)
- `main`, `develop`, `staging` (environment branches)

## Merge Request Best Practices

When creating MRs, the skill follows these patterns:

1. **Title Format**: `[JIRA-123] Brief description`
2. **Description Includes**:
   - Jira ticket link
   - Summary of changes
   - Testing performed
   - Related issues or MRs
3. **Labels**: Automatically suggests relevant labels
4. **Assignee**: Can auto-assign based on branch author

## CI/CD Pipeline Interpretation

The skill interprets pipeline status:

| Status | Meaning | Action |
|--------|---------|--------|
| `success` | All jobs passed | Safe to merge |
| `failed` | One or more jobs failed | Review failures |
| `running` | Pipeline in progress | Wait for completion |
| `pending` | Pipeline queued | Check runner availability |
| `canceled` | Manually stopped | Re-run if needed |
| `skipped` | Jobs not triggered | Review pipeline rules |

## Error Handling

The skill handles common GitLab errors:

- **401 Unauthorized**: Invalid or expired token
- **403 Forbidden**: Insufficient permissions
- **404 Not Found**: Repository or branch doesn't exist
- **422 Unprocessable**: Invalid MR parameters (branches identical)
- **409 Conflict**: MR already exists for these branches

## Configuration Requirements

Requires these environment variables:

```bash
export GITLAB_TOKEN="glpat-your-token-here"
export GITLAB_API_URL="https://gitlab.com/api/v4"

# For self-hosted:
# export GITLAB_API_URL="https://your-gitlab.com/api/v4"
```

## Token Scopes Required

Minimum token scopes:
- `api` - Full API access
- `read_repository` - Read repository data
- `write_repository` - Push commits and create branches

Optional scopes:
- `read_api` - Read-only API access
- `write_webhook` - Create CI/CD webhooks

## Troubleshooting

**Issue: "Cannot find repository"**
- Verify project path format: namespace/project-name
- Check you have access to the repository
- Ensure repository exists in GitLab

**Issue: "Cannot create merge request"**
- Verify source and target branches exist
- Check branches are different (have changes)
- Ensure you have Developer+ role

**Issue: "Pipeline status unavailable"**
- Verify CI/CD is enabled for the project
- Check pipeline was triggered for the branch
- Confirm you have permission to view pipelines

## Related Skills

- **atlassian-mcp**: Link MRs to Jira tickets automatically
- **git-jira-workflow**: Create branches from Jira tickets
- **serena**: Store project configuration and MR templates

---

**Skill Version**: 1.0.0
**MCP Server**: gitlab
**Last Updated**: 2025-10-18