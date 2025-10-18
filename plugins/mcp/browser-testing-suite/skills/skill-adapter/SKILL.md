---
name: Testing Browser Applications
description: |
  Automatically activates comprehensive browser testing capabilities when users mention testing websites, web apps, E2E testing, browser automation, performance profiling, or debugging. Uses Playwright, Chrome DevTools, Cypress, Selenium, and Katalon servers to perform cross-browser testing, visual regression testing, network analysis, code coverage reports, and automated UI interactions. Triggers on phrases like "test this website", "automate browser", "check performance", "run E2E tests", "capture screenshots", "profile page load", or "analyze network requests".
---

## Overview

This skill automatically detects when you need browser testing capabilities and activates the appropriate MCP servers from the browser-testing-suite. It intelligently routes requests to Playwright for E2E automation, Chrome DevTools for performance analysis, or other specialized testing frameworks based on your specific needs.

## How It Works

1. **Detection**: Monitors for browser testing keywords and automatically activates relevant MCP servers
2. **Server Selection**: Routes requests to the most appropriate testing framework (Playwright, Selenium, Cypress, etc.)
3. **Execution**: Performs the requested testing operations and provides comprehensive results
4. **Analysis**: Interprets test results and provides actionable insights

## When to Use This Skill

- Testing website functionality or user flows
- Automating repetitive browser tasks
- Capturing screenshots or generating PDFs
- Profiling page performance and load times
- Analyzing network requests and responses
- Checking code coverage for CSS/JavaScript
- Cross-browser compatibility testing
- Visual regression testing
- Form automation and data entry testing
- Mobile responsiveness testing

## Examples

### Example 1: E2E Testing
User request: "Test the login flow on our website and take screenshots of each step"

The skill will:
1. Launch Playwright automation server
2. Navigate to the login page and capture initial screenshot
3. Fill in credentials and submit the form
4. Verify successful login and capture final screenshot
5. Generate a test report with all screenshots

### Example 2: Performance Analysis
User request: "Check how fast this page loads and analyze the network requests"

The skill will:
1. Connect to Chrome DevTools server
2. Start performance profiling and network monitoring
3. Navigate to the target page
4. Capture CPU usage, memory consumption, and load times
5. Generate detailed network analysis with timing breakdowns
6. Provide optimization recommendations

### Example 3: Cross-Browser Testing
User request: "Make sure this form works in Chrome, Firefox, and Safari"

The skill will:
1. Launch multiple browser instances using Playwright
2. Test form submission in Chromium, Firefox, and WebKit
3. Capture screenshots from each browser
4. Report any browser-specific issues or inconsistencies

### Example 4: Code Coverage Analysis
User request: "Show me which CSS and JavaScript code is actually being used on this page"

The skill will:
1. Connect via Chrome DevTools Protocol
2. Enable code coverage tracking
3. Navigate to the page and interact with key elements
4. Generate comprehensive coverage report
5. Identify unused CSS rules and JavaScript functions

## Best Practices

- **Server Selection**: Playwright for general E2E testing, Chrome DevTools for performance analysis, Selenium for legacy browser support
- **Wait Strategies**: Always use appropriate wait conditions for dynamic content loading
- **Screenshot Management**: Capture screenshots at key test steps for debugging and documentation
- **Performance Testing**: Run performance tests multiple times to get accurate averages
- **Error Handling**: Implement proper error handling and cleanup for browser instances
- **Mobile Testing**: Use device emulation for responsive design testing

## Integration

Works seamlessly with other development plugins by automatically detecting browser testing needs in your workflow. Integrates with CI/CD pipelines through programmatic APIs, supports visual regression testing with image comparison tools, and can export results in standard formats like JUnit XML or HTML reports. The multiple MCP servers can be used independently or in combination for comprehensive testing coverage.