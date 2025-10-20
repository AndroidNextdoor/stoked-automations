---
name: Chrome DevTools MCP
description: |
  Official Google Chrome DevTools Protocol MCP server for browser automation and performance analysis. Activates when users mention:
  - Chrome DevTools, CDP (Chrome DevTools Protocol), or Puppeteer
  - Performance analysis, Lighthouse audits, or Core Web Vitals
  - Network inspection, HAR files, or request/response analysis
  - Browser console logs, errors, or debugging
  - Screenshot capture or DOM inspection
  - Chrome-specific browser automation or testing
---

## How It Works

This plugin provides access to the official **Google Chrome DevTools Protocol MCP server**, enabling programmatic control of Chrome browsers with full DevTools capabilities.

**Core Capabilities:**
1. **Performance Analysis** - Lighthouse audits, Core Web Vitals, performance traces
2. **Network Monitoring** - HAR file generation, request/response inspection, timing breakdowns
3. **Console Access** - Capture errors, logs, warnings from browser console
4. **Screenshots** - Full page or viewport captures with high quality
5. **DOM Inspection** - Query elements, get computed styles, analyze structure
6. **JavaScript Execution** - Run scripts in browser context for testing or automation
7. **Cookie Management** - Get/set cookies programmatically

**Based on:** Google's official ChromeDevTools/chrome-devtools-mcp server using Puppeteer

## When to Use This Skill

Activate when users mention:

- **Performance & Optimization:**
  - "Run Lighthouse audit"
  - "Check Core Web Vitals"
  - "Analyze page performance"
  - "Generate performance trace"
  - "Identify performance bottlenecks"

- **Network Analysis:**
  - "Inspect network requests"
  - "Generate HAR file"
  - "Check API response times"
  - "Monitor network activity"
  - "Analyze request/response headers"

- **Browser Debugging:**
  - "Check console errors"
  - "Capture console logs"
  - "Debug JavaScript issues"
  - "Inspect Chrome DevTools"
  - "Use Chrome DevTools Protocol"

- **Screenshots & Inspection:**
  - "Take screenshot with Chrome"
  - "Capture full page"
  - "Inspect DOM elements"
  - "Get computed styles"

- **Chrome Automation:**
  - "Automate Chrome browser"
  - "Use Puppeteer via MCP"
  - "Control Chrome programmatically"

## Examples

**User:** "Run a Lighthouse audit on https://stokedautomations.com"

**Skill activates** → Uses Chrome DevTools MCP to launch Chrome, navigate to URL, capture performance trace, and generate Lighthouse audit report with Core Web Vitals (LCP, FID, CLS), accessibility score, best practices, and SEO metrics.

---

**User:** "Check for console errors on my production site"

**Skill activates** → Launches Chrome with console monitoring enabled, navigates to site, captures all console messages (errors, warnings, logs), and provides categorized report with error frequencies and source locations.

---

**User:** "Analyze the network requests for this page and show me the slowest API calls"

**Skill activates** → Enables network recording, navigates to page, captures all requests, generates HAR file, analyzes timing breakdowns (DNS, TCP, TLS, waiting, download), and identifies bottlenecks ranked by duration.

---

**User:** "Take a full-page screenshot of the website"

**Skill activates** → Launches Chrome headless, navigates to URL with proper wait conditions, captures full-page screenshot with high quality settings, and saves to specified path.

---

**User:** "What's the DOM structure of the navigation menu?"

**Skill activates** → Navigates to page, queries DOM for navigation elements, extracts structure with selectors and computed styles, and provides detailed breakdown of menu hierarchy.

## Installation

### NPX (Direct Execution)
```bash
npx chrome-devtools-mcp@latest
```

### Claude Code MCP Configuration
```bash
claude mcp add chrome-devtools npx chrome-devtools-mcp@latest
```

### Claude Desktop Config
```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["chrome-devtools-mcp@latest"]
    }
  }
}
```

### Plugin Installation
```bash
/plugin install chrome-devtools-mcp@stoked-automations
```

## Available MCP Tools

The Chrome DevTools MCP server provides these tools through the MCP protocol:

| Tool | Purpose |
|------|---------|
| `launch` | Launch Chrome browser instance |
| `navigate` | Navigate to URL with wait conditions |
| `performance_trace` | Capture performance metrics and traces |
| `lighthouse_audit` | Run full Lighthouse audit |
| `get_network_requests` | Retrieve captured network activity (HAR format) |
| `get_console_logs` | Get browser console messages |
| `screenshot` | Capture full page or viewport screenshot |
| `execute_script` | Run JavaScript in browser context |
| `query_dom` | Query DOM elements with selectors |
| `get_cookies` | Retrieve browser cookies |
| `set_cookies` | Set browser cookies |

## Common Workflows

### Performance Audit Workflow
```bash
1. /mcp chrome-devtools launch
2. /mcp chrome-devtools navigate url="https://example.com"
3. /mcp chrome-devtools performance_trace
4. /mcp chrome-devtools lighthouse_audit
5. /mcp chrome-devtools get_network_requests
```

### Debugging Workflow
```bash
1. /mcp chrome-devtools launch headless=false
2. /mcp chrome-devtools navigate url="https://example.com"
3. /mcp chrome-devtools get_console_logs
4. /mcp chrome-devtools screenshot path="./debug.png"
```

### Network Analysis Workflow
```bash
1. /mcp chrome-devtools launch
2. /mcp chrome-devtools navigate url="https://api.example.com"
3. /mcp chrome-devtools get_network_requests
# Analyze HAR file for timing breakdowns
```

## Key Features

**Performance Analysis:**
- Core Web Vitals (LCP, FID, CLS, TTFB, INP)
- Lighthouse scores (performance, accessibility, best practices, SEO)
- Performance traces with flame graphs
- Paint timing and resource loading analysis

**Network Monitoring:**
- HAR (HTTP Archive) file generation
- Request/response header inspection
- Timing breakdown (DNS, TCP, TLS, waiting, content download)
- Request filtering by type (XHR, fetch, document, script, style)

**Console Debugging:**
- Error capturing with stack traces
- Warning and info message logging
- Custom console.log() statements
- Exception tracking

**Browser Control:**
- Headless or headed mode
- Custom viewport sizes
- Device emulation
- Cookie and local storage manipulation

## Comparison with Other Testing Tools

### Chrome DevTools MCP vs Playwright MCP

| Feature | Chrome DevTools MCP | Playwright MCP |
|---------|-------------------|----------------|
| Primary Focus | Performance & DevTools | E2E testing & automation |
| Lighthouse Integration | ✅ Native | ❌ No |
| Network HAR Export | ✅ Yes | ✅ Yes |
| Multi-browser | ❌ Chrome only | ✅ Chrome, Firefox, WebKit |
| Performance Traces | ✅ Advanced | ⚠️ Basic |
| Maintained By | Google Chrome Team | Microsoft |

### When to Use Chrome DevTools MCP
- **Performance audits** - Lighthouse integration and Core Web Vitals
- **Chrome-specific testing** - CDP features and Chrome DevTools
- **Network analysis** - Deep HAR inspection and timing breakdowns
- **Google tooling** - Integration with Chrome ecosystem

### When to Use Playwright Instead
- **Multi-browser testing** - Need Firefox or WebKit support
- **E2E test suites** - Comprehensive test automation
- **Accessibility snapshots** - Structured a11y tree analysis
- **Fast automation** - Deterministic, no screenshot-based approach

## Best Practices

**ALWAYS:**
- Use headless mode for performance (no GUI rendering overhead)
- Wait for `networkidle` or `domcontentloaded` before capturing metrics
- Enable network recording BEFORE navigation
- Close browser instances when done to free resources
- Capture console logs early (errors may occur during page load)

**NEVER:**
- Run Lighthouse audits on throttled connections without documenting it
- Compare performance metrics across different network conditions
- Ignore console errors (they often indicate real issues)
- Skip waiting for page load before taking screenshots

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Browser won't launch | Install Chrome: `npx @puppeteer/browsers install chrome@latest` |
| Timeout errors | Increase timeout: `navigate({ timeout: 60000 })` |
| Incomplete HAR data | Enable network recording before navigation |
| Console logs missing | Enable console monitoring at browser launch |
| Screenshot is blank | Wait for proper load state before capturing |

## Resources

- **GitHub Repository:** https://github.com/ChromeDevTools/chrome-devtools-mcp
- **Blog Post:** https://developer.chrome.com/blog/chrome-devtools-mcp
- **CDP Protocol Docs:** https://chromedevtools.github.io/devtools-protocol/
- **Puppeteer Docs:** https://pptr.dev/
- **Lighthouse Docs:** https://developer.chrome.com/docs/lighthouse/

## Version & License

- **Version:** 2025.0.0
- **License:** Apache-2.0
- **Maintained By:** Google Chrome Team
- **Repository:** https://github.com/AndroidNextdoor/stoked-automations (plugin wrapper)