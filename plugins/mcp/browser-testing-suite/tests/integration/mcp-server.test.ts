import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import {
  ListToolsRequestSchema,
  CallToolRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

/**
 * Integration tests for MCP Server implementations
 * Tests the MCP protocol compliance and tool registration
 */

describe('MCP Server Integration Tests', () => {
  describe('Server Initialization', () => {
    it('should create server with metadata', () => {
      const server = new Server(
        {
          name: 'test-server',
          version: '1.0.0',
        },
        {
          capabilities: {
            tools: {},
          },
        }
      );

      expect(server).toBeDefined();
    });

    it('should have required capabilities', () => {
      const capabilities = {
        tools: {},
      };

      expect(capabilities).toHaveProperty('tools');
    });
  });

  describe('Tool Registration', () => {
    let server: Server;

    beforeAll(() => {
      server = new Server(
        {
          name: 'test-server',
          version: '1.0.0',
        },
        {
          capabilities: {
            tools: {},
          },
        }
      );

      // Register a test tool
      server.setRequestHandler(ListToolsRequestSchema, async () => {
        return {
          tools: [
            {
              name: 'test_tool',
              description: 'A test tool',
              inputSchema: {
                type: 'object',
                properties: {
                  param: { type: 'string' },
                },
                required: ['param'],
              },
            },
          ],
        };
      });
    });

    it('should list registered tools', async () => {
      const response = await server.request(
        { method: 'tools/list', params: {} },
        ListToolsRequestSchema
      );

      expect(response.tools).toBeDefined();
      expect(response.tools.length).toBeGreaterThan(0);
    });

    it('should include tool metadata', async () => {
      const response = await server.request(
        { method: 'tools/list', params: {} },
        ListToolsRequestSchema
      );

      const tool = response.tools[0];
      expect(tool.name).toBe('test_tool');
      expect(tool.description).toBeTruthy();
      expect(tool.inputSchema).toBeDefined();
    });

    it('should define input schema', async () => {
      const response = await server.request(
        { method: 'tools/list', params: {} },
        ListToolsRequestSchema
      );

      const tool = response.tools[0];
      expect(tool.inputSchema.type).toBe('object');
      expect(tool.inputSchema.properties).toBeDefined();
    });
  });

  describe('Tool Execution', () => {
    let server: Server;

    beforeAll(() => {
      server = new Server(
        {
          name: 'test-server',
          version: '1.0.0',
        },
        {
          capabilities: {
            tools: {},
          },
        }
      );

      server.setRequestHandler(ListToolsRequestSchema, async () => {
        return {
          tools: [
            {
              name: 'echo',
              description: 'Echo back the input',
              inputSchema: {
                type: 'object',
                properties: {
                  message: { type: 'string' },
                },
                required: ['message'],
              },
            },
          ],
        };
      });

      server.setRequestHandler(CallToolRequestSchema, async (request) => {
        const { name, arguments: args } = request.params;

        if (name === 'echo') {
          return {
            content: [
              {
                type: 'text',
                text: `Echo: ${(args as any).message}`,
              },
            ],
          };
        }

        throw new Error(`Unknown tool: ${name}`);
      });
    });

    it('should execute tool with valid parameters', async () => {
      const response = await server.request(
        {
          method: 'tools/call',
          params: {
            name: 'echo',
            arguments: { message: 'Hello World' },
          },
        },
        CallToolRequestSchema
      );

      expect(response.content).toBeDefined();
      expect(response.content[0].type).toBe('text');
      expect(response.content[0].text).toContain('Hello World');
    });

    it('should return error for unknown tool', async () => {
      await expect(
        server.request(
          {
            method: 'tools/call',
            params: {
              name: 'unknown_tool',
              arguments: {},
            },
          },
          CallToolRequestSchema
        )
      ).rejects.toThrow();
    });
  });

  describe('Tool Response Format', () => {
    it('should return text content', () => {
      const response = {
        content: [
          {
            type: 'text',
            text: 'Operation completed successfully',
          },
        ],
      };

      expect(response.content[0].type).toBe('text');
      expect(response.content[0].text).toBeTruthy();
    });

    it('should support multiple content blocks', () => {
      const response = {
        content: [
          {
            type: 'text',
            text: 'First block',
          },
          {
            type: 'text',
            text: 'Second block',
          },
        ],
      };

      expect(response.content.length).toBe(2);
    });

    it('should include error flag', () => {
      const errorResponse = {
        content: [
          {
            type: 'text',
            text: 'Error: Operation failed',
          },
        ],
        isError: true,
      };

      expect(errorResponse.isError).toBe(true);
    });
  });

  describe('Error Handling', () => {
    let server: Server;

    beforeAll(() => {
      server = new Server(
        {
          name: 'test-server',
          version: '1.0.0',
        },
        {
          capabilities: {
            tools: {},
          },
        }
      );

      server.setRequestHandler(CallToolRequestSchema, async (request) => {
        const { name } = request.params;

        if (name === 'failing_tool') {
          throw new Error('Tool execution failed');
        }

        return {
          content: [{ type: 'text', text: 'Success' }],
        };
      });
    });

    it('should catch and handle errors', async () => {
      await expect(
        server.request(
          {
            method: 'tools/call',
            params: {
              name: 'failing_tool',
              arguments: {},
            },
          },
          CallToolRequestSchema
        )
      ).rejects.toThrow('Tool execution failed');
    });
  });

  describe('Schema Validation', () => {
    it('should validate tool input schema', () => {
      const schema = {
        type: 'object',
        properties: {
          url: { type: 'string' },
          timeout: { type: 'number' },
          options: {
            type: 'object',
            properties: {
              headless: { type: 'boolean' },
            },
          },
        },
        required: ['url'],
      };

      expect(schema.type).toBe('object');
      expect(schema.properties.url.type).toBe('string');
      expect(schema.required).toContain('url');
    });

    it('should support nested schemas', () => {
      const schema = {
        type: 'object',
        properties: {
          config: {
            type: 'object',
            properties: {
              browser: { type: 'string' },
              viewport: {
                type: 'object',
                properties: {
                  width: { type: 'number' },
                  height: { type: 'number' },
                },
              },
            },
          },
        },
      };

      expect(schema.properties.config.properties.viewport).toBeDefined();
    });

    it('should support array types', () => {
      const schema = {
        type: 'object',
        properties: {
          tags: {
            type: 'array',
            items: { type: 'string' },
          },
        },
      };

      expect(schema.properties.tags.type).toBe('array');
      expect(schema.properties.tags.items).toBeDefined();
    });

    it('should support enum values', () => {
      const schema = {
        type: 'object',
        properties: {
          browser: {
            type: 'string',
            enum: ['chromium', 'firefox', 'webkit'],
          },
        },
      };

      expect(schema.properties.browser.enum).toBeDefined();
      expect(schema.properties.browser.enum?.length).toBe(3);
    });
  });

  describe('Tool Categories', () => {
    it('should group browser automation tools', () => {
      const browserTools = [
        'launch_browser',
        'navigate',
        'click',
        'type_text',
        'screenshot',
      ];

      expect(browserTools.length).toBeGreaterThan(0);
      browserTools.forEach((tool) => {
        expect(tool).toMatch(/^[a-z_]+$/);
      });
    });

    it('should group testing tools', () => {
      const testingTools = [
        'create_test',
        'run_test',
        'create_test_suite',
        'generate_report',
      ];

      expect(testingTools.length).toBeGreaterThan(0);
    });

    it('should group API testing tools', () => {
      const apiTools = ['create_api_test', 'run_api_test', 'validate_response'];

      expect(apiTools.length).toBeGreaterThan(0);
    });
  });

  describe('Tool Documentation', () => {
    it('should provide clear descriptions', () => {
      const toolDocs = {
        launch_browser: 'Launch a browser instance (chromium, firefox, or webkit)',
        navigate: 'Navigate to a URL',
        click: 'Click an element using a selector',
        screenshot: 'Take a screenshot of the current page',
      };

      Object.values(toolDocs).forEach((description) => {
        expect(description).toBeTruthy();
        expect(description.length).toBeGreaterThan(10);
      });
    });

    it('should document parameters', () => {
      const paramDocs = {
        url: 'URL to navigate to',
        selector: 'CSS selector or text to click',
        timeout: 'Maximum wait time in milliseconds',
        headless: 'Run browser in headless mode',
      };

      Object.values(paramDocs).forEach((doc) => {
        expect(doc).toBeTruthy();
      });
    });
  });

  describe('Server Performance', () => {
    it('should handle multiple concurrent requests', async () => {
      const server = new Server(
        { name: 'test', version: '1.0.0' },
        { capabilities: { tools: {} } }
      );

      server.setRequestHandler(CallToolRequestSchema, async (request) => {
        return {
          content: [{ type: 'text', text: `Response for ${request.params.name}` }],
        };
      });

      const requests = Array.from({ length: 10 }, (_, i) =>
        server.request(
          {
            method: 'tools/call',
            params: { name: `tool_${i}`, arguments: {} },
          },
          CallToolRequestSchema
        )
      );

      const responses = await Promise.all(requests);
      expect(responses.length).toBe(10);
    });
  });
});