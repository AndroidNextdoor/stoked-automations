---
name: Greeting New Users
description: |
  Provides contextual welcome messages and initial guidance for users starting with Claude Code. Automatically activates when users need orientation, want to test basic functionality, or request simple greetings. Uses the /hello or /h commands to deliver personalized welcomes and offer assistance based on the current project context.
---

## Overview

This skill teaches Claude Code to provide warm, contextual welcome messages through the hello-world plugin. It demonstrates basic slash command functionality while helping users get oriented and feel comfortable with the CLI environment.

## How It Works

1. **Command Recognition**: Detects `/hello` or `/h` commands and greeting-related requests
2. **Context Analysis**: Evaluates the current working directory and project state
3. **Personalized Response**: Delivers a contextual welcome message and offers relevant assistance

## When to Use This Skill

- User types "hello", "hi", or requests a greeting
- New users need orientation or want to test basic functionality  
- Users ask "how can you help" or want to explore capabilities
- Someone wants to verify the plugin system is working correctly
- Users need a friendly starting point for their CLI session

## Examples

### Example 1: First-Time User
User request: "Hello, I'm new to Claude Code"

The skill will:
1. Execute the `/hello` command automatically
2. Provide a warm welcome with basic guidance about available commands and features

### Example 2: Project Context Greeting
User request: "Hi there, what can you help me with?"

The skill will:
1. Run `/h` (shortcut) to generate a contextual greeting
2. Analyze the current directory and suggest relevant next steps based on project files

### Example 3: Testing Functionality
User request: "Let me test if this is working"

The skill will:
1. Recognize this as a greeting scenario and execute `/hello`
2. Confirm the plugin system is functional while providing a helpful welcome

## Best Practices

- **Immediate Activation**: Use this skill as soon as users express greeting intentions
- **Context Awareness**: Let the command adapt its response based on the current project environment
- **Gateway Function**: Use successful greetings as launching points to introduce other available plugins and capabilities

## Integration

The hello-world plugin serves as an entry point that can reference other installed plugins and available commands. It works seamlessly with Claude Code's plugin marketplace system and helps users discover additional functionality through its welcoming interface.