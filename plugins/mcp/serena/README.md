# Serena MCP Server

AI-powered memory and context management system with semantic search, project-specific prompts, and intelligent codebase understanding through language server integration.

## Overview

Serena is an MCP (Model Context Protocol) server that provides:

- **Memory Management**: Store and retrieve memories with semantic search
- **Project Context**: Maintain project-specific context and configuration
- **Smart Prompts**: Generate optimized prompts based on project needs
- **Codebase Understanding**: Analyze code using language servers (TypeScript, Python, etc.)
- **Semantic Search**: Find relevant memories using AI-powered similarity search

## Features

- Persistent memory storage with semantic search capabilities
- Project-level context and configuration management
- Language server integration for deep code understanding
- YAML-based configuration for easy customization
- Support for multiple language servers (TypeScript, Python, etc.)

## Prerequisites

Before using this plugin, you need:

1. **Python 3.8 or higher**
   ```bash
   python3 --version  # Should be 3.8.0 or higher
   ```

2. **uv Package Manager**
   ```bash
   # Install uv
   curl -LsSf https://astral.sh/uv/install.sh | sh

   # Verify installation
   uv --version
   ```

3. **Language Servers (Optional but Recommended)**

   For TypeScript/JavaScript support:
   ```bash
   npm install -g typescript-language-server typescript
   ```

   For Python support:
   ```bash
   npm install -g pyright
   # or
   pip install pyright
   ```

4. **Configuration Directory**
   ```bash
   mkdir -p ~/.serena
   ```

## Installation

Install the plugin from the Stoked Automations marketplace:

```bash
# Add marketplace (if not already added)
/plugin marketplace add AndroidNextdoor/stoked-automations

# Install Serena plugin
/plugin install serena@stoked-automations
```

## Configuration

Create a configuration file at `~/.serena/serena_config.yml`:

```yaml
# Serena Configuration

# Memory storage settings
memory:
  storage_path: ~/.serena/memories
  max_memories: 1000
  embedding_model: sentence-transformers/all-MiniLM-L6-v2

# Project-specific settings
projects:
  default:
    name: "Default Project"
    description: "Default project configuration"
    custom_prompts:
      - system: "You are a helpful AI assistant"
      - context: "Focus on code quality and best practices"

# Language server configurations
language_servers:
  typescript:
    enabled: true
    command: typescript-language-server
    args: ["--stdio"]

  python:
    enabled: true
    command: pyright-langserver
    args: ["--stdio"]

# Search settings
search:
  similarity_threshold: 0.7
  max_results: 10
```

### Project-Level Configuration

You can also create project-specific configurations:

```bash
# In your project root
mkdir -p .serena
cat > .serena/config.yml << EOF
name: "My Project"
description: "Project-specific configuration"

custom_prompts:
  - role: system
    content: "You are an expert in React and TypeScript"

  - role: context
    content: "This project uses React 18 with TypeScript"

language_servers:
  typescript:
    enabled: true
  python:
    enabled: false
EOF
```

## MCP Tools

This plugin provides 5 MCP tools:

### 1. `create_memory`
Store new memories with semantic search capabilities.

**Example:**
```
User: "Remember that we use React 18 with TypeScript in this project"
→ create_memory({content: "Project uses React 18 with TypeScript", tags: ["react", "typescript"]})
```

### 2. `search_memories`
Search stored memories using semantic similarity.

**Example:**
```
User: "What framework are we using?"
→ search_memories({query: "project framework"}) → "Project uses React 18 with TypeScript"
```

### 3. `get_project_context`
Retrieve project-specific context and configuration.

**Example:**
```
User: "What's the current project setup?"
→ get_project_context() → [Project name, description, custom prompts, language server config]
```

### 4. `create_prompt`
Generate optimized prompts based on project context.

**Example:**
```
User: "Create a prompt for code review"
→ create_prompt({task: "code_review"}) → [Optimized prompt with project context]
```

### 5. `analyze_codebase`
Analyze codebase structure using language servers.

**Example:**
```
User: "Analyze the TypeScript files in src/"
→ analyze_codebase({path: "src/", language: "typescript"}) → [Code structure, symbols, dependencies]
```

## Usage

Once installed, Serena automatically activates when you:

### Memory Management
```
User: "Remember that our API endpoint is https://api.stokedautomations.com"
Serena: [Stores memory with semantic indexing]

User: "What's our API endpoint?"
Serena: [Searches memories] "Your API endpoint is https://api.stokedautomations.com"
```

### Project Context
```
User: "What are the coding standards for this project?"
Serena: [Retrieves project context and custom prompts]
       "Based on your project configuration, you should..."
```

### Codebase Analysis
```
User: "What components do we have in src/components?"
Serena: [Uses language server to analyze]
        "Found the following components: Header, Footer, Sidebar..."
```

### Prompt Generation
```
User: "Create a prompt for adding a new feature"
Serena: [Generates prompt with project context]
        "Here's an optimized prompt that includes your project setup..."
```

## How It Works

1. **Memory Storage**: Memories are stored locally with vector embeddings for semantic search
2. **Language Servers**: Integrates with LSP servers for deep code understanding
3. **Context Aware**: Maintains project-specific context across sessions
4. **Smart Search**: Uses AI embeddings to find relevant memories
5. **Prompt Optimization**: Generates prompts tailored to your project

## Benefits

- **Persistent Memory**: Never lose important project information
- **Smart Retrieval**: Find relevant context using natural language
- **Code Understanding**: Deep analysis using language servers
- **Custom Prompts**: Generate prompts specific to your project needs
- **Multi-Project**: Support for multiple projects with separate contexts

## Troubleshooting

### uv Command Not Found

If Serena isn't working:

1. Verify uv installation:
   ```bash
   uv --version
   ```

2. Install uv if missing:
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   source ~/.bashrc  # or ~/.zshrc
   ```

### Language Server Not Working

If code analysis isn't working:

1. Check language server installation:
   ```bash
   typescript-language-server --version
   pyright --version
   ```

2. Verify configuration in `~/.serena/serena_config.yml`

3. Check language server is enabled for your file type

### Memory Search Not Finding Results

If semantic search isn't working:

1. Check similarity threshold in config (try lowering it)
2. Ensure embedding model is downloaded
3. Verify memory storage path exists

### Configuration Not Loading

If custom config isn't being used:

1. Check file path: `~/.serena/serena_config.yml`
2. Verify YAML syntax is correct
3. Check file permissions

## Resources

- **Official Repository**: [https://github.com/oraios/serena](https://github.com/oraios/serena)
- **uv Documentation**: [https://astral.sh/uv](https://astral.sh/uv)
- **Language Server Protocol**: [https://microsoft.github.io/language-server-protocol/](https://microsoft.github.io/language-server-protocol/)

## License

MIT License - See [LICENSE](LICENSE) file for details

## Author

**Oraios**
- GitHub: [https://github.com/oraios](https://github.com/oraios)

## Contributing

This plugin is part of the Stoked Automations marketplace. To contribute:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

See [CONTRIBUTING.md](../../../CONTRIBUTING.md) for guidelines.

## Support

For issues related to:

- **This Plugin**: Open an issue at [Stoked Automations Issues](https://github.com/AndroidNextdoor/stoked-automations/issues)
- **Serena MCP Server**: Open an issue at [Serena Repository](https://github.com/oraios/serena/issues)
- **Claude Code**: Visit [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code/)