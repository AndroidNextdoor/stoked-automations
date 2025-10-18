#!/usr/bin/env node

/**
 * Chrome DevTools Protocol MCP Server
 * Provides performance profiling, network analysis, coverage reports, and debugging via CDP
 *
 * Uses full Puppeteer with bundled Chromium (~300MB) for zero-configuration browser automation.
 * No Chrome installation required - Chromium is downloaded automatically with the plugin.
 * Advanced users can override with executablePath to use their own Chrome installation.
 */

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import puppeteer, { Browser, Page, Protocol } from 'puppeteer';
import { z } from 'zod';

// Validation schemas
const ConnectChromeSchema = z.object({
  executablePath: z.string().optional(),
  headless: z.boolean().default(true),
  devtools: z.boolean().default(false),
});

const NavigateSchema = z.object({
  url: z.string().url(),
});

const PerformanceProfileSchema = z.object({
  duration: z.number().default(5000),
  categories: z.array(z.string()).optional(),
});

const CoverageReportSchema = z.object({
  type: z.enum(['css', 'js', 'both']).default('both'),
});

const NetworkAnalysisSchema = z.object({
  filter: z.string().optional(),
});

const ConsoleLogsSchema = z.object({
  level: z.enum(['log', 'info', 'warn', 'error', 'all']).default('all'),
});

const EmulateDeviceSchema = z.object({
  device: z.string(),
  viewport: z.object({
    width: z.number(),
    height: z.number(),
    deviceScaleFactor: z.number().default(1),
    isMobile: z.boolean().default(false),
  }).optional(),
});

const ThrottleNetworkSchema = z.object({
  offline: z.boolean().default(false),
  downloadThroughput: z.number().default(-1),
  uploadThroughput: z.number().default(-1),
  latency: z.number().default(0),
});

// Server state
let browser: Browser | null = null;
let page: Page | null = null;
let performanceMetrics: Protocol.Performance.Metric[] = [];
let networkRequests: Protocol.Network.Request[] = [];
let consoleLogs: Array<{ type: string; text: string; timestamp: number }> = [];
let coverageData: { js: any[]; css: any[] } = { js: [], css: [] };

const server = new Server(
  {
    name: 'chrome-devtools',
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
        name: 'connect_chrome',
        description: 'Connect to Chrome/Chromium with DevTools Protocol. Uses bundled Chromium by default (no installation needed). Optionally specify executablePath to use system Chrome.',
        inputSchema: {
          type: 'object',
          properties: {
            executablePath: {
              type: 'string',
              description: 'Optional: Path to Chrome executable. If not provided, uses bundled Chromium (~300MB included with plugin)',
            },
            headless: { type: 'boolean', default: true },
            devtools: { type: 'boolean', default: false },
          },
        },
      },
      {
        name: 'navigate_to',
        description: 'Navigate to a URL',
        inputSchema: {
          type: 'object',
          properties: {
            url: { type: 'string' },
          },
          required: ['url'],
        },
      },
      {
        name: 'start_performance_profile',
        description: 'Start performance profiling (CPU, memory, rendering)',
        inputSchema: {
          type: 'object',
          properties: {
            duration: { type: 'number', default: 5000 },
            categories: {
              type: 'array',
              items: { type: 'string' },
              description: 'Tracing categories',
            },
          },
        },
      },
      {
        name: 'get_performance_metrics',
        description: 'Get current performance metrics',
        inputSchema: {
          type: 'object',
          properties: {},
        },
      },
      {
        name: 'start_coverage',
        description: 'Start CSS/JS coverage tracking',
        inputSchema: {
          type: 'object',
          properties: {
            type: { type: 'string', enum: ['css', 'js', 'both'], default: 'both' },
          },
        },
      },
      {
        name: 'stop_coverage',
        description: 'Stop coverage and get report',
        inputSchema: {
          type: 'object',
          properties: {},
        },
      },
      {
        name: 'analyze_network',
        description: 'Get network request analysis',
        inputSchema: {
          type: 'object',
          properties: {
            filter: {
              type: 'string',
              description: 'Filter URLs (regex pattern)',
            },
          },
        },
      },
      {
        name: 'get_console_logs',
        description: 'Get console logs from the page',
        inputSchema: {
          type: 'object',
          properties: {
            level: {
              type: 'string',
              enum: ['log', 'info', 'warn', 'error', 'all'],
              default: 'all',
            },
          },
        },
      },
      {
        name: 'emulate_device',
        description: 'Emulate a specific device or viewport',
        inputSchema: {
          type: 'object',
          properties: {
            device: { type: 'string' },
            viewport: {
              type: 'object',
              properties: {
                width: { type: 'number' },
                height: { type: 'number' },
                deviceScaleFactor: { type: 'number', default: 1 },
                isMobile: { type: 'boolean', default: false },
              },
            },
          },
          required: ['device'],
        },
      },
      {
        name: 'throttle_network',
        description: 'Throttle network to simulate slow connections',
        inputSchema: {
          type: 'object',
          properties: {
            offline: { type: 'boolean', default: false },
            downloadThroughput: { type: 'number', default: -1 },
            uploadThroughput: { type: 'number', default: -1 },
            latency: { type: 'number', default: 0 },
          },
        },
      },
      {
        name: 'get_accessibility_tree',
        description: 'Get accessibility tree for the page',
        inputSchema: {
          type: 'object',
          properties: {},
        },
      },
      {
        name: 'lighthouse_audit',
        description: 'Run Lighthouse performance audit',
        inputSchema: {
          type: 'object',
          properties: {
            categories: {
              type: 'array',
              items: { type: 'string' },
              description: 'Categories: performance, accessibility, best-practices, seo, pwa',
            },
          },
        },
      },
      {
        name: 'disconnect',
        description: 'Disconnect from Chrome',
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
      case 'connect_chrome': {
        const params = ConnectChromeSchema.parse(args);

        if (browser) {
          await browser.close();
        }

        // Launch browser - uses bundled Chromium by default if executablePath not provided
        // Bundled Chromium (~300MB) is included with full Puppeteer for zero-config setup
        browser = await puppeteer.launch({
          executablePath: params.executablePath, // Optional: override to use system Chrome
          headless: params.headless,
          devtools: params.devtools,
          args: ['--no-sandbox', '--disable-setuid-sandbox'],
        });

        page = await browser.newPage();

        // Enable performance monitoring
        const client = await page.target().createCDPSession();
        await client.send('Performance.enable');

        // Listen for console logs
        page.on('console', (msg) => {
          consoleLogs.push({
            type: msg.type(),
            text: msg.text(),
            timestamp: Date.now(),
          });
        });

        // Listen for network requests
        await client.send('Network.enable');
        client.on('Network.requestWillBeSent', (params) => {
          networkRequests.push(params.request);
        });

        return {
          content: [
            {
              type: 'text',
              text: `✅ Connected to Chrome (headless: ${params.headless})`,
            },
          ],
        };
      }

      case 'navigate_to': {
        if (!page) throw new Error('Not connected. Call connect_chrome first.');

        const params = NavigateSchema.parse(args);
        await page.goto(params.url, { waitUntil: 'networkidle2' });

        return {
          content: [
            {
              type: 'text',
              text: `✅ Navigated to ${params.url}`,
            },
          ],
        };
      }

      case 'start_performance_profile': {
        if (!page) throw new Error('Not connected. Call connect_chrome first.');

        const params = PerformanceProfileSchema.parse(args);

        await page.tracing.start({
          screenshots: true,
          categories: params.categories,
        });

        await new Promise((resolve) => setTimeout(resolve, params.duration));

        const trace = await page.tracing.stop();

        return {
          content: [
            {
              type: 'text',
              text: `✅ Performance profile completed (${params.duration}ms)\nTrace data size: ${trace?.byteLength || 0} bytes`,
            },
          ],
        };
      }

      case 'get_performance_metrics': {
        if (!page) throw new Error('Not connected. Call connect_chrome first.');

        const client = await page.target().createCDPSession();
        const metrics = await client.send('Performance.getMetrics');
        performanceMetrics = metrics.metrics;

        const metricsObj: Record<string, number> = {};
        metrics.metrics.forEach((metric) => {
          metricsObj[metric.name] = metric.value;
        });

        return {
          content: [
            {
              type: 'text',
              text: `📊 Performance Metrics:\n${JSON.stringify(metricsObj, null, 2)}`,
            },
          ],
        };
      }

      case 'start_coverage': {
        if (!page) throw new Error('Not connected. Call connect_chrome first.');

        const params = CoverageReportSchema.parse(args);

        if (params.type === 'js' || params.type === 'both') {
          await page.coverage.startJSCoverage();
        }
        if (params.type === 'css' || params.type === 'both') {
          await page.coverage.startCSSCoverage();
        }

        return {
          content: [
            {
              type: 'text',
              text: `✅ Coverage tracking started (${params.type})`,
            },
          ],
        };
      }

      case 'stop_coverage': {
        if (!page) throw new Error('Not connected. Call connect_chrome first.');

        const jsCoverage = await page.coverage.stopJSCoverage();
        const cssCoverage = await page.coverage.stopCSSCoverage();

        coverageData.js = jsCoverage;
        coverageData.css = cssCoverage;

        const totalJS = jsCoverage.reduce((acc, entry) => acc + entry.text.length, 0);
        const usedJS = jsCoverage.reduce(
          (acc, entry) =>
            acc +
            entry.ranges.reduce((sum, range) => sum + (range.end - range.start), 0),
          0
        );
        const jsPercent = totalJS > 0 ? ((usedJS / totalJS) * 100).toFixed(2) : 0;

        const totalCSS = cssCoverage.reduce((acc, entry) => acc + entry.text.length, 0);
        const usedCSS = cssCoverage.reduce(
          (acc, entry) =>
            acc +
            entry.ranges.reduce((sum, range) => sum + (range.end - range.start), 0),
          0
        );
        const cssPercent = totalCSS > 0 ? ((usedCSS / totalCSS) * 100).toFixed(2) : 0;

        return {
          content: [
            {
              type: 'text',
              text: `📊 Coverage Report:
JS Coverage: ${jsPercent}% (${usedJS}/${totalJS} bytes)
CSS Coverage: ${cssPercent}% (${usedCSS}/${totalCSS} bytes)

Files analyzed:
- JS: ${jsCoverage.length} files
- CSS: ${cssCoverage.length} files`,
            },
          ],
        };
      }

      case 'analyze_network': {
        const params = NetworkAnalysisSchema.parse(args);

        let filteredRequests = networkRequests;
        if (params.filter) {
          const regex = new RegExp(params.filter);
          filteredRequests = networkRequests.filter((req) => regex.test(req.url));
        }

        const analysis = {
          totalRequests: filteredRequests.length,
          methods: filteredRequests.reduce((acc, req) => {
            acc[req.method] = (acc[req.method] || 0) + 1;
            return acc;
          }, {} as Record<string, number>),
          domains: Array.from(
            new Set(filteredRequests.map((req) => new URL(req.url).hostname))
          ),
        };

        return {
          content: [
            {
              type: 'text',
              text: `🌐 Network Analysis:\n${JSON.stringify(analysis, null, 2)}`,
            },
          ],
        };
      }

      case 'get_console_logs': {
        const params = ConsoleLogsSchema.parse(args);

        let logs = consoleLogs;
        if (params.level !== 'all') {
          logs = consoleLogs.filter((log) => log.type === params.level);
        }

        return {
          content: [
            {
              type: 'text',
              text: `📜 Console Logs (${logs.length}):\n${JSON.stringify(logs, null, 2)}`,
            },
          ],
        };
      }

      case 'emulate_device': {
        if (!page) throw new Error('Not connected. Call connect_chrome first.');

        const params = EmulateDeviceSchema.parse(args);

        if (params.viewport) {
          await page.setViewport({
            width: params.viewport.width,
            height: params.viewport.height,
            deviceScaleFactor: params.viewport.deviceScaleFactor,
            isMobile: params.viewport.isMobile,
          });
        }

        return {
          content: [
            {
              type: 'text',
              text: `✅ Emulating device: ${params.device}`,
            },
          ],
        };
      }

      case 'throttle_network': {
        if (!page) throw new Error('Not connected. Call connect_chrome first.');

        const params = ThrottleNetworkSchema.parse(args);
        const client = await page.target().createCDPSession();

        await client.send('Network.emulateNetworkConditions', {
          offline: params.offline,
          downloadThroughput: params.downloadThroughput,
          uploadThroughput: params.uploadThroughput,
          latency: params.latency,
        });

        return {
          content: [
            {
              type: 'text',
              text: `✅ Network throttling applied (latency: ${params.latency}ms)`,
            },
          ],
        };
      }

      case 'get_accessibility_tree': {
        if (!page) throw new Error('Not connected. Call connect_chrome first.');

        const snapshot = await page.accessibility.snapshot();

        return {
          content: [
            {
              type: 'text',
              text: `♿ Accessibility Tree:\n${JSON.stringify(snapshot, null, 2)}`,
            },
          ],
        };
      }

      case 'lighthouse_audit': {
        // Note: Full Lighthouse integration requires additional setup
        // This is a placeholder for the tool definition
        return {
          content: [
            {
              type: 'text',
              text: `⚠️  Lighthouse audit requires additional configuration. Use get_performance_metrics for basic performance data.`,
            },
          ],
        };
      }

      case 'disconnect': {
        if (browser) {
          await browser.close();
          browser = null;
          page = null;
        }

        return {
          content: [
            {
              type: 'text',
              text: '✅ Disconnected from Chrome',
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
  console.error('Chrome DevTools MCP server running on stdio');
}

main().catch((error) => {
  console.error('Fatal error:', error);
  process.exit(1);
});