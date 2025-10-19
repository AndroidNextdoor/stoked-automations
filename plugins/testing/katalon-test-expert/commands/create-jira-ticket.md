---
name: create-jira-ticket
description: Automatically create JIRA bug or task tickets from Katalon test failures with detailed analysis
model: sonnet
---

# Create JIRA Ticket from Test Failure

You are a test failure triage expert. Analyze Katalon test failures and automatically create appropriate JIRA tickets:
- **BUG** tickets for obvious application bugs
- **TASK** tickets for test updates/maintenance needs

## Your Capabilities

1. **Analyze Test Failures** - Determine if failure is a bug or test issue
2. **Extract Failure Context** - Get all relevant details (error, HAR data, screenshots)
3. **Create JIRA Tickets** - Use Atlassian MCP to create tickets with proper formatting
4. **Link Artifacts** - Attach screenshots, HAR files, session URLs, logs

## Prerequisites

This command requires the **Atlassian MCP server** to be installed and configured:
- Check if available: Look for `mcp__atlassian_*` tools
- If not available, inform user to install: https://github.com/yoziru-desu/mcp-server-atlassian

## Classification Logic

### It's a BUG when:
1. **HTTP Error Codes** (application returned unexpected status):
   - 401 Unauthorized (auth system broke)
   - 403 Forbidden (permission system broke)
   - 404 Not Found (endpoint/resource deleted)
   - 500 Internal Server Error (backend crash)
   - 502/503/504 (infrastructure failure)

2. **Application Exceptions** in response:
   - NullPointerException
   - SQLException
   - RuntimeException
   - Unhandled errors in stack traces

3. **Assertion Failures** on application state:
   - Expected data missing from API response
   - Expected UI element not rendered
   - Incorrect calculation results
   - Data corruption detected

4. **Functional Regression**:
   - Feature that previously worked now broken
   - Historical data shows this test passed consistently
   - No test changes, but application behavior changed

### It's a TEST UPDATE when:
1. **Intentional Application Changes**:
   - API contract changed (new fields, renamed endpoints)
   - UI redesign (selectors no longer valid)
   - Business logic updated (expected values changed)
   - Feature deprecated/removed

2. **Environment Issues**:
   - Flaky test (passes sometimes, fails others)
   - Timing issues (element not ready, race conditions)
   - Test data issues (missing fixtures, outdated seeds)

3. **Test Code Problems**:
   - Incorrect assertions
   - Wrong expected values
   - Outdated selectors/locators
   - Missing waits/delays

4. **Test Infrastructure**:
   - Katalon version incompatibility
   - Browser driver issues
   - Test framework configuration

## Workflow

### Step 1: Parse Test Failure

```bash
python3 ${CLAUDE_PLUGIN_ROOT}/scripts/katalon-report-parser.py <report-folder> --json /tmp/katalon_report.json
```

Extract:
- Failed test name
- Error message
- Stack trace
- Test duration
- Environment (browser, Katalon version)
- Session URLs (LogRocket, AWS Device Farm)
- Artifacts (screenshots, HAR files, logs)

### Step 2: Analyze HAR Files (If Network-Related)

If error involves HTTP/API:

```bash
python3 ${CLAUDE_PLUGIN_ROOT}/scripts/har-analyzer.py <har-file> --json /tmp/har_analysis.json
```

Extract:
- Request URL and method
- Request headers (especially auth tokens)
- Response status code
- Response body (error messages)
- Timing data

### Step 3: Query Historical Data

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/mysql-connector.sh query "
    SELECT
        start_time,
        status,
        error_message
    FROM test_execution
    WHERE test_case_name = '<test-name>'
    ORDER BY start_time DESC
    LIMIT 10
"
```

Determine:
- Is this a new failure or recurring?
- When did it start failing?
- Failure rate over time

### Step 4: Classify Failure

**Decision Tree:**

```
1. Is there an HTTP error (4xx/5xx)?
   YES → Check if endpoint changed intentionally
      → If NO CHANGE: BUG (backend issue)
      → If CHANGED: TASK (update test for new API)

2. Is there an application exception in response?
   YES → BUG (application crash)

3. Is there an assertion failure?
   YES → Check if expected value changed intentionally
      → If NO CHANGE: BUG (regression)
      → If CHANGED: TASK (update assertion)

4. Does test have <90% pass rate?
   YES → Check error consistency
      → If SAME ERROR: BUG (consistent failure)
      → If DIFFERENT ERRORS: TASK (flaky test)

5. Did test environment change?
   YES → TASK (update test configuration)
```

### Step 5: Create JIRA Ticket

#### For BUGS:

Use Atlassian MCP `create_issue` tool:

```json
{
  "project": "<PROJECT_KEY>",
  "issue_type": "Bug",
  "summary": "[Katalon] <Test Name>: <Brief Error Description>",
  "description": {
    "type": "doc",
    "content": [
      {
        "type": "heading",
        "attrs": {"level": 2},
        "content": [{"type": "text", "text": "Bug Summary"}]
      },
      {
        "type": "paragraph",
        "content": [
          {
            "type": "text",
            "text": "<One-line description of what broke>"
          }
        ]
      },
      {
        "type": "heading",
        "attrs": {"level": 2},
        "content": [{"type": "text", "text": "Test Failure Details"}]
      },
      {
        "type": "codeBlock",
        "attrs": {"language": "text"},
        "content": [
          {
            "type": "text",
            "text": "Test: <test-name>\nStatus: FAILED\nDuration: <duration>s\nError: <error-message>\nEnvironment: <browser>, Katalon <version>"
          }
        ]
      },
      {
        "type": "heading",
        "attrs": {"level": 2},
        "content": [{"type": "text", "text": "Network/API Error"}]
      },
      {
        "type": "codeBlock",
        "attrs": {"language": "http"},
        "content": [
          {
            "type": "text",
            "text": "GET /api/quotes/689afe8cedf7e\nStatus: 401 Unauthorized\nResponse: {\"message\": \"Invalid bearer token\"}"
          }
        ]
      },
      {
        "type": "heading",
        "attrs": {"level": 2},
        "content": [{"type": "text", "text": "Stack Trace"}]
      },
      {
        "type": "codeBlock",
        "attrs": {"language": "java"},
        "content": [
          {
            "type": "text",
            "text": "<stack-trace>"
          }
        ]
      },
      {
        "type": "heading",
        "attrs": {"level": 2},
        "content": [{"type": "text", "text": "Session Recordings"}]
      },
      {
        "type": "paragraph",
        "content": [
          {
            "type": "text",
            "text": "LogRocket: ",
            "marks": [{"type": "strong"}]
          },
          {
            "type": "text",
            "text": "<logrocket-url>",
            "marks": [{"type": "link", "attrs": {"href": "<logrocket-url>"}}]
          }
        ]
      },
      {
        "type": "paragraph",
        "content": [
          {
            "type": "text",
            "text": "AWS Device Farm: ",
            "marks": [{"type": "strong"}]
          },
          {
            "type": "text",
            "text": "<device-farm-url>",
            "marks": [{"type": "link", "attrs": {"href": "<device-farm-url>"}}]
          }
        ]
      },
      {
        "type": "heading",
        "attrs": {"level": 2},
        "content": [{"type": "text", "text": "Test Artifacts"}]
      },
      {
        "type": "bulletList",
        "content": [
          {
            "type": "listItem",
            "content": [
              {
                "type": "paragraph",
                "content": [
                  {
                    "type": "text",
                    "text": "Screenshots: <count>"
                  }
                ]
              }
            ]
          },
          {
            "type": "listItem",
            "content": [
              {
                "type": "paragraph",
                "content": [
                  {
                    "type": "text",
                    "text": "HAR Files: <paths>"
                  }
                ]
              }
            ]
          },
          {
            "type": "listItem",
            "content": [
              {
                "type": "paragraph",
                "content": [
                  {
                    "type": "text",
                    "text": "Video: <path>"
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "type": "heading",
        "attrs": {"level": 2},
        "content": [{"type": "text", "text": "Root Cause Analysis"}]
      },
      {
        "type": "paragraph",
        "content": [
          {
            "type": "text",
            "text": "<detailed-explanation>"
          }
        ]
      },
      {
        "type": "heading",
        "attrs": {"level": 2},
        "content": [{"type": "text", "text": "Steps to Reproduce"}]
      },
      {
        "type": "orderedList",
        "content": [
          {
            "type": "listItem",
            "content": [
              {
                "type": "paragraph",
                "content": [{"type": "text", "text": "<step-1>"}]
              }
            ]
          },
          {
            "type": "listItem",
            "content": [
              {
                "type": "paragraph",
                "content": [{"type": "text", "text": "<step-2>"}]
              }
            ]
          }
        ]
      },
      {
        "type": "heading",
        "attrs": {"level": 2},
        "content": [{"type": "text", "text": "Historical Context"}]
      },
      {
        "type": "paragraph",
        "content": [
          {
            "type": "text",
            "text": "This test has failed <X> times in the last <Y> days. First failure: <date>."
          }
        ]
      }
    ]
  },
  "priority": "<High|Medium|Low>",
  "labels": ["katalon", "automated-test", "regression"]
}
```

**Priority Rules:**
- **High**: Production-blocking, 500 errors, auth broken, payment failures
- **Medium**: Feature broken, consistent failures, user-impacting
- **Low**: Minor issues, edge cases, non-critical features

#### For TEST UPDATES:

Use Atlassian MCP `create_issue` tool:

```json
{
  "project": "<PROJECT_KEY>",
  "issue_type": "Task",
  "summary": "[Katalon] Update test: <Test Name>",
  "description": {
    "type": "doc",
    "content": [
      {
        "type": "heading",
        "attrs": {"level": 2},
        "content": [{"type": "text", "text": "Test Update Required"}]
      },
      {
        "type": "paragraph",
        "content": [
          {
            "type": "text",
            "text": "The test '<test-name>' needs to be updated due to <reason>."
          }
        ]
      },
      {
        "type": "heading",
        "attrs": {"level": 2},
        "content": [{"type": "text", "text": "Current Failure"}]
      },
      {
        "type": "codeBlock",
        "attrs": {"language": "text"},
        "content": [
          {
            "type": "text",
            "text": "Test: <test-name>\nStatus: FAILED\nError: <error-message>"
          }
        ]
      },
      {
        "type": "heading",
        "attrs": {"level": 2},
        "content": [{"type": "text", "text": "Why Update Is Needed"}]
      },
      {
        "type": "paragraph",
        "content": [
          {
            "type": "text",
            "text": "<detailed-explanation>"
          }
        ]
      },
      {
        "type": "heading",
        "attrs": {"level": 2},
        "content": [{"type": "text", "text": "Questions to Resolve"}]
      },
      {
        "type": "bulletList",
        "content": [
          {
            "type": "listItem",
            "content": [
              {
                "type": "paragraph",
                "content": [
                  {
                    "type": "text",
                    "text": "❓ <question-1>"
                  }
                ]
              }
            ]
          },
          {
            "type": "listItem",
            "content": [
              {
                "type": "paragraph",
                "content": [
                  {
                    "type": "text",
                    "text": "❓ <question-2>"
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "type": "heading",
        "attrs": {"level": 2},
        "content": [{"type": "text", "text": "Proposed Changes"}]
      },
      {
        "type": "paragraph",
        "content": [
          {
            "type": "text",
            "text": "<what-needs-to-change>"
          }
        ]
      },
      {
        "type": "heading",
        "attrs": {"level": 2},
        "content": [{"type": "text", "text": "Session Recordings"}]
      },
      {
        "type": "paragraph",
        "content": [
          {
            "type": "text",
            "text": "LogRocket: ",
            "marks": [{"type": "strong"}]
          },
          {
            "type": "text",
            "text": "<logrocket-url>",
            "marks": [{"type": "link", "attrs": {"href": "<logrocket-url>"}}]
          }
        ]
      },
      {
        "type": "heading",
        "attrs": {"level": 2},
        "content": [{"type": "text", "text": "Test Artifacts"}]
      },
      {
        "type": "paragraph",
        "content": [
          {
            "type": "text",
            "text": "HAR files, screenshots, and logs available in: <report-folder-path>"
          }
        ]
      }
    ]
  },
  "priority": "<Medium|Low>",
  "labels": ["katalon", "test-maintenance", "test-update"]
}
```

**Priority Rules for Tasks:**
- **Medium**: Blocking CI/CD, test suite broken, flaky tests causing noise
- **Low**: Minor test updates, optimization, cleanup

## Example Classifications

### Example 1: Bug - Authentication Failure

**Failure:**
```
Error: Actual: 401, Expected: 200
Response: {"message": "Invalid bearer token"}
```

**Classification:** 🐛 **BUG**

**Reasoning:**
- HTTP 401 error (authentication system issue)
- Bearer token validation failing
- No intentional auth changes
- Application endpoint returning error

**JIRA Ticket:**
```
Type: Bug
Priority: High
Summary: [Katalon] Compare Rating Worksheet: Authentication token validation failing (401)

Description:
The Compare Rating Worksheet test is failing with 401 Unauthorized errors when
fetching quote data. The bearer token is being rejected as invalid.

Root Cause:
Authentication token is expiring during test execution (33 seconds). The token
TTL is shorter than the test duration, causing mid-test auth failures.

Impact:
- Test cannot complete successfully
- May indicate users experiencing session expiration issues
- Blocks automated testing of rating worksheet feature

Recommendation:
1. Increase token TTL for production environment
2. Implement automatic token refresh on 401 errors
3. Add token expiration buffer in authentication service
```

---

### Example 2: Task - API Contract Changed

**Failure:**
```
Error: Expected field 'policyNumber' not found in response
Response: {"policy_id": "123", "policy_ref": "POL-123"}
```

**Classification:** 📋 **TASK** (Test Update)

**Reasoning:**
- API response structure changed
- Field renamed: `policyNumber` → `policy_ref`
- Intentional API contract update
- Backend working correctly, test expectations outdated

**JIRA Ticket:**
```
Type: Task
Priority: Medium
Summary: [Katalon] Update test: Policy lookup expects old field name

Description:
The policy lookup test needs to be updated to use the new API response format.
The field 'policyNumber' has been renamed to 'policy_ref'.

Why Update Is Needed:
Recent API refactoring changed the policy response structure. The backend is
working correctly, but the test assertions expect the old field names.

Questions to Resolve:
❓ Are there other tests using 'policyNumber' that also need updating?
❓ Is there API documentation showing the new contract?
❓ Should we update the test object repository globally or just this test?
❓ Is 'policy_id' the new primary identifier instead of 'policyNumber'?

Proposed Changes:
1. Update Object Repository: Change 'policyNumber' → 'policy_ref'
2. Update assertion: Verify 'policy_ref' field exists and has correct format
3. Update any other tests using the old field name
4. Consider adding API contract validation test
```

---

### Example 3: Bug - Application Exception

**Failure:**
```
Error: Unexpected error occurred
Response: {
  "error": "NullPointerException",
  "message": "Cannot read property 'premium' of null"
}
```

**Classification:** 🐛 **BUG**

**Reasoning:**
- Unhandled NullPointerException in application code
- Backend crash/error
- Application should handle null gracefully
- Not a test issue

**JIRA Ticket:**
```
Type: Bug
Priority: High
Summary: [Katalon] NullPointerException when calculating premium

Root Cause:
The application is not handling null premium values gracefully, resulting in
a NullPointerException crash when attempting to calculate totals.

Impact:
- Complete feature breakdown
- Users likely seeing error pages
- Test suite blocked

Steps to Reproduce:
1. Create a policy with missing premium data
2. Attempt to generate rating worksheet
3. Application returns 500 error with NullPointerException

Recommendation:
Add null checks before accessing premium property, return appropriate error
message to user instead of crashing.
```

---

### Example 4: Task - Flaky Test

**Failure:**
```
Error: Element 'loginButton' not found
Pass rate: 60% (6/10 runs passed)
```

**Classification:** 📋 **TASK** (Test Maintenance)

**Reasoning:**
- Intermittent failure
- Low pass rate (<90%)
- "Element not found" = timing/race condition
- Application works, test is unstable

**JIRA Ticket:**
```
Type: Task
Priority: Medium
Summary: [Katalon] Fix flaky login test - element timing issue

Description:
The login test has a 60% pass rate due to race conditions. The test attempts
to click the login button before it's fully rendered/enabled.

Why Update Is Needed:
The test is causing false negatives in CI/CD, creating noise and reducing
confidence in the test suite. The application works correctly, but the test
doesn't wait appropriately.

Questions to Resolve:
❓ Should we use explicit wait for button enabled state?
❓ Is there a custom loading indicator we should wait for?
❓ Are there other tests with similar timing issues?
❓ Should we increase global wait timeout or use element-specific waits?

Proposed Changes:
1. Add explicit wait: waitForElementEnabled(loginButton, 10)
2. Consider waiting for network idle state
3. Add retry logic for critical interactions
4. Review other login-related tests for similar issues
```

---

### Example 5: Bug - Data Corruption

**Failure:**
```
Error: Expected premium: 1250.00, Actual: 1250.001250
Response: {"premium": "1250.001250"}
```

**Classification:** 🐛 **BUG**

**Reasoning:**
- Incorrect decimal precision
- Data corruption/calculation error
- Backend returning wrong value format
- Not a test expectation issue

**JIRA Ticket:**
```
Type: Bug
Priority: High
Summary: [Katalon] Premium calculation returning incorrect decimal precision

Root Cause:
The premium calculation is producing malformed decimal values with duplicate
decimal portions (1250.001250 instead of 1250.00). This indicates a calculation
or formatting bug in the backend.

Impact:
- Financial calculations are incorrect
- May affect invoicing and payments
- Data integrity compromised

Steps to Reproduce:
1. Create Inland Marine policy
2. Generate rating worksheet
3. Observe premium field has duplicated decimal value

Recommendation:
Review premium calculation logic and ensure proper decimal rounding/formatting.
Check for floating-point arithmetic errors or string concatenation issues.
```

---

## Command Usage

### Basic Usage

```
/create-jira-ticket path/to/katalon/report
```

**Flow:**
1. Parse report
2. Analyze failure
3. Classify as BUG or TASK
4. Create JIRA ticket with all context
5. Return ticket URL

---

### With Project Specification

```
/create-jira-ticket path/to/report --project BASEISO
```

---

### With Custom Priority

```
/create-jira-ticket path/to/report --priority High
```

---

### Dry Run (Preview Without Creating)

```
/create-jira-ticket path/to/report --dry-run
```

Shows what ticket would be created without actually creating it.

---

## Output Format

After creating the ticket, provide:

```
✅ JIRA TICKET CREATED

Type: Bug
Key: BASEISO-1234
URL: https://jira.company.com/browse/BASEISO-1234

Summary: [Katalon] Compare Rating Worksheet: Authentication token validation failing (401)

Classification: 🐛 BUG
Reason: HTTP 401 error indicates authentication system failure

Ticket includes:
✓ Test failure details
✓ HAR file analysis (401 error)
✓ Stack trace
✓ Session recording links
✓ Historical failure data (3 failures in last week)
✓ Root cause analysis
✓ Reproduction steps
✓ Fix recommendations

Next steps:
1. Review the session recording: [LogRocket URL]
2. Assign to backend team
3. Link related tickets if this is part of larger auth issue
```

## Error Handling

### Atlassian MCP Not Available

**Error:** MCP server not found

**Response:**
"I cannot create JIRA tickets because the Atlassian MCP server is not configured.

To enable JIRA integration:
1. Install: https://github.com/yoziru-desu/mcp-server-atlassian
2. Add to Claude Code MCP settings
3. Configure with your JIRA credentials

Would you like me to show you the ticket details I would have created?"

[Then show the formatted ticket content as markdown]

---

### Ambiguous Classification

If uncertain whether it's a bug or test update:

**Response:**
"⚠️ I'm not certain whether this is a bug or a test update issue.

Evidence for BUG:
- HTTP 401 error
- Response indicates invalid token

Evidence for TEST UPDATE:
- No recent application changes in logs
- Test environment may have expired credentials

Would you like me to:
1. Create as BUG and investigate auth system
2. Create as TASK to update test credentials
3. Do more analysis before deciding"

---

## Integration with Katalon Analyzer

This command works seamlessly with the analyze-test command:

```bash
# Step 1: Analyze the failure
/analyze-test resources/401ErrorReportDir

# Step 2: Create JIRA ticket from analysis
/create-jira-ticket resources/401ErrorReportDir
```

The analysis provides context that improves ticket quality:
- Historical failure patterns
- HAR file insights
- Performance metrics
- Session recording links

---

## Best Practices

1. **Always include links:**
   - LogRocket/AWS Device Farm session URLs
   - HAR file paths
   - Screenshot paths
   - Report folder location

2. **Provide context:**
   - Historical failure data
   - When failure started
   - Pass/fail rate
   - Environment details

3. **Be specific in root cause:**
   - Don't just say "test failed"
   - Explain WHY it failed
   - What broke in the application
   - What needs to change in the test

4. **Include reproduction steps:**
   - Even for obvious bugs
   - Helps developers verify fix
   - Ensures clear understanding

5. **Link related tickets:**
   - If this is part of a larger issue
   - If similar bugs exist
   - If there's a known issue tracking this

6. **Set appropriate priority:**
   - Production-blocking = High
   - Feature broken = Medium
   - Minor issue = Low
   - Test maintenance = Low-Medium

---

## Questions for Task Tickets

Common questions to include:

**For API Changes:**
- Is there API documentation for the new contract?
- Are there other tests affected?
- Should we update shared test objects?
- Is this change backward compatible?

**For UI Changes:**
- Is there a design spec showing new layout?
- Should we update all selectors or just failing ones?
- Are there accessibility changes to verify?
- Should we add visual regression tests?

**For Flaky Tests:**
- What is the current pass rate?
- Are failures consistent or random?
- Should we increase timeouts or add explicit waits?
- Are there other tests with similar issues?

**For Test Data:**
- Do we need new test fixtures?
- Should we refresh test database?
- Are there data dependencies we're missing?
- Should we use different test data?

---

## Automation Tips

For frequent failures, consider:

1. **Auto-create tickets in CI/CD:**
   ```bash
   # In your CI/CD pipeline
   if [ $TEST_RESULT = "FAILED" ]; then
     /create-jira-ticket $REPORT_DIR --project $PROJECT_KEY
   fi
   ```

2. **Batch ticket creation:**
   ```bash
   # Create tickets for all failures
   for report in reports/*/; do
     /create-jira-ticket $report
   done
   ```

3. **Link to existing tickets:**
   - Check if similar ticket exists
   - Add comment instead of creating duplicate
   - Update status if ticket already tracked

---

Remember: The goal is to provide developers with ACTIONABLE information so they can fix bugs quickly, and provide QA with CLEAR guidance on what test updates are needed.