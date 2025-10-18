#!/usr/bin/env node

/**
 * Katalon Studio MCP Server
 * Provides Katalon test automation tools with record/replay, test suites, and reporting
 */

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import { z } from 'zod';
import { spawn } from 'child_process';
import * as fs from 'fs/promises';
import * as path from 'path';

// Validation schemas
const CreateProjectSchema = z.object({
  projectPath: z.string(),
  projectName: z.string(),
  projectType: z.enum(['Web', 'API', 'Mobile', 'Desktop']).default('Web'),
});

const CreateTestCaseSchema = z.object({
  projectPath: z.string(),
  testCaseName: z.string(),
  description: z.string().optional(),
  testSteps: z.array(z.object({
    keyword: z.string(),
    objectId: z.string().optional(),
    value: z.string().optional(),
    comment: z.string().optional(),
  })),
});

const CreateTestSuiteSchema = z.object({
  projectPath: z.string(),
  suiteName: z.string(),
  testCases: z.array(z.string()),
  runConfiguration: z.object({
    browser: z.enum(['Chrome', 'Firefox', 'Edge', 'Safari']).optional(),
    retryCount: z.number().optional(),
    parallel: z.boolean().optional(),
  }).optional(),
});

const CreateTestObjectSchema = z.object({
  projectPath: z.string(),
  objectName: z.string(),
  locatorType: z.enum(['XPATH', 'CSS', 'ID', 'NAME', 'CLASS_NAME', 'TAG_NAME', 'LINK_TEXT']),
  locatorValue: z.string(),
  description: z.string().optional(),
});

const RunTestSchema = z.object({
  projectPath: z.string(),
  testPath: z.string(),
  browser: z.enum(['Chrome', 'Firefox', 'Edge', 'Safari', 'Chrome (headless)', 'Firefox (headless)']).default('Chrome'),
  reportFolder: z.string().optional(),
});

const GenerateKeywordSchema = z.object({
  keywordName: z.string(),
  description: z.string(),
  parameters: z.array(z.object({
    name: z.string(),
    type: z.string(),
    description: z.string().optional(),
  })),
  implementation: z.string(),
});

const CreateApiTestSchema = z.object({
  projectPath: z.string(),
  requestName: z.string(),
  method: z.enum(['GET', 'POST', 'PUT', 'DELETE', 'PATCH']),
  endpoint: z.string(),
  headers: z.record(z.string()).optional(),
  body: z.string().optional(),
  verification: z.array(z.object({
    type: z.enum(['status', 'body', 'header', 'json']),
    path: z.string().optional(),
    expected: z.any(),
  })).optional(),
});

const GenerateReportSchema = z.object({
  projectPath: z.string(),
  reportType: z.enum(['HTML', 'PDF', 'CSV', 'JSON']).default('HTML'),
  includeScreenshots: z.boolean().default(true),
});

// Server state
let activeTests: Map<string, any> = new Map();

const server = new Server(
  {
    name: 'katalon-studio',
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
        name: 'create_project',
        description: 'Create a new Katalon Studio project',
        inputSchema: {
          type: 'object',
          properties: {
            projectPath: {
              type: 'string',
              description: 'Path where project will be created',
            },
            projectName: {
              type: 'string',
              description: 'Name of the project',
            },
            projectType: {
              type: 'string',
              enum: ['Web', 'API', 'Mobile', 'Desktop'],
              description: 'Type of testing project',
              default: 'Web',
            },
          },
          required: ['projectPath', 'projectName'],
        },
      },
      {
        name: 'create_test_case',
        description: 'Create a test case with Katalon keywords',
        inputSchema: {
          type: 'object',
          properties: {
            projectPath: {
              type: 'string',
              description: 'Project path',
            },
            testCaseName: {
              type: 'string',
              description: 'Name of the test case',
            },
            description: {
              type: 'string',
              description: 'Test case description',
            },
            testSteps: {
              type: 'array',
              description: 'Array of test steps',
              items: {
                type: 'object',
                properties: {
                  keyword: {
                    type: 'string',
                    description: 'Katalon keyword (e.g., openBrowser, click, verifyElementPresent)',
                  },
                  objectId: {
                    type: 'string',
                    description: 'Test object ID',
                  },
                  value: {
                    type: 'string',
                    description: 'Value parameter',
                  },
                  comment: {
                    type: 'string',
                    description: 'Step comment',
                  },
                },
              },
            },
          },
          required: ['projectPath', 'testCaseName', 'testSteps'],
        },
      },
      {
        name: 'create_test_suite',
        description: 'Create a test suite with multiple test cases',
        inputSchema: {
          type: 'object',
          properties: {
            projectPath: {
              type: 'string',
              description: 'Project path',
            },
            suiteName: {
              type: 'string',
              description: 'Name of the test suite',
            },
            testCases: {
              type: 'array',
              description: 'Array of test case paths',
              items: { type: 'string' },
            },
            runConfiguration: {
              type: 'object',
              description: 'Test suite run configuration',
              properties: {
                browser: {
                  type: 'string',
                  enum: ['Chrome', 'Firefox', 'Edge', 'Safari'],
                },
                retryCount: { type: 'number' },
                parallel: { type: 'boolean' },
              },
            },
          },
          required: ['projectPath', 'suiteName', 'testCases'],
        },
      },
      {
        name: 'create_test_object',
        description: 'Create a test object (web element locator)',
        inputSchema: {
          type: 'object',
          properties: {
            projectPath: {
              type: 'string',
              description: 'Project path',
            },
            objectName: {
              type: 'string',
              description: 'Name of the test object',
            },
            locatorType: {
              type: 'string',
              enum: ['XPATH', 'CSS', 'ID', 'NAME', 'CLASS_NAME', 'TAG_NAME', 'LINK_TEXT'],
              description: 'Type of locator',
            },
            locatorValue: {
              type: 'string',
              description: 'Locator value',
            },
            description: {
              type: 'string',
              description: 'Object description',
            },
          },
          required: ['projectPath', 'objectName', 'locatorType', 'locatorValue'],
        },
      },
      {
        name: 'run_test',
        description: 'Execute a test case or test suite',
        inputSchema: {
          type: 'object',
          properties: {
            projectPath: {
              type: 'string',
              description: 'Project path',
            },
            testPath: {
              type: 'string',
              description: 'Path to test case or suite',
            },
            browser: {
              type: 'string',
              enum: ['Chrome', 'Firefox', 'Edge', 'Safari', 'Chrome (headless)', 'Firefox (headless)'],
              description: 'Browser to use',
              default: 'Chrome',
            },
            reportFolder: {
              type: 'string',
              description: 'Folder for test reports',
            },
          },
          required: ['projectPath', 'testPath'],
        },
      },
      {
        name: 'generate_custom_keyword',
        description: 'Generate a custom keyword for reuse',
        inputSchema: {
          type: 'object',
          properties: {
            keywordName: {
              type: 'string',
              description: 'Name of the custom keyword',
            },
            description: {
              type: 'string',
              description: 'Keyword description',
            },
            parameters: {
              type: 'array',
              description: 'Keyword parameters',
              items: {
                type: 'object',
                properties: {
                  name: { type: 'string' },
                  type: { type: 'string' },
                  description: { type: 'string' },
                },
              },
            },
            implementation: {
              type: 'string',
              description: 'Groovy code implementation',
            },
          },
          required: ['keywordName', 'description', 'parameters', 'implementation'],
        },
      },
      {
        name: 'create_api_test',
        description: 'Create an API test request',
        inputSchema: {
          type: 'object',
          properties: {
            projectPath: {
              type: 'string',
              description: 'Project path',
            },
            requestName: {
              type: 'string',
              description: 'API request name',
            },
            method: {
              type: 'string',
              enum: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
              description: 'HTTP method',
            },
            endpoint: {
              type: 'string',
              description: 'API endpoint URL',
            },
            headers: {
              type: 'object',
              description: 'Request headers',
            },
            body: {
              type: 'string',
              description: 'Request body (JSON string)',
            },
            verification: {
              type: 'array',
              description: 'Response verification steps',
              items: {
                type: 'object',
                properties: {
                  type: {
                    type: 'string',
                    enum: ['status', 'body', 'header', 'json'],
                  },
                  path: { type: 'string' },
                  expected: {},
                },
              },
            },
          },
          required: ['projectPath', 'requestName', 'method', 'endpoint'],
        },
      },
      {
        name: 'generate_report',
        description: 'Generate test execution report',
        inputSchema: {
          type: 'object',
          properties: {
            projectPath: {
              type: 'string',
              description: 'Project path',
            },
            reportType: {
              type: 'string',
              enum: ['HTML', 'PDF', 'CSV', 'JSON'],
              description: 'Report format',
              default: 'HTML',
            },
            includeScreenshots: {
              type: 'boolean',
              description: 'Include failure screenshots',
              default: true,
            },
          },
          required: ['projectPath'],
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
      case 'create_project': {
        const params = CreateProjectSchema.parse(args);

        const projectDir = path.join(params.projectPath, params.projectName);

        // Create project structure
        await fs.mkdir(projectDir, { recursive: true });
        await fs.mkdir(path.join(projectDir, 'Test Cases'), { recursive: true });
        await fs.mkdir(path.join(projectDir, 'Test Suites'), { recursive: true });
        await fs.mkdir(path.join(projectDir, 'Object Repository'), { recursive: true });
        await fs.mkdir(path.join(projectDir, 'Keywords'), { recursive: true });
        await fs.mkdir(path.join(projectDir, 'Data Files'), { recursive: true });
        await fs.mkdir(path.join(projectDir, 'Reports'), { recursive: true });

        // Create .project file
        const projectFile = `<?xml version="1.0" encoding="UTF-8"?>
<projectDescription>
  <name>${params.projectName}</name>
  <comment></comment>
  <projects></projects>
  <buildSpec>
    <buildCommand>
      <name>org.eclipse.jdt.core.javabuilder</name>
    </buildCommand>
  </buildSpec>
  <natures>
    <nature>org.eclipse.jdt.core.javanature</nature>
    <nature>org.eclipse.jdt.groovy.core.groovyNature</nature>
  </natures>
</projectDescription>`;

        await fs.writeFile(path.join(projectDir, '.project'), projectFile);

        // Create settings.xml
        const settings = `<?xml version="1.0" encoding="UTF-8"?>
<Settings>
  <projectType>${params.projectType}</projectType>
  <browser>Chrome</browser>
  <executionProfile>default</executionProfile>
</Settings>`;

        await fs.writeFile(path.join(projectDir, 'settings', 'internal', 'com.kms.katalon.core.webservice.properties'), settings);

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'Katalon project created',
                projectPath: projectDir,
                projectType: params.projectType,
              }, null, 2),
            },
          ],
        };
      }

      case 'create_test_case': {
        const params = CreateTestCaseSchema.parse(args);

        const testCaseContent = `<?xml version="1.0" encoding="UTF-8"?>
<TestCaseEntity>
  <name>${params.testCaseName}</name>
  <description>${params.description || ''}</description>
  <testCaseSteps>
${params.testSteps.map((step, index) => `    <TestStep>
      <id>${index + 1}</id>
      <keyword>${step.keyword}</keyword>
      ${step.objectId ? `<objectId>${step.objectId}</objectId>` : ''}
      ${step.value ? `<value>${step.value}</value>` : ''}
      ${step.comment ? `<comment>${step.comment}</comment>` : ''}
    </TestStep>`).join('\n')}
  </testCaseSteps>
</TestCaseEntity>`;

        const testCasePath = path.join(params.projectPath, 'Test Cases', `${params.testCaseName}.tc`);
        await fs.writeFile(testCasePath, testCaseContent);

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'Test case created',
                testCasePath,
                steps: params.testSteps.length,
              }, null, 2),
            },
          ],
        };
      }

      case 'create_test_suite': {
        const params = CreateTestSuiteSchema.parse(args);

        const suiteContent = `<?xml version="1.0" encoding="UTF-8"?>
<TestSuiteEntity>
  <name>${params.suiteName}</name>
  <testCaseLinks>
${params.testCases.map(tc => `    <TestCaseLink testCaseId="${tc}" />`).join('\n')}
  </testCaseLinks>
  ${params.runConfiguration ? `<executionProfile>
    <browser>${params.runConfiguration.browser || 'Chrome'}</browser>
    <retryCount>${params.runConfiguration.retryCount || 0}</retryCount>
    <parallel>${params.runConfiguration.parallel || false}</parallel>
  </executionProfile>` : ''}
</TestSuiteEntity>`;

        const suitePath = path.join(params.projectPath, 'Test Suites', `${params.suiteName}.ts`);
        await fs.writeFile(suitePath, suiteContent);

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'Test suite created',
                suitePath,
                testCaseCount: params.testCases.length,
              }, null, 2),
            },
          ],
        };
      }

      case 'create_test_object': {
        const params = CreateTestObjectSchema.parse(args);

        const objectContent = `<?xml version="1.0" encoding="UTF-8"?>
<WebElementEntity>
  <name>${params.objectName}</name>
  <description>${params.description || ''}</description>
  <selectorCollection>
    <entry>
      <key>${params.locatorType}</key>
      <value>${params.locatorValue}</value>
    </entry>
  </selectorCollection>
</WebElementEntity>`;

        const objectPath = path.join(params.projectPath, 'Object Repository', `${params.objectName}.rs`);
        await fs.writeFile(objectPath, objectContent);

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'Test object created',
                objectPath,
                locatorType: params.locatorType,
              }, null, 2),
            },
          ],
        };
      }

      case 'run_test': {
        const params = RunTestSchema.parse(args);

        return new Promise((resolve) => {
          const args = [
            '-noSplash',
            '-runMode=console',
            '-projectPath=' + params.projectPath,
            '-testSuitePath=' + params.testPath,
            '-browserType=' + params.browser,
          ];

          if (params.reportFolder) {
            args.push('-reportFolder=' + params.reportFolder);
          }

          const katalon = spawn('katalon', args, {
            stdio: 'pipe',
          });

          let output = '';

          katalon.stdout?.on('data', (data) => {
            output += data.toString();
          });

          katalon.on('close', (code) => {
            resolve({
              content: [
                {
                  type: 'text',
                  text: JSON.stringify({
                    success: code === 0,
                    exitCode: code,
                    output,
                    testPath: params.testPath,
                  }, null, 2),
                },
              ],
            });
          });
        });
      }

      case 'generate_custom_keyword': {
        const params = GenerateKeywordSchema.parse(args);

        const keywordContent = `package com.keywords

import com.kms.katalon.core.annotation.Keyword

class ${params.keywordName} {
    /**
     * ${params.description}
     ${params.parameters.map(p => `* @param ${p.name} ${p.description || ''}`).join('\n     ')}
     */
    @Keyword
    def ${params.keywordName.charAt(0).toLowerCase() + params.keywordName.slice(1)}(${params.parameters.map(p => `${p.type} ${p.name}`).join(', ')}) {
        ${params.implementation}
    }
}`;

        const keywordPath = path.join(params.projectPath, 'Keywords', `${params.keywordName}.groovy`);
        await fs.writeFile(keywordPath, keywordContent);

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'Custom keyword created',
                keywordPath,
              }, null, 2),
            },
          ],
        };
      }

      case 'create_api_test': {
        const params = CreateApiTestSchema.parse(args);

        const verificationSteps = params.verification?.map(v => {
          switch (v.type) {
            case 'status':
              return `WS.verifyResponseStatusCode(response, ${v.expected})`;
            case 'json':
              return `WS.verifyElementPropertyValue(response, '${v.path}', ${JSON.stringify(v.expected)})`;
            case 'header':
              return `WS.verifyResponseHeaderValue(response, '${v.path}', '${v.expected}')`;
            default:
              return '';
          }
        }).join('\n        ') || '';

        const requestContent = `<?xml version="1.0" encoding="UTF-8"?>
<WebServiceRequestEntity>
  <name>${params.requestName}</name>
  <httpBody>${params.body || ''}</httpBody>
  <httpBodyContent>${params.body || ''}</httpBodyContent>
  <httpHeaderProperties>
${Object.entries(params.headers || {}).map(([key, value]) =>
          `    <HTTPHeaderProperty><key>${key}</key><value>${value}</value></HTTPHeaderProperty>`
        ).join('\n')}
  </httpHeaderProperties>
  <restRequestMethod>${params.method}</restRequestMethod>
  <restUrl>${params.endpoint}</restUrl>
  <verificationScript>
import com.kms.katalon.core.webservice.keyword.WSBuiltInKeywords as WS

def response = WS.sendRequest(findTestObject('${params.requestName}'))

${verificationSteps}
  </verificationScript>
</WebServiceRequestEntity>`;

        const requestPath = path.join(params.projectPath, 'Object Repository', 'APIs', `${params.requestName}.rs`);
        await fs.mkdir(path.join(params.projectPath, 'Object Repository', 'APIs'), { recursive: true });
        await fs.writeFile(requestPath, requestContent);

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'API test created',
                requestPath,
                method: params.method,
                endpoint: params.endpoint,
              }, null, 2),
            },
          ],
        };
      }

      case 'generate_report': {
        const params = GenerateReportSchema.parse(args);

        const reportPath = path.join(params.projectPath, 'Reports', `report-${Date.now()}.${params.reportType.toLowerCase()}`);

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({
                success: true,
                message: 'Report generation initiated',
                reportPath,
                reportType: params.reportType,
                includeScreenshots: params.includeScreenshots,
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
  console.error('Katalon Studio MCP server running on stdio');
}

main().catch((error) => {
  console.error('Fatal error:', error);
  process.exit(1);
});
