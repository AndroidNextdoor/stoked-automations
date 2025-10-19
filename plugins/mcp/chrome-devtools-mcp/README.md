# Chrome DevTools MCP Server

![Version](https://img.shields.io/badge/version-2025.0.0-blue)
![License](https://img.shields.io/badge/license-Apache--2.0-green)
![Category](https://img.shields.io/badge/category-testing-teal)

**Official Google Chrome DevTools Protocol MCP server** - Control and inspect live Chrome browsers with performance insights, network analysis, and console access.

---

## Overview

Wrapper plugin for [ChromeDevTools/chrome-devtools-mcp](https://github.com/ChromeDevTools/chrome-devtools-mcp) - Google's official CDP MCP server.

### Why Chrome DevTools MCP?

- **📊 Performance Insights** - DevTools traces, network analysis
- **🐛 Debugging** - Console access, breakpoints, profiling
- **🌐 Network Monitoring** - Request/response inspection
- **📸 Screenshots** - High-quality browser screenshots
- **🎯 Official** - Maintained by Google Chrome team
- **🤖 Puppeteer-based** - Reliable automation foundation

---

## Installation

```bash
# NPX installation
npx chrome-devtools-mcp@latest

# Claude Code CLI
claude mcp add chrome-devtools npx chrome-devtools-mcp@latest

# Claude Desktop config
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["chrome-devtools-mcp@latest"]
    }
  }
}

# Claude Code
/plugin install chrome-devtools-mcp@stoked-automations
```

---

## Features

- **Performance Analysis** - Lighthouse audits, Core Web Vitals
- **Network Inspection** - HAR files, timing breakdowns
- **Console Access** - Capture errors, logs, warnings
- **Screenshots** - Full page or viewport captures
- **DOM Inspection** - Query elements, get computed styles
- **JavaScript Execution** - Run scripts in browser context
- **Cookie Management** - Get/set cookies programmatically

---

## Usage Examples

```bash
# Performance audit
/mcp chrome-devtools launch
/mcp chrome-devtools navigate url="https://stokedautomations.com"
/mcp chrome-devtools performance_trace
/mcp chrome-devtools get_network_requests
/mcp chrome-devtools screenshot path="./page.png"

# Console monitoring
/mcp chrome-devtools get_console_logs
```

---

## Resources

- **GitHub:** https://github.com/ChromeDevTools/chrome-devtools-mcp
- **Blog Post:** https://developer.chrome.com/blog/chrome-devtools-mcp
- **CDP Protocol:** https://chromedevtools.github.io/devtools-protocol/

---

## License

Apache-2.0 License

---

## Version History

### v2025.0.0 (2025-10-18)
- Initial release as standalone MCP plugin
- Wrapper for official ChromeDevTools/chrome-devtools-mcp
