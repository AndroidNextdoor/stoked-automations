# Context7 MCP Server

Up-to-date code documentation for LLMs and AI code editors. Context7 fetches current, version-specific documentation and code examples directly from the source, eliminating outdated information and hallucinated APIs.

## Overview

Context7 is an MCP (Model Context Protocol) server that provides:

- **Up-to-date Documentation**: Pulls version-specific docs straight from the source
- **Code Examples**: Delivers clean code snippets and explanations
- **Smart Context**: Indexes entire project documentation with proprietary ranking algorithm
- **No Hallucinations**: Eliminates outdated or generic information from LLM responses

## Features

- Real-time documentation fetching from Context7.com's documentation database
- Version-specific API references and code examples
- Intelligent project ranking and filtering
- Customizable token limits
- Support for multiple frameworks and libraries

## Prerequisites

Before using this plugin, you need:

1. **Node.js 18 or higher**
   ```bash
   node --version  # Should be 18.0.0 or higher
   ```

2. **Context7 API Key**
   - Visit [https://context7.com](https://context7.com)
   - Create an account
   - Generate an API key from your dashboard

3. **Environment Variable**
   ```bash
   # Add to ~/.zshrc or ~/.bashrc
   export CONTEXT7_API_KEY='your-api-key-here'

   # Reload your shell
   source ~/.zshrc  # or source ~/.bashrc
   ```

## Installation

Install the plugin from the Stoked Automations marketplace:

```bash
# Add marketplace (if not already added)
/plugin marketplace add AndroidNextdoor/stoked-automations

# Install Context7 plugin
/plugin install context7@stoked-automations
```

## MCP Tools

This plugin provides 2 MCP tools:

### 1. `resolve_library`
Resolves a general library name into a Context7-compatible library ID.

**Example:**
```
User: "I need docs for React 18"
→ resolve_library("React") → "react@18"
```

### 2. `fetch_documentation`
Fetches documentation for a library using a Context7-compatible library ID.

**Example:**
```
User: "Show me React hooks documentation"
→ fetch_documentation("react@18", "hooks") → [Current React hooks docs]
```

## Usage

Once installed, Claude Code will automatically use Context7 to fetch up-to-date documentation when you ask about libraries or frameworks:

### Example 1: Getting Current API Documentation
```
User: "How do I use React's useEffect hook?"
Claude: [Uses Context7 to fetch latest React 18 docs]
        "According to the current React documentation..."
```

### Example 2: Version-Specific Examples
```
User: "Show me Express.js middleware examples"
Claude: [Uses Context7 to get Express v5 docs]
        "Here's the latest middleware pattern from Express v5..."
```

### Example 3: Multiple Libraries
```
User: "I need to integrate Prisma with Next.js"
Claude: [Fetches docs for both Prisma and Next.js]
        "Here's how to set up Prisma with Next.js 14..."
```

## Configuration

The MCP server is configured in `.claude-plugin/mcp/server.json`:

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"],
      "env": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      }
    }
  }
}
```

### Alternative Runtime Configurations

**Using Bun:**
```json
{
  "command": "bunx",
  "args": ["-y", "@upstash/context7-mcp"]
}
```

**Using Deno:**
```json
{
  "command": "deno",
  "args": ["run", "--allow-env", "--allow-net", "npm:@upstash/context7-mcp"]
}
```

**Windows:**
```json
{
  "command": "cmd",
  "args": ["/c", "npx", "-y", "@upstash/context7-mcp", "--api-key", "${CONTEXT7_API_KEY}"]
}
```

## How It Works

1. **User Query**: You ask Claude about a library or framework
2. **Library Resolution**: Context7 resolves the library name to a version-specific ID
3. **Documentation Fetch**: Current docs are fetched from Context7's database
4. **Context Injection**: Clean, relevant docs are injected into Claude's context
5. **Response**: Claude provides accurate, up-to-date information

## Benefits

- **No Outdated Info**: Always get current documentation
- **Version-Specific**: Docs match the exact version you're using
- **No Tab Switching**: Documentation seamlessly integrated into conversation
- **Reduced Hallucinations**: Grounded in actual, current documentation
- **Faster Development**: Instant access to relevant code examples

## Pricing

Context7 operates on a freemium model:

- **Free Tier**: Available with API key from context7.com
- **Paid Plans**: Higher usage limits and additional features
- Visit [https://context7.com/pricing](https://context7.com/pricing) for details

## Troubleshooting

### API Key Not Found

If you see "CONTEXT7_API_KEY not found":

1. Verify the environment variable is set:
   ```bash
   echo $CONTEXT7_API_KEY
   ```

2. Add to your shell config if missing:
   ```bash
   echo "export CONTEXT7_API_KEY='your-key'" >> ~/.zshrc
   source ~/.zshrc
   ```

### NPM Package Not Found

If Context7 isn't working:

1. Check Node.js version:
   ```bash
   node --version  # Must be 18+
   ```

2. Manually install the package:
   ```bash
   npm install -g @upstash/context7-mcp
   ```

### Rate Limiting

If you hit rate limits:

- Check your Context7 plan limits at [https://context7.com/dashboard](https://context7.com/dashboard)
- Upgrade to a paid plan for higher limits
- Space out documentation requests

## Resources

- **Official Repository**: [https://github.com/upstash/context7](https://github.com/upstash/context7)
- **NPM Package**: [https://www.npmjs.com/package/@upstash/context7-mcp](https://www.npmjs.com/package/@upstash/context7-mcp)
- **Context7 Website**: [https://context7.com](https://context7.com)
- **Upstash Blog**: [https://upstash.com/blog/context7-llmtxt-cursor](https://upstash.com/blog/context7-llmtxt-cursor)

## License

MIT License - See [LICENSE](LICENSE) file for details

## Author

**Upstash**
- Website: [https://upstash.com](https://upstash.com)
- GitHub: [https://github.com/upstash](https://github.com/upstash)

## Contributing

This plugin is part of the Stoked Automations marketplace. To contribute:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

See [CONTRIBUTING.md](../../../CONTRIBUTING.md) for guidelines.

## Support

For issues related to:

- **This Plugin**: Open an issue at [Stoked Automations Issues](https://github.com/AndroidNextdoor/stoked-automations/issues)
- **Context7 MCP Server**: Open an issue at [Context7 Repository](https://github.com/upstash/context7/issues)
- **Claude Code**: Visit [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code/)