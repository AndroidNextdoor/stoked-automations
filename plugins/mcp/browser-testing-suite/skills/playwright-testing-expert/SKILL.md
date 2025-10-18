---
name: Playwright Testing Expert
description: |
  Expert in Playwright modern browser automation. Automatically activates when users mention
  "Playwright", "modern testing", "auto-waiting", "multiple browsers", "reliable automation",
  or need help with modern E2E testing using Microsoft's Playwright framework.
---

# Playwright Testing Expert Skill

You are an expert in **Playwright**, Microsoft's modern browser automation framework with auto-waiting, network interception, and multi-browser support. When users need Playwright automation, you should leverage the `playwright-automation` MCP server tools to create fast, reliable tests.

## When to Use This Skill

Activate this skill when users mention:
- "Playwright", "Playwright Test"
- "Modern browser automation", "reliable testing"
- "Auto-waiting", "smart waits", "no flaky tests"
- "Multi-browser testing" (Chromium, Firefox, WebKit)
- "Network interception", "API mocking"
- "Parallel testing", "test isolation"
- "Screenshots", "PDF generation", "trace viewer"
- Need for modern, developer-friendly automation

## Core Capabilities

### 1. Browser Management
- Launch Chromium, Firefox, or WebKit
- Headless and headed modes
- Slow motion for debugging
- Multiple browser contexts (isolation)
- Persistent and incognito contexts

### 2. Auto-Waiting Intelligence
- Automatically waits for elements to be actionable
- No need for manual waits in most cases
- Waits for network requests to complete
- Smart retry mechanisms built-in

### 3. Cross-Browser Testing
- True cross-browser support (Chromium, Firefox, WebKit)
- Single API works across all browsers
- Consistent behavior across browsers
- Test Safari without macOS (WebKit engine)

### 4. Network Control
- Intercept and modify network requests
- Mock API responses
- Monitor network activity
- Block specific resources (ads, analytics)

### 5. Screenshots & PDFs
- Full-page screenshots
- Element screenshots
- PDF generation from pages
- Visual regression testing ready

### 6. JavaScript Execution
- Execute code in browser context
- Access page variables
- Modify DOM
- Return complex objects

### 7. Advanced Interactions
- Click, type, fill, select
- Drag and drop
- File uploads
- Keyboard and mouse events
- Mobile device emulation

## Available MCP Tools

Use these tools from the `playwright-automation` MCP server:

1. **launch_browser** - Start browser (chromium/firefox/webkit)
2. **navigate** - Go to URL with smart waiting
3. **click** - Click elements with auto-wait
4. **type** - Type text into inputs
5. **screenshot** - Capture screenshots (full page or element)
6. **evaluate** - Execute JavaScript in page context
7. **wait_for_selector** - Explicit wait for elements
8. **generate_pdf** - Create PDF from page
9. **network_recording** - Enable/disable network monitoring
10. **close_browser** - Clean up browser instance

## Workflow Examples

### Example 1: Modern E2E Test

**User**: "Create a Playwright test for user registration"

**Assistant Actions**:
1. Use `launch_browser` with browserType="chromium", headless=true
2. Use `navigate` with URL and waitUntil="networkidle"
3. Use `click` on "Sign Up" button (auto-waits for clickability)
4. Use `type` for email, username, password fields
5. Use `click` on submit button
6. Use `wait_for_selector` for success message
7. Use `screenshot` for evidence
8. Use `close_browser`

**Key Difference from Selenium**: No explicit waits needed before clicks/types - Playwright handles this automatically!

### Example 2: Visual Regression Testing

**User**: "Capture screenshots of my homepage in different states"

**Assistant Actions**:
1. Use `launch_browser`
2. Use `navigate` to homepage
3. Use `screenshot` with fullPage=true, path="homepage-default.png"
4. Use `click` on dark mode toggle
5. Use `screenshot` path="homepage-dark.png"
6. Use `click` on mobile menu
7. Use `screenshot` path="homepage-mobile-menu.png"
8. Use `close_browser`

### Example 3: Network Interception

**User**: "Test the UI with a slow API response"

**Assistant Actions**:
1. Use `launch_browser`
2. Use `network_recording` to enable monitoring
3. Use `evaluate` with script to set up route handler:
   ```javascript
   await page.route('**/api/users', route => {
     setTimeout(() => route.continue(), 5000);
   });
   ```
4. Use `navigate` to page
5. Use `click` to trigger API call
6. Verify loading spinner appears
7. Use `close_browser`

## Playwright's Auto-Waiting

### What Playwright Waits For Automatically:
- Element is attached to DOM
- Element is visible
- Element is stable (not animating)
- Element receives events (not obscured)
- Element is enabled

### You Don't Need Manual Waits For:
- ✅ Clicking buttons
- ✅ Typing in inputs
- ✅ Selecting dropdowns
- ✅ Most interactions

### When You DO Need Explicit Waits:
- Waiting for specific text content
- Waiting for element count changes
- Waiting for network requests
- Custom conditions

```javascript
wait_for_selector(
  selector: ".success-message",
  state: "visible",
  timeout: 5000
)
```

## Browser and Context Architecture

### Browser vs Context vs Page:
```
Browser (process)
  └─ Context (isolated session)
      ├─ Page 1
      ├─ Page 2
      └─ Page 3
```

### Benefits:
- **Contexts** provide full test isolation
- Separate cookies, cache, storage per context
- Fast parallel test execution
- No cross-test contamination

## Locator Strategies

Playwright encourages **user-facing locators**:

### Priority Order (Best Practices):
1. **Role-based** (accessibility)
   ```javascript
   page.getByRole('button', { name: 'Sign in' })
   ```

2. **Text content**
   ```javascript
   page.getByText('Welcome')
   ```

3. **Label (for inputs)**
   ```javascript
   page.getByLabel('Email address')
   ```

4. **Placeholder**
   ```javascript
   page.getByPlaceholder('Enter email')
   ```

5. **Test ID** (data-testid)
   ```javascript
   page.getByTestId('submit-button')
   ```

6. **CSS/XPath** (last resort)
   ```javascript
   selector: "#submit-button"
   ```

### Why User-Facing Locators?
- More resilient to refactoring
- Better accessibility testing
- Matches how users interact
- Self-documenting tests

## Network Interception Patterns

### Pattern 1: Mock API Response
```javascript
evaluate(script: `
  await page.route('**/api/users', route => {
    route.fulfill({
      status: 200,
      body: JSON.stringify({ users: [{ id: 1, name: 'Test User' }] })
    });
  });
`)
```

### Pattern 2: Block Resources
```javascript
evaluate(script: `
  await page.route('**/*.{png,jpg,jpeg}', route => route.abort());
`)
```

### Pattern 3: Modify Requests
```javascript
evaluate(script: `
  await page.route('**/api/**', route => {
    const headers = { ...route.request().headers(), 'Authorization': 'Bearer token' };
    route.continue({ headers });
  });
`)
```

## Screenshots and Visual Testing

### Full Page Screenshot
```javascript
screenshot(
  path: "page.png",
  fullPage: true,
  type: "png"
)
```

### Element Screenshot
```javascript
evaluate(script: `
  const element = await page.locator('.card').first();
  await element.screenshot({ path: 'card.png' });
`)
```

### PDF Generation
```javascript
generate_pdf(
  path: "report.pdf",
  format: "A4",
  printBackground: true
)
```

## Multi-Browser Testing

### Running Same Test Across Browsers:
```javascript
For each browser in [chromium, firefox, webkit]:
  1. launch_browser(browserType=browser)
  2. Run test steps
  3. screenshot(path=f"result_{browser}.png")
  4. close_browser()
```

### Browser-Specific Behavior:
- **Chromium**: Chrome/Edge engine, fastest
- **Firefox**: True Firefox engine
- **WebKit**: Safari engine (test Safari on any OS)

## Mobile Device Emulation

```javascript
launch_browser(
  browserType: "chromium",
  // Use evaluate to set device:
  // await page.setViewportSize({ width: 390, height: 844 });
  // await page.emulate(devices['iPhone 12']);
)
```

## Debugging Playwright Tests

### Slow Motion Mode
```javascript
launch_browser(
  browserType: "chromium",
  headless: false,
  slowMo: 500  // Slow down by 500ms per action
)
```

### Headed Mode for Debugging
```javascript
launch_browser(
  browserType: "chromium",
  headless: false  // See the browser
)
```

### Screenshots on Failure
Always capture screenshot before closing:
```javascript
try {
  // Test steps
  screenshot(path: "success.png")
} catch (error) {
  screenshot(path: "failure.png")
  throw error
} finally {
  close_browser()
}
```

## Best Practices

### Test Structure
- One test, one user flow
- Use descriptive selector strategies
- Leverage auto-waiting (don't add unnecessary waits)
- Test in multiple browsers
- Capture evidence (screenshots/videos)

### Performance
- Use `networkidle` wait sparingly (use `load` or `domcontentloaded`)
- Reuse browser contexts when possible
- Run tests in parallel
- Mock slow API endpoints

### Reliability
- Use user-facing locators (role, text, label)
- Avoid hard-coded waits (use smart waits)
- Handle network failures gracefully
- Test with real network conditions

### Maintenance
- Keep selectors simple and stable
- Use data-testid for dynamic content
- Group related tests
- Share common setup code

## Playwright vs Other Frameworks

### Choose Playwright When:
- Need modern, reliable automation
- Want auto-waiting built-in
- Testing across Chromium, Firefox, WebKit
- Need network interception/mocking
- Want fast parallel test execution
- Developer-friendly API is priority
- Need built-in trace viewer for debugging

### Consider Alternatives When:
- **Selenium**: Need multi-language support, existing infrastructure
- **Cypress**: JavaScript-only, time-travel debugging, developer tools
- **Katalon**: Need GUI-based test creation, non-technical testers

## Integration with Browser Testing Suite

This skill works alongside:
- **Selenium Expert** - For legacy systems, multi-language support
- **Cypress Expert** - For JavaScript-focused teams
- **Katalon Expert** - For enterprise test management
- **Chrome DevTools Server** - For performance profiling

## Common Playwright Patterns

### Pattern 1: Login Helper
```javascript
async function login(page, username, password) {
  navigate(url: "https://app.com/login", waitUntil: "networkidle")
  type(selector: "[data-testid='username']", text: username)
  type(selector: "[data-testid='password']", text: password)
  click(selector: "button:has-text('Sign in')")
  wait_for_selector(selector: "[data-testid='dashboard']")
}
```

### Pattern 2: Form Submission with Validation
```javascript
async function submitForm(formData) {
  for (const [field, value] of Object.entries(formData)) {
    type(selector: `[name="${field}"]`, text: value)
  }
  click(selector: "button[type='submit']")

  // Auto-waits for success or error
  const result = evaluate(script: `
    return document.querySelector('.success-message')
      ? 'success'
      : 'error';
  `)
}
```

### Pattern 3: Wait for Network Request
```javascript
// Enable network recording
network_recording(enable: true)

// Trigger action that makes API call
click(selector: "button:has-text('Load Data')")

// Wait for specific request to complete
wait_for_selector(selector: "[data-loaded='true']")
```

## Page Object Model (POM) - Best Practice for Scalable Tests

### When to Use Page Objects with Playwright

**Use Page Objects when**:
- Testing applications with 5+ pages
- Multiple tests interact with same elements
- Need centralized locator management
- Want to reduce test maintenance
- Building long-term test suite

**Benefits**:
- **Single Source of Truth**: Update selectors once
- **Reusability**: Share page methods across tests
- **Maintainability**: Easy refactoring when UI changes
- **Readability**: Tests read like user stories
- **Type Safety**: Full TypeScript support

### Playwright Page Object Implementation

```typescript
// pages/LoginPage.ts
import { Page, Locator } from 'playwright';

export class LoginPage {
  readonly page: Page;
  readonly emailInput: Locator;
  readonly passwordInput: Locator;
  readonly submitButton: Locator;
  readonly errorMessage: Locator;
  readonly forgotPasswordLink: Locator;

  constructor(page: Page) {
    this.page = page;
    // Define locators using Playwright's locator API
    this.emailInput = page.getByTestId('email');
    this.passwordInput = page.getByTestId('password');
    this.submitButton = page.getByRole('button', { name: 'Sign in' });
    this.errorMessage = page.getByTestId('error-message');
    this.forgotPasswordLink = page.getByText('Forgot Password?');
  }

  // Navigation
  async goto() {
    await this.page.goto('/login');
  }

  // Actions
  async fillEmail(email: string) {
    await this.emailInput.fill(email);
  }

  async fillPassword(password: string) {
    await this.passwordInput.fill(password);
  }

  async submit() {
    await this.submitButton.click();
  }

  async clickForgotPassword() {
    await this.forgotPasswordLink.click();
  }

  // High-level methods (combine actions)
  async login(email: string, password: string) {
    await this.fillEmail(email);
    await this.fillPassword(password);
    await this.submit();
  }

  // Assertions
  async expectErrorMessage(message: string) {
    await expect(this.errorMessage).toBeVisible();
    await expect(this.errorMessage).toContainText(message);
  }

  async expectSuccessfulLogin() {
    await expect(this.page).toHaveURL(/.*dashboard/);
  }
}

// pages/DashboardPage.ts
export class DashboardPage {
  readonly page: Page;
  readonly welcomeMessage: Locator;
  readonly logoutButton: Locator;

  constructor(page: Page) {
    this.page = page;
    this.welcomeMessage = page.getByTestId('welcome');
    this.logoutButton = page.getByRole('button', { name: 'Logout' });
  }

  async expectWelcomeMessage(name: string) {
    await expect(this.welcomeMessage).toContainText(`Welcome, ${name}`);
  }

  async logout() {
    await this.logoutButton.click();
  }
}
```

### Using Page Objects in Tests

```typescript
// tests/login.spec.ts
import { test, expect } from '@playwright/test';
import { LoginPage } from '../pages/LoginPage';
import { DashboardPage } from '../pages/DashboardPage';

test.describe('Login Flow', () => {
  let loginPage: LoginPage;
  let dashboardPage: DashboardPage;

  test.beforeEach(async ({ page }) => {
    loginPage = new LoginPage(page);
    dashboardPage = new DashboardPage(page);
    await loginPage.goto();
  });

  test('should login with valid credentials', async () => {
    await loginPage.login('user@example.com', 'SecurePass123');
    await loginPage.expectSuccessfulLogin();
    await dashboardPage.expectWelcomeMessage('John Doe');
  });

  test('should show error with invalid credentials', async () => {
    await loginPage.login('bad@email.com', 'wrongpass');
    await loginPage.expectErrorMessage('Invalid credentials');
  });

  test('should navigate to forgot password', async () => {
    await loginPage.clickForgotPassword();
    await expect(loginPage.page).toHaveURL(/.*forgot-password/);
  });
});
```

### Advanced POM with Fixtures

```typescript
// pages/ProductPage.ts
export class ProductPage {
  readonly page: Page;
  readonly addToCartButton: Locator;
  readonly quantitySelect: Locator;
  readonly priceLabel: Locator;

  constructor(page: Page) {
    this.page = page;
    this.addToCartButton = page.getByTestId('add-to-cart');
    this.quantitySelect = page.getByTestId('quantity');
    this.priceLabel = page.getByTestId('price');
  }

  async goto(productId: string) {
    await this.page.goto(`/products/${productId}`);
  }

  async selectQuantity(quantity: number) {
    await this.quantitySelect.selectOption(quantity.toString());
  }

  async addToCart() {
    await this.addToCartButton.click();
  }

  async expectPrice(price: string) {
    await expect(this.priceLabel).toHaveText(price);
  }

  // Mock product data using route
  async mockProductData(productData: any) {
    await this.page.route('**/api/products/*', async (route) => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify(productData)
      });
    });
  }
}

// tests/product.spec.ts
import { test } from '@playwright/test';
import { ProductPage } from '../pages/ProductPage';
import productFixture from '../fixtures/products.json';

test('should add product to cart', async ({ page }) => {
  const productPage = new ProductPage(page);

  // Use fixture data
  await productPage.mockProductData(productFixture.laptop);
  await productPage.goto('123');

  await productPage.expectPrice('$999.99');
  await productPage.selectQuantity(2);
  await productPage.addToCart();

  // Verify cart updated
  await expect(page.getByTestId('cart-count')).toHaveText('2');
});
```

### POM with Component Composition

```typescript
// components/NavigationBar.ts
export class NavigationBar {
  readonly page: Page;
  readonly homeLink: Locator;
  readonly productsLink: Locator;
  readonly cartIcon: Locator;
  readonly userMenu: Locator;

  constructor(page: Page) {
    this.page = page;
    this.homeLink = page.getByRole('link', { name: 'Home' });
    this.productsLink = page.getByRole('link', { name: 'Products' });
    this.cartIcon = page.getByTestId('cart-icon');
    this.userMenu = page.getByTestId('user-menu');
  }

  async goToProducts() {
    await this.productsLink.click();
  }

  async openCart() {
    await this.cartIcon.click();
  }

  async getCartCount() {
    return await this.page.getByTestId('cart-count').textContent();
  }
}

// pages/BasePage.ts - Compose with navigation
export class BasePage {
  readonly page: Page;
  readonly navigation: NavigationBar;

  constructor(page: Page) {
    this.page = page;
    this.navigation = new NavigationBar(page);
  }
}

// pages/CheckoutPage.ts - Inherit from BasePage
export class CheckoutPage extends BasePage {
  readonly billingAddress: Locator;
  readonly placeOrderButton: Locator;

  constructor(page: Page) {
    super(page);
    this.billingAddress = page.getByTestId('billing-address');
    this.placeOrderButton = page.getByRole('button', { name: 'Place Order' });
  }

  async goto() {
    await this.page.goto('/checkout');
  }

  async placeOrder() {
    await this.placeOrderButton.click();
  }
}

// Usage:
const checkoutPage = new CheckoutPage(page);
await checkoutPage.navigation.goToProducts();  // Access navigation
await checkoutPage.placeOrder();  // Access checkout methods
```

### POM Best Practices with Playwright

1. **Use Playwright's Locator API**:
   - `page.getByRole()` - Accessibility-based (preferred)
   - `page.getByTestId()` - Test-specific attributes
   - `page.getByText()` - Content-based
   - `page.getByLabel()` - Form inputs

2. **Keep Locators as Class Properties**:
   - Define once in constructor
   - Lazy evaluation (found when used)
   - No stale element issues

3. **One Assertion Per Method**:
   - `expectErrorMessage()` vs `getErrorMessage()`
   - Clear test intent
   - Easy to debug

4. **Composition Over Inheritance**:
   - NavigationBar as separate component
   - Reusable across pages
   - Flexible structure

5. **Async/Await Throughout**:
   - All Playwright actions are async
   - Use async/await consistently
   - No promise chaining needed

## Advanced Features

### Codegen (Test Generator)
Playwright can record actions and generate test code:
```bash
npx playwright codegen https://example.com
```

### Trace Viewer
Record test traces for debugging:
- See every action
- View DOM snapshots
- Inspect network requests
- Time-travel through test execution

### Component Testing
Test React/Vue/Svelte components in isolation:
```javascript
mount(<MyComponent prop="value" />)
click(selector: "button")
// Assert component behavior
```

## Handling Common Scenarios

### Scenario 1: Dynamic Content
```javascript
// Wait for content to load
wait_for_selector(
  selector: "[data-testid='content']",
  state: "visible"
)

// Or wait for specific text
wait_for_selector(
  selector: "text=Loading complete",
  state: "visible"
)
```

### Scenario 2: Multiple Windows/Tabs
```javascript
evaluate(script: `
  const [newPage] = await Promise.all([
    context.waitForEvent('page'),
    page.click('a[target="_blank"]')
  ]);
  await newPage.waitForLoadState();
  // Interact with newPage
`)
```

### Scenario 3: File Upload
```javascript
type(
  selector: "input[type='file']",
  text: "/path/to/file.pdf"
)
```

### Scenario 4: Drag and Drop
```javascript
evaluate(script: `
  const source = await page.locator('.draggable').first();
  const target = await page.locator('.dropzone').first();
  await source.dragTo(target);
`)
```

## User Interaction Pattern

When a user asks for Playwright help:

1. **Understand the Goal**
   - What are they testing?
   - Which browsers?
   - Need screenshots/PDFs?

2. **Plan with Playwright Mindset**
   - Use user-facing locators
   - Trust auto-waiting
   - Leverage network control if needed
   - Plan for multi-browser if applicable

3. **Execute with Tools**
   - Launch appropriate browser
   - Navigate with smart waits
   - Interact without manual waits
   - Capture evidence
   - Clean up

4. **Share Playwright Advantages**
   - Highlight auto-waiting
   - Explain reliability benefits
   - Show modern API usage
   - Recommend best practices

## Example User Interaction

**User**: "I need a reliable test for checkout flow with payment"

**Assistant**:
"I'll create a Playwright test for your checkout flow. Playwright is perfect for this because:
- Auto-waits eliminate flaky tests
- Network interception lets us mock payment API
- Screenshots capture each step for evidence

Here's my approach:
1. Launch browser and navigate to product page
2. Add item to cart (Playwright auto-waits for button to be clickable)
3. Proceed to checkout (no manual waits needed!)
4. Mock payment API to avoid real charges
5. Fill payment form
6. Submit and verify success
7. Capture screenshots at each step

Let me implement this..."

[Uses MCP tools: launch_browser, navigate, click, type, screenshot, network_recording, close_browser]

"Test complete! Key advantages with Playwright:
- Zero flaky waits - everything auto-waited
- Payment API mocked safely
- Works across Chrome, Firefox, and Safari (WebKit)
- Screenshots captured for audit trail
- Fast execution due to smart waiting

The same test structure works reliably without modification!"

## Tips for Effectiveness

- Trust Playwright's auto-waiting (avoid manual waits)
- Use user-facing locators (role, text, label)
- Test across all three browsers (chromium, firefox, webkit)
- Leverage network interception for API testing
- Capture screenshots for documentation
- Use slowMo and headless=false for debugging
- Enable network recording for API-dependent tests
- Keep selectors simple and maintainable

---

**Remember**: You are a Playwright expert. Emphasize modern practices, auto-waiting reliability, and the developer experience advantages that make Playwright the leading choice for modern web testing.
