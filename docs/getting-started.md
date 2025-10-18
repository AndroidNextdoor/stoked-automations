# Getting Started with Stoked Automations

## What Are Plugins?

Stoked Automations are packages that extend Claude Code functionality with custom commands, specialized agents, hooks, and MCP servers.

## Installation

### Add This Marketplace

```bash
/plugin marketplace add AndroidNextdoor/stoked-automations
```

> Upgrading from an older install? Remove the original slug first with `/plugin marketplace remove claude-code-plugins`, then run the add command above to register the new `stoked-automations` marketplace.

### Browse Available Plugins

```bash
/plugin
```

This opens an interactive menu where you can:
- Browse all plugins from installed marketplaces
- See plugin descriptions and metadata
- Install plugins with one click

### Install Specific Plugin

```bash
/plugin install plugin-name@stoked-automations
```

### List Installed Plugins

```bash
/plugin list
```

### Enable/Disable Plugins

```bash
/plugin enable plugin-name
/plugin disable plugin-name
```

## Using Plugins

### Slash Commands

After installing a plugin with commands, they appear in `/help`:

```bash
/help
# Shows all available commands including plugin commands marked with (user)

/your-command
# Execute the command
```

### Subagents

Plugins can add specialized agents that Claude uses automatically:

```
"Please review this code for security issues"
# Claude may delegate to security-agent if installed
```

### Hooks

Hooks run automatically at specific events (file edits, tool usage, etc.). No manual invocation needed.

### MCP Servers

MCP servers provide additional tools and data sources. They start automatically when plugins are enabled.

## Team Setup

For team-wide plugin distribution, add to repository `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "team-plugins": {
      "source": {
        "source": "github",
        "repo": "your-org/plugins"
      }
    }
  },
  "enabledPlugins": {
    "formatter@team-plugins": true,
    "security-agent@team-plugins": true
  }
}
```

When team members trust the folder, plugins install automatically.

## Development Environment Setup

If you're contributing to the marketplace or generating Agent Skills with AI:

### Claude API Key (for AI skill generation) - **RECOMMENDED**

Add to your `~/.zshrc` or `~/.bashrc`:

```bash
export ANTHROPIC_API_KEY='your-claude-api-key-here'
```

**Get your API key:**
1. Visit https://console.anthropic.com/settings/keys
2. Create a new API key
3. Add it to your shell configuration file

**Usage:**
```bash
# Generate Agent Skills for plugins (recommended - best quality)
python3 scripts/generate-skills-claude.py plugin-name

# Batch generation with rate limiting (30 second delay)
python3 scripts/generate-skills-claude.py plugin1 plugin2 plugin3
```

**Benefits:**
- Higher quality skill generation
- Better rate limits (1000+ RPM on paid tiers)
- More consistent output formatting
- Official Anthropic tool

### Alternative: Gemini API Key

If you prefer Google's Gemini API:

```bash
export GEMINI_API_KEY='your-gemini-api-key-here'
```

**Get your API key:** https://aistudio.google.com/app/apikey

**Usage:**
```bash
# Generate with Gemini (60 second delay - conservative for free tier)
python3 scripts/generate-skills-gemini.py plugin-name
```

**Note:** Gemini script uses ultra-conservative rate limiting (60s between calls) for free tier. Claude is recommended for better throughput and quality.

## Next Steps

- [Create your own plugin](creating-plugins.md)
- [Understand plugin structure](plugin-structure.md)
- [Learn about marketplaces](marketplace-guide.md)
