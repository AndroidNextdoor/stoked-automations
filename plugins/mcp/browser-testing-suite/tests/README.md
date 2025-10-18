# Browser Testing Suite - Test Documentation

This directory contains comprehensive tests for the Browser Testing Suite MCP plugin.

## Test Structure

```
tests/
├── unit/                           # Unit tests for individual MCP servers
│   ├── playwright-automation.test.ts
│   ├── selenium-webdriver.test.ts
│   ├── cypress-runner.test.ts
│   └── katalon-studio.test.ts
├── integration/                    # Integration tests for MCP protocol
│   └── mcp-server.test.ts
├── e2e/                           # End-to-end tests (future)
├── fixtures/                      # Test data and fixtures
│   └── sample-test-data.json
└── README.md                      # This file
```

## Running Tests

### Run All Tests
```bash
pnpm test
```

### Run Tests in Watch Mode
```bash
pnpm test:watch
```

### Run Tests with Coverage
```bash
pnpm test:coverage
```

### Run Specific Test File
```bash
pnpm test playwright-automation
pnpm test selenium-webdriver
pnpm test cypress-runner
pnpm test katalon-studio
```

### Run Integration Tests Only
```bash
pnpm test integration
```

## Test Coverage

The test suite covers:

### Playwright Automation Server (13 tools)
- ✅ Browser launch (chromium, firefox, webkit)
- ✅ Navigation with wait strategies
- ✅ Element interaction (click, type)
- ✅ Screenshots (full page, viewport)
- ✅ JavaScript evaluation
- ✅ Wait for selector
- ✅ Page content retrieval
- ✅ PDF generation
- ✅ Network recording
- ✅ Browser cleanup

### Selenium WebDriver Server (14 tools)
- ✅ Driver initialization (Chrome, Firefox)
- ✅ Navigation and URL management
- ✅ Element location (CSS, XPath, ID)
- ✅ Element interaction (click, sendKeys, clear)
- ✅ JavaScript execution
- ✅ Screenshots
- ✅ Wait conditions
- ✅ Frame handling
- ✅ Alert handling
- ✅ Cookie management
- ✅ Window management
- ✅ Drag and drop
- ✅ Driver cleanup

### Cypress Runner Server (6 tools)
- ✅ Cypress configuration generation
- ✅ E2E test templates
- ✅ Component test templates
- ✅ API test templates
- ✅ Visual regression tests
- ✅ Fixture data management
- ✅ Network interception
- ✅ Custom commands
- ✅ Assertion methods
- ✅ Viewport configuration

### Katalon Studio Server (9 tools)
- ✅ Project structure validation
- ✅ Test case generation (XML format)
- ✅ Test object repository (Page Object Model)
- ✅ Test suite configuration
- ✅ Custom keywords (Groovy)
- ✅ API testing
- ✅ Report generation
- ✅ Data-driven testing
- ✅ Execution profiles
- ✅ Browser configuration
- ✅ Self-healing locators

### MCP Server Integration
- ✅ Server initialization
- ✅ Tool registration
- ✅ Tool execution
- ✅ Response format validation
- ✅ Error handling
- ✅ Schema validation
- ✅ Concurrent request handling

## Test Requirements

### Browser Binaries Required

The following browser binaries must be installed:

- **Chromium**: Used by Playwright and Selenium tests
  ```bash
  npx playwright install chromium
  ```

- **Chrome**: Used by Selenium WebDriver tests
  - ChromeDriver must be available in PATH
  - Or use Selenium Manager (auto-downloads)

- **Cypress**: Browser bundled with Cypress installation
  ```bash
  npx cypress install
  ```

### Environment Setup

1. **Install dependencies:**
   ```bash
   pnpm install
   ```

2. **Install browser binaries:**
   ```bash
   npx playwright install chromium
   npx cypress install
   ```

3. **Build MCP servers:**
   ```bash
   pnpm build
   ```

## Test Configuration

### Vitest Configuration (`vitest.config.ts`)

```typescript
{
  test: {
    environment: 'node',
    testTimeout: 30000,      // 30 seconds per test
    hookTimeout: 30000,      // 30 seconds for hooks
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      include: ['servers/**/*.ts'],
    },
  }
}
```

### Timeouts

- **Test timeout**: 30 seconds (browser operations can be slow)
- **Hook timeout**: 30 seconds (browser initialization)
- **Teardown timeout**: 10 seconds

## Test Data

Test fixtures are located in `tests/fixtures/`:

- `sample-test-data.json` - Sample user credentials, URLs, selectors

### Using Test Fixtures

```typescript
import testData from '../fixtures/sample-test-data.json';

it('should login with test user', async () => {
  const user = testData.users[0];
  await page.goto(testData.testUrls.production);
  // ... use user.username, user.password
});
```

## Writing New Tests

### Unit Test Template

```typescript
import { describe, it, expect, beforeAll, afterAll } from 'vitest';

describe('My Feature Tests', () => {
  beforeAll(async () => {
    // Setup (e.g., launch browser)
  });

  afterAll(async () => {
    // Cleanup (e.g., close browser)
  });

  describe('Feature Group', () => {
    it('should do something', async () => {
      // Arrange
      const input = 'test';

      // Act
      const result = await doSomething(input);

      // Assert
      expect(result).toBe('expected');
    });
  });
});
```

### Integration Test Template

```typescript
import { describe, it, expect } from 'vitest';
import { Server } from '@modelcontextprotocol/sdk/server/index.js';

describe('MCP Server Integration', () => {
  it('should register and execute tool', async () => {
    const server = new Server(
      { name: 'test', version: '1.0.0' },
      { capabilities: { tools: {} } }
    );

    // Register tool
    server.setRequestHandler(ListToolsRequestSchema, async () => ({
      tools: [{ name: 'test_tool', description: 'Test', inputSchema: {} }],
    }));

    // Execute tool
    const response = await server.request(/* ... */);
    expect(response).toBeDefined();
  });
});
```

## CI/CD Integration

### GitHub Actions

```yaml
- name: Run tests
  run: pnpm test:ci

- name: Generate coverage
  run: pnpm test:coverage
```

### Test Coverage Goals

- **Unit tests**: >80% coverage
- **Integration tests**: All MCP protocol methods
- **E2E tests**: Critical user flows (future)

## Debugging Tests

### Run Single Test with Debug Output

```bash
pnpm test playwright-automation --reporter=verbose
```

### Debug in VS Code

Add to `.vscode/launch.json`:
```json
{
  "type": "node",
  "request": "launch",
  "name": "Debug Tests",
  "runtimeExecutable": "pnpm",
  "runtimeArgs": ["test", "--run"],
  "console": "integratedTerminal"
}
```

### Browser Debugging

For Playwright/Selenium tests with visible browser:

```typescript
const browser = await chromium.launch({
  headless: false,  // See browser UI
  slowMo: 100,      // Slow down operations
});
```

## Known Issues

1. **Selenium WebDriver**: Requires ChromeDriver in PATH
   - Solution: Use Selenium Manager or install manually

2. **Playwright**: First run downloads browsers
   - Solution: Run `npx playwright install` before tests

3. **Timeouts**: Some tests may timeout on slow machines
   - Solution: Increase timeout in vitest.config.ts

## Performance Benchmarks

Average test execution times:

- **Playwright unit tests**: ~2-3 seconds per test
- **Selenium unit tests**: ~3-4 seconds per test
- **Cypress unit tests**: <1 second (no browser launch)
- **Katalon unit tests**: <1 second (validation only)
- **Integration tests**: <1 second per test

**Total suite**: ~60-90 seconds

## Contributing

When adding new tests:

1. Follow existing test structure
2. Use descriptive test names
3. Add comments for complex logic
4. Include both positive and negative test cases
5. Clean up resources in `afterAll()`
6. Keep tests independent (no shared state)
7. Use test fixtures for sample data

## Resources

- [Vitest Documentation](https://vitest.dev/)
- [Playwright Testing Guide](https://playwright.dev/docs/test-intro)
- [Selenium WebDriver Docs](https://www.selenium.dev/documentation/)
- [Cypress Best Practices](https://docs.cypress.io/guides/references/best-practices)
- [MCP SDK Documentation](https://github.com/modelcontextprotocol/sdk)