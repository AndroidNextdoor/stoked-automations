# Selenium MCP Server

![Version](https://img.shields.io/badge/version-2025.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Category](https://img.shields.io/badge/category-testing-teal)

**Selenium WebDriver MCP server** - Industry-standard browser automation with cross-browser support for Chrome, Firefox, Edge, and Safari.

---

## Overview

Wrapper plugin for [angiejones/mcp-selenium](https://github.com/angiejones/mcp-selenium) - the most popular Selenium MCP implementation.

### Why Selenium MCP?

- **🌐 Cross-browser** - Chrome, Firefox, Edge, Safari support
- **📊 Industry Standard** - Most widely adopted automation framework
- **🔧 WebDriver Protocol** - W3C standard for browser control
- **🎯 Mature Ecosystem** - Extensive tooling and community support
- **☁️ Cloud Integration** - Works with BrowserStack, Sauce Labs, etc.

---

## Installation

```bash
# NPM installation
npx -y @angiejones/mcp-selenium

# Claude Desktop config
{
  "mcpServers": {
    "selenium": {
      "command": "npx",
      "args": ["-y", "@angiejones/mcp-selenium"]
    }
  }
}

# Claude Code
/plugin install selenium-mcp@stoked-automations
```

---

## Features

- Launch browsers (Chrome, Firefox, Edge, Safari)
- Element interactions (click, type, select)
- Screenshots and file uploads
- Mouse actions (hover, drag, scroll)
- Keyboard events and shortcuts
- Cookie and storage management
- Headless mode support

---

## Usage Examples

```bash
# Basic automation
/mcp selenium launch_driver browser="chrome" headless=true
/mcp selenium navigate url="https://example.com"
/mcp selenium find_element selector="css=#email"
/mcp selenium type element_id="..." text="[email protected]"
/mcp selenium click element_id="..."
/mcp selenium screenshot path="./screenshot.png"
```

---

## Resources

- **GitHub:** https://github.com/angiejones/mcp-selenium
- **Selenium Docs:** https://www.selenium.dev/documentation/
- **Package:** `@angiejones/mcp-selenium`

---

## License

MIT License

---

## Version History

### v2025.0.0 (2025-10-18)
- Initial release as standalone MCP plugin
- Wrapper for angiejones/mcp-selenium
