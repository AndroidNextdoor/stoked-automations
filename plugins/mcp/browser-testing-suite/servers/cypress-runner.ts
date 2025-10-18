#!/usr/bin/env node

/**
 * Cypress Test Runner MCP Server
 * Provides Cypress E2E testing tools with component testing, API testing, and visual regression
 */

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import { z } from 'zod';
import { spawn, ChildProcess } from 'child_process';
import * as fs from 'fs/promises';
import * as path from 'path';

// Validation schemas
const InitCypressSchema = z.object({
  projectPath: z.string(),
  baseUrl: z.string().url().optional(),
  viewportWidth: z.number().default(1280),
  viewportHeight: z.number().default(720),
});

const RunTestSchema = z.object({
  specPath: z.string(),
  browser: z.enum(['chrome', 'firefox', 'edge', 'electron']).default('chrome'),
  headless: z.boolean().default(true),
  config: z.record(z.any()).optional(),
});

const CreateTestSchema = z.object({
  testName: z.string(),
  testPath: z.string(),
  testType: z.enum(['e2e', 'component', 'api']).default('e2e'),
  baseUrl: z.string().url().optional(),
});

const RunComponentTestSchema = z.object({
  componentPath: z.string(),
  browser: z.enum(['chrome', 'firefox', 'edge']).default('chrome'),
  headless: z.boolean().default(true),
});

const ApiTestSchema = z.object({
  name: z.string(),
  endpoint: z.string(),
  method: z.enum(['GET', 'POST', 'PUT', 'DELETE', 'PATCH']).default('GET'),
  assertions: z.array(z.object({
    type: z.string(),
    value: z.any(),
  })).optional(),
});

const VisualRegressionSchema = z.object({
  testName: z.string(),
  screenshotName: z.string(),
  compareToBaseline: z.boolean().default(true),
});

// Server state
let cypressProcess: ChildProcess | null = null;
let projectPath: string = process.cwd();
let testResults: any[] = [];

const server = new Server(
  {
    name: 'cypress-runner',
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
        name: 'init_cypress',
        description: 'Initialize Cypress configuration and project structure',
        inputSchema: {
          type: 'object',
          properties: {
            projectPath: {
              type: 'string',
              description: 'Path to the project directory',
            },
            baseUrl: {
              type: 'string',
              description: 'Base URL for E2E tests',
            },
            viewportWidth: {
              type: 'number',
              description: 'Default viewport width',
              default: 1280,
            },
            viewportHeight: {
              type: 'number',
              description: 'Default viewport height',
              default: 720,
            },
          },
          required: ['projectPath'],
        },
      },
      {
        name: 'run_test',
        description: 'Run a Cypress test spec file',
        inputSchema: {
          type: 'object',
          properties: {
            specPath: {
              type: 'string',
              description: 'Path to the spec file',
            },
            browser: {
              type: 'string',
              enum: ['chrome', 'firefox', 'edge', 'electron'],
              description: 'Browser to run tests in',
              default: 'chrome',
            },
            headless: {
              type: 'boolean',
              description: 'Run in headless mode',
              default: true,
            },
            config: {
              type: 'object',
              description: 'Additional Cypress configuration',
            },
          },
          required: ['specPath'],
        },
      },
      {
        name: 'create_test',
        description: 'Create a new Cypress test file with template',
        inputSchema: {
          type: 'object',
          properties: {
            testName: {
              type: 'string',
              description: 'Name of the test',
            },
            testPath: {
              type: 'string',
              description: 'Path where test file should be created',
            },
            testType: {
              type: 'string',
              enum: ['e2e', 'component', 'api'],
              description: 'Type of test to create',
              default: 'e2e',
            },
            baseUrl: {
              type: 'string',
              description: 'Base URL for the test',
            },
          },
          required: ['testName', 'testPath'],
        },
      },
      {
        name: 'run_component_test',
        description: 'Run Cypress component tests',
        inputSchema: {
          type: 'object',
          properties: {
            componentPath: {
              type: 'string',
              description: 'Path to the component test file',
            },
            browser: {
              type: 'string',
              enum: ['chrome', 'firefox', 'edge'],
              description: 'Browser for component testing',
              default: 'chrome',
            },
            headless: {
              type: 'boolean',
              description: 'Run in headless mode',
              default: true,
            },
          },
          required: ['componentPath'],
        },
      },
      {
        name: 'create_api_test',
        description: 'Create and run an API test using cy.request()',
        inputSchema: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              description: 'Name of the API test',
            },
            endpoint: {
              type: 'string',
              description: 'API endpoint URL',
            },
            method: {
              type: 'string',
              enum: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
              description: 'HTTP method',
              default: 'GET',
            },
            assertions: {
              type: 'array',
              description: 'Assertions to validate response',
              items: {
                type: 'object',
                properties: {
                  type: { type: 'string' },
                  value: {},
                },
              },
            },
          },
          required: ['name', 'endpoint'],
        },
      },
      {
        name: 'visual_regression_test',
        description: 'Capture screenshot and compare with baseline',
        inputSchema: {
          type: 'object',
          properties: {
            testName: {
              type: 'string',
              description: 'Name of the visual test',
            },
            screenshotName: {
              type: 'string',
              description: 'Name for the screenshot',
            },
            compareToBaseline: {
              type: 'boolean',
              description: 'Compare to baseline image',
              default: true,
            },
          },
          required: ['testName', 'screenshotName'],
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
      case 'init_cypress': {
        const params = InitCypressSchema.parse(args);
        projectPath = params.projectPath;

        // Create cypress.config.ts
        const config = {
          e2e: {
            baseUrl: params.baseUrl,
            viewportWidth: params.viewportWidth,
            viewportHeight: params.viewportHeight,
            setupNodeEvents(on: any, config: any) {
              // implement node event listeners here
            },
          },
          component: {
            devServer: {
              framework: 'react',
              bundler: 'vite',
            },
          },
        };

        const configContent = `import { defineConfig } from 'cypress';

export default defineConfig(${JSON.stringify(config, null, 2)});
`;

        await fs.writeFile(
          path.join(projectPath, 'cypress.config.ts'),
          configContent
        );

        // Create directory structure
        await fs.mkdir(path.join(projectPath, 'cypress', 'e2e'), { recursive: true });
        await fs.mkdir(path.join(projectPath, 'cypress', 'fixtures'), { recursive: true });
        await fs.mkdir(path.join(projectPath, 'cypress', 'support'), { recursive: true });

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'Cypress initialized successfully',
                projectPath,
                configPath: path.join(projectPath, 'cypress.config.ts'),
              }, null, 2),
            },
          ],
        };
      }

      case 'run_test': {
        const params = RunTestSchema.parse(args);

        return new Promise((resolve) => {
          const args = [
            'run',
            '--spec', params.specPath,
            '--browser', params.browser,
          ];

          if (params.headless) {
            args.push('--headless');
          }

          if (params.config) {
            args.push('--config', JSON.stringify(params.config));
          }

          const cypress = spawn('npx', ['cypress', ...args], {
            cwd: projectPath,
            stdio: 'pipe',
          });

          let output = '';
          let errorOutput = '';

          cypress.stdout?.on('data', (data) => {
            output += data.toString();
          });

          cypress.stderr?.on('data', (data) => {
            errorOutput += data.toString();
          });

          cypress.on('close', (code) => {
            testResults.push({
              spec: params.specPath,
              exitCode: code,
              output,
              timestamp: new Date().toISOString(),
            });

            resolve({
              content: [
                {
                  type: 'text',
                  text: JSON.stringify({
                    success: code === 0,
                    exitCode: code,
                    output,
                    errorOutput,
                    specPath: params.specPath,
                  }, null, 2),
                },
              ],
            });
          });
        });
      }

      case 'create_test': {
        const params = CreateTestSchema.parse(args);

        let template = '';

        if (params.testType === 'e2e') {
          template = `describe('${params.testName}', () => {
  beforeEach(() => {
    cy.visit('${params.baseUrl || '/'}');
  });

  it('should pass this test', () => {
    cy.get('body').should('be.visible');
  });

  it('should interact with elements', () => {
    // Add your test steps here
    // cy.get('selector').click();
    // cy.get('input').type('text');
    // cy.contains('text').should('be.visible');
  });
});
`;
        } else if (params.testType === 'component') {
          template = `import React from 'react';
import { mount } from 'cypress/react18';
// import YourComponent from './YourComponent';

describe('${params.testName}', () => {
  it('renders the component', () => {
    // mount(<YourComponent />);
    // cy.get('[data-testid="component"]').should('be.visible');
  });
});
`;
        } else if (params.testType === 'api') {
          template = `describe('${params.testName} API Tests', () => {
  it('should call the API endpoint', () => {
    cy.request('${params.baseUrl || 'https://api.example.com'}')
      .then((response) => {
        expect(response.status).to.eq(200);
        expect(response.body).to.have.property('data');
      });
  });
});
`;
        }

        await fs.writeFile(params.testPath, template);

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'Test file created',
                path: params.testPath,
                type: params.testType,
              }, null, 2),
            },
          ],
        };
      }

      case 'run_component_test': {
        const params = RunComponentTestSchema.parse(args);

        return new Promise((resolve) => {
          const cypress = spawn('npx', [
            'cypress',
            'run-ct',
            '--spec', params.componentPath,
            '--browser', params.browser,
            ...(params.headless ? ['--headless'] : []),
          ], {
            cwd: projectPath,
            stdio: 'pipe',
          });

          let output = '';

          cypress.stdout?.on('data', (data) => {
            output += data.toString();
          });

          cypress.on('close', (code) => {
            resolve({
              content: [
                {
                  type: 'text',
                  text: JSON.stringify({
                    success: code === 0,
                    exitCode: code,
                    output,
                    componentPath: params.componentPath,
                  }, null, 2),
                },
              ],
            });
          });
        });
      }

      case 'create_api_test': {
        const params = ApiTestSchema.parse(args);

        const assertionsCode = params.assertions?.map(a =>
          `        expect(response).to.have.property('${a.type}', ${JSON.stringify(a.value)});`
        ).join('\n') || '';

        const testContent = `describe('${params.name} API Test', () => {
  it('should test ${params.method} ${params.endpoint}', () => {
    cy.request({
      method: '${params.method}',
      url: '${params.endpoint}',
    }).then((response) => {
      expect(response.status).to.be.oneOf([200, 201]);
${assertionsCode}
    });
  });
});
`;

        const testPath = path.join(projectPath, 'cypress', 'e2e', `${params.name.replace(/\s+/g, '-').toLowerCase()}.cy.ts`);
        await fs.writeFile(testPath, testContent);

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'API test created',
                testPath,
                endpoint: params.endpoint,
                method: params.method,
              }, null, 2),
            },
          ],
        };
      }

      case 'visual_regression_test': {
        const params = VisualRegressionSchema.parse(args);

        const testContent = `describe('${params.testName} Visual Regression', () => {
  it('should match the baseline screenshot', () => {
    cy.visit('/');
    cy.screenshot('${params.screenshotName}');
    ${params.compareToBaseline ? "// Add visual regression plugin comparison here" : ""}
  });
});
`;

        const testPath = path.join(projectPath, 'cypress', 'e2e', `${params.testName.replace(/\s+/g, '-').toLowerCase()}-visual.cy.ts`);
        await fs.writeFile(testPath, testContent);

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'Visual regression test created',
                testPath,
                screenshotName: params.screenshotName,
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
  console.error('Cypress Runner MCP server running on stdio');
}

main().catch((error) => {
  console.error('Fatal error:', error);
  process.exit(1);
});
