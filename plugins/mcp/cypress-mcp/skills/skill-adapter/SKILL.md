---
name: Cypress MCP
description: |
  Cypress MCP server for component and E2E testing with automatic test generation. Activates when users mention:
  - Cypress testing, component testing, or E2E test automation
  - Generating Page Object Models or test suites automatically
  - Testing React, Vue, or Angular components in isolation
  - Creating test fixtures or test data
  - Time-travel debugging or Cypress-specific features
  - Modern JavaScript framework testing
---

## How It Works

This plugin provides access to **Cypress MCP server** (jprealini/cypress-mcp), enabling LLMs to generate, execute, and analyze Cypress tests through the Model Context Protocol.

**Core Capabilities:**
1. **Automatic Test Generation** - Analyzes web pages and generates Page Object Models + test suites
2. **Component Testing** - First-class support for React, Vue, Angular components in isolation
3. **E2E Test Execution** - Runs Cypress specs with video/screenshot capture on failure
4. **Time Travel Debugging** - Debug tests by traveling back to any point in execution
5. **Smart Selectors** - Generates reliable CSS/XPath selectors automatically
6. **Test Fixtures** - Creates structured test data for assertions

**Based on:** jprealini/cypress-mcp using Puppeteer + Cheerio for web analysis

## When to Use This Skill

Activate when users mention:

- **Test Generation:**
  - "Generate Cypress tests"
  - "Create Page Object Model"
  - "Analyze page and generate test suite"
  - "Auto-generate test cases"
  - "Create test fixtures"

- **Component Testing:**
  - "Test React component"
  - "Test Vue component in isolation"
  - "Component-level testing"
  - "Unit test UI components"
  - "Test Angular components"

- **E2E Testing:**
  - "Run Cypress E2E tests"
  - "Test user workflows"
  - "End-to-end test automation"
  - "Integration testing with Cypress"

- **Debugging:**
  - "Time travel debugging"
  - "Cypress test debugging"
  - "Why is my Cypress test failing?"
  - "Replay test execution"

- **Framework-Specific:**
  - "Cypress for React apps"
  - "Modern JavaScript testing"
  - "SPA testing with Cypress"

## Examples

**User:** "Generate Page Object Model and tests for https://stokedautomations.com/login"

**Skill activates** → Uses Cypress MCP to:
1. Scrape login page using Puppeteer + Cheerio
2. Analyze form structure, buttons, inputs
3. Generate LoginPage POM class with methods (visit, fillUsername, fillPassword, submit)
4. Create comprehensive test suite (login.spec.js) with success/failure scenarios
5. Generate smart CSS selectors (prefers data-testid, id, then class)

**Output:**
```javascript
// pages/LoginPage.js
class LoginPage {
  visit() { cy.visit('/login'); }
  fillUsername(username) { cy.get('#username').type(username); }
  fillPassword(password) { cy.get('#password').type(password); }
  submit() { cy.get('button[type="submit"]').click(); }
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

---

**User:** "Test this React Button component"

**Skill activates** → Sets up Cypress component testing:
```bash
/mcp cypress test_component component="Button.jsx" framework="react"
```

Generates component test:
```javascript
import Button from './Button';

describe('Button Component', () => {
  it('renders with text', () => {
    cy.mount(<Button>Click Me</Button>);
    cy.contains('Click Me').should('be.visible');
  });

  it('calls onClick handler', () => {
    const onClick = cy.stub();
    cy.mount(<Button onClick={onClick}>Submit</Button>);
    cy.contains('Submit').click();
    cy.wrap(onClick).should('be.called');
  });

  it('applies disabled state', () => {
    cy.mount(<Button disabled>Disabled</Button>);
    cy.get('button').should('be.disabled');
  });
});
```

---

**User:** "Run my Cypress E2E tests"

**Skill activates** → Executes Cypress test suite:
```bash
# Run all tests
/mcp cypress run_tests

# Run specific spec
/mcp cypress run_tests spec="tests/login.spec.js"

# Run in headed mode (see browser)
/mcp cypress run_tests headed=true
```

Provides execution results with:
- Pass/fail status for each test
- Screenshots of failures
- Video recordings (if enabled)
- Execution time breakdowns

---

**User:** "Create test fixtures for user data"

**Skill activates** → Generates structured test data:
```bash
/mcp cypress create_fixture name="users" data='[...]'
```

Creates `cypress/fixtures/users.json`:
```json
[
  {
    "id": 1,
    "username": "testuser",
    "email": "[email protected]",
    "role": "admin"
  },
  {
    "id": 2,
    "username": "normaluser",
    "email": "[email protected]",
    "role": "user"
  }
]
```

Can be loaded in tests: `cy.fixture('users').then((users) => { ... })`

## Installation

### NPM Installation
```bash
npm install -g cypress-mcp
```

### Claude Desktop Config
```json
{
  "mcpServers": {
    "cypress": {
      "command": "cypress-mcp"
    }
  }
}
```

### Claude Code Plugin
```bash
/plugin install cypress-mcp@stoked-automations
```

## Available MCP Tools

| Tool | Purpose |
|------|---------|
| `generate_test` | Generate Page Object Model and test suite from URL |
| `run_tests` | Execute Cypress test specs |
| `test_component` | Test individual component (React/Vue/Angular) |
| `create_fixture` | Create test fixture data |
| `setup_project` | Initialize Cypress in project |
| `get_results` | Retrieve test execution results |

## Key Features

**Test Generation:**
- Automatic Page Object Model creation
- Smart selector generation (data-testid > id > class)
- Web scraping with Puppeteer + Cheerio
- Comprehensive test suite scaffolding

**Component Testing (First-Class):**
- React Testing Library integration
- Vue Test Utils support
- Angular TestBed compatibility
- Isolated component mounting
- Fast execution (no full app load)

**Time Travel Debugging:**
- Hover over commands to see snapshots
- Travel back to any point in test execution
- Visual command log with DOM snapshots
- Unique to Cypress (not available in Playwright/Selenium)

**Automatic Features:**
- Auto-wait for elements (no manual `wait()` needed)
- Auto-retry assertions until timeout
- Screenshot on failure
- Video recording (optional)
- Network stubbing and mocking

## Configuration

### Cypress Configuration (cypress.config.js)
```javascript
module.exports = {
  e2e: {
    baseUrl: 'https://stokedautomations.com',
    viewportWidth: 1280,
    viewportHeight: 720,
    video: true,
    screenshotOnRunFailure: true,
    defaultCommandTimeout: 10000,
    retries: {
      runMode: 2,    // Retry failed tests in CI
      openMode: 0    // No retries in dev
    }
  },
  component: {
    devServer: {
      framework: 'react',  // or 'vue', 'angular'
      bundler: 'webpack'   // or 'vite'
    },
    specPattern: 'src/**/*.cy.{js,jsx,ts,tsx}'
  }
};
```

## Comparison with Playwright

| Feature | Cypress | Playwright |
|---------|---------|------------|
| **Component Testing** | ✅ First-class | ⚠️ Limited |
| **Time Travel Debugging** | ✅ Yes | ❌ No |
| **Auto-wait** | ✅ Built-in | ✅ Built-in |
| **Multi-tab Support** | ❌ Limited | ✅ Easy |
| **Browser Support** | Chrome, Firefox, Edge | Chrome, Firefox, WebKit |
| **Speed** | ⚡ Fast (direct DOM) | ⚡ Fast (CDP) |
| **Test Generation** | ✅ Yes (MCP) | ❌ Manual |

**Choose Cypress When:**
- Testing modern JavaScript frameworks (React/Vue/Angular)
- Component testing is a priority
- Time travel debugging is valuable
- Test generation from URLs is needed

**Choose Playwright When:**
- Multi-browser testing is required
- WebKit/Safari testing is needed
- Multi-tab workflows are common
- Accessibility tree analysis is important

## Best Practices

**ALWAYS:**
- Use `data-testid` attributes for reliable selectors
- Leverage Page Object Models for maintainability
- Enable video recording in CI for debugging failures
- Use fixtures for consistent test data
- Stub network requests for deterministic tests

**NEVER:**
- Use fragile CSS selectors (`.btn.btn-primary.active`)
- Add arbitrary `cy.wait(5000)` (use auto-wait instead)
- Test external sites (use stubbed API responses)
- Rely on timing-dependent assertions
- Share state between tests (use `beforeEach` for setup)

## Common Patterns

### Page Object Model Pattern
```javascript
// pages/DashboardPage.js
class DashboardPage {
  visit() {
    cy.visit('/dashboard');
  }

  getSidebar() {
    return cy.get('[data-testid="sidebar"]');
  }

  clickMenuItem(item) {
    this.getSidebar().contains(item).click();
  }

  verifyPageTitle(title) {
    cy.get('h1').should('contain', title);
  }
}
```

### Network Stubbing
```javascript
cy.intercept('GET', '/api/users', { fixture: 'users.json' }).as('getUsers');
cy.visit('/users');
cy.wait('@getUsers');
```

### Custom Commands
```javascript
// cypress/support/commands.js
Cypress.Commands.add('login', (username, password) => {
  cy.visit('/login');
  cy.get('#username').type(username);
  cy.get('#password').type(password);
  cy.get('button[type="submit"]').click();
});

// In tests:
cy.login('testuser', 'testpass');
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Timeout errors | Increase `defaultCommandTimeout` in config |
| Element not found | Check selector, ensure element exists in DOM |
| Flaky tests | Use `cy.wait('@alias')` instead of `cy.wait(ms)` |
| Component won't mount | Verify devServer config matches project setup |
| Video not recording | Enable `video: true` in config |

## Resources

- **GitHub Repository:** https://github.com/jprealini/cypress-mcp
- **Cypress Official Docs:** https://docs.cypress.io/
- **Component Testing Guide:** https://docs.cypress.io/guides/component-testing/overview
- **Best Practices:** https://docs.cypress.io/guides/references/best-practices
- **MCP Protocol:** https://modelcontextprotocol.io/

## Version & License

- **Version:** 2025.0.0
- **License:** MIT
- **Author:** jprealini
- **Repository:** https://github.com/AndroidNextdoor/stoked-automations (plugin wrapper)