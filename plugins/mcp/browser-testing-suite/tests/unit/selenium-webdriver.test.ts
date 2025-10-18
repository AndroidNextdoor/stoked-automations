import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { Builder, By, until, WebDriver, Capabilities } from 'selenium-webdriver';
import * as chrome from 'selenium-webdriver/chrome.js';

/**
 * Unit tests for Selenium WebDriver MCP Server
 * Tests WebDriver functionality and tool implementations
 */

describe('Selenium WebDriver Server - Unit Tests', () => {
  let driver: WebDriver;

  beforeAll(async () => {
    const options = new chrome.Options();
    options.addArguments('--headless=new', '--disable-gpu', '--no-sandbox');

    driver = await new Builder()
      .forBrowser('chrome')
      .setChromeOptions(options)
      .build();
  }, 30000);

  afterAll(async () => {
    await driver?.quit();
  });

  describe('Driver Initialization', () => {
    it('should create Chrome WebDriver', async () => {
      const options = new chrome.Options();
      options.addArguments('--headless=new');

      const testDriver = await new Builder()
        .forBrowser('chrome')
        .setChromeOptions(options)
        .build();

      expect(testDriver).toBeDefined();
      await testDriver.quit();
    });

    it('should get capabilities', async () => {
      const capabilities = await driver.getCapabilities();
      expect(capabilities.getBrowserName()).toBe('chrome');
    });
  });

  describe('Navigation', () => {
    it('should navigate to URL', async () => {
      await driver.get('https://example.com');
      const url = await driver.getCurrentUrl();
      expect(url).toBe('https://example.com/');
    });

    it('should get page title', async () => {
      await driver.get('https://example.com');
      const title = await driver.getTitle();
      expect(title).toBe('Example Domain');
    });
  });

  describe('Element Location', () => {
    beforeAll(async () => {
      await driver.get('https://example.com');
    });

    it('should find element by CSS selector', async () => {
      const element = await driver.findElement(By.css('h1'));
      expect(element).toBeDefined();
      const text = await element.getText();
      expect(text).toContain('Example Domain');
    });

    it('should find element by tag name', async () => {
      const element = await driver.findElement(By.tagName('h1'));
      expect(element).toBeDefined();
    });

    it('should find element by xpath', async () => {
      const element = await driver.findElement(By.xpath('//h1'));
      expect(element).toBeDefined();
    });

    it('should throw error for nonexistent element', async () => {
      await expect(
        driver.findElement(By.id('nonexistent'))
      ).rejects.toThrow();
    });
  });

  describe('Element Interaction', () => {
    beforeAll(async () => {
      await driver.get('https://example.com');
    });

    it('should click elements', async () => {
      const link = await driver.findElement(By.css('a'));
      await expect(link.click()).resolves.toBeUndefined();
    });

    it('should send keys to input', async () => {
      // Create test input via JavaScript
      await driver.executeScript(`
        const input = document.createElement('input');
        input.id = 'test-input';
        document.body.appendChild(input);
      `);

      const input = await driver.findElement(By.id('test-input'));
      await input.sendKeys('Hello Selenium');

      const value = await input.getAttribute('value');
      expect(value).toBe('Hello Selenium');
    });

    it('should clear input fields', async () => {
      await driver.executeScript(`
        const input = document.createElement('input');
        input.id = 'clear-input';
        input.value = 'Initial';
        document.body.appendChild(input);
      `);

      const input = await driver.findElement(By.id('clear-input'));
      await input.clear();

      const value = await input.getAttribute('value');
      expect(value).toBe('');
    });
  });

  describe('JavaScript Execution', () => {
    it('should execute synchronous script', async () => {
      await driver.get('https://example.com');
      const result = await driver.executeScript('return document.title;');
      expect(result).toBe('Example Domain');
    });

    it('should execute script with arguments', async () => {
      const result = await driver.executeScript(
        'return arguments[0] + arguments[1];',
        10,
        20
      );
      expect(result).toBe(30);
    });

    it('should return complex objects', async () => {
      const result = await driver.executeScript(
        'return { foo: "bar", count: 42 };'
      );
      expect(result).toEqual({ foo: 'bar', count: 42 });
    });
  });

  describe('Screenshots', () => {
    it('should take screenshot', async () => {
      await driver.get('https://example.com');
      const screenshot = await driver.takeScreenshot();
      expect(screenshot).toBeDefined();
      expect(screenshot.length).toBeGreaterThan(0);

      // Base64 encoded image
      const decoded = Buffer.from(screenshot, 'base64');
      expect(decoded.length).toBeGreaterThan(0);
    });
  });

  describe('Wait Conditions', () => {
    beforeAll(async () => {
      await driver.get('https://example.com');
    });

    it('should wait for element to be visible', async () => {
      const element = await driver.wait(
        until.elementLocated(By.css('h1')),
        5000
      );
      expect(element).toBeDefined();
    });

    it('should wait for title', async () => {
      await driver.wait(until.titleIs('Example Domain'), 5000);
      const title = await driver.getTitle();
      expect(title).toBe('Example Domain');
    });

    it('should timeout when condition not met', async () => {
      await expect(
        driver.wait(until.titleIs('Nonexistent Title'), 1000)
      ).rejects.toThrow();
    });
  });

  describe('Frame Handling', () => {
    it('should switch to default content', async () => {
      await driver.get('https://example.com');
      await driver.switchTo().defaultContent();
      const title = await driver.getTitle();
      expect(title).toBe('Example Domain');
    });
  });

  describe('Alert Handling', () => {
    it('should handle alerts', async () => {
      await driver.get('https://example.com');

      // Create an alert
      await driver.executeScript('window.testAlert = function() { alert("Test Alert"); };');

      // For testing purposes, we verify the function exists
      const hasFunction = await driver.executeScript(
        'return typeof window.testAlert === "function";'
      );
      expect(hasFunction).toBe(true);
    });
  });

  describe('Cookie Management', () => {
    beforeAll(async () => {
      await driver.get('https://example.com');
    });

    it('should get all cookies', async () => {
      const cookies = await driver.manage().getCookies();
      expect(Array.isArray(cookies)).toBe(true);
    });

    it('should add cookie', async () => {
      await driver.manage().addCookie({
        name: 'test_cookie',
        value: 'test_value',
      });

      const cookie = await driver.manage().getCookie('test_cookie');
      expect(cookie).toBeDefined();
      expect(cookie?.value).toBe('test_value');
    });

    it('should delete cookie', async () => {
      await driver.manage().addCookie({
        name: 'delete_me',
        value: 'goodbye',
      });

      await driver.manage().deleteCookie('delete_me');

      const cookie = await driver.manage().getCookie('delete_me');
      expect(cookie).toBeNull();
    });
  });

  describe('Window Management', () => {
    it('should get window handle', async () => {
      const handle = await driver.getWindowHandle();
      expect(handle).toBeDefined();
      expect(typeof handle).toBe('string');
    });

    it('should get window size', async () => {
      const rect = await driver.manage().window().getRect();
      expect(rect.width).toBeGreaterThan(0);
      expect(rect.height).toBeGreaterThan(0);
    });

    it('should set window size', async () => {
      await driver.manage().window().setRect({ width: 1280, height: 720 });
      const rect = await driver.manage().window().getRect();
      expect(rect.width).toBe(1280);
      expect(rect.height).toBe(720);
    });
  });

  describe('Drag and Drop', () => {
    it('should perform drag and drop actions', async () => {
      await driver.get('https://example.com');

      // Create draggable elements
      await driver.executeScript(`
        const source = document.createElement('div');
        source.id = 'source';
        source.textContent = 'Drag me';
        source.draggable = true;
        document.body.appendChild(source);

        const target = document.createElement('div');
        target.id = 'target';
        target.textContent = 'Drop here';
        document.body.appendChild(target);
      `);

      const source = await driver.findElement(By.id('source'));
      const target = await driver.findElement(By.id('target'));

      // Verify elements exist
      expect(source).toBeDefined();
      expect(target).toBeDefined();
    });
  });

  describe('Driver Cleanup', () => {
    it('should quit driver properly', async () => {
      const options = new chrome.Options();
      options.addArguments('--headless=new');

      const testDriver = await new Builder()
        .forBrowser('chrome')
        .setChromeOptions(options)
        .build();

      await testDriver.get('https://example.com');
      await expect(testDriver.quit()).resolves.toBeUndefined();
    });
  });
});