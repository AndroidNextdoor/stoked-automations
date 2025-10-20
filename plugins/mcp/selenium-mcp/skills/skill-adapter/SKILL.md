---
name: Selenium MCP
description: |
  Selenium WebDriver MCP server for industry-standard browser automation with cross-browser support. Activates when users mention:
  - Selenium, WebDriver, or Selenium Grid
  - Industry-standard browser automation
  - Cross-browser testing (Chrome, Firefox, Edge, Safari)
  - Legacy test migration or Selenium compatibility
  - Cloud testing platforms (BrowserStack, Sauce Labs)
  - Java/Python test automation (Selenium's primary languages)
---

## How It Works

This plugin provides access to **Selenium WebDriver MCP server** (angiejones/mcp-selenium), the industry-standard automation framework with 28+ years of development and the widest browser support.

**Core Capabilities:**
1. **Cross-Browser Support** - Chrome, Firefox, Edge, Safari (widest browser compatibility)
2. **Industry Standard** - Most widely adopted automation framework (10M+ downloads/month)
3. **Cloud Integration** - Native support for BrowserStack, Sauce Labs, Selenium Grid
4. **WebDriver Protocol** - W3C standard for browser control
5. **Mature Ecosystem** - Extensive tooling, community support, integrations
6. **Language Support** - Primary APIs in Java, Python, C#, Ruby, JavaScript

**Based on:** angiejones/mcp-selenium using Selenium WebDriver bindings

## When to Use This Skill

Activate when users mention:

- **Selenium-Specific:**
  - "Use Selenium"
  - "Selenium WebDriver automation"
  - "Selenium Grid"
  - "Migrate from Selenium"
  - "Selenium compatibility"

- **Cross-Browser Testing:**
  - "Test on Chrome, Firefox, Edge, and Safari"
  - "Browser compatibility testing"
  - "Real Safari testing" (not WebKit)
  - "Cross-browser automation"

- **Cloud Testing:**
  - "BrowserStack integration"
  - "Sauce Labs testing"
  - "Remote WebDriver"
  - "Selenium Grid execution"

- **Enterprise/Legacy:**
  - "Industry standard automation"
  - "Existing Selenium tests"
  - "Java test automation"
  - "Python Selenium scripts"

- **Specific Features:**
  - "WebDriver protocol"
  - "Selenium waits and timeouts"
  - "Browser driver management"

## Examples

**User:** "Automate this workflow using Selenium"

**Skill activates** → Uses Selenium MCP with WebDriver protocol:
```bash
/mcp selenium launch_driver browser="chrome" headless=true
/mcp selenium navigate url="https://stokedautomations.com"
/mcp selenium find_element selector="css=#email"
# Returns element_id: "element-6066-11e4-a52e-4f735466cecf"
/mcp selenium type element_id="..." text="[email protected]"
/mcp selenium click element_id="..."
/mcp selenium screenshot path="./page.png"
```

**WebDriver Protocol:**
Selenium uses W3C WebDriver standard - element IDs are passed between commands (different from Playwright's direct selector approach).

---

**User:** "Test this on real Safari browser"

**Skill activates** → Launches actual Safari (not WebKit):
```bash
# Real Safari on macOS
/mcp selenium launch_driver browser="safari"
/mcp selenium navigate url="https://example.com"
# ... perform tests ...
```

**Why this matters:**
- **Safari** - Real Safari browser with Apple's rendering engine
- **WebKit** (Playwright) - Open-source engine, slightly different from Safari
- Use Selenium for **real Safari testing** on macOS/iOS

---

**User:** "Run my tests on BrowserStack"

**Skill activates** → Configures remote WebDriver:
```bash
# BrowserStack capabilities
{
  "browserName": "Chrome",
  "browserVersion": "latest",
  "os": "Windows",
  "os_version": "11",
  "resolution": "1920x1080",
  "browserstack.user": "YOUR_USERNAME",
  "browserstack.key": "YOUR_ACCESS_KEY"
}

/mcp selenium launch_driver remote=true hub_url="https://hub.browserstack.com/wd/hub" capabilities={...}
```

**Cloud Platform Support:**
- BrowserStack - Real device cloud
- Sauce Labs - Cross-browser testing
- LambdaTest - Selenium Grid
- Selenium Grid - Self-hosted

---

**User:** "Wait for element to be visible and clickable"

**Skill activates** → Uses Selenium's explicit waits:
```bash
/mcp selenium wait_for_element selector="css=#submit-button" condition="visible" timeout=10000
/mcp selenium wait_for_element selector="css=#submit-button" condition="clickable" timeout=10000
/mcp selenium click element_id="..."
```

**Selenium Wait Conditions:**
- `visible` - Element is displayed
- `clickable` - Element is visible and enabled
- `present` - Element exists in DOM (may not be visible)
- `invisible` - Element is not displayed

---

**User:** "Hover over menu and click submenu item"

**Skill activates** → Uses Selenium Actions API:
```bash
/mcp selenium find_element selector="css=#menu"
/mcp selenium hover element_id="..."
/mcp selenium find_element selector="css=#submenu-item"
/mcp selenium click element_id="..."
```

## Installation

### NPM Installation
```bash
npx -y @angiejones/mcp-selenium
```

### Claude Desktop Config
```json
{
  "mcpServers": {
    "selenium": {
      "command": "npx",
      "args": ["-y", "@angiejones/mcp-selenium"]
    }
  }
}
```

### Claude Code Plugin
```bash
/plugin install selenium-mcp@stoked-automations
```

### Install Browser Drivers (First Time)
```bash
# Chrome
npm install -g chromedriver

# Firefox
npm install -g geckodriver

# Edge
npm install -g edgedriver

# Safari (macOS only, built-in)
safaridriver --enable
```

## Available MCP Tools

### Core Tools
| Tool | Purpose |
|------|---------|
| `launch_driver` | Launch browser driver (chrome, firefox, edge, safari) |
| `quit_driver` | Close browser and driver |
| `navigate` | Navigate to URL |
| `find_element` | Find element by selector (returns element_id) |
| `find_elements` | Find multiple elements (returns array of element_ids) |
| `click` | Click element by element_id |
| `type` | Type text into element |
| `clear` | Clear input field |
| `screenshot` | Capture screenshot |
| `get_text` | Get element text content |
| `get_attribute` | Get element attribute value |

### Advanced Tools
| Tool | Purpose |
|------|---------|
| `wait_for_element` | Explicit wait with conditions |
| `execute_script` | Run JavaScript in browser |
| `select_dropdown` | Select option from dropdown |
| `hover` | Hover over element (mouse actions) |
| `drag_and_drop` | Drag element to target |
| `switch_to_frame` | Switch to iframe context |
| `switch_to_window` | Switch between browser tabs/windows |
| `get_cookies` / `set_cookies` | Manage browser cookies |
| `accept_alert` | Handle JavaScript alerts |
| `upload_file` | Upload files to input elements |

## Key Features

### WebDriver Protocol (W3C Standard)

Selenium implements the **W3C WebDriver standard** for browser automation:

**How it works:**
1. **Find element** - Returns element_id (UUID)
2. **Use element_id** - Pass to subsequent commands
3. **Element stale** - Re-find if element changes

```javascript
// Step 1: Find element
const elementId = await findElement('css=#button');
// Returns: "element-6066-11e4-a52e-4f735466cecf"

// Step 2: Use element_id
await click(elementId);

// Step 3: If page changes, re-find
const newElementId = await findElement('css=#button');
```

**Difference from Playwright:**
- **Selenium** - Element IDs (WebDriver protocol)
- **Playwright** - Direct selectors (no element IDs)

### Cross-Browser Support

| Browser | Engine | Selenium | Playwright | Notes |
|---------|--------|----------|------------|-------|
| **Chrome** | Blink | ✅ | ✅ | Both support |
| **Firefox** | Gecko | ✅ | ✅ | Both support |
| **Edge** | Blink | ✅ | ✅ | Both support |
| **Safari** | WebKit | ✅ Real Safari | ⚠️ WebKit OSS | Selenium uses real Safari |
| **IE11** | Trident | ✅ | ❌ | Only Selenium |

**Real Safari vs WebKit:**
- **Safari (Selenium)** - Actual Safari browser on macOS (with Apple modifications)
- **WebKit (Playwright)** - Open-source engine (slightly different from Safari)
- For **iOS/Safari testing**, use Selenium for real browser

### Cloud Platform Integration

Selenium has **first-class support** for cloud testing platforms:

**BrowserStack Example:**
```javascript
{
  "browserName": "iPhone",
  "device": "iPhone 14 Pro",
  "realMobile": "true",
  "os_version": "16",
  "browserstack.user": "USERNAME",
  "browserstack.key": "ACCESS_KEY"
}
```

**Sauce Labs Example:**
```javascript
{
  "browserName": "chrome",
  "platform": "Windows 11",
  "version": "latest",
  "username": "USERNAME",
  "accessKey": "ACCESS_KEY"
}
```

**Why this matters:**
- Test on real devices (not emulators)
- Access to 2000+ browser/OS combinations
- Parallel test execution
- Video recording and logs

### Selenium Grid (Distributed Testing)

Run tests in parallel across multiple machines:

```bash
# Hub
java -jar selenium-server.jar hub

# Nodes (different machines)
java -jar selenium-server.jar node --hub http://hub-ip:4444

# Connect MCP to Grid
/mcp selenium launch_driver remote=true hub_url="http://hub-ip:4444/wd/hub"
```

## Comparison with Other Tools

### Selenium vs Playwright

| Feature | Selenium | Playwright |
|---------|----------|------------|
| **Browser Support** | Chrome, Firefox, Edge, **Real Safari** | Chrome, Firefox, **WebKit OSS** |
| **API Style** | WebDriver (element IDs) | Direct selectors |
| **Auto-wait** | ❌ Manual explicit waits | ✅ Built-in |
| **Multi-tab** | ⚠️ Complex (switch windows) | ✅ Easy (contexts) |
| **Cloud Platforms** | ✅ Native support | ⚠️ Manual setup |
| **Industry Adoption** | ✅ 28 years, most popular | ⚠️ Newer (2020) |
| **Speed** | 🐌 Slower | ⚡ Faster |

**Choose Selenium When:**
- Testing **real Safari** on macOS/iOS
- Using cloud testing platforms (BrowserStack, Sauce Labs)
- Migrating from existing Selenium tests
- Integrating with Selenium Grid
- Enterprise environment with Selenium standards

**Choose Playwright When:**
- Speed is critical (5-10x faster)
- Multi-browser testing (Chrome, Firefox, WebKit OSS is sufficient)
- Modern API preferred (async/await, auto-wait)
- Cost optimization (accessibility tree vs screenshots)

### Selenium vs Cypress

| Feature | Selenium | Cypress |
|---------|----------|---------|
| **Cross-browser** | ✅ Chrome, Firefox, Edge, Safari | ⚠️ Chrome, Firefox, Edge |
| **Safari Support** | ✅ Real Safari | ❌ No |
| **Multi-tab** | ⚠️ Complex | ❌ Limited |
| **Component Testing** | ❌ No | ✅ First-class |
| **Cloud Platforms** | ✅ Native | ⚠️ Manual |
| **Language Support** | Java, Python, C#, Ruby, JS | JavaScript/TypeScript only |

## Best Practices

**ALWAYS:**
- Use explicit waits (not implicit waits or sleep)
- Prefer `wait_for_element` with conditions
- Close drivers when done (`quit_driver`)
- Use unique selectors (data-testid attributes)
- Handle stale element exceptions (re-find element)

**NEVER:**
- Use `Thread.sleep()` or `time.sleep()` (brittle, slow)
- Mix implicit and explicit waits (conflicts)
- Find element once and reuse for entire test (may become stale)
- Test on local browsers only (use cloud platforms)

## Common Patterns

### Explicit Wait Pattern
```javascript
// ❌ BAD: Arbitrary sleep
await sleep(5000);

// ✅ GOOD: Explicit wait with condition
await waitForElement('css=#button', 'clickable', 10000);
await click(elementId);
```

### Page Object Model Pattern
```javascript
class LoginPage {
  async login(username, password) {
    await navigate('https://example.com/login');
    const usernameField = await findElement('css=#username');
    await type(usernameField, username);
    const passwordField = await findElement('css=#password');
    await type(passwordField, password);
    const submitButton = await findElement('css=button[type=submit]');
    await click(submitButton);
  }
}
```

### Handling Stale Elements
```javascript
// Element may become stale after page change
try {
  await click(elementId);
} catch (StaleElementException) {
  // Re-find element
  const newElementId = await findElement('css=#button');
  await click(newElementId);
}
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Driver not found | Install browser driver: `npm install -g chromedriver` |
| Safari won't launch | Enable safaridriver: `safaridriver --enable` |
| Stale element errors | Re-find element after page changes |
| Timeout errors | Increase wait timeout: `wait_for_element(..., timeout=30000)` |
| Element not interactable | Wait for element to be clickable, not just visible |

## Resources

### Official Documentation
- **GitHub Repository:** https://github.com/angiejones/mcp-selenium
- **Selenium Official Docs:** https://www.selenium.dev/documentation/
- **WebDriver W3C Spec:** https://www.w3.org/TR/webdriver/
- **SeleniumHQ:** https://www.selenium.dev/
- **NPM Package:** `@angiejones/mcp-selenium`

### Cloud Platforms
- **BrowserStack:** https://www.browserstack.com/
- **Sauce Labs:** https://saucelabs.com/
- **LambdaTest:** https://www.lambdatest.com/
- **Selenium Grid:** https://www.selenium.dev/documentation/grid/

### Learning Resources
- **Selenium Tutorials:** https://www.selenium.dev/documentation/webdriver/
- **Best Practices:** https://www.selenium.dev/documentation/test_practices/
- **Waits Guide:** https://www.selenium.dev/documentation/webdriver/waits/

## Version & License

- **Version:** 2025.0.0
- **License:** MIT
- **Author:** Angie Jones (@angiejones)
- **Repository:** https://github.com/AndroidNextdoor/stoked-automations (plugin wrapper)
