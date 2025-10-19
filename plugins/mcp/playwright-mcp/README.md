# Playwright MCP Server

![Version](https://img.shields.io/badge/version-2025.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Category](https://img.shields.io/badge/category-testing-teal)

**Official Microsoft Playwright MCP server** - Browser automation using structured accessibility trees instead of screenshots. Fast, lightweight, and deterministic E2E testing across Chrome, Firefox, and WebKit.

---

## Overview

This is a **wrapper plugin** for Microsoft's official [playwright-mcp](https://github.com/microsoft/playwright-mcp) server. It enables LLMs to interact with web browsers through Playwright's accessibility snapshot API, eliminating the need for vision models or screenshot-based approaches.

### Why Playwright MCP?

- **🚀 Fast** - Uses structured accessibility data instead of pixel-based screenshots
- **🎯 Deterministic** - No ambiguity from visual interpretation
- **💡 LLM-friendly** - Works with text-only models (no vision required)
- **🌐 Multi-browser** - Supports Chromium, Firefox, and WebKit
- **🔧 Reliable** - Battle-tested automation from Microsoft's Playwright team

---

## Installation

### Quick Install

```bash
npx @playwright/mcp@latest
```

### Claude Desktop Configuration

Add to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"]
    }
  }
}
```

### Claude Code Installation

```bash
/plugin install playwright-mcp@stoked-automations
```

---

## Features

### Browser Automation

- **Launch browsers** - Chromium, Firefox, WebKit with headless/headed modes
- **Navigation** - Visit URLs with configurable wait conditions
- **Element interaction** - Click, type, fill forms, upload files
- **Screenshots** - Capture full page or element-specific screenshots
- **PDF generation** - Convert pages to PDF with custom formatting
- **Network recording** - Monitor HTTP requests and responses
- **Console logs** - Capture browser console output
- **Execute JavaScript** - Run custom scripts in browser context

### Accessibility-First Approach

Playwright MCP uses **accessibility tree snapshots** instead of screenshots:

```typescript
// Traditional approach: Take screenshot → Vision model analyzes pixels
// Playwright MCP: Extract accessibility tree → LLM reads structured data

{
  "role": "button",
  "name": "Submit",
  "description": "Submit the form"
}
```

**Benefits:**
- Faster execution (no image processing)
- More accurate (no OCR errors)
- Works with any LLM (no vision model required)
- Better for screen reader compatibility testing

---

## Usage Examples

### Example 1: Navigate and Screenshot

```bash
# Launch browser and take screenshot
/mcp playwright launch_browser browserType="chromium" headless=true
/mcp playwright navigate url="https://example.com"
/mcp playwright screenshot path="./example.png" fullPage=true
```

### Example 2: Form Automation

```bash
# Fill form and submit
/mcp playwright type selector="#email" text="[email protected]"
/mcp playwright type selector="#password" text="secret123"
/mcp playwright click selector="button[type=submit]"
```

### Example 3: E2E Testing Workflow

```bash
# Complete E2E test
/mcp playwright launch_browser
/mcp playwright navigate url="https://app.example.com/login"
/mcp playwright type selector="#username" text="testuser"
/mcp playwright type selector="#password" text="testpass"
/mcp playwright click selector="button.login"
/mcp playwright wait_for_selector selector=".dashboard" state="visible"
/mcp playwright screenshot path="./dashboard.png"
```

### Example 4: Performance Testing

```bash
# Enable network recording
/mcp playwright network_recording enable=true
/mcp playwright navigate url="https://example.com"
/mcp playwright get_network_logs
```

---

## Available Tools

### Core Tools

| Tool | Description |
|------|-------------|
| `launch_browser` | Launch a browser instance (chromium, firefox, webkit) |
| `close_browser` | Close the current browser instance |
| `navigate` | Navigate to a URL |
| `click` | Click an element by selector |
| `type` | Type text into an element |
| `fill` | Fill form field (faster than type) |
| `screenshot` | Take a screenshot (full page or element) |
| `pdf` | Generate PDF of current page |
| `wait_for_selector` | Wait for element to appear/disappear |
| `evaluate` | Execute JavaScript in browser context |
| `network_recording` | Enable/disable network monitoring |
| `get_network_logs` | Retrieve recorded network requests |
| `get_console_logs` | Retrieve browser console output |

### Advanced Tools

- **Element queries** - Query accessibility tree for element info
- **Mouse actions** - Hover, drag, scroll
- **Keyboard events** - Press keys, keyboard shortcuts
- **File uploads** - Upload files to input elements
- **Cookies** - Get/set browser cookies
- **Local storage** - Interact with browser storage

---

## Configuration

### Browser Options

```json
{
  "browserType": "chromium",  // chromium, firefox, webkit
  "headless": true,           // Run without UI
  "slowMo": 100,              // Slow down by 100ms per action (for debugging)
  "viewport": {
    "width": 1280,
    "height": 720
  },
  "userAgent": "Custom UA"
}
```

### Navigation Options

```json
{
  "url": "https://example.com",
  "waitUntil": "networkidle",  // load, domcontentloaded, networkidle
  "timeout": 30000             // 30 seconds
}
```

---

## Comparison with Other Solutions

### Playwright MCP vs Screenshot-based Automation

| Feature | Playwright MCP | Screenshot-based |
|---------|---------------|------------------|
| Speed | ⚡ Fast (no image processing) | 🐌 Slow (image generation + analysis) |
| Accuracy | 🎯 High (structured data) | 📊 Variable (depends on vision model) |
| Model Requirements | 📝 Text-only LLM | 👁️ Vision-capable model |
| Cost | 💰 Low (fewer tokens) | 💸 High (image tokens expensive) |
| Reliability | ✅ Deterministic | ⚠️ May have ambiguity |

### Playwright MCP vs Selenium MCP

| Feature | Playwright | Selenium |
|---------|-----------|----------|
| Browser Support | Chrome, Firefox, WebKit | Chrome, Firefox, Safari, Edge |
| API Design | Modern async/await | WebDriver protocol |
| Network Interception | ✅ Native | ❌ Requires proxy |
| Auto-wait | ✅ Built-in | ❌ Manual waits |
| Multi-tab | ✅ Easy | ⚠️ Complex |

---

## Troubleshooting

### Browser Won't Launch

```bash
# Install browser binaries
npx playwright install chromium
```

### Timeout Errors

```javascript
// Increase timeout for slow pages
navigate({ url: "https://slow-site.com", timeout: 60000 })
```

### Element Not Found

```bash
# Use wait_for_selector before interacting
/mcp playwright wait_for_selector selector="#dynamic-element" timeout=10000
/mcp playwright click selector="#dynamic-element"
```

### Network Recording Not Working

```bash
# Enable BEFORE navigating
/mcp playwright network_recording enable=true
/mcp playwright navigate url="https://example.com"
```

---

## Performance Tips

1. **Use headless mode** for faster execution (no GUI rendering)
2. **Enable network recording selectively** (adds overhead)
3. **Prefer `fill()` over `type()`** for form inputs (faster)
4. **Use `waitUntil: 'domcontentloaded'`** instead of `'load'` for faster navigation
5. **Close browser when done** to free resources

---

## Resources

### Official Documentation

- **GitHub Repository:** https://github.com/microsoft/playwright-mcp
- **Playwright Docs:** https://playwright.dev/
- **MCP Protocol:** https://modelcontextprotocol.io/
- **Blog Post:** https://developer.chrome.com/blog/chrome-devtools-mcp

### Related Plugins

- **selenium-mcp** - Alternative WebDriver-based automation
- **cypress-mcp** - Component testing focused
- **chrome-devtools-mcp** - Chrome DevTools Protocol access

---

## Contributing

This is a **wrapper plugin** that references Microsoft's official Playwright MCP server. For issues, features, or contributions to the MCP server itself, visit:

🔗 https://github.com/microsoft/playwright-mcp/issues

For marketplace-specific issues (plugin metadata, documentation), open an issue in the Stoked Automations repository.

---

## License

This plugin wrapper is MIT licensed. The underlying Playwright MCP server is also MIT licensed by Microsoft.

---

## Version History

### v2025.0.0 (2025-10-18)
- Initial release as standalone MCP plugin
- Wrapper for microsoft/playwright-mcp official server
- Comprehensive documentation and examples
