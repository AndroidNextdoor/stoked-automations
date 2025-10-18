#!/usr/bin/env node

/**
 * Playwright Automation MCP Server
 * Provides browser automation tools via Playwright for E2E testing, screenshots, PDF generation, and more
 */

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import { chromium, firefox, webkit, Browser, Page, BrowserContext } from 'playwright';
import { z } from 'zod';

// Validation schemas
const LaunchBrowserSchema = z.object({
  browserType: z.enum(['chromium', 'firefox', 'webkit']).default('chromium'),
  headless: z.boolean().default(true),
  slowMo: z.number().optional(),
});

const NavigateSchema = z.object({
  url: z.string().url(),
  waitUntil: z.enum(['load', 'domcontentloaded', 'networkidle']).default('load'),
  timeout: z.number().default(30000),
});

const ClickSchema = z.object({
  selector: z.string(),
  timeout: z.number().default(30000),
  force: z.boolean().default(false),
});

const TypeSchema = z.object({
  selector: z.string(),
  text: z.string(),
  delay: z.number().default(0),
});

const ScreenshotSchema = z.object({
  path: z.string(),
  fullPage: z.boolean().default(false),
  type: z.enum(['png', 'jpeg']).default('png'),
});

const EvaluateSchema = z.object({
  script: z.string(),
});

const WaitForSelectorSchema = z.object({
  selector: z.string(),
  state: z.enum(['attached', 'detached', 'visible', 'hidden']).default('visible'),
  timeout: z.number().default(30000),
});

const GeneratePDFSchema = z.object({
  path: z.string(),
  format: z.enum(['Letter', 'A4']).default('A4'),
  printBackground: z.boolean().default(true),
});

const NetworkRecordingSchema = z.object({
  enable: z.boolean(),
});

// Server state
let browser: Browser | null = null;
let context: BrowserContext | null = null;
let page: Page | null = null;
let networkLogs: Array<{ url: string; method: string; status: number; timing: number }> = [];

const server = new Server(
  {
    name: 'playwright-automation',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// List available tools
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'launch_browser',
        description: 'Launch a browser instance (chromium, firefox, or webkit)',
        inputSchema: {
          type: 'object',
          properties: {
            browserType: {
              type: 'string',
              enum: ['chromium', 'firefox', 'webkit'],
              description: 'Browser to launch',
              default: 'chromium',
            },
            headless: {
              type: 'boolean',
              description: 'Run in headless mode',
              default: true,
            },
            slowMo: {
              type: 'number',
              description: 'Slow down operations by specified milliseconds',
            },
          },
        },
      },
      {
        name: 'navigate',
        description: 'Navigate to a URL',
        inputSchema: {
          type: 'object',
          properties: {
            url: {
              type: 'string',
              description: 'URL to navigate to',
            },
            waitUntil: {
              type: 'string',
              enum: ['load', 'domcontentloaded', 'networkidle'],
              default: 'load',
            },
            timeout: {
              type: 'number',
              default: 30000,
            },
          },
          required: ['url'],
        },
      },
      {
        name: 'click',
        description: 'Click an element',
        inputSchema: {
          type: 'object',
          properties: {
            selector: {
              type: 'string',
              description: 'CSS selector or text to click',
            },
            timeout: { type: 'number', default: 30000 },
            force: { type: 'boolean', default: false },
          },
          required: ['selector'],
        },
      },
      {
        name: 'type_text',
        description: 'Type text into an input field',
        inputSchema: {
          type: 'object',
          properties: {
            selector: { type: 'string' },
            text: { type: 'string' },
            delay: { type: 'number', default: 0 },
          },
          required: ['selector', 'text'],
        },
      },
      {
        name: 'screenshot',
        description: 'Take a screenshot of the current page',
        inputSchema: {
          type: 'object',
          properties: {
            path: { type: 'string', description: 'Path to save screenshot' },
            fullPage: { type: 'boolean', default: false },
            type: { type: 'string', enum: ['png', 'jpeg'], default: 'png' },
          },
          required: ['path'],
        },
      },
      {
        name: 'evaluate',
        description: 'Execute JavaScript in the page context',
        inputSchema: {
          type: 'object',
          properties: {
            script: { type: 'string', description: 'JavaScript to execute' },
          },
          required: ['script'],
        },
      },
      {
        name: 'wait_for_selector',
        description: 'Wait for a selector to appear',
        inputSchema: {
          type: 'object',
          properties: {
            selector: { type: 'string' },
            state: {
              type: 'string',
              enum: ['attached', 'detached', 'visible', 'hidden'],
              default: 'visible',
            },
            timeout: { type: 'number', default: 30000 },
          },
          required: ['selector'],
        },
      },
      {
        name: 'get_page_content',
        description: 'Get the HTML content of the current page',
        inputSchema: {
          type: 'object',
          properties: {},
        },
      },
      {
        name: 'get_page_title',
        description: 'Get the title of the current page',
        inputSchema: {
          type: 'object',
          properties: {},
        },
      },
      {
        name: 'generate_pdf',
        description: 'Generate a PDF of the current page',
        inputSchema: {
          type: 'object',
          properties: {
            path: { type: 'string' },
            format: { type: 'string', enum: ['Letter', 'A4'], default: 'A4' },
            printBackground: { type: 'boolean', default: true },
          },
          required: ['path'],
        },
      },
      {
        name: 'record_network',
        description: 'Enable or disable network request recording',
        inputSchema: {
          type: 'object',
          properties: {
            enable: { type: 'boolean' },
          },
          required: ['enable'],
        },
      },
      {
        name: 'get_network_logs',
        description: 'Get recorded network requests',
        inputSchema: {
          type: 'object',
          properties: {},
        },
      },
      {
        name: 'close_browser',
        description: 'Close the browser instance',
        inputSchema: {
          type: 'object',
          properties: {},
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
      case 'launch_browser': {
        const params = LaunchBrowserSchema.parse(args);

        if (browser) {
          await browser.close();
        }

        const browserTypes = { chromium, firefox, webkit };
        browser = await browserTypes[params.browserType].launch({
          headless: params.headless,
          slowMo: params.slowMo,
        });

        context = await browser.newContext();
        page = await context.newPage();

        return {
          content: [
            {
              type: 'text',
              text: `✅ Launched ${params.browserType} browser (headless: ${params.headless})`,
            },
          ],
        };
      }

      case 'navigate': {
        if (!page) throw new Error('No browser launched. Call launch_browser first.');

        const params = NavigateSchema.parse(args);
        await page.goto(params.url, {
          waitUntil: params.waitUntil,
          timeout: params.timeout,
        });

        return {
          content: [
            {
              type: 'text',
              text: `✅ Navigated to ${params.url}`,
            },
          ],
        };
      }

      case 'click': {
        if (!page) throw new Error('No browser launched. Call launch_browser first.');

        const params = ClickSchema.parse(args);
        await page.click(params.selector, {
          timeout: params.timeout,
          force: params.force,
        });

        return {
          content: [
            {
              type: 'text',
              text: `✅ Clicked ${params.selector}`,
            },
          ],
        };
      }

      case 'type_text': {
        if (!page) throw new Error('No browser launched. Call launch_browser first.');

        const params = TypeSchema.parse(args);
        await page.type(params.selector, params.text, { delay: params.delay });

        return {
          content: [
            {
              type: 'text',
              text: `✅ Typed "${params.text}" into ${params.selector}`,
            },
          ],
        };
      }

      case 'screenshot': {
        if (!page) throw new Error('No browser launched. Call launch_browser first.');

        const params = ScreenshotSchema.parse(args);
        await page.screenshot({
          path: params.path,
          fullPage: params.fullPage,
          type: params.type,
        });

        return {
          content: [
            {
              type: 'text',
              text: `✅ Screenshot saved to ${params.path}`,
            },
          ],
        };
      }

      case 'evaluate': {
        if (!page) throw new Error('No browser launched. Call launch_browser first.');

        const params = EvaluateSchema.parse(args);
        const result = await page.evaluate(params.script);

        return {
          content: [
            {
              type: 'text',
              text: `✅ Evaluation result:\n${JSON.stringify(result, null, 2)}`,
            },
          ],
        };
      }

      case 'wait_for_selector': {
        if (!page) throw new Error('No browser launched. Call launch_browser first.');

        const params = WaitForSelectorSchema.parse(args);
        await page.waitForSelector(params.selector, {
          state: params.state,
          timeout: params.timeout,
        });

        return {
          content: [
            {
              type: 'text',
              text: `✅ Selector ${params.selector} is ${params.state}`,
            },
          ],
        };
      }

      case 'get_page_content': {
        if (!page) throw new Error('No browser launched. Call launch_browser first.');

        const content = await page.content();
        return {
          content: [
            {
              type: 'text',
              text: content,
            },
          ],
        };
      }

      case 'get_page_title': {
        if (!page) throw new Error('No browser launched. Call launch_browser first.');

        const title = await page.title();
        return {
          content: [
            {
              type: 'text',
              text: `Page title: ${title}`,
            },
          ],
        };
      }

      case 'generate_pdf': {
        if (!page) throw new Error('No browser launched. Call launch_browser first.');

        const params = GeneratePDFSchema.parse(args);
        await page.pdf({
          path: params.path,
          format: params.format,
          printBackground: params.printBackground,
        });

        return {
          content: [
            {
              type: 'text',
              text: `✅ PDF saved to ${params.path}`,
            },
          ],
        };
      }

      case 'record_network': {
        if (!page) throw new Error('No browser launched. Call launch_browser first.');

        const params = NetworkRecordingSchema.parse(args);

        if (params.enable) {
          networkLogs = [];
          page.on('response', async (response) => {
            const request = response.request();
            const timing = response.timing();
            networkLogs.push({
              url: request.url(),
              method: request.method(),
              status: response.status(),
              timing: timing?.responseEnd || 0,
            });
          });
        } else {
          page.removeAllListeners('response');
        }

        return {
          content: [
            {
              type: 'text',
              text: `✅ Network recording ${params.enable ? 'enabled' : 'disabled'}`,
            },
          ],
        };
      }

      case 'get_network_logs': {
        return {
          content: [
            {
              type: 'text',
              text: `Network Logs (${networkLogs.length} requests):\n${JSON.stringify(networkLogs, null, 2)}`,
            },
          ],
        };
      }

      case 'close_browser': {
        if (browser) {
          await browser.close();
          browser = null;
          context = null;
          page = null;
        }

        return {
          content: [
            {
              type: 'text',
              text: '✅ Browser closed',
            },
          ],
        };
      }

      default:
        throw new Error(`Unknown tool: ${name}`);
    }
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : String(error);
    return {
      content: [
        {
          type: 'text',
          text: `❌ Error: ${errorMessage}`,
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
  console.error('Playwright Automation MCP server running on stdio');
}

main().catch((error) => {
  console.error('Fatal error:', error);
  process.exit(1);
});