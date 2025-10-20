---
name: LogRocket Session Analyzer
description: |
  Scrape and analyze session replay recordings from LogRocket and AWS Device Farm using Firecrawl MCP. Activates when users mention:
  - LogRocket session analysis or session replay debugging
  - AWS Device Farm test artifacts or session recordings
  - Extracting console logs from session replays
  - Analyzing network activity from recorded sessions
  - User action tracking or session replay analysis
  - Debugging test failures using session recordings
  - Extracting performance metrics from session replays
---

## How It Works

This plugin enables **automated scraping and analysis** of session replay platforms (LogRocket, AWS Device Farm) using **Firecrawl MCP** for web content extraction.

**Core Capabilities:**
1. **Session Replay Scraping** - Extracts data from LogRocket and AWS Device Farm recordings
2. **Console Log Extraction** - Captures JavaScript errors, warnings, and logs from sessions
3. **Network Activity Analysis** - Analyzes HTTP requests/responses during user sessions
4. **User Action Tracking** - Reconstructs user interactions (clicks, inputs, navigation)
5. **Performance Metrics** - Extracts timing data, resource loading, page performance
6. **Test Artifact Analysis** - Processes test failure recordings for debugging

**Based on:** Firecrawl MCP server for web scraping session replay interfaces

## When to Use This Skill

Activate when users mention:

- **LogRocket Analysis:**
  - "Analyze LogRocket session"
  - "Extract console errors from LogRocket"
  - "Debug LogRocket session replay"
  - "Get network requests from LogRocket recording"
  - "User actions in LogRocket session"

- **AWS Device Farm:**
  - "Analyze Device Farm test session"
  - "Extract Device Farm test artifacts"
  - "Debug Device Farm test failure"
  - "Device Farm session replay analysis"

- **Session Replay Debugging:**
  - "Debug session replay"
  - "Extract session recording data"
  - "Analyze user session"
  - "Session replay scraping"

- **Test Debugging:**
  - "Why did this test fail?"
  - "Console errors in test session"
  - "Network issues during test"
  - "User actions before failure"

## Examples

**User:** "Analyze this LogRocket session and show me why the checkout failed"

**Skill activates** → Uses Firecrawl MCP to scrape LogRocket session:
```bash
# 1. Scrape LogRocket session page
/mcp firecrawl scrape_url url="https://app.logrocket.com/sessions/[session-id]"

# 2. Extract console logs
# Filters for errors and warnings during checkout flow

# 3. Analyze network requests
# Identifies failed API calls (4xx/5xx status codes)

# 4. Reconstruct user actions
# Timeline: User clicked "Checkout" → Payment API failed (500 error)
```

**Output:**
```
🔍 LOGROCKET SESSION ANALYSIS: session-abc123

=== CONSOLE ERRORS (3 found) ===
1. [ERROR] Uncaught TypeError: Cannot read property 'token' of undefined
   File: checkout.js:142
   Timestamp: 2025-10-18 14:32:15

2. [ERROR] Payment API call failed: 500 Internal Server Error
   File: payment-service.js:89
   Timestamp: 2025-10-18 14:32:16

3. [WARNING] Stripe.js not loaded
   File: checkout.js:56
   Timestamp: 2025-10-18 14:32:10

=== NETWORK FAILURES ===
❌ POST /api/payment/process → 500 (Internal Server Error)
   Request: {"amount": 49.99, "currency": "USD"}
   Response: {"error": "Payment gateway timeout"}
   Duration: 30s (timeout)

=== USER ACTIONS BEFORE FAILURE ===
1. 14:31:45 - Clicked "Add to Cart"
2. 14:31:52 - Navigated to /checkout
3. 14:32:05 - Filled credit card form
4. 14:32:15 - Clicked "Pay $49.99"
5. 14:32:16 - Payment failed (500 error)
6. 14:32:18 - User refreshed page

=== ROOT CAUSE ===
Payment API timed out (30s) causing 500 error.
Stripe.js warning suggests payment gateway initialization failed.

🔧 RECOMMENDATION:
- Check payment gateway uptime status
- Verify Stripe.js is loaded before checkout
- Add retry logic for payment API calls
- Increase API timeout from 30s to 60s
```

---

**User:** "Extract console errors from this AWS Device Farm test session"

**Skill activates** → Scrapes Device Farm test artifacts:
```bash
# 1. Scrape Device Farm session page
/mcp firecrawl scrape_url url="https://console.aws.amazon.com/devicefarm/sessions/[session-id]"

# 2. Extract logs from test artifacts
# Parses test output, console logs, crash reports

# 3. Categorize errors
# JavaScript errors, native crashes, network failures
```

**Output:**
```
📱 AWS DEVICE FARM SESSION ANALYSIS: test-xyz789

Device: iPhone 14 Pro (iOS 17.2)
Test: Login Flow E2E Test
Status: FAILED

=== CONSOLE LOGS ===
[INFO] Test started: login_test.spec.js
[INFO] Navigating to /login
[ERROR] Network request failed: Connection timeout
[ERROR] Element not found: #login-button
[FAIL] Test failed: Login button not clickable

=== NETWORK FAILURES ===
❌ GET /api/auth/session → Timeout (60s)
❌ POST /api/login → Not attempted (blocked by timeout)

=== DEVICE-SPECIFIC ISSUES ===
⚠️ iOS 17.2 has known issue with WKWebView timeouts
⚠️ Cellular network simulation (3G) may be too slow

🔧 RECOMMENDATION:
- Increase network timeout for mobile tests
- Add retry logic for auth session requests
- Test with WiFi simulation instead of 3G
- Verify backend API responds within 30s on 3G
```

---

**User:** "What network requests happened during this session replay?"

**Skill activates** → Extracts network activity:
```bash
# Scrape session replay and extract network timeline
/mcp firecrawl scrape_url url="https://app.logrocket.com/sessions/[session-id]/network"
```

**Output:**
```
🌐 NETWORK ACTIVITY TIMELINE

=== REQUESTS (23 total) ===

1. 14:31:42 GET /api/user/profile → 200 (150ms)
2. 14:31:43 GET /api/products → 200 (320ms)
3. 14:31:45 GET /api/cart → 200 (89ms)
4. 14:32:05 POST /api/cart/add → 200 (245ms)
5. 14:32:10 GET /api/stripe/config → 500 (5s) ❌ FAILED
6. 14:32:15 POST /api/payment/process → 500 (30s) ❌ TIMEOUT

=== SLOWEST REQUESTS ===
1. POST /api/payment/process → 30s (timeout)
2. GET /api/stripe/config → 5s (500 error)
3. GET /api/products → 320ms

=== FAILED REQUESTS ===
❌ GET /api/stripe/config → 500 Internal Server Error
❌ POST /api/payment/process → 500 Gateway Timeout

🔧 ISSUE DETECTED:
Stripe configuration endpoint failing before payment.
This blocks payment processing flow.
```

---

**User:** "Show me the user's journey before the error occurred"

**Skill activates** → Reconstructs user action timeline:
```
👤 USER ACTION TIMELINE

14:31:40 - Landed on homepage (/)
14:31:42 - Scrolled to product section
14:31:45 - Clicked "Add to Cart" (Product: Premium Plan)
14:31:52 - Clicked "Checkout"
14:31:55 - Navigated to /checkout
14:32:00 - Filled email: [email protected]
14:32:05 - Filled credit card form
14:32:10 - Clicked "Apply Coupon" (SAVE20)
14:32:12 - Coupon applied (20% discount)
14:32:15 - Clicked "Pay $39.99"
14:32:16 - Payment API failed (500 error) ❌
14:32:18 - User refreshed page (F5)
14:32:20 - Abandoned checkout

=== INSIGHTS ===
- User spent 40 seconds on checkout flow
- Discount applied successfully
- Payment failed immediately after clicking "Pay"
- User gave up after single refresh attempt

💡 HIGH-VALUE USER:
- Applied coupon (engaged shopper)
- Premium plan (high-value product)
- Quick abandonment suggests urgency

🔧 RECOVERY ACTION:
- Send abandoned cart email within 1 hour
- Offer 24-hour extension on coupon code
- Provide alternative payment methods
```

## Installation

### Prerequisites

**Required: Firecrawl MCP Server**
```bash
# Option 1: NPM installation
npm install -g @firecrawl/mcp-server

# Option 2: Install from marketplace
/plugin install firecrawl-mcp@stoked-automations

# Configure in Claude Code MCP settings
claude mcp add firecrawl npx @firecrawl/mcp-server@latest
```

**Optional: JSON Processing**
```bash
# For advanced JSON parsing
brew install jq
```

### Plugin Installation
```bash
/plugin install logrocket-session-analyzer@stoked-automations
```

### Authentication

**LogRocket Sessions:**
- Requires authentication (SSO in many cases)
- May need manual cookie extraction
- Use browser extension or export cookies from authenticated session

**AWS Device Farm:**
- Requires AWS credentials
- Use IAM role with DeviceFarm read permissions
- Session URLs must be accessible

## Available Commands

The plugin leverages **Firecrawl MCP tools** for scraping:

| Tool (via Firecrawl) | Purpose |
|----------------------|---------|
| `scrape_url` | Scrape session replay page HTML/content |
| `extract_structured_data` | Extract structured logs, network data |
| `scrape_with_javascript` | Handle dynamic content loading |

## Key Features

**Console Log Extraction:**
- JavaScript errors with stack traces
- Console warnings and info messages
- Categorized by severity (error, warning, info)
- Timestamped relative to user actions

**Network Activity Analysis:**
- Complete request/response timeline
- Failed requests identification (4xx/5xx)
- Slow request detection (>1s)
- Request/response body inspection

**User Action Reconstruction:**
- Click events with target elements
- Form inputs and submissions
- Page navigation and scrolling
- Mouse movements and hovers

**Performance Metrics:**
- Page load times
- Resource loading duration
- API response times
- Client-side rendering performance

## Supported Platforms

### LogRocket
- **Session replays** - Full user session recordings
- **Console logs** - JavaScript errors and warnings
- **Network activity** - HTTP request/response logs
- **User actions** - Click, input, navigation events
- **Performance** - Resource timing, page load metrics

### AWS Device Farm
- **Test sessions** - Mobile app and browser test recordings
- **Device logs** - iOS/Android system logs
- **Console output** - JavaScript console logs from WebViews
- **Network logs** - HTTP traffic during tests
- **Crash reports** - Native app crashes and exceptions

## Authentication Considerations

**LogRocket:**
- Most organizations use SSO (Google, Okta, etc.)
- Direct scraping requires authenticated session cookies
- Alternative: Use LogRocket API (if available) instead of scraping
- Plugin provides scripts for cookie extraction from browser

**AWS Device Farm:**
- Requires AWS credentials (Access Key ID, Secret Access Key)
- Session URLs must be accessible via IAM permissions
- Recommended: Use IAM role with `devicefarm:GetRun` permission

## Best Practices

**ALWAYS:**
- Verify authentication before scraping sessions
- Extract cookies from authenticated browser session
- Respect rate limits (avoid rapid scraping)
- Use structured data extraction (Firecrawl's structured mode)
- Timestamp all extracted data for correlation

**NEVER:**
- Scrape without authentication (will fail)
- Expose authentication cookies in logs
- Scrape production sessions without permission
- Store sensitive user data from sessions
- Use for unauthorized access to session data

## Common Use Cases

### 1. Test Failure Debugging
Analyze failed E2E tests by extracting:
- Console errors at failure point
- Network requests before failure
- User actions leading to failure
- Performance bottlenecks

### 2. User Issue Reproduction
Help support teams by:
- Reconstructing user's exact journey
- Identifying JavaScript errors user encountered
- Showing failed API calls
- Extracting browser/device information

### 3. Performance Analysis
Identify performance issues:
- Slow API calls (>1s)
- Large resource downloads
- Client-side rendering delays
- Memory leaks or excessive re-renders

### 4. Quality Assurance
Validate fixes by comparing sessions:
- Before/after console error counts
- Network failure rates
- User drop-off points
- Performance improvements

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Authentication failed | Extract cookies from authenticated browser session |
| Session page not loading | Verify Firecrawl MCP is running and configured |
| Incomplete data extraction | Use `scrape_with_javascript` for dynamic content |
| Rate limiting | Add delays between scraping requests |
| Missing network logs | Ensure LogRocket captures network activity |

## Resources

### Session Replay Platforms
- **LogRocket:** https://logrocket.com/
- **AWS Device Farm:** https://aws.amazon.com/device-farm/

### Tools
- **Firecrawl MCP:** https://firecrawl.dev/
- **jq (JSON processor):** https://jqlang.github.io/jq/

### Documentation
- **LogRocket API:** https://docs.logrocket.com/reference/
- **AWS Device Farm API:** https://docs.aws.amazon.com/devicefarm/

## Version & License

- **Version:** 2025.0.0
- **License:** MIT
- **Author:** Stoked Automations (andrew@stokedautomation.com)
- **Repository:** https://github.com/AndroidNextdoor/stoked-automations
- **Dependencies:** Firecrawl MCP server (required)
