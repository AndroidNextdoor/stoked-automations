---
name: Managing AI Memory and Context
description: |
  Activates when users need to store, retrieve, or search project memories, manage codebase context, or create intelligent prompts. Triggers on phrases like "remember this", "search memories", "project context", "understand codebase", "semantic search", "store memory", "recall information", or "analyze code structure". Uses Serena's AI-powered memory system with semantic search capabilities and language server integration for deep code understanding.
---

## Overview

This skill leverages Serena's AI-powered memory and context management system to help users maintain persistent project knowledge, search through stored information semantically, and understand codebases through language server integration. It automatically stores important information and retrieves relevant context when needed.

## How It Works

1. **Memory Storage**: Captures and stores important information with semantic embeddings for intelligent retrieval
2. **Semantic Search**: Uses AI-powered similarity search to find relevant memories based on context rather than keywords
3. **Project Context**: Maintains project-specific configurations and custom prompts for tailored assistance
4. **Code Analysis**: Integrates with language servers to provide deep understanding of TypeScript, Python, and other codebases

## When to Use This Skill

- When you want to remember important decisions, patterns, or insights for later retrieval
- When searching through past conversations or stored knowledge semantically
- When you need project-specific context and intelligent prompting
- When analyzing complex codebases with language server support
- When managing long-term project memory across development sessions
- When you want AI to understand your codebase structure and relationships

## Examples

### Example 1: Storing Project Decisions
User request: "Remember that we decided to use Redis for caching because PostgreSQL was too slow for our real-time features"

The skill will:
1. Store this architectural decision in Serena's memory system
2. Create semantic embeddings for intelligent retrieval
3. Associate it with the current project context

### Example 2: Semantic Memory Search
User request: "What did we decide about caching solutions?"

The skill will:
1. Perform semantic search through stored memories
2. Retrieve relevant information about caching decisions
3. Present context about Redis choice and PostgreSQL performance issues

### Example 3: Codebase Understanding
User request: "Analyze the structure of this TypeScript project and understand the component relationships"

The skill will:
1. Activate TypeScript language server integration
2. Analyze code structure, imports, and dependencies
3. Store insights about component architecture in project memory

## Best Practices

- **Memory Organization**: Store decisions, patterns, and insights with clear context for better semantic retrieval
- **Project Configuration**: Set up project-specific prompts and context in `.serena/config.yml` for tailored assistance
- **Language Servers**: Install relevant language servers (typescript-language-server, pyright) for enhanced code understanding
- **Search Queries**: Use natural language when searching memories rather than exact keyword matching

## Integration

Serena integrates seamlessly with development workflows by maintaining persistent memory across Claude Code sessions. It works with existing language servers and development tools, storing insights that can be retrieved contextually. The semantic search capabilities enhance other plugins by providing relevant historical context and project-specific knowledge when needed.