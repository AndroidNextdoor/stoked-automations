---
name: scrape-session
description: Scrape LogRocket or AWS Device Farm session recordings using Firecrawl MCP
model: sonnet
---

# Scrape Session Recording

Scrape LogRocket and AWS Device Farm session recordings to extract detailed test execution data including console logs, network requests, user events, errors, and performance metrics.

## Prerequisites

**Required:** Firecrawl MCP Server must be installed and configured.

Check if available by looking for these MCP tools:
- `mcp__firecrawl__scrape_url`
- `mcp__firecrawl__crawl_website`
- `mcp__firecrawl__map_website`

If not available, install:
```bash
npm install -g @firecrawl/mcp-server
```

Or use the `firecrawl-mcp` plugin from this marketplace.

## Authentication Requirements

### LogRocket Sessions
LogRocket requires SSO authentication. You need to:

**Option 1: Browser Cookies**
1. Log into LogRocket in your browser
2. Export cookies using browser extension:
   - Chrome: "EditThisCookie"
   - Firefox: "Cookie Quick Manager"
   - Safari: "Cookie"
3. Save to `~/.katalon-session-cookies.txt`

**Option 2: Session Token**
1. Log into LogRocket
2. Open DevTools → Network tab
3. Find API request, copy Authorization header
4. Set: `export LOGROCKET_SESSION_TOKEN="Bearer ..."`

**Option 3: Manual Screenshots**
1. Open session in browser
2. Take screenshots of key data
3. I'll analyze screenshots to extract information

### AWS Device Farm Sessions
Requires AWS credentials:

**Option 1: AWS CLI Configured** (Automatic)
```bash
aws configure
```

**Option 2: Temporary Credentials**
```bash
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..."
```

**Option 3: SSO**
```bash
aws sso login --profile your-profile
export AWS_PROFILE=your-profile
```

## Usage

### Basic Scraping

```
/scrape-session <session-url>
```

**Example:**
```
/scrape-session https://app.logrocket.com/dtizdl/portal/s/6-01997ca3-2cad-7110-a6a6-9dbb41b835c7/0
```

### With Output File

```
/scrape-session <session-url> --output session_data.json
```

### From Katalon Report

Extract session URL from report and scrape:
```
/scrape-session --from-report path/to/katalon/report
```

This will:
1. Parse the Katalon report
2. Extract LogRocket/Device Farm URLs
3. Scrape each session
4. Save combined data

## What Gets Scraped

### LogRocket Sessions

**Console Logs:**
```json
{
  "console_logs": [
    {
      "timestamp": "2025-09-24T16:52:13.278Z",
      "level": "error",
      "message": "Failed to fetch: 401 Unauthorized",
      "source": "main.js:123"
    }
  ]
}
```

**Network Requests:**
```json
{
  "network_requests": [
    {
      "timestamp": "2025-09-24T16:52:13.278Z",
      "method": "GET",
      "url": "https://api.example.com/quotes/123",
      "status": 401,
      "duration_ms": 473,
      "request_headers": {
        "Authorization": "Bearer eyJra..."
      },
      "response_body": "{\"message\": \"Invalid bearer token\"}"
    }
  ]
}
```

**User Events:**
```json
{
  "user_events": [
    {
      "timestamp": "2025-09-24T16:52:10.100Z",
      "type": "click",
      "element": "button.submit-rating",
      "element_text": "Generate Worksheet"
    },
    {
      "timestamp": "2025-09-24T16:52:13.278Z",
      "type": "navigation",
      "from_url": "/quotes/123",
      "to_url": "/rating-worksheet"
    }
  ]
}
```

**JavaScript Errors:**
```json
{
  "errors": [
    {
      "timestamp": "2025-09-24T16:52:13.500Z",
      "message": "Cannot read property 'premium' of null",
      "stack_trace": "at calculateTotal (main.js:456)\nat generateWorksheet (app.js:123)",
      "file": "main.js",
      "line": 456,
      "column": 12
    }
  ]
}
```

**Performance Metrics:**
```json
{
  "performance": {
    "page_load_time_ms": 2340,
    "dom_content_loaded_ms": 1200,
    "first_paint_ms": 850,
    "largest_contentful_paint_ms": 1800,
    "time_to_interactive_ms": 2100,
    "cumulative_layout_shift": 0.05
  }
}
```

**Session Metadata:**
```json
{
  "session_metadata": {
    "session_id": "6-01997ca3-2cad-7110-a6a6-9dbb41b835c7",
    "browser": "Chrome 140.0.7339.80",
    "os": "Windows 10",
    "screen_resolution": "1920x1080",
    "duration_seconds": 127,
    "page_url": "https://app.example.com/rating-worksheet",
    "user_agent": "Mozilla/5.0..."
  }
}
```

### AWS Device Farm Sessions

**Test Details:**
```json
{
  "test_details": {
    "status": "FAILED",
    "duration_seconds": 127,
    "device": "Windows Desktop",
    "os_version": "Windows 10",
    "browser": "Chrome 140.0.7339.80",
    "session_id": "1b16d78aaf1f916146a0db6854b032db"
  }
}
```

**Application Logs:**
```json
{
  "application_logs": [
    {
      "timestamp": "2025-09-24T16:52:13.278Z",
      "level": "ERROR",
      "message": "Authentication failed: Invalid bearer token",
      "source": "authentication.service"
    }
  ]
}
```

**Device Logs:**
```json
{
  "device_logs": [
    {
      "timestamp": "2025-09-24T16:52:13.278Z",
      "message": "HTTP/1.1 401 Unauthorized"
    }
  ]
}
```

**Video Recording:**
```json
{
  "artifacts": {
    "video_url": "https://s3.amazonaws.com/.../video_testgrid_2025-09-24_16-51-22_000.mp4",
    "screenshots": [
      {
        "timestamp": "2025-09-24T16:52:10.100Z",
        "url": "https://s3.amazonaws.com/.../screenshot_001.png",
        "description": "Before API call"
      },
      {
        "timestamp": "2025-09-24T16:52:13.500Z",
        "url": "https://s3.amazonaws.com/.../screenshot_002.png",
        "description": "After 401 error"
      }
    ]
  }
}
```

**Performance Data:**
```json
{
  "performance": {
    "cpu_usage": [
      {"timestamp": "2025-09-24T16:52:13.278Z", "value": 45.2}
    ],
    "memory_usage": [
      {"timestamp": "2025-09-24T16:52:13.278Z", "value": 512.8}
    ],
    "network_usage": [
      {"timestamp": "2025-09-24T16:52:13.278Z", "sent_kb": 12.4, "received_kb": 8.2}
    ]
  }
}
```

## Workflow with Firecrawl MCP

### Step 1: Prepare Scrape Specification

Create a scrape spec for Firecrawl:

```json
{
  "url": "https://app.logrocket.com/session/123",
  "waitFor": "[data-test-id='timeline-loaded']",
  "timeout": 30000,
  "elements": {
    "consoleLogs": {
      "selector": "[data-test-id='console-log-item']",
      "attributes": ["data-timestamp", "data-level", "data-message"]
    },
    "networkRequests": {
      "selector": "[data-test-id='network-request']",
      "attributes": ["data-url", "data-method", "data-status"]
    },
    "userEvents": {
      "selector": "[data-test-id='user-event']",
      "attributes": ["data-timestamp", "data-type"]
    }
  }
}
```

### Step 2: Execute Firecrawl MCP Scrape

Use the `mcp__firecrawl__scrape_url` tool:

```javascript
{
  "url": "https://app.logrocket.com/session/123",
  "formats": ["html", "markdown", "screenshot"],
  "onlyMainContent": false,
  "includeTags": ["div", "span", "button", "a"],
  "waitFor": 5000
}
```

### Step 3: Parse Scraped Content

Extract structured data from Firecrawl response:

1. Parse HTML to find session data elements
2. Extract timestamps, messages, URLs
3. Correlate events chronologically
4. Build timeline of user actions + system responses

### Step 4: Enrich with Context

Combine scraped session data with Katalon report data:

- Link network errors from LogRocket to HAR files
- Match timestamps between session recording and test logs
- Correlate user actions with test steps
- Identify exact moment test failed

## Example: Complete Workflow

**Scenario:** Test failed with 401 error, need to understand why

**Step 1: Parse Katalon Report**
```bash
python3 scripts/katalon-report-parser.py resources/401ErrorReportDir --json report.json
```

**Extracts:**
- Test failed: "Compare Rating Worksheet"
- Error: "Actual: 401, Expected: 200"
- LogRocket URL: https://app.logrocket.com/.../s/6-01997ca3...

**Step 2: Scrape LogRocket Session**
```bash
/scrape-session https://app.logrocket.com/.../s/6-01997ca3... --output logrocket_data.json
```

**Scrapes:**
- Console logs showing auth error
- Network request with expired token
- User clicked "Generate Worksheet" button
- API returned 401 after 473ms

**Step 3: Analyze Combined Data**

**From Katalon Report:**
- Test duration: 33.48 seconds
- Failed at: "Download Document" step
- HAR file shows: GET /api/quotes/689afe8cedf7e returned 401

**From LogRocket Session:**
- User action: Clicked "Generate Worksheet" at 16:52:10
- Network request: GET /api/quotes at 16:52:13 (3 seconds later)
- Console error: "Failed to fetch: 401 Unauthorized" at 16:52:13
- Token in request: "Bearer eyJraWQi..." (check expiration)

**Step 4: Root Cause Analysis**

```
Timeline:
16:52:10 - User clicks "Generate Worksheet"
16:52:13 - API request sent with bearer token
16:52:13 - Server returns 401 "Invalid bearer token"
16:52:13 - Console logs error
16:52:13 - Test assertion fails (expected 200, got 401)

Root Cause:
The bearer token expired between test start (16:51:24) and API call (16:52:13).
Token lifetime: 49 seconds
Test duration before call: 49 seconds
Result: Token expired exactly when needed

Fix:
Increase token TTL to at least 60 seconds (test max duration + buffer)
```

## Integration with Other Commands

### With Test Analysis

```bash
# Analyze test failure
/analyze-test resources/401ErrorReportDir

# Scrape session for more context
/scrape-session --from-report resources/401ErrorReportDir

# Create JIRA ticket with all data
/create-jira-ticket resources/401ErrorReportDir --include-session-data
```

### With HAR Analysis

```bash
# Compare HAR data with LogRocket network requests
python3 scripts/har-analyzer.py resources/401ErrorReportDir/requests/main/Get-Quote-Data_0.har --json har_data.json

# Scrape LogRocket to get client-side perspective
/scrape-session <logrocket-url> --output logrocket_data.json

# Compare: HAR shows server response, LogRocket shows what user experienced
```

## Output Format

Scraped data is saved as structured JSON:

```json
{
  "session_type": "logrocket",
  "session_url": "https://app.logrocket.com/.../s/6-01997ca3...",
  "session_id": "6-01997ca3-2cad-7110-a6a6-9dbb41b835c7",
  "scraped_at": "2025-10-18T15:30:00Z",

  "session_metadata": {
    "browser": "Chrome 140.0.7339.80",
    "os": "Windows 10",
    "duration_seconds": 127,
    "page_url": "https://baseiso.clariondoor.com/rating-worksheet"
  },

  "timeline": {
    "console_logs": [...],
    "network_requests": [...],
    "user_events": [...],
    "errors": [...]
  },

  "performance": {
    "page_load_time_ms": 2340,
    "dom_content_loaded_ms": 1200,
    "first_paint_ms": 850
  },

  "network_summary": {
    "total_requests": 15,
    "failed_requests": 1,
    "average_response_time_ms": 250,
    "slowest_requests": [
      {
        "url": "https://api.example.com/quotes/123",
        "duration_ms": 473,
        "status": 401
      }
    ]
  },

  "errors_summary": {
    "total_errors": 2,
    "javascript_errors": 0,
    "network_errors": 1,
    "console_errors": 1
  },

  "key_findings": [
    "401 Unauthorized error on GET /api/quotes",
    "Bearer token rejected as invalid",
    "Token likely expired during test execution",
    "User experienced immediate error after clicking button"
  ]
}
```

## Troubleshooting

### Authentication Failed

**Error:** Cannot access LogRocket session (401/403)

**Solutions:**
1. Check cookies are valid and not expired
2. Verify session token is correct
3. Ensure you're logged into the correct organization
4. Try manual screenshot approach if automated scraping fails

### Firecrawl MCP Not Available

**Error:** MCP tool not found

**Solutions:**
1. Install Firecrawl MCP: `npm install -g @firecrawl/mcp-server`
2. Configure in Claude Code MCP settings
3. Restart Claude Code
4. Check with: Look for `mcp__firecrawl__*` tools

### Session Elements Not Found

**Error:** Selectors don't match page structure

**Reason:** LogRocket/Device Farm UI changed

**Solution:**
1. Inspect page with DevTools
2. Find new selectors for session data
3. Update scrape spec in `scripts/scrape-session.sh`
4. Report issue so plugin can be updated

### Rate Limiting

**Error:** Too many requests to LogRocket API

**Solution:**
1. Add delays between scrapes
2. Use caching for repeated sessions
3. Scrape only when needed (not every test run)

## Best Practices

1. **Cache Session Data:**
   - Don't re-scrape the same session multiple times
   - Store scraped data with session ID as key
   - Check cache before scraping

2. **Scrape Selectively:**
   - Only scrape sessions for failed tests
   - Or tests with interesting failures
   - Don't scrape every test run (expensive)

3. **Combine Data Sources:**
   - Use HAR files for network-level detail
   - Use LogRocket for user experience perspective
   - Use Katalon logs for test framework details
   - Use Device Farm for infrastructure metrics

4. **Protect Credentials:**
   - Never commit cookies/tokens to git
   - Use environment variables
   - Rotate tokens regularly
   - Use short-lived session tokens when possible

5. **Correlate Timestamps:**
   - All systems use UTC
   - Be careful with timezone conversions
   - Use millisecond precision for event correlation
   - Account for clock skew between systems

## Advanced Use Cases

### Automated Failure Investigation

Create a script that:
1. Detects test failure in CI/CD
2. Parses Katalon report to extract session URL
3. Scrapes LogRocket/Device Farm session
4. Analyzes combined data
5. Creates JIRA ticket with findings
6. Notifies team via Slack

### Flaky Test Detection

Scrape sessions from multiple test runs:
1. Collect session data for same test across 10+ runs
2. Compare timelines to find differences
3. Identify which step timing varies
4. Determine if race condition or external dependency
5. Recommend fix based on pattern

### Performance Regression Tracking

Track performance over time:
1. Scrape LogRocket sessions for each deployment
2. Extract performance metrics (load time, TTFB, etc.)
3. Compare against baseline
4. Alert if degradation detected
5. Link to commit that caused regression

---

## Notes

- LogRocket scraping requires valid authentication
- AWS Device Farm requires AWS credentials
- Scraping is subject to rate limits
- Session data is large (can be 10+ MB per session)
- Store scraped data efficiently (compress, deduplicate)
- Consider privacy when scraping user session data

---

**Remember:** Session recordings contain sensitive data (user actions, API responses, potentially PII). Handle with appropriate security measures and comply with privacy policies.