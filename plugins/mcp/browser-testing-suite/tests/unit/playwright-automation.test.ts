import { describe, it, expect, beforeAll, afterAll, beforeEach } from 'vitest';
import { chromium, Browser, Page } from 'playwright';

/**
 * Unit tests for Playwright Automation MCP Server
 * Tests individual tool functionality without full MCP server integration
 */

describe('Playwright Automation Server - Unit Tests', () => {
  let browser: Browser;
  let page: Page;

  beforeAll(async () => {
    // Launch browser for testing
    browser = await chromium.launch({ headless: true });
    const context = await browser.newContext();
    page = await context.newPage();
  });

  afterAll(async () => {
    await browser?.close();
  });

  describe('Browser Launch', () => {
    it('should launch chromium browser', async () => {
      const testBrowser = await chromium.launch({ headless: true });
      expect(testBrowser).toBeDefined();
      expect(testBrowser.isConnected()).toBe(true);
      await testBrowser.close();
    });

    it('should launch firefox browser', async () => {
      const { firefox } = await import('playwright');
      const testBrowser = await firefox.launch({ headless: true });
      expect(testBrowser).toBeDefined();
      expect(testBrowser.isConnected()).toBe(true);
      await testBrowser.close();
    });

    it('should launch with slowMo option', async () => {
      const testBrowser = await chromium.launch({
        headless: true,
        slowMo: 100,
      });
      expect(testBrowser).toBeDefined();
      await testBrowser.close();
    });
  });

  describe('Navigation', () => {
    it('should navigate to a URL', async () => {
      await page.goto('https://stokedautomations.com');
      expect(page.url()).toBe('https://stokedautomations.com/');
    });

    it('should wait for load event', async () => {
      const response = await page.goto('https://stokedautomations.com', {
        waitUntil: 'load',
      });
      expect(response?.status()).toBe(200);
    });

    it('should respect timeout parameter', async () => {
      await expect(
        page.goto('https://stokedautomations.com', { timeout: 5000 })
      ).resolves.toBeDefined();
    });
  });

  describe('Element Interaction', () => {
    beforeEach(async () => {
      await page.goto('https://stokedautomations.com');
    });

    it('should click elements', async () => {
      const linkSelector = 'a';
      await page.waitForSelector(linkSelector);
      await expect(page.click(linkSelector)).resolves.toBeUndefined();
    });

    it('should type text into inputs', async () => {
      // Create a test input dynamically
      await page.evaluate(() => {
        return new Promise((resolve) => {
          const input = document.createElement('input');
          input.id = 'test-input';
          document.body.appendChild(input);
          resolve(undefined);
        });
      });

      await page.waitForSelector('#test-input');
      await page.type('#test-input', 'Hello World');
      const value = await page.inputValue('#test-input');
      expect(value).toBe('Hello World');
    });

    it('should type with delay', async () => {
      await page.evaluate(() => {
        return new Promise((resolve) => {
          const input = document.createElement('input');
          input.id = 'delayed-input';
          document.body.appendChild(input);
          resolve(undefined);
        });
      });

      await page.waitForSelector('#delayed-input');
      const startTime = Date.now();
      await page.type('#delayed-input', 'ABC', { delay: 50 });
      const elapsed = Date.now() - startTime;

      // 3 characters * 50ms delay = ~150ms minimum
      expect(elapsed).toBeGreaterThanOrEqual(150);
    });
  });

  describe('Screenshots', () => {
    it('should capture full page screenshot', async () => {
      await page.goto('https://stokedautomations.com');
      const screenshot = await page.screenshot({ fullPage: true });
      expect(screenshot).toBeInstanceOf(Buffer);
      expect(screenshot.length).toBeGreaterThan(0);
    });

    it('should capture viewport screenshot', async () => {
      await page.goto('https://stokedautomations.com');
      const screenshot = await page.screenshot({ fullPage: false });
      expect(screenshot).toBeInstanceOf(Buffer);
    });

    it('should support different image formats', async () => {
      await page.goto('https://stokedautomations.com');

      const pngScreenshot = await page.screenshot({ type: 'png' });
      const jpegScreenshot = await page.screenshot({ type: 'jpeg' });

      expect(pngScreenshot).toBeInstanceOf(Buffer);
      expect(jpegScreenshot).toBeInstanceOf(Buffer);
    });
  });

  describe('JavaScript Evaluation', () => {
    it('should evaluate JavaScript in page context', async () => {
      await page.goto('https://stokedautomations.com');
      const result = await page.evaluate(() => {
        return document.title;
      });
      expect(result).toContain('Stoked');
    });

    it('should return evaluation results', async () => {
      const result = await page.evaluate(() => {
        return { foo: 'bar', count: 42 };
      });
      expect(result).toEqual({ foo: 'bar', count: 42 });
    });

    it('should pass arguments to evaluation', async () => {
      const result = await page.evaluate(({ x, y }) => x + y, { x: 10, y: 20 });
      expect(result).toBe(30);
    });
  });

  describe('Wait for Selector', () => {
    it('should wait for selector to be visible', async () => {
      await page.goto('https://stokedautomations.com');
      await expect(
        page.waitForSelector('h1', { state: 'visible', timeout: 5000 })
      ).resolves.toBeDefined();
    });

    it('should wait for selector to be attached', async () => {
      await page.goto('https://stokedautomations.com');
      await expect(
        page.waitForSelector('body', { state: 'attached' })
      ).resolves.toBeDefined();
    });

    it('should timeout when selector not found', async () => {
      await page.goto('https://stokedautomations.com');
      await expect(
        page.waitForSelector('#nonexistent', { timeout: 1000 })
      ).rejects.toThrow();
    });
  });

  describe('Page Content', () => {
    it('should get HTML content', async () => {
      await page.goto('https://stokedautomations.com');
      const content = await page.content();
      expect(content).toContain('<!DOCTYPE html>');
      expect(content).toContain('Stoked');
    });

    it('should get page title', async () => {
      await page.goto('https://stokedautomations.com');
      const title = await page.title();
      expect(title).toContain('Stoked');
    });
  });

  describe('PDF Generation', () => {
    it('should generate PDF', async () => {
      await page.goto('https://stokedautomations.com');
      const pdf = await page.pdf({ format: 'A4' });
      expect(pdf).toBeInstanceOf(Buffer);
      expect(pdf.length).toBeGreaterThan(0);
      // PDF magic number
      expect(pdf.toString('utf8', 0, 4)).toBe('%PDF');
    });

    it('should generate PDF with custom format', async () => {
      await page.goto('https://stokedautomations.com');
      const pdf = await page.pdf({
        format: 'Letter',
        printBackground: true,
      });
      expect(pdf).toBeInstanceOf(Buffer);
    });
  });

  describe('Network Recording', () => {
    it('should record network requests', async () => {
      const requests: string[] = [];

      page.on('request', (request) => {
        requests.push(request.url());
      });

      await page.goto('https://stokedautomations.com');

      expect(requests.length).toBeGreaterThan(0);
      expect(requests[0]).toContain('stokedautomations.com');
    });

    it('should capture response details', async () => {
      const responses: Array<{ url: string; status: number }> = [];

      page.on('response', (response) => {
        responses.push({
          url: response.url(),
          status: response.status(),
        });
      });

      await page.goto('https://stokedautomations.com');

      expect(responses.length).toBeGreaterThan(0);
      expect(responses[0].status).toBe(200);
    });

    it('should disable network recording', async () => {
      page.removeAllListeners('response');

      const responses: string[] = [];
      const handler = (response: any) => responses.push(response.url());

      page.on('response', handler);
      page.removeListener('response', handler);

      await page.goto('https://stokedautomations.com');
      expect(responses.length).toBe(0);
    });
  });

  describe('Browser Cleanup', () => {
    it('should close browser properly', async () => {
      const testBrowser = await chromium.launch({ headless: true });
      expect(testBrowser.isConnected()).toBe(true);

      await testBrowser.close();
      expect(testBrowser.isConnected()).toBe(false);
    });
  });
});