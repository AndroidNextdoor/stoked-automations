#!/usr/bin/env node

/**
 *
 * Selenium WebDriver MCP Server
 * Provides Selenium automation tools with Grid support, cross-browser testing, and advanced interactions
 */

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import { z } from 'zod';
import { Builder, By, until, WebDriver, WebElement } from 'selenium-webdriver';
import * as chrome from 'selenium-webdriver/chrome.js';
import * as firefox from 'selenium-webdriver/firefox.js';
import * as edge from 'selenium-webdriver/edge.js';

// Validation schemas
const StartDriverSchema = z.object({
  browser: z.enum(['chrome', 'firefox', 'edge', 'safari']).default('chrome'),
  headless: z.boolean().default(true),
  gridUrl: z.string().url().optional(),
  capabilities: z.record(z.any()).optional(),
});

const NavigateToSchema = z.object({
  url: z.string().url(),
  waitForElement: z.string().optional(),
  timeout: z.number().default(10000),
});

const FindElementSchema = z.object({
  locator: z.string(),
  strategy: z.enum(['id', 'css', 'xpath', 'name', 'className', 'tagName', 'linkText', 'partialLinkText']).default('css'),
  timeout: z.number().default(10000),
});

const ClickElementSchema = z.object({
  locator: z.string(),
  strategy: z.enum(['id', 'css', 'xpath', 'name', 'className', 'tagName', 'linkText', 'partialLinkText']).default('css'),
  timeout: z.number().default(10000),
});

const SendKeysSchema = z.object({
  locator: z.string(),
  strategy: z.enum(['id', 'css', 'xpath', 'name', 'className', 'tagName']).default('css'),
  text: z.string(),
  clearFirst: z.boolean().default(false),
});

const ExecuteScriptSchema = z.object({
  script: z.string(),
  args: z.array(z.any()).optional(),
});

const TakeScreenshotSchema = z.object({
  filePath: z.string(),
  fullPage: z.boolean().default(false),
});

const SwitchToFrameSchema = z.object({
  frameIdentifier: z.union([z.string(), z.number()]),
});

const HandleAlertsSchema = z.object({
  action: z.enum(['accept', 'dismiss', 'getText', 'sendKeys']),
  text: z.string().optional(),
});

const WaitForConditionSchema = z.object({
  condition: z.enum(['elementVisible', 'elementPresent', 'elementClickable', 'titleContains', 'urlContains']),
  value: z.string(),
  timeout: z.number().default(10000),
});

const DragAndDropSchema = z.object({
  sourceLocator: z.string(),
  targetLocator: z.string(),
  strategy: z.enum(['css', 'xpath', 'id']).default('css'),
});

const GetCookiesSchema = z.object({
  cookieName: z.string().optional(),
});

const AddCookieSchema = z.object({
  name: z.string(),
  value: z.string(),
  domain: z.string().optional(),
  path: z.string().default('/'),
  expiry: z.number().optional(),
});

// Server state
let driver: WebDriver | null = null;

const server = new Server(
  {
    name: 'selenium-webdriver',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Helper to get By locator
function getByLocator(strategy: string, locator: string): By {
  switch (strategy) {
    case 'id':
      return By.id(locator);
    case 'css':
      return By.css(locator);
    case 'xpath':
      return By.xpath(locator);
    case 'name':
      return By.name(locator);
    case 'className':
      return By.className(locator);
    case 'tagName':
      return By.tagName(locator);
    case 'linkText':
      return By.linkText(locator);
    case 'partialLinkText':
      return By.partialLinkText(locator);
    default:
      return By.css(locator);
  }
}

// List available tools
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'start_driver',
        description: 'Start a Selenium WebDriver instance with optional Grid support',
        inputSchema: {
          type: 'object',
          properties: {
            browser: {
              type: 'string',
              enum: ['chrome', 'firefox', 'edge', 'safari'],
              description: 'Browser to use',
              default: 'chrome',
            },
            headless: {
              type: 'boolean',
              description: 'Run in headless mode',
              default: true,
            },
            gridUrl: {
              type: 'string',
              description: 'Selenium Grid URL (optional)',
            },
            capabilities: {
              type: 'object',
              description: 'Additional browser capabilities',
            },
          },
          required: [],
        },
      },
      {
        name: 'navigate_to',
        description: 'Navigate to a URL and optionally wait for an element',
        inputSchema: {
          type: 'object',
          properties: {
            url: {
              type: 'string',
              description: 'URL to navigate to',
            },
            waitForElement: {
              type: 'string',
              description: 'CSS selector to wait for after navigation',
            },
            timeout: {
              type: 'number',
              description: 'Timeout in milliseconds',
              default: 10000,
            },
          },
          required: ['url'],
        },
      },
      {
        name: 'find_element',
        description: 'Find an element using various locator strategies',
        inputSchema: {
          type: 'object',
          properties: {
            locator: {
              type: 'string',
              description: 'Element locator',
            },
            strategy: {
              type: 'string',
              enum: ['id', 'css', 'xpath', 'name', 'className', 'tagName', 'linkText', 'partialLinkText'],
              description: 'Locator strategy',
              default: 'css',
            },
            timeout: {
              type: 'number',
              description: 'Timeout in milliseconds',
              default: 10000,
            },
          },
          required: ['locator'],
        },
      },
      {
        name: 'click_element',
        description: 'Click an element',
        inputSchema: {
          type: 'object',
          properties: {
            locator: {
              type: 'string',
              description: 'Element locator',
            },
            strategy: {
              type: 'string',
              enum: ['id', 'css', 'xpath', 'name', 'className', 'tagName', 'linkText', 'partialLinkText'],
              description: 'Locator strategy',
              default: 'css',
            },
            timeout: {
              type: 'number',
              description: 'Timeout in milliseconds',
              default: 10000,
            },
          },
          required: ['locator'],
        },
      },
      {
        name: 'send_keys',
        description: 'Type text into an input element',
        inputSchema: {
          type: 'object',
          properties: {
            locator: {
              type: 'string',
              description: 'Element locator',
            },
            strategy: {
              type: 'string',
              enum: ['id', 'css', 'xpath', 'name', 'className', 'tagName'],
              description: 'Locator strategy',
              default: 'css',
            },
            text: {
              type: 'string',
              description: 'Text to type',
            },
            clearFirst: {
              type: 'boolean',
              description: 'Clear the field before typing',
              default: false,
            },
          },
          required: ['locator', 'text'],
        },
      },
      {
        name: 'execute_script',
        description: 'Execute JavaScript in the browser context',
        inputSchema: {
          type: 'object',
          properties: {
            script: {
              type: 'string',
              description: 'JavaScript code to execute',
            },
            args: {
              type: 'array',
              description: 'Arguments to pass to the script',
            },
          },
          required: ['script'],
        },
      },
      {
        name: 'take_screenshot',
        description: 'Capture a screenshot',
        inputSchema: {
          type: 'object',
          properties: {
            filePath: {
              type: 'string',
              description: 'Path to save the screenshot',
            },
            fullPage: {
              type: 'boolean',
              description: 'Capture full page (requires JS execution)',
              default: false,
            },
          },
          required: ['filePath'],
        },
      },
      {
        name: 'switch_to_frame',
        description: 'Switch to an iframe or frame',
        inputSchema: {
          type: 'object',
          properties: {
            frameIdentifier: {
              description: 'Frame index (number) or name/id (string)',
            },
          },
          required: ['frameIdentifier'],
        },
      },
      {
        name: 'handle_alert',
        description: 'Handle JavaScript alerts, confirms, and prompts',
        inputSchema: {
          type: 'object',
          properties: {
            action: {
              type: 'string',
              enum: ['accept', 'dismiss', 'getText', 'sendKeys'],
              description: 'Action to perform on the alert',
            },
            text: {
              type: 'string',
              description: 'Text to send to prompt (for sendKeys action)',
            },
          },
          required: ['action'],
        },
      },
      {
        name: 'wait_for_condition',
        description: 'Wait for a specific condition to be met',
        inputSchema: {
          type: 'object',
          properties: {
            condition: {
              type: 'string',
              enum: ['elementVisible', 'elementPresent', 'elementClickable', 'titleContains', 'urlContains'],
              description: 'Condition to wait for',
            },
            value: {
              type: 'string',
              description: 'Value for the condition (selector, text, etc.)',
            },
            timeout: {
              type: 'number',
              description: 'Timeout in milliseconds',
              default: 10000,
            },
          },
          required: ['condition', 'value'],
        },
      },
      {
        name: 'drag_and_drop',
        description: 'Perform drag and drop operation',
        inputSchema: {
          type: 'object',
          properties: {
            sourceLocator: {
              type: 'string',
              description: 'Source element locator',
            },
            targetLocator: {
              type: 'string',
              description: 'Target element locator',
            },
            strategy: {
              type: 'string',
              enum: ['css', 'xpath', 'id'],
              description: 'Locator strategy',
              default: 'css',
            },
          },
          required: ['sourceLocator', 'targetLocator'],
        },
      },
      {
        name: 'get_cookies',
        description: 'Get browser cookies',
        inputSchema: {
          type: 'object',
          properties: {
            cookieName: {
              type: 'string',
              description: 'Specific cookie name (optional)',
            },
          },
          required: [],
        },
      },
      {
        name: 'add_cookie',
        description: 'Add a cookie to the browser',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Cookie name',
            },
            value: {
              type: 'string',
              description: 'Cookie value',
            },
            domain: {
              type: 'string',
              description: 'Cookie domain',
            },
            path: {
              type: 'string',
              description: 'Cookie path',
              default: '/',
            },
            expiry: {
              type: 'number',
              description: 'Cookie expiry timestamp',
            },
          },
          required: ['name', 'value'],
        },
      },
      {
        name: 'quit_driver',
        description: 'Close the browser and end the WebDriver session',
        inputSchema: {
          type: 'object',
          properties: {},
          required: [],
        },
      },
    ],
  };
});

// Handle tool calls
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    switch (name) {
      case 'start_driver': {
        const params = StartDriverSchema.parse(args);

        let builder = new Builder();

        if (params.gridUrl) {
          builder = builder.usingServer(params.gridUrl);
        }

        if (params.browser === 'chrome') {
          const options = new chrome.Options();
          if (params.headless) {
            options.addArguments('--headless=new');
          }
          builder = builder.setChromeOptions(options);
        } else if (params.browser === 'firefox') {
          const options = new firefox.Options();
          if (params.headless) {
            options.addArguments('-headless');
          }
          builder = builder.setFirefoxOptions(options);
        } else if (params.browser === 'edge') {
          const options = new edge.Options();
          if (params.headless) {
            options.addArguments('--headless=new');
          }
          builder = builder.setEdgeOptions(options);
        }

        builder = builder.forBrowser(params.browser);

        if (params.capabilities) {
          for (const [key, value] of Object.entries(params.capabilities)) {
            builder = builder.withCapabilities({ [key]: value });
          }
        }

        driver = await builder.build();

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'WebDriver started',
                browser: params.browser,
                headless: params.headless,
                gridUrl: params.gridUrl,
              }, null, 2),
            },
          ],
        };
      }

      case 'navigate_to': {
        if (!driver) throw new Error('Driver not started. Call start_driver first.');
        const params = NavigateToSchema.parse(args);

        await driver.get(params.url);

        if (params.waitForElement) {
          await driver.wait(
            until.elementLocated(By.css(params.waitForElement)),
            params.timeout
          );
        }

        const currentUrl = await driver.getCurrentUrl();
        const title = await driver.getTitle();

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                currentUrl,
                title,
              }, null, 2),
            },
          ],
        };
      }

      case 'find_element': {
        if (!driver) throw new Error('Driver not started. Call start_driver first.');
        const params = FindElementSchema.parse(args);

        const by = getByLocator(params.strategy, params.locator);
        const element = await driver.wait(until.elementLocated(by), params.timeout);

        const text = await element.getText();
        const tagName = await element.getTagName();
        const isDisplayed = await element.isDisplayed();

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                element: {
                  text,
                  tagName,
                  isDisplayed,
                },
              }, null, 2),
            },
          ],
        };
      }

      case 'click_element': {
        if (!driver) throw new Error('Driver not started. Call start_driver first.');
        const params = ClickElementSchema.parse(args);

        const by = getByLocator(params.strategy, params.locator);
        const element = await driver.wait(until.elementLocated(by), params.timeout);
        await driver.wait(until.elementIsVisible(element), params.timeout);
        await element.click();

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'Element clicked',
                locator: params.locator,
              }, null, 2),
            },
          ],
        };
      }

      case 'send_keys': {
        if (!driver) throw new Error('Driver not started. Call start_driver first.');
        const params = SendKeysSchema.parse(args);

        const by = getByLocator(params.strategy, params.locator);
        const element = await driver.findElement(by);

        if (params.clearFirst) {
          await element.clear();
        }

        await element.sendKeys(params.text);

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'Keys sent to element',
                locator: params.locator,
                text: params.text,
              }, null, 2),
            },
          ],
        };
      }

      case 'execute_script': {
        if (!driver) throw new Error('Driver not started. Call start_driver first.');
        const params = ExecuteScriptSchema.parse(args);

        const result = await driver.executeScript(params.script, ...(params.args || []));

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                result,
              }, null, 2),
            },
          ],
        };
      }

      case 'take_screenshot': {
        if (!driver) throw new Error('Driver not started. Call start_driver first.');
        const params = TakeScreenshotSchema.parse(args);

        const screenshot = await driver.takeScreenshot();
        const fs = await import('fs/promises');
        await fs.writeFile(params.filePath, screenshot, 'base64');

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'Screenshot saved',
                filePath: params.filePath,
              }, null, 2),
            },
          ],
        };
      }

      case 'switch_to_frame': {
        if (!driver) throw new Error('Driver not started. Call start_driver first.');
        const params = SwitchToFrameSchema.parse(args);

        if (typeof params.frameIdentifier === 'number') {
          await driver.switchTo().frame(params.frameIdentifier);
        } else {
          const frame = await driver.findElement(By.css(params.frameIdentifier));
          await driver.switchTo().frame(frame);
        }

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'Switched to frame',
                frameIdentifier: params.frameIdentifier,
              }, null, 2),
            },
          ],
        };
      }

      case 'handle_alert': {
        if (!driver) throw new Error('Driver not started. Call start_driver first.');
        const params = HandleAlertsSchema.parse(args);

        const alert = await driver.switchTo().alert();

        let result: any = { success: true, action: params.action };

        switch (params.action) {
          case 'accept':
            await alert.accept();
            result.message = 'Alert accepted';
            break;
          case 'dismiss':
            await alert.dismiss();
            result.message = 'Alert dismissed';
            break;
          case 'getText':
            result.text = await alert.getText();
            break;
          case 'sendKeys':
            if (!params.text) throw new Error('Text required for sendKeys action');
            await alert.sendKeys(params.text);
            await alert.accept();
            result.message = 'Text sent to alert';
            break;
        }

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify(result, null, 2),
            },
          ],
        };
      }

      case 'wait_for_condition': {
        if (!driver) throw new Error('Driver not started. Call start_driver first.');
        const params = WaitForConditionSchema.parse(args);

        let condition;

        switch (params.condition) {
          case 'elementVisible':
            condition = until.elementIsVisible(await driver.findElement(By.css(params.value)));
            break;
          case 'elementPresent':
            condition = until.elementLocated(By.css(params.value));
            break;
          case 'elementClickable':
            condition = until.elementIsEnabled(await driver.findElement(By.css(params.value)));
            break;
          case 'titleContains':
            condition = until.titleContains(params.value);
            break;
          case 'urlContains':
            condition = until.urlContains(params.value);
            break;
        }

        await driver.wait(condition, params.timeout);

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'Condition met',
                condition: params.condition,
              }, null, 2),
            },
          ],
        };
      }

      case 'drag_and_drop': {
        if (!driver) throw new Error('Driver not started. Call start_driver first.');
        const params = DragAndDropSchema.parse(args);

        const by = getByLocator(params.strategy, params.sourceLocator);
        const source = await driver.findElement(by);
        const targetBy = getByLocator(params.strategy, params.targetLocator);
        const target = await driver.findElement(targetBy);

        const actions = driver.actions({ async: true });
        await actions.dragAndDrop(source, target).perform();

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'Drag and drop completed',
              }, null, 2),
            },
          ],
        };
      }

      case 'get_cookies': {
        if (!driver) throw new Error('Driver not started. Call start_driver first.');
        const params = GetCookiesSchema.parse(args);

        if (params.cookieName) {
          const cookie = await driver.manage().getCookie(params.cookieName);
          return {
            content: [
              {
                type: 'text',
                text: JSON.stringify({ success: true, cookie }, null, 2),
              },
            ],
          };
        } else {
          const cookies = await driver.manage().getCookies();
          return {
            content: [
              {
                type: 'text',
                text: JSON.stringify({ success: true, cookies }, null, 2),
              },
            ],
          };
        }
      }

      case 'add_cookie': {
        if (!driver) throw new Error('Driver not started. Call start_driver first.');
        const params = AddCookieSchema.parse(args);

        await driver.manage().addCookie(params);

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'Cookie added',
                name: params.name,
              }, null, 2),
            },
          ],
        };
      }

      case 'quit_driver': {
        if (!driver) throw new Error('Driver not started.');

        await driver.quit();
        driver = null;

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'WebDriver session ended',
              }, null, 2),
            },
          ],
        };
      }

      default:
        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({ error: `Unknown tool: ${name}` }),
            },
          ],
          isError: true,
        };
    }
  } catch (error) {
    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify({
            error: error instanceof Error ? error.message : 'Unknown error',
            tool: name,
          }),
        },
      ],
      isError: true,
    };
  }
});

// Start server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('Selenium WebDriver MCP server running on stdio');
}

main().catch((error) => {
  console.error('Fatal error:', error);
  process.exit(1);
});
