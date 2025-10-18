---
name: Fetching Current Code Documentation
description: |
  Automatically fetches up-to-date, version-specific documentation and code examples from Context7's database when users ask about libraries, frameworks, APIs, or need coding help. Triggers on requests like "how to use", "documentation for", "examples of", "API reference", or mentions of popular libraries like React, Express, Prisma, Next.js, etc. Eliminates outdated information by pulling current docs directly from the source.
---

## Overview

This skill automatically activates Context7 to fetch current, version-specific documentation and code examples when you ask about libraries, frameworks, or APIs. It ensures you always get the most up-to-date information instead of potentially outdated or hallucinated responses.

## How It Works

1. **Library Resolution**: Converts your natural language library mentions into Context7-compatible IDs (e.g., "React" → "react@18")
2. **Documentation Fetching**: Retrieves current documentation, API references, and code examples from Context7's database
3. **Context Delivery**: Provides clean, version-specific information with working code snippets

## When to Use This Skill

- Asking "How do I use [library/framework]?"
- Requesting "Show me examples of [API/method]"
- Mentioning popular libraries: React, Vue, Express, Next.js, Prisma, TypeScript, etc.
- Needing "documentation for [library]"
- Asking about "API reference" or "latest version"
- Integration questions: "How to connect X with Y?"
- Troubleshooting: "Why isn't [method] working?"

## Examples

### Example 1: React Hook Documentation
User request: "How do I use React's useEffect hook with cleanup?"

The skill will:
1. Resolve "React" to current version identifier
2. Fetch latest useEffect documentation with cleanup examples
3. Provide current syntax and best practices

### Example 2: Express.js Middleware
User request: "Show me Express middleware examples"

The skill will:
1. Identify Express.js as the target library
2. Retrieve current Express v5 middleware documentation
3. Return working code examples with explanations

### Example 3: Library Integration
User request: "How to set up Prisma with Next.js?"

The skill will:
1. Resolve both Prisma and Next.js to current versions
2. Fetch integration documentation for both libraries
3. Provide step-by-step setup with current syntax

### Example 4: API Reference Lookup
User request: "What are the options for fetch() in JavaScript?"

The skill will:
1. Identify this as a web API documentation request
2. Retrieve current fetch API specification
3. List all available options with examples

## Best Practices

- **Be Specific**: Mention version numbers when you need specific versions
- **Context Matters**: Describe your use case for more targeted documentation
- **Multiple Libraries**: Ask about integrations between libraries for comprehensive setup guides
- **Error Resolution**: Mention error messages to get troubleshooting documentation

## Integration

Works seamlessly with other development plugins by providing accurate, current documentation as foundation knowledge. The fetched documentation enhances code generation, debugging, and architectural decisions across your entire development workflow.