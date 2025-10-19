---
name: test-branch-naming
description: Test branch naming conventions with Jira integration
model: sonnet
---

# Test Branch Naming Conventions

Comprehensive test suite to verify that branch names are generated correctly according to the git-jira-workflow conventions.

## Branch Naming Rules

The plugin follows these conventions:

### Feature Branches
- **Format**: `JIRA-123-sanitized-description`
- **No prefix**: Feature branches start directly with the ticket ID
- **Examples**:
  - `JIRA-1234-add-user-authentication`
  - `PROJ-5678-payment-integration`
  - `ACME-999-fix-login-bug`

### Hotfix Branches
- **Format**: `HOTFIX/JIRA-123-description` or `HOTFIX-description`
- **With HOTFIX prefix**: Critical production fixes
- **Examples**:
  - `HOTFIX/JIRA-9999-security-patch`
  - `HOTFIX/PROJ-777-memory-leak`
  - `HOTFIX-critical-database-fix`

### Release Branches
- **Format**: `2025.1.0` (Annual-style versioning)
- **Pattern**: `YYYY.R.P` (Year.Release.Patch)
- **Examples**:
  - `2025.1.0` - First release of 2025
  - `2025.1.1` - First patch
  - `2025.2.0` - Second major release

## Test Suite

Run through these tests to verify branch naming works correctly.

## Test 1: Feature Branch Naming

### Test 1.1: Standard Feature Branch

**User Request**:
```
I need to start working on JIRA-1234 for adding user authentication
```

**Expected Branch Name**:
```
JIRA-1234-add-user-authentication
```

**Verification Checklist**:
- [ ] Branch name starts with `JIRA-1234` (ticket ID)
- [ ] No `feature/` prefix
- [ ] Description is sanitized (lowercase, hyphens)
- [ ] No special characters in description
- [ ] Descriptive enough to understand the feature

**Common Issues**:
- ❌ `feature/JIRA-1234-add-user-authentication` (extra prefix)
- ❌ `JIRA-1234` (missing description)
- ❌ `JIRA-1234_add_user_authentication` (underscores instead of hyphens)
- ❌ `JIRA-1234-Add-User-Authentication` (not lowercase)

### Test 1.2: Long Description Handling

**User Request**:
```
Start work on JIRA-5678 for implementing the new payment gateway integration with Stripe and PayPal including webhook handlers
```

**Expected Branch Name**:
```
JIRA-5678-implement-payment-gateway-integration
```

**Verification Checklist**:
- [ ] Description is concise but meaningful
- [ ] Long description is truncated reasonably
- [ ] Still conveys the main purpose
- [ ] No excessive length (< 60 characters total)

### Test 1.3: Special Characters Handling

**User Request**:
```
Work on JIRA-9999: Fix the bug with user's @email addresses & special characters!
```

**Expected Branch Name**:
```
JIRA-9999-fix-bug-user-email-addresses-special-characters
```

**Verification Checklist**:
- [ ] Special characters removed: `@`, `&`, `!`, `:`
- [ ] Apostrophes handled correctly
- [ ] Multiple spaces collapsed to single hyphens
- [ ] No leading or trailing hyphens

### Test 1.4: Custom Project Keys

Test with different Jira project keys:

**User Requests**:
```
1. "Start work on PROJ-123 for dashboard redesign"
2. "Work on ACME-456 for API refactoring"
3. "Begin DEV-789 for database migration"
```

**Expected Branch Names**:
```
1. PROJ-123-dashboard-redesign
2. ACME-456-api-refactoring
3. DEV-789-database-migration
```

**Verification Checklist**:
- [ ] Works with any project key (not just "JIRA")
- [ ] Project key format validated (CAPS-NUMBER)
- [ ] Description always follows same rules

## Test 2: Hotfix Branch Naming

### Test 2.1: Standard Hotfix

**User Request**:
```
Critical bug! Need to create hotfix for JIRA-9999 - security vulnerability
```

**Expected Branch Name**:
```
HOTFIX/JIRA-9999-security-vulnerability
```

**Verification Checklist**:
- [ ] Starts with `HOTFIX/` prefix
- [ ] Includes Jira ticket ID
- [ ] Description is sanitized
- [ ] Clearly indicates urgency

**Common Issues**:
- ❌ `hotfix/JIRA-9999-security-vulnerability` (lowercase prefix)
- ❌ `JIRA-9999-security-vulnerability` (missing HOTFIX prefix)
- ❌ `HOTFIX-JIRA-9999-security-vulnerability` (hyphen instead of slash)

### Test 2.2: Hotfix Without Ticket

**User Request**:
```
Emergency hotfix needed for production database connection issue
```

**Expected Branch Name**:
```
HOTFIX-production-database-connection
```

**Verification Checklist**:
- [ ] Starts with `HOTFIX-` (hyphen when no ticket)
- [ ] Description is clear and urgent
- [ ] No ticket ID present (optional for emergencies)

### Test 2.3: Hotfix Priority Detection

**User Request**:
```
Create hotfix for JIRA-7777
```

**Expected Behavior**:
1. Fetch Jira ticket via `mcp__atlassian__getIssue`
2. Check if ticket type is "Bug" or has "Critical" priority
3. If not critical, prompt user to confirm hotfix vs regular fix
4. Create branch: `HOTFIX/JIRA-7777-[description]`

**Verification Checklist**:
- [ ] Verifies ticket is actually critical
- [ ] Suggests regular branch if not urgent
- [ ] Updates Jira priority to "Critical" if user confirms

## Test 3: Branch Name Sanitization Rules

### Test 3.1: Character Replacement

Test these inputs and verify correct sanitization:

| Input | Expected Output |
|-------|----------------|
| `User's Authentication` | `user-authentication` |
| `API & Database` | `api-database` |
| `Fix: Login Bug` | `fix-login-bug` |
| `Update README.md` | `update-readme-md` |
| `Add @mentions feature` | `add-mentions-feature` |
| `Support UTF-8 encoding` | `support-utf-8-encoding` |

**Sanitization Rules**:
- [ ] Lowercase conversion
- [ ] Spaces → hyphens
- [ ] Special chars removed: `!@#$%^&*()+=[]{}|;:'",<>?`
- [ ] Apostrophes removed
- [ ] Colons removed
- [ ] Multiple hyphens collapsed to single
- [ ] Leading/trailing hyphens trimmed

### Test 3.2: Acronym Preservation

**User Request**:
```
Work on JIRA-1111 for implementing REST API with JSON responses
```

**Expected Branch Name**:
```
JIRA-1111-implement-rest-api-json-responses
```

**Verification Checklist**:
- [ ] Acronyms preserved in lowercase (rest, api, json)
- [ ] Not broken up (j-s-o-n)
- [ ] Readable and clear

## Test 4: Branch Existence Checking

### Test 4.1: Duplicate Branch Detection

**Setup**: Create a test branch first
```bash
git checkout -b JIRA-1234-test-feature
```

**User Request**:
```
Start work on JIRA-1234
```

**Expected Behavior**:
1. Check if branch `JIRA-1234-*` already exists via `mcp__gitlab__list_branches`
2. Warn user that branch already exists
3. Suggest:
   - Checkout existing branch
   - Create new branch with suffix: `JIRA-1234-test-feature-v2`
   - Use different ticket

**Verification Checklist**:
- [ ] Detects existing branches
- [ ] Provides clear options
- [ ] Doesn't overwrite existing work

### Test 4.2: Similar Branch Names

**Scenario**: Multiple branches for same ticket

Existing branches:
- `JIRA-1234-add-authentication`
- `JIRA-1234-authentication-tests`

**User Request**:
```
Work on JIRA-1234
```

**Expected Behavior**:
- [ ] Lists existing branches with JIRA-1234
- [ ] Asks which to checkout or create new
- [ ] Suggests descriptive suffix if creating new

## Test 5: Integration with Jira

### Test 5.1: Fetch Ticket for Branch Name

**User Request**:
```
Start work on JIRA-5555
```

**Expected Workflow**:
1. Call `mcp__atlassian__getIssue` with ticket ID
2. Extract ticket summary (e.g., "Implement OAuth2 Authentication")
3. Generate branch name: `JIRA-5555-implement-oauth2-authentication`
4. Present to user for confirmation
5. Create branch if confirmed

**Verification Checklist**:
- [ ] Ticket fetched successfully
- [ ] Summary used for description
- [ ] User can modify suggested name
- [ ] Branch created with final name

### Test 5.2: Ticket Not Found Handling

**User Request**:
```
Work on JIRA-99999
```

**Expected Behavior**:
1. Attempt to fetch ticket
2. Receive 404 Not Found
3. Gracefully handle error
4. Options:
   - Verify ticket ID
   - Create branch without Jira (manual description)
   - Create Jira ticket first

**Verification Checklist**:
- [ ] Clear error message
- [ ] Helpful suggestions
- [ ] Doesn't crash
- [ ] Allows manual branch name input

## Test 6: GitLab Integration

### Test 6.1: Branch Creation via GitLab MCP

**Prerequisites**: GitLab MCP server configured

**User Request**:
```
Create branch JIRA-7777-new-feature in my GitLab project
```

**Expected Workflow**:
1. Validate branch name format
2. Check if branch exists via `mcp__gitlab__list_branches`
3. Create branch via Git operations
4. Verify creation via `mcp__gitlab__list_branches`

**Verification Checklist**:
- [ ] Branch created in GitLab
- [ ] Visible in repository
- [ ] Associated with correct base branch
- [ ] Ready for commits

## Test 7: Complete Workflow Test

### End-to-End Branch Creation Test

**Scenario**: Complete workflow from Jira ticket to branch creation

**Steps**:
1. **User**: "I need to start working on JIRA-2468"
2. **Plugin**:
   - Fetches ticket via Atlassian MCP
   - Ticket summary: "Add Two-Factor Authentication"
   - Suggests: `JIRA-2468-add-two-factor-authentication`
3. **User**: Confirms
4. **Plugin**:
   - Creates local branch
   - Updates Jira status to "In Progress"
   - Confirms branch ready

**Verification Checklist**:
- [ ] Branch name follows convention
- [ ] No `feature/` prefix
- [ ] Jira status updated
- [ ] User can start working immediately
- [ ] Branch tracked in GitLab

## Test Results Summary

After running all tests, document the results:

### ✅ Passing Tests

- [ ] Feature branch naming (no prefix)
- [ ] Hotfix branch naming (with HOTFIX/ prefix)
- [ ] Character sanitization
- [ ] Long description handling
- [ ] Special characters removed
- [ ] Custom project keys
- [ ] Duplicate detection
- [ ] Jira integration
- [ ] GitLab integration
- [ ] End-to-end workflow

### ❌ Failing Tests

Document any failures:
- Test name
- Expected result
- Actual result
- Error message
- Suggested fix

### 📋 Test Environment

- Git version: `git --version`
- Atlassian MCP status: `/mcp list | grep atlassian`
- GitLab MCP status: `/mcp list | grep gitlab`
- Current directory: `pwd`
- Repository: `git remote -v`

## Manual Verification Commands

### Check Current Branch
```bash
git branch --show-current
```

### List All Branches
```bash
git branch -a
```

### Verify Branch Pattern
```bash
git branch | grep -E "^  (JIRA|PROJ|ACME)-[0-9]+-"
```

### Check Remote Branches
```bash
git ls-remote --heads origin
```

### GitLab API Check
```bash
curl --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
  "${GITLAB_API_URL}/projects/PROJECT_ID/repository/branches"
```

## Troubleshooting

### Issue: Wrong Branch Prefix

**Symptom**: Branches created as `feature/JIRA-123-description`

**Fix**:
- Check SKILL.md is updated with correct format
- Verify no conflicting configuration
- Clear any cached branch naming logic

### Issue: Special Characters Not Removed

**Symptom**: Branches like `JIRA-123-user's-feature`

**Fix**:
- Review sanitization function
- Test character replacement logic
- Update regex patterns

### Issue: Branch Names Too Long

**Symptom**: Branch names exceed 60 characters

**Fix**:
- Implement length limits
- Truncate description intelligently
- Keep essential words

### Issue: Duplicate Branches Not Detected

**Symptom**: Creates multiple branches with same name

**Fix**:
- Verify GitLab MCP is working
- Check `list_branches` command
- Test branch existence logic

## Quick Test Script

Create a file `test-branches.sh` for automated testing:

```bash
#!/bin/bash

echo "Testing Branch Naming Conventions"
echo "=================================="

# Test 1: Feature Branch
echo "Test 1: Feature branch naming"
echo "Expected: JIRA-1234-test-feature"
read -p "Create test branch? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git checkout -b JIRA-1234-test-feature
    git branch | grep "JIRA-1234-test-feature" && echo "✅ PASS" || echo "❌ FAIL"
    git checkout -
    git branch -D JIRA-1234-test-feature
fi

# Test 2: Hotfix Branch
echo "Test 2: Hotfix branch naming"
echo "Expected: HOTFIX/JIRA-9999-urgent-fix"
read -p "Create hotfix branch? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git checkout -b HOTFIX/JIRA-9999-urgent-fix
    git branch | grep "HOTFIX/JIRA-9999-urgent-fix" && echo "✅ PASS" || echo "❌ FAIL"
    git checkout -
    git branch -D HOTFIX/JIRA-9999-urgent-fix
fi

echo "Tests complete!"
```

Make executable:
```bash
chmod +x test-branches.sh
./test-branches.sh
```

## Success Criteria

All tests pass when:

✅ Feature branches have NO `feature/` prefix
✅ Format is exactly: `JIRA-123-description`
✅ Hotfixes use: `HOTFIX/JIRA-123-description`
✅ Special characters are sanitized
✅ Long descriptions are truncated reasonably
✅ Duplicate branches are detected
✅ Jira integration works correctly
✅ GitLab integration works correctly
✅ End-to-end workflow completes successfully

Your branch naming convention is ready for production use! 🎉