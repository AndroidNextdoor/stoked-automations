---
name: Playwright MCP
description: |
  Official Microsoft Playwright MCP server for fast, deterministic E2E testing using accessibility trees (no screenshots). Activates when users mention:
  - Playwright automation, E2E testing, or browser testing
  - Multi-browser testing (Chrome, Firefox, WebKit/Safari)
  - Accessibility tree analysis or structured element data
  - Fast, deterministic browser automation (no vision model needed)
  - Cross-browser compatibility testing
  - Screenshot capture, PDF generation, or network recording
---

## How It Works

This plugin provides access to **Microsoft's official Playwright MCP server**, enabling fast browser automation through structured accessibility tree snapshots instead of pixel-based screenshots.

**Revolutionary Approach:**
- **Traditional tools:** Take screenshot → Vision model analyzes pixels → Identify elements
- **Playwright MCP:** Extract accessibility tree → LLM reads structured data → Interact with elements

**Core Capabilities:**
1. **Multi-Browser Support** - Chromium, Firefox, WebKit (Safari engine)
2. **Accessibility-First** - Uses structured a11y trees (faster, more accurate than screenshots)
3. **Text-Only LLM** - No vision model required (lower cost, faster execution)
4. **Deterministic** - No ambiguity from visual interpretation
5. **Network Recording** - Monitor HTTP requests and responses
6. **Auto-Wait** - Built-in smart waiting for elements (no manual waits)
7. **Screenshots & PDFs** - High-quality capture when needed

**Based on:** Microsoft's playwright-mcp using Playwright's accessibility snapshot API

## When to Use This Skill

Activate when users mention:

- **E2E Testing & Automation:**
  - "E2E test automation"
  - "Browser testing"
  - "Test user workflows"
  - "Automate web interactions"
  - "Integration testing"

- **Multi-Browser Testing:**
  - "Test on Chrome, Firefox, and Safari"
  - "Cross-browser compatibility"
  - "WebKit testing"
  - "Browser compatibility testing"

- **Fast/Deterministic Automation:**
  - "Fast browser automation"
  - "No screenshot-based testing"
  - "Deterministic tests"
  - "Reliable test automation"
  - "Accessibility tree analysis"

- **Specific Features:**
  - "Take screenshot with Playwright"
  - "Generate PDF from page"
  - "Record network traffic"
  - "Multi-tab testing"
  - "File uploads"

- **Cost-Effective:**
  - "Browser automation without vision model"
  - "Lower-cost automation"
  - "Text-only LLM automation"

## Examples

**User:** "Test the login flow on https://stokedautomations.com"

**Skill activates** → Uses Playwright MCP's accessibility tree approach:
```bash
/mcp playwright launch_browser browserType="chromium" headless=true
/mcp playwright navigate url="https://stokedautomations.com/login"
# Playwright extracts accessibility tree (no screenshot)
/mcp playwright type selector="#email" text="[email protected]"
/mcp playwright type selector="#password" text="secret123"
/mcp playwright click selector="button[type=submit]"
/mcp playwright wait_for_selector selector=".dashboard" state="visible"
```

**Why faster than screenshot-based:**
- No image generation (saves time)
- No image processing (saves tokens)
- No OCR errors (direct element access)
- Works with any text-only LLM (no vision model needed)

---

**User:** "Test this workflow on Chrome, Firefox, and Safari"

**Skill activates** → Runs tests across all 3 browsers:
```bash
# Chrome (Chromium)
/mcp playwright launch_browser browserType="chromium"
/mcp playwright navigate url="https://example.com"
# ... perform tests ...
/mcp playwright close_browser

# Firefox
/mcp playwright launch_browser browserType="firefox"
/mcp playwright navigate url="https://example.com"
# ... perform tests ...
/mcp playwright close_browser

# Safari (WebKit)
/mcp playwright launch_browser browserType="webkit"
/mcp playwright navigate url="https://example.com"
# ... perform tests ...
```

**Result:** Identifies browser-specific issues (CSS rendering, JavaScript compatibility, etc.)

---

**User:** "Capture network requests while loading the page"

**Skill activates** → Enables network recording:
```bash
/mcp playwright launch_browser
/mcp playwright network_recording enable=true
/mcp playwright navigate url="https://stokedautomations.com"
/mcp playwright get_network_logs
```

**Output:** Complete network activity including:
- Request/response headers
- Status codes and timing
- Request/response bodies
- Resource types (XHR, fetch, document, script, style)

---

**User:** "Fill out this form and submit it"

**Skill activates** → Uses Playwright's form interaction tools:
```bash
/mcp playwright navigate url="https://example.com/contact"
/mcp playwright fill selector="#name" text="John Doe"
/mcp playwright fill selector="#email" text="[email protected]"
/mcp playwright select selector="#country" value="USA"
/mcp playwright check selector="#agree-terms"
/mcp playwright click selector="button[type=submit]"
/mcp playwright wait_for_selector selector=".success-message"
```

**Note:** `fill()` is faster than `type()` for form inputs (sets value directly).

---

**User:** "Generate a PDF of this page"

**Skill activates** → Creates PDF with custom formatting:
```bash
/mcp playwright navigate url="https://docs.example.com"
/mcp playwright pdf path="./documentation.pdf" format="A4" printBackground=true
```

## Installation

### Quick Install (NPX)
```bash
npx @playwright/mcp@latest
```

### Claude Desktop Config
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

### Claude Code Plugin
```bash
/plugin install playwright-mcp@stoked-automations
```

### Install Browsers (First Time)
```bash
npx playwright install chromium firefox webkit
```

## Available MCP Tools

### Core Tools
| Tool | Purpose |
|------|---------|
| `launch_browser` | Launch browser (chromium, firefox, webkit) |
| `close_browser` | Close current browser instance |
| `navigate` | Navigate to URL with wait conditions |
| `click` | Click element by selector |
| `type` | Type text into element (with key events) |
| `fill` | Fill form field (faster, no key events) |
| `screenshot` | Capture screenshot (full page or element) |
| `pdf` | Generate PDF from current page |
| `wait_for_selector` | Wait for element to appear/disappear |
| `evaluate` | Execute JavaScript in browser context |

### Advanced Tools
| Tool | Purpose |
|------|---------|
| `network_recording` | Enable/disable network monitoring |
| `get_network_logs` | Retrieve recorded network activity |
| `get_console_logs` | Get browser console output |
| `upload_file` | Upload files to input elements |
| `select` | Select option from dropdown |
| `check` / `uncheck` | Check/uncheck checkboxes |
| `hover` | Hover over element |
| `drag_and_drop` | Drag element to target |
| `get_cookies` / `set_cookies` | Manage browser cookies |
| `press_key` | Press keyboard keys or shortcuts |

## Key Features

### Accessibility Tree Approach

**What is an accessibility tree?**
Browsers maintain a structured representation of page elements for screen readers:
```json
{
  "role": "button",
  "name": "Submit Form",
  "description": "Submit the contact form",
  "clickable": true
}
```

**Playwright MCP benefits:**
- ⚡ **5-10x faster** than screenshot-based (no image generation)
- 💰 **90% cost reduction** (text tokens vs image tokens)
- 🎯 **More accurate** (no OCR errors, direct element access)
- 📝 **Text-only LLM** (works with Haiku, Sonnet, no vision model needed)
- ♿ **Accessibility testing** (verifies screen reader compatibility)

### Multi-Browser Testing

| Browser | Engine | Use Case |
|---------|--------|----------|
| **Chromium** | Blink | Chrome, Edge, Opera, Brave (70% market share) |
| **Firefox** | Gecko | Firefox (3% market share, unique rendering) |
| **WebKit** | WebKit | Safari on macOS/iOS (20% mobile market share) |

**Why test all three?**
- CSS rendering differences
- JavaScript API compatibility
- Font rendering and layout
- Mobile-specific issues (WebKit for iOS)

### Auto-Wait (No Manual Waits Needed)

Playwright automatically waits for elements to be:
- **Visible** - Not display:none or visibility:hidden
- **Stable** - Not moving or animating
- **Enabled** - Not disabled attribute
- **Clickable** - Not covered by another element

```javascript
// ❌ OLD WAY (Selenium)
await driver.sleep(5000);  // Brittle, slow
await driver.findElement(By.id('button')).click();

// ✅ NEW WAY (Playwright)
await page.click('#button');  // Auto-waits up to 30s
```

## Configuration

### Browser Launch Options
```javascript
{
  "browserType": "chromium",  // or "firefox", "webkit"
  "headless": true,           // No GUI (faster)
  "slowMo": 100,              // Slow down by 100ms (for debugging)
  "viewport": {
    "width": 1280,
    "height": 720
  },
  "userAgent": "Custom User Agent",
  "proxy": {
    "server": "http://proxy:8080"
  }
}
```

### Navigation Options
```javascript
{
  "url": "https://stokedautomations.com",
  "waitUntil": "networkidle",  // or "load", "domcontentloaded"
  "timeout": 30000             // 30 seconds
}
```

## Comparison with Other Tools

### Playwright MCP vs Screenshot-Based Automation

| Metric | Playwright MCP | Screenshot-Based |
|--------|---------------|------------------|
| **Speed** | ⚡ 5-10x faster | 🐌 Slow (image gen + analysis) |
| **Cost** | 💰 90% cheaper | 💸 Expensive (image tokens) |
| **Accuracy** | 🎯 High (no OCR) | 📊 Variable (vision model errors) |
| **Model** | 📝 Text-only LLM | 👁️ Vision model required |
| **Reliability** | ✅ Deterministic | ⚠️ Visual ambiguity possible |

### Playwright vs Selenium

| Feature | Playwright | Selenium |
|---------|-----------|----------|
| **Browser Support** | Chrome, Firefox, WebKit | Chrome, Firefox, Safari, Edge |
| **API Design** | Modern async/await | WebDriver protocol |
| **Auto-wait** | ✅ Built-in | ❌ Manual waits |
| **Network Interception** | ✅ Native | ❌ Requires proxy |
| **Multi-tab** | ✅ Easy (browser contexts) | ⚠️ Complex (window handles) |
| **Speed** | ⚡ Faster | 🐌 Slower |

### Playwright vs Cypress

| Feature | Playwright | Cypress |
|---------|-----------|---------|
| **Component Testing** | ⚠️ Limited | ✅ First-class |
| **Multi-browser** | ✅ Chrome, Firefox, WebKit | ⚠️ Chrome, Firefox, Edge |
| **Multi-tab** | ✅ Easy | ❌ Limited |
| **Time Travel Debug** | ❌ No | ✅ Yes |
| **Test Generation (MCP)** | ❌ No | ✅ Yes |
| **Speed** | ⚡ Fast | ⚡ Fast |

**Choose Playwright When:**
- Multi-browser testing is required (especially WebKit/Safari)
- Multi-tab workflows are common
- Fast, cost-effective automation is needed
- Accessibility tree analysis is valuable
- No vision model is available

**Choose Cypress When:**
- Component testing is a priority
- Time travel debugging is valuable
- Test generation from URLs is needed

## Best Practices

**ALWAYS:**
- Use headless mode in CI (faster, no GUI overhead)
- Prefer `fill()` over `type()` for form inputs (faster)
- Use `waitUntil: 'domcontentloaded'` instead of `'load'` (faster)
- Close browsers when done (`close_browser`) to free resources
- Enable network recording **before** navigation

**NEVER:**
- Add `sleep()` or `wait(ms)` delays (use auto-wait instead)
- Test on single browser only (multi-browser issues are real)
- Ignore console errors (check with `get_console_logs`)
- Use fragile selectors (prefer `data-testid` attributes)

## Performance Tips

1. **Headless mode** - No GUI rendering (50% faster)
2. **Selective network recording** - Only enable when needed (adds overhead)
3. **Use `fill()` not `type()`** - For form inputs (10x faster)
4. **`domcontentloaded` wait** - Instead of `load` (faster navigation)
5. **Browser contexts** - Reuse browser, create new contexts (faster than new browser)

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Browser won't launch | `npx playwright install chromium` |
| Timeout errors | Increase timeout: `navigate({ timeout: 60000 })` |
| Element not found | Use `wait_for_selector` before interacting |
| Network logs empty | Enable recording **before** navigation |
| Multi-tab not working | Use browser contexts: `const context = await browser.newContext()` |

## Resources

### Official Documentation
- **GitHub Repository:** https://github.com/microsoft/playwright-mcp
- **Playwright Docs:** https://playwright.dev/
- **Accessibility Snapshots:** https://playwright.dev/docs/accessibility-testing
- **MCP Protocol:** https://modelcontextprotocol.io/
- **Blog Post:** https://developer.chrome.com/blog/chrome-devtools-mcp

### Related Plugins
- **selenium-mcp** - Alternative WebDriver-based automation
- **cypress-mcp** - Component testing with test generation
- **chrome-devtools-mcp** - Chrome DevTools Protocol access

## Version & License

- **Version:** 2025.0.0
- **License:** MIT
- **Maintained By:** Microsoft Playwright Team
- **Repository:** https://github.com/AndroidNextdoor/stoked-automations (plugin wrapper)
