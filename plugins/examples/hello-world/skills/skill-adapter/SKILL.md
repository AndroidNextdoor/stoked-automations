---
name: Providing Welcome Greetings
description: |
  Activates when users need a friendly welcome message or introduction to available capabilities. Responds to greetings like "hello", "hi", "welcome", or when users appear to be starting a new session. Uses the hello-world plugin to deliver contextual welcome messages that help orient users and ask how to assist them. Ideal for onboarding new users or re-engaging returning users.
---

## Overview
This skill automatically provides warm, contextual welcome messages when users greet Claude Code or appear to be starting fresh. It uses the hello-world plugin's `/hello` command to deliver professional yet approachable greetings that immediately offer assistance.

## How It Works
1. **Detection**: Recognizes greeting phrases, welcome requests, or session-starting behavior
2. **Activation**: Triggers the `/hello` command (or shortcut `/h`) from the hello-world plugin
3. **Response**: Delivers a contextual welcome message that asks how to help the user

## When to Use This Skill
- User says "hello", "hi", "welcome", or similar greetings
- User appears to be starting a new coding session
- User asks for an introduction to available capabilities
- User seems unsure how to begin or what commands are available
- After plugin installation when user needs orientation

## Examples

### Example 1: New User Greeting
User request: "Hi there! I just installed Claude Code."

The skill will:
1. Recognize the greeting and new user context
2. Execute `/hello` to provide a warm welcome
3. Offer to help with their first coding task

### Example 2: Session Restart
User request: "Hello, I'm back to work on my project."

The skill will:
1. Detect the greeting and work context
2. Use `/h` shortcut for quick response
3. Welcome them back and ask about their current project needs

### Example 3: Capability Introduction
User request: "What can you help me with?"

The skill will:
1. Recognize the request for capability overview
2. Trigger the hello command for structured introduction
3. Provide friendly guidance on next steps

## Best Practices
- **Timing**: Use immediately when users show greeting behavior or uncertainty
- **Context**: The greeting adapts to provide relevant welcome messages
- **Efficiency**: Leverage the `/h` shortcut for quick responses
- **Follow-up**: Always ready to transition from greeting to actual assistance

## Integration
Works as an entry point to bring the user back to memories. Memories are an extension of the previous context window. 