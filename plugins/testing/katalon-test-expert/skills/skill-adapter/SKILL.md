---
name: Katalon Test Analyzer
description: |
  Automatically activate when users mention Katalon test failures, HAR files,
  test result analysis, LogRocket sessions, AWS Device Farm, or need help
  debugging test execution issues. Parse Katalon reports, analyze network
  performance, query MySQL test databases, and correlate failures with session recordings.
---

# Katalon Test Analyzer Skill

## How It Works

This skill helps you deep-dive into Katalon Studio test failures with a LogRocket-style analysis approach:

1. **Detect Test Analysis Needs** - Activates when you mention:
   - Katalon test failures or errors
   - HAR file analysis or network debugging
   - Test result parsing or MySQL test data queries
   - LogRocket or AWS Device Farm session URLs
   - Performance issues in API tests
   - Failed test investigation

2. **Parse Katalon Reports** - Automatically:
   - Locate and parse JUnit XML reports
   - Extract test execution summaries (passed/failed/errors)
   - Identify test environment details (browser, Katalon version, session ID)
   - Find and list all test artifacts (screenshots, videos, HAR files)
   - Extract LogRocket and AWS Device Farm session URLs

3. **Analyze Network Performance** - Using HAR files:
   - Detect HTTP errors (401, 403, 404, 500, etc.)
   - Measure performance metrics (TTFB, SSL time, DNS time, connect time)
   - Identify slow requests (>1000ms threshold)
   - Analyze resource breakdown (JS, CSS, images, API calls)
   - Generate performance recommendations

4. **Query MySQL Database** - For historical context:
   - List recent test executions
   - Find failed tests in specific time ranges
   - Get detailed test execution data
   - Retrieve performance metrics
   - Export test data to JSON

5. **Correlate Errors** - Across multiple sources:
   - Match HAR file errors with test failures
   - Link session recordings to failed test cases
   - Identify patterns in flaky tests
   - Compare against historical test data

## When to Use This Skill

### Automatic Activation Triggers

This skill activates automatically when you say things like:

- "Analyze this Katalon test failure"
- "Why did my test get a 401 error?"
- "Parse the test report in this directory"
- "Show me HAR files for the failed test"
- "Query MySQL for recent test failures"
- "What's the LogRocket session URL?"
- "Analyze network performance for this API test"
- "Find slow requests in the HAR file"
- "Get test execution details from the database"
- "Compare this test failure to previous runs"

### Manual Invocation

You can also explicitly request analysis:

```
Please analyze the Katalon test report at /path/to/report
```

```
Parse HAR files in the requests directory and find errors
```

```
Query the MySQL database for tests that failed in the last 24 hours
```

## What You Can Ask

### Report Parsing

**User:** "Parse the Katalon report in the 401ErrorReportDir folder"

**Skill Response:** Runs `katalon-report-parser.py` and provides:
- Test execution summary (5 tests, 1 failed)
- Failed test details (which test, error message, stack trace)
- Test environment (Browser: Chrome 140, Remote Driver: Device Farm)
- Session URLs (LogRocket, AWS Device Farm)
- Artifacts found (8 screenshots, 1 video, 2 HAR files, 1 log)

---

**User:** "Export that report to JSON"

**Skill Response:** Re-runs parser with `--json` flag and saves to specified file

---

### HAR File Analysis

**User:** "Analyze the Get-Quote-Data HAR file for errors"

**Skill Response:** Runs `har-analyzer.py` and provides:
- HTTP errors detected (401 Unauthorized)
- Performance metrics (473ms connection time)
- Request/response details
- Recommendations for fixing the issue

---

**User:** "Why did the API call return 401?"

**Skill Response:**
1. Locates HAR file for that API call
2. Parses request headers (finds expired bearer token)
3. Explains: "Invalid bearer token" in response body
4. Suggests: Check authentication flow or token refresh logic

---

**User:** "Find slow requests in this HAR file"

**Skill Response:** Analyzes timing data and lists all requests slower than 1000ms with:
- Request URL
- Method (GET/POST)
- Duration
- Response size
- HTTP status

---

### MySQL Database Queries

**User:** "Show me the last 10 test executions"

**Skill Response:** Runs `mysql-connector.sh list 10` and displays table with:
- Test ID
- Test suite and case name
- Status (PASSED/FAILED)
- Start/end times
- Duration
- Error message (if failed)
- LogRocket/Device Farm URL

---

**User:** "Get all failed tests from yesterday"

**Skill Response:** Runs `mysql-connector.sh failed 24` and shows:
- List of failed tests
- Error messages
- When they occurred
- Links to session recordings

---

**User:** "What's the failure rate for the Rating Worksheet test?"

**Skill Response:** Runs custom SQL query:
```sql
SELECT
    COUNT(*) as total_runs,
    SUM(CASE WHEN status='FAILED' THEN 1 ELSE 0 END) as failures,
    ROUND(SUM(CASE WHEN status='FAILED' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as failure_rate
FROM test_execution
WHERE test_case_name LIKE '%Rating Worksheet%'
AND start_time >= DATE_SUB(NOW(), INTERVAL 30 DAY)
```
Then explains the results

---

### Session Recording Analysis

**User:** "Open the LogRocket session for this failed test"

**Skill Response:**
1. Parses report to extract LogRocket URL
2. Displays URL for user to open
3. Optionally: Uses `logrocket-session-analyzer` plugin to scrape session data (if installed)

---

**User:** "Get the AWS Device Farm video for test execution 1b16d78a"

**Skill Response:**
1. Searches JUnit XML for session ID
2. Extracts AWS Device Farm console URL
3. Provides direct link to logs and video

---

### Integrated Workflows

**User:** "Investigate why the Compare Rating Worksheet test failed"

**Skill Response:** Full analysis workflow:
1. **Parse Report:**
   - Test failed with "Actual: 401, Expected: 200"
   - Duration: 33.48 seconds
   - Test case: Compare Rating Worksheet To Baseline

2. **Analyze HAR Files:**
   - Found Get-Quote-Data_0.har with 401 error
   - Request: GET https://baseiso.clariondoor.com/api/quotes/689afe8cedf7e
   - Response: {"message": "Invalid bearer token"}

3. **Check Session Recording:**
   - LogRocket: https://app.logrocket.com/.../s/6-01997ca3-...
   - AWS Device Farm: https://us-west-2.console.aws.amazon.com/.../1b16d78aaf1f916146a0db6854b032db

4. **Query Historical Data:**
   - This test has failed 3 times in the last week
   - All failures show 401 errors
   - Pattern: Fails during off-hours (token expiration?)

5. **Recommendation:**
   - Authentication token is expiring mid-test
   - Check token refresh logic in test setup
   - Verify bearer token TTL matches test duration

---

**User:** "Compare this test failure to the last successful run"

**Skill Response:**
1. Gets current failure details from report
2. Queries MySQL for last PASSED execution:
   ```sql
   SELECT * FROM test_execution
   WHERE test_case_name = 'Compare Rating Worksheet To Baseline'
   AND status = 'PASSED'
   ORDER BY start_time DESC
   LIMIT 1
   ```
3. Compares:
   - Duration difference (33s vs 28s)
   - Error presence (401 vs no error)
   - Environment changes (same browser, same Katalon version)
4. Suggests: "Token expiration issue introduced recently"

---

## Tool Execution Patterns

### Pattern 1: Quick Report Analysis

When user provides a report directory path:

```python
# Run parser
python3 ${CLAUDE_PLUGIN_ROOT}/scripts/katalon-report-parser.py /path/to/report

# Output is displayed directly to user
# Skill explains findings and offers next steps
```

### Pattern 2: HAR File Deep Dive

When test failure involves network errors:

```bash
# First, locate HAR files
ls -la /path/to/report/requests/main/*.har

# For each HAR file related to failure:
python3 ${CLAUDE_PLUGIN_ROOT}/scripts/har-analyzer.py /path/to/report/requests/main/Get-Quote-Data_0.har

# Correlate HAR errors with test failure message
```

### Pattern 3: Database Historical Analysis

When investigating recurring failures:

```bash
# Get recent failures
${CLAUDE_PLUGIN_ROOT}/scripts/mysql-connector.sh failed 168  # Last week

# Get specific test details
${CLAUDE_PLUGIN_ROOT}/scripts/mysql-connector.sh get TEST-12345

# Run custom analytics query
${CLAUDE_PLUGIN_ROOT}/scripts/mysql-connector.sh query "
    SELECT DATE(start_time) as date, COUNT(*) as failures
    FROM test_execution
    WHERE test_case_name LIKE '%Rating Worksheet%'
    AND status = 'FAILED'
    GROUP BY DATE(start_time)
    ORDER BY date DESC
"
```

### Pattern 4: Full Investigation Workflow

When user says "investigate this test failure":

1. **Parse the report** to get overview
2. **Identify failed test cases** and error messages
3. **Locate relevant HAR files** based on test case name or timestamps
4. **Analyze HAR files** for HTTP errors
5. **Extract session URLs** for replay
6. **Query MySQL** for historical context
7. **Correlate findings** across all sources
8. **Generate recommendations** for fixing the issue

### Pattern 5: Performance Analysis

When user asks about slow tests:

1. **Parse report** to get test durations
2. **Find HAR files** for slow test cases
3. **Analyze HAR timings:**
   - DNS resolution time
   - TCP connection time
   - SSL handshake time
   - Time to First Byte (TTFB)
   - Content download time
4. **Identify bottlenecks:**
   - Slow DNS (>100ms)
   - Slow SSL (>200ms)
   - Slow TTFB (>1000ms)
5. **Provide optimization recommendations**

## Tool Paths and Environment

### Script Locations

All scripts are in `${CLAUDE_PLUGIN_ROOT}/scripts/`:

- `katalon-report-parser.py` - Parse Katalon reports
- `har-analyzer.py` - Analyze HAR files
- `mysql-connector.sh` - Query MySQL database

### Environment Variables

MySQL connection configured via:

- `KATALON_MYSQL_CONTAINER` - Docker container name (default: katalon-mysql)
- `KATALON_MYSQL_USER` - MySQL username (default: root)
- `KATALON_MYSQL_PASSWORD` - MySQL password (default: password)
- `KATALON_MYSQL_DB` - Database name (default: katalon_test_results)
- `KATALON_MYSQL_HOST` - MySQL host for TCP (default: 127.0.0.1)
- `KATALON_MYSQL_PORT` - MySQL port (default: 3306)

### Dependencies

**Python requirements:**
- Python 3.7+
- `haralyzer` library (install: `pip3 install haralyzer`)

**System requirements:**
- MySQL client (for database queries)
- Docker (if using Docker MySQL container)
- jq (optional, for JSON processing)

## Error Handling

### Missing Dependencies

**Error:** `haralyzer not installed`

**Response:** "I need the haralyzer Python library to analyze HAR files. Please run: `pip3 install haralyzer`"

---

**Error:** MySQL container not found

**Response:** "The MySQL container 'katalon-mysql' is not running. You can:
1. Start it: `docker start katalon-mysql`
2. Use TCP connection instead (set KATALON_MYSQL_HOST and KATALON_MYSQL_PORT)"

---

### Missing Files

**Error:** JUnit_Report.xml not found

**Response:** "No JUnit XML report found in this directory. Are you sure this is a Katalon report folder? Expected structure:
- JUnit_Report.xml
- execution.properties
- requests/main/*.har"

---

**Error:** HAR file not found

**Response:** "No HAR files found. HAR files should be in `requests/main/` subdirectory. This test may not have had network recording enabled."

---

### Invalid Data

**Error:** Malformed XML

**Response:** "The JUnit XML file appears to be corrupted or incomplete. Try:
1. Re-running the test
2. Checking Katalon Studio version compatibility
3. Verifying report generation settings"

---

## Integration with Other Plugins

### LogRocket Session Analyzer (Companion Plugin)

When session URLs are found, offer to scrape LogRocket data:

```
Found LogRocket session: https://app.logrocket.com/.../s/6-01997ca3

Would you like me to analyze this session using the LogRocket Session Analyzer?
This will scrape the session timeline, console logs, network activity, and user actions.
```

### Atlassian MCP (Confluence Integration)

Offer to export findings to Confluence:

```
I can export this test failure analysis to Confluence. Would you like me to:
1. Create a new page with test results
2. Attach the report JSON file
3. Include screenshots and HAR analysis
```

### GitLab MCP (Code Correlation)

Link test failures to code changes:

```
This test started failing on 2025-09-24. Let me check GitLab for code changes
around that time that might have introduced the authentication issue.
```

### Serena MCP (Memory/Context)

Store failure patterns for future reference:

```
I'll remember that the "Compare Rating Worksheet" test commonly fails with 401
errors due to token expiration. Next time this occurs, I'll immediately check
the authentication token TTL.
```

## Examples

### Example 1: Simple Failure Analysis

**User:** "Analyze the test report in resources/401ErrorReportDir"

**Skill:**
1. Runs `katalon-report-parser.py resources/401ErrorReportDir`
2. Shows summary: 5 tests, 1 failed (Compare Rating Worksheet)
3. Error: "Actual: 401, Expected: 200"
4. Offers: "Would you like me to analyze the HAR files to see what API call returned 401?"

**User:** "Yes"

**Skill:**
1. Finds Get-Quote-Data_0.har
2. Runs `har-analyzer.py`
3. Shows: GET /api/quotes/689afe8cedf7e returned 401 "Invalid bearer token"
4. Explains: "The authentication token was invalid or expired when fetching quote data"

---

### Example 2: Performance Investigation

**User:** "Why is the Rating Worksheet test so slow?"

**Skill:**
1. Parses report, finds test took 33.48 seconds
2. Locates HAR files
3. Analyzes timings:
   - Connect time: 473ms
   - Most time spent waiting for response (not shown in timings = 0)
4. Identifies: "The API call took 33 seconds total but only 473ms was connection. The remaining 32.5 seconds was likely backend processing time."
5. Recommendation: "Check the server-side quote generation logic for performance issues."

---

### Example 3: Flaky Test Detection

**User:** "Is the Login test flaky?"

**Skill:**
1. Queries MySQL:
   ```sql
   SELECT status, COUNT(*) as count
   FROM test_execution
   WHERE test_case_name LIKE '%Login%'
   AND start_time >= DATE_SUB(NOW(), INTERVAL 7 DAY)
   GROUP BY status
   ```
2. Results: 12 PASSED, 3 FAILED
3. Analysis: "Login test has an 80% pass rate (12/15). This suggests flakiness."
4. Queries failed executions:
   ```sql
   SELECT error_message FROM test_execution
   WHERE test_case_name LIKE '%Login%' AND status='FAILED'
   ```
5. Pattern: All 3 failures show "Element not found" errors
6. Conclusion: "Login test is flaky due to timing issues. Element appears before it's ready. Add explicit waits."

---

## Best Practices

### 1. Always Start with Report Parsing

Before diving into HAR files or database queries, parse the full report to get context:
- Which tests failed?
- What were the error messages?
- How long did tests take?
- What artifacts are available?

### 2. Correlate Multiple Data Sources

Don't rely on just one source:
- JUnit XML shows test outcomes
- HAR files show network activity
- MySQL shows historical trends
- Session recordings show user perspective

### 3. Explain Findings Clearly

When presenting analysis:
- Start with high-level summary
- Provide specific details (error codes, timings)
- Show evidence (HAR request/response, stack traces)
- End with actionable recommendations

### 4. Offer Next Steps

After analysis, always ask:
- "Would you like me to analyze the HAR files?"
- "Should I query the database for historical data?"
- "Want me to open the LogRocket session?"
- "Shall I export these findings to Confluence?"

### 5. Handle Missing Data Gracefully

If HAR files or MySQL data aren't available:
- Explain what's missing
- Show what analysis is still possible
- Suggest how to enable missing data sources

---

## Skill Maintenance

This skill stays up-to-date with:
- Latest Katalon Studio report formats
- New HAR file structures
- Evolving MySQL schemas
- Updated session recording URLs (LogRocket, AWS Device Farm, etc.)

If you encounter unsupported formats, please report to: andrew@stokedautomations.com