# Browser Testing Suite

Comprehensive browser testing toolkit combining Playwright automation and Chrome DevTools Protocol (CDP) for E2E testing, performance profiling, network analysis, and visual regression testing.

## Overview

This MCP plugin provides two specialized servers that work together to give you complete browser testing capabilities:

1. **Playwright Automation Server** - Cross-browser E2E testing, screenshots, PDF generation, and form automation
2. **Chrome DevTools Server** - Performance profiling, network analysis, code coverage, and advanced debugging

## Features

### Playwright Automation
- **Multi-browser support**: Test in Chromium, Firefox, and WebKit
- **E2E test automation**: Navigate, click, type, fill forms, and interact with pages
- **Visual testing**: Capture screenshots and generate PDFs
- **Script execution**: Run custom JavaScript in page context
- **Flexible configuration**: Headless/headed modes, slow motion, custom timeouts

### Chrome DevTools Protocol
- **Performance profiling**: Capture runtime performance metrics and CPU profiles
- **Network analysis**: Monitor requests, responses, timing, and resource loading
- **Code coverage**: Track CSS and JavaScript usage
- **Console monitoring**: Capture and filter console logs
- **Device emulation**: Test responsive designs with custom viewports
- **Debugging tools**: Access Chrome-specific debugging capabilities

## Installation

```bash
# Add the Stoked Automations marketplace
/plugin marketplace add AndroidNextdoor/stoked-automations

# Install the browser-testing-suite plugin
/plugin install browser-testing-suite@stoked-automations
```

## MCP Servers

This plugin includes two MCP servers that can be used independently or together:

### 1. Playwright Automation Server

```json
{
  "mcpServers": {
    "playwright-automation": {
      "command": "node",
      "args": [
        "/path/to/plugins/mcp/browser-testing-suite/dist/servers/playwright-automation.js"
      ]
    }
  }
}
```

**Available Tools:**
- `launch_browser` - Start a browser instance (Chromium/Firefox/WebKit)
- `navigate` - Navigate to a URL with wait conditions
- `click` - Click elements by selector
- `type` - Type text into input fields
- `screenshot` - Capture page screenshots
- `evaluate` - Execute JavaScript in page context
- `close_browser` - Close the browser instance

### 2. Chrome DevTools Server

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "node",
      "args": [
        "/path/to/plugins/mcp/browser-testing-suite/dist/servers/chrome-devtools.js"
      ]
    }
  }
}
```

**Available Tools:**
- `connect_chrome` - Connect to Chrome/Chromium via CDP
- `navigate_cdp` - Navigate to URL for profiling
- `performance_profile` - Capture CPU and memory profiles
- `coverage_report` - Generate CSS/JS code coverage
- `network_analysis` - Monitor and analyze network traffic
- `console_logs` - Capture console messages
- `emulate_device` - Test with custom viewports

## Usage Examples

### E2E Testing Workflow

```
User: "Test the login flow on example.com"

Assistant uses:
1. launch_browser (headless: true)
2. navigate (url: "https://example.com/login")
3. type (selector: "#username", text: "testuser")
4. type (selector: "#password", text: "testpass")
5. click (selector: "#login-button")
6. screenshot (path: "login-success.png")
7. close_browser
```

### Performance Analysis

```
User: "Profile the performance of my app's dashboard"

Assistant uses:
1. connect_chrome (headless: true)
2. navigate_cdp (url: "https://myapp.com/dashboard")
3. performance_profile (duration: 10000)
4. network_analysis
5. coverage_report (type: "both")
```

### Visual Regression Testing

```
User: "Capture screenshots across different viewports"

Assistant uses:
1. launch_browser (browserType: "chromium")
2. navigate (url: "https://example.com")
3. screenshot (path: "desktop-1920x1080.png")
4. emulate_device (device: "iPhone 12", viewport: {width: 390, height: 844})
5. screenshot (path: "mobile-iphone12.png")
6. close_browser
```

## Requirements

### System Dependencies

- **Node.js**: 20.x or higher
- **Browsers**: Playwright will auto-install Chromium, Firefox, and WebKit
- **Chrome/Chromium**: Required for CDP server (can use system installation)

### Installation from Source

```bash
cd plugins/mcp/browser-testing-suite
pnpm install
pnpm build
```

## Development

### Build

```bash
pnpm build              # Compile TypeScript to dist/
```

### Development Mode

```bash
pnpm dev:playwright     # Watch mode for Playwright server
pnpm dev:devtools       # Watch mode for Chrome DevTools server
```

### Testing

```bash
pnpm test               # Run unit tests
pnpm test:ci            # Run tests in CI mode
pnpm test:e2e           # Run E2E tests with Playwright
```

### Type Checking

```bash
pnpm typecheck          # Check TypeScript types
pnpm lint               # Run ESLint
```

## Configuration

### Playwright Server Options

- **browserType**: `chromium`, `firefox`, or `webkit`
- **headless**: Run without visible UI (default: true)
- **slowMo**: Slow down operations by milliseconds (debugging)
- **timeout**: Default timeout for actions (ms)

### Chrome DevTools Options

- **executablePath**: Path to Chrome/Chromium binary (optional, uses bundled)
- **headless**: Run without visible UI (default: true)
- **devtools**: Open DevTools automatically (default: false)

## Use Cases

### QA & Testing
- Automated E2E test suite execution
- Cross-browser compatibility testing
- Visual regression detection
- Form validation testing

### Performance Engineering
- Load time analysis
- Runtime performance profiling
- Network waterfall analysis
- Code coverage reports

### Development & Debugging
- Screenshot generation for documentation
- PDF report creation
- Console log monitoring
- Network request debugging

### CI/CD Integration
- Automated screenshot comparison
- Performance regression detection
- Accessibility testing
- Pre-deployment smoke tests

## Troubleshooting

### Browser Not Found

Playwright auto-installs browsers. If missing:
```bash
npx playwright install chromium
npx playwright install firefox
npx playwright install webkit
```

### Chrome DevTools Connection Issues

Ensure Chrome/Chromium is installed:
```bash
# macOS
brew install --cask google-chrome

# Linux
sudo apt-get install chromium-browser

# Or use bundled Chromium:
npx puppeteer browsers install chrome
```

### Permission Errors

Ensure execute permissions:
```bash
chmod +x dist/servers/*.js
```

### TypeScript Build Errors

```bash
rm -rf dist/ node_modules/
pnpm install
pnpm build
```

## Architecture

### Directory Structure

```
browser-testing-suite/
├── servers/
│   ├── playwright-automation.ts    # E2E testing MCP server
│   └── chrome-devtools.ts          # CDP profiling MCP server
├── skills/
│   └── test-automation-expert/     # Agent skill for auto-activation
├── tests/
│   └── *.test.ts                   # Unit and integration tests
├── .claude-plugin/
│   └── plugin.json                 # Plugin metadata
├── package.json                    # Dependencies and scripts
├── tsconfig.json                   # TypeScript configuration
└── README.md                       # This file
```

### Technology Stack

- **@modelcontextprotocol/sdk**: MCP server framework
- **playwright**: Cross-browser automation (v1.48.0)
- **puppeteer-core**: Chrome DevTools Protocol client
- **chrome-remote-interface**: Low-level CDP access
- **zod**: Runtime type validation
- **TypeScript**: Type-safe development
- **Vitest**: Unit testing framework

## Security Considerations

### Execution Safety
- All browser actions are sandboxed in isolated contexts
- No direct file system access from web pages
- Custom scripts run in controlled page contexts

### Network Security
- HTTPS validation for secure connections
- Network request filtering capabilities
- Cookie and localStorage isolation per session

### Best Practices
- Use headless mode in production/CI environments
- Validate all URLs before navigation
- Set reasonable timeouts to prevent hanging
- Clean up browser instances after use
- Review coverage reports for unused code

## Contributing

This plugin is part of the [Stoked Automations](https://github.com/AndroidNextdoor/stoked-automations) marketplace.

### Reporting Issues

Found a bug or have a feature request? [Open an issue](https://github.com/AndroidNextdoor/stoked-automations/issues).

### Development Workflow

1. Fork the repository
2. Create a feature branch
3. Make changes to `servers/*.ts`
4. Add tests in `tests/`
5. Run `pnpm build && pnpm test`
6. Submit a pull request

## License

MIT License - see [LICENSE](./LICENSE) file for details.

## Credits

Developed by **Andrew Nixdorf** for the Claude Code community.

Part of the **Stoked Automations** plugin marketplace.

## Related Plugins

- **design-to-code** - Convert Figma/screenshots to code (uses Playwright)
- **project-health-auditor** - Code health analysis
- **workflow-orchestrator** - DAG-based automation

## Support

- **Documentation**: [Stoked Automations Docs](https://stokedautomations.com/)
- **Discord**: [Claude Code Community](https://discord.com/invite/6PPFFzqPDZ)
- **GitHub**: [Issue Tracker](https://github.com/AndroidNextdoor/stoked-automations/issues)

---

**Version**: 1.0.0
**Last Updated**: October 2025
**Status**: Production Ready
