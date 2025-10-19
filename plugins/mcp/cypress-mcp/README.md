# Cypress MCP Server

![Version](https://img.shields.io/badge/version-2025.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Category](https://img.shields.io/badge/category-testing-teal)

**Cypress MCP server** - Automatically generates Cypress test cases and Page Object Models by analyzing web pages. Component-focused testing with modern JavaScript frameworks.

---

## Overview

This is a **wrapper plugin** for [jprealini/cypress-mcp](https://github.com/jprealini/cypress-mcp). It enables LLMs to generate, execute, and analyze Cypress tests through the Model Context Protocol.

### Why Cypress MCP?

- **🎯 Component Testing** - First-class support for React, Vue, Angular
- **📝 Auto-generate Tests** - Creates Page Object Models and test suites automatically
- **⚡ Fast Execution** - Direct DOM access, no WebDriver overhead
- **🔄 Time Travel** - Debug tests by traveling back in time
- **📸 Automatic Screenshots** - Captures screenshots and videos on failure
- **🌐 Modern Framework Support** - Built for modern JavaScript applications

---

## Installation

### NPM Installation

```bash
npm install -g cypress-mcp
```

### Claude Desktop Configuration

Add to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "cypress": {
      "command": "cypress-mcp"
    }
  }
}
```

### Claude Code Installation

```bash
/plugin install cypress-mcp@stoked-automations
```

---

## Features

### Automated Test Generation

- **Page Object Models** - Automatically generates POM classes
- **Test Suites** - Creates comprehensive test cases
- **Web Scraping** - Analyzes page structure using Puppeteer + Cheerio
- **Smart Selectors** - Generates reliable CSS/XPath selectors

### Test Execution

- **Run Tests** - Execute Cypress specs programmatically
- **Watch Mode** - Re-run tests on file changes
- **Parallel Execution** - Run tests across multiple browsers
- **CI/CD Integration** - Designed for continuous integration

### Component Testing

- **React** - Test React components in isolation
- **Vue** - Test Vue components
- **Angular** - Test Angular components
- **Framework-agnostic** - Works with any component library

---

## Usage Examples

### Example 1: Generate Test from URL

```bash
# Generate Page Object Model and tests
/mcp cypress generate_test url="https://example.com/login"
```

Output:
```javascript
// pages/LoginPage.js
class LoginPage {
  visit() {
    cy.visit('/login');
  }

  fillUsername(username) {
    cy.get('#username').type(username);
  }

  fillPassword(password) {
    cy.get('#password').type(password);
  }

  submit() {
    cy.get('button[type="submit"]').click();
  }
}

// tests/login.spec.js
describe('Login Tests', () => {
  const loginPage = new LoginPage();

  it('should login successfully', () => {
    loginPage.visit();
    loginPage.fillUsername('testuser');
    loginPage.fillPassword('testpass');
    loginPage.submit();
    cy.url().should('include', '/dashboard');
  });
});
```

### Example 2: Run Existing Tests

```bash
# Run all tests
/mcp cypress run_tests

# Run specific spec
/mcp cypress run_tests spec="tests/login.spec.js"

# Run in headed mode
/mcp cypress run_tests headed=true
```

### Example 3: Component Testing

```bash
# Test React component
/mcp cypress test_component component="Button.jsx" framework="react"
```

---

## Available Tools

| Tool | Description |
|------|-------------|
| `generate_test` | Generate Page Object Model and test suite from URL |
| `run_tests` | Execute Cypress test specs |
| `test_component` | Test individual component |
| `create_fixture` | Create test fixture data |
| `setup_project` | Initialize Cypress in project |
| `get_results` | Retrieve test execution results |

---

## Configuration

### Cypress Configuration

```javascript
// cypress.config.js
module.exports = {
  e2e: {
    baseUrl: 'https://example.com',
    viewportWidth: 1280,
    viewportHeight: 720,
    video: true,
    screenshotOnRunFailure: true
  },
  component: {
    devServer: {
      framework: 'react',
      bundler: 'webpack'
    }
  }
};
```

---

## Comparison with Playwright

| Feature | Cypress | Playwright |
|---------|---------|------------|
| Component Testing | ✅ First-class | ⚠️ Limited |
| Time Travel Debugging | ✅ Yes | ❌ No |
| Auto-wait | ✅ Built-in | ✅ Built-in |
| Multi-tab | ❌ Limited | ✅ Easy |
| Browser Support | Chrome, Firefox, Edge | Chrome, Firefox, WebKit |
| Speed | ⚡ Fast (direct DOM) | ⚡ Fast (CDP) |

---

## Resources

- **GitHub:** https://github.com/jprealini/cypress-mcp
- **Cypress Docs:** https://docs.cypress.io/
- **MCP Protocol:** https://modelcontextprotocol.io/

---

## License

MIT License

---

## Version History

### v2025.0.0 (2025-10-18)
- Initial release as standalone MCP plugin
- Wrapper for jprealini/cypress-mcp
- Automated test generation and execution
