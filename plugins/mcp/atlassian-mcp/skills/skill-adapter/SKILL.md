---
name: Jira and Confluence Management
description: |
  Activates when users need to manage Jira issues, update ticket statuses, search for issues, add comments, or access Confluence documentation. Triggers on phrases like "create Jira ticket", "update issue status", "search Jira", "add comment to ticket", "get Confluence page", "fetch issue details", "transition issue", or "search documentation". Uses Atlassian MCP server for full Jira and Confluence integration via REST API.
---

## Overview

This skill leverages the Atlassian MCP server to provide seamless integration with Jira and Confluence. It enables comprehensive issue tracking, project management, and documentation access directly from Claude Code without leaving your development environment.

## How It Works

1. **Issue Management**: Create, read, update, and delete Jira issues with full field support
2. **Status Transitions**: Move issues through your Jira workflow with validation
3. **JQL Search**: Execute powerful searches using Jira Query Language
4. **Comments & Collaboration**: Add comments and collaborate on issues in real-time
5. **Confluence Access**: Retrieve and search Confluence documentation

## When to Use This Skill

- When you need to create a Jira ticket for a bug or feature request
- When updating issue status (To Do → In Progress → Done)
- When searching for issues by project, status, assignee, or custom criteria
- When adding progress updates or comments to issues
- When retrieving API documentation or technical specs from Confluence
- When checking issue details before starting work
- When transitioning issues through your team's workflow

## MCP Tools Available

### Jira Tools

- **getIssue**: Fetch complete details for a specific issue by key (PROJ-123)
- **createIssue**: Create new issues with summary, description, type, priority
- **updateIssue**: Modify issue fields (status, assignee, labels, custom fields)
- **searchIssues**: Execute JQL queries to find issues matching criteria
- **addComment**: Add comments to issues for collaboration
- **transitionIssue**: Move issues through workflow states

### Confluence Tools

- **getConfluencePage**: Retrieve page content by ID or title
- **searchConfluence**: Search across all Confluence spaces for content

## Examples

### Example 1: Creating a Bug Report

User request: "Create a Jira bug for the login issue on mobile Safari, assign it to me, set priority to High"

The skill will:
1. Use `createIssue` to create a new Bug-type issue
2. Set summary: "Login issue on mobile Safari"
3. Assign to the requesting user
4. Set priority to High
5. Return the issue key (e.g., PROJ-456)

### Example 2: Checking Sprint Progress

User request: "Show me all issues in PROJ that are currently In Progress"

The skill will:
1. Use `searchIssues` with JQL: `project = PROJ AND status = "In Progress"`
2. Return list of matching issues with:
   - Issue key and summary
   - Assignee
   - Priority
   - Last updated timestamp

### Example 3: Updating Issue Status

User request: "Update PROJ-789 status to 'In Review' and add a comment that the code is ready"

The skill will:
1. Use `transitionIssue` to move issue to "In Review" status
2. Use `addComment` to add: "Code is ready for review"
3. Confirm successful update

### Example 4: Finding Documentation

User request: "Get the Confluence page about our authentication API"

The skill will:
1. Use `searchConfluence` with query: "authentication API"
2. Return relevant pages with excerpts
3. Provide full page URL for detailed access

### Example 5: Advanced JQL Search

User request: "Find all critical bugs assigned to john.doe that were updated in the last week"

The skill will:
1. Construct JQL query:
   ```jql
   project = PROJ AND
   type = Bug AND
   priority = Critical AND
   assignee = "john.doe@company.com" AND
   updated >= -1w
   ```
2. Execute `searchIssues`
3. Return matching issues with full details

## Workflow Integration

### Development Workflow

```
1. User starts work on JIRA-1234
   → Use getIssue to fetch details
   → Display summary, description, acceptance criteria

2. User creates feature branch
   → (Handled by git-jira-workflow plugin)

3. User completes work
   → Use transitionIssue to move to "In Review"
   → Use addComment to notify team

4. Code review complete
   → Use transitionIssue to move to "Done"
```

### Bug Triage Workflow

```
1. User discovers bug
   → Use createIssue to report Bug-type issue
   → Set priority based on severity

2. Team reviews bug
   → Use searchIssues to find similar bugs
   → Use addComment to add triage notes

3. Bug gets assigned
   → Use updateIssue to set assignee
   → Use transitionIssue to move to "In Progress"
```

## Common JQL Patterns

The skill understands these common search patterns:

| User Request | Generated JQL |
|--------------|---------------|
| "My open issues" | `assignee = currentUser() AND status != Done` |
| "High priority bugs" | `type = Bug AND priority = High` |
| "Issues updated today" | `updated >= startOfDay()` |
| "Unassigned stories" | `type = Story AND assignee is EMPTY` |
| "Overdue issues" | `duedate < now() AND status != Done` |

## Field Mapping

When creating or updating issues, the skill maps natural language to Jira fields:

| Natural Language | Jira Field |
|------------------|------------|
| "assign to me" | `assignee = currentUser` |
| "high priority" | `priority = High` |
| "bug" | `issuetype = Bug` |
| "sprint 23" | `sprint = "Sprint 23"` |
| "blocker" | `priority = Blocker` |

## Error Handling

The skill gracefully handles common errors:

- **401 Unauthorized**: Prompts to check API token
- **404 Not Found**: Suggests verifying issue key format
- **403 Forbidden**: Indicates permission issues
- **400 Bad Request**: Validates required fields before retry

## Best Practices

1. **Use JQL for complex searches** - More powerful than simple keyword search
2. **Always fetch issue before updating** - Ensures you have latest data
3. **Add meaningful comments** - Helps team collaboration
4. **Transition issues through workflow** - Don't skip workflow states
5. **Link related issues** - Use issue keys in comments (PROJ-123)
6. **Set appropriate priority** - Helps with triage and planning

## Configuration Requirements

Requires these environment variables:

```bash
export JIRA_URL="https://yourcompany.atlassian.net"
export ATLASSIAN_EMAIL="your.email@company.com"
export ATLASSIAN_API_TOKEN="your-token-here"

# Optional for Confluence:
export CONFLUENCE_URL="https://yourcompany.atlassian.net/wiki"
```

## Troubleshooting

**Issue: "Cannot find issue PROJ-123"**
- Verify issue exists in Jira web UI
- Check you have permission to view the issue
- Ensure issue key format is correct (PROJECT-NUMBER)

**Issue: "Cannot transition issue"**
- Check Jira workflow allows this transition
- Verify you have permission to transition
- Some transitions require specific fields to be set

**Issue: "Search returns no results"**
- Verify JQL syntax is correct
- Check project key exists
- Ensure you have access to the project

## Related Skills

- **git-jira-workflow**: Automatically creates branches from Jira tickets
- **serena**: Stores project context and decisions
- **gitlab-mcp**: Creates merge requests linked to Jira issues

---

**Skill Version**: 1.0.0
**MCP Server**: mcp-atlassian
**Last Updated**: 2025-10-18