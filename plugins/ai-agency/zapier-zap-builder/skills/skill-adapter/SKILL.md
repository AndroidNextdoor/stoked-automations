---
name: Building Zapier Automations
description: |
  Creates multi-step Zapier Zap configurations with triggers, actions, filters, paths, and formatters. Activates when users mention "zapier", "zap", "automate", "connect apps", "workflow automation", or describe connecting different applications together. Provides step-by-step Zap setup instructions with cost estimates and best practices for no-code automation workflows.
---

## Overview

This skill helps you design and configure complex Zapier automations by breaking down your workflow needs into structured Zap configurations. It provides complete setup instructions, cost calculations, and optimization recommendations for connecting your favorite apps without code.

## How It Works

1. **Requirements Analysis**: Identifies trigger apps, action apps, and data flow requirements
2. **Zap Architecture**: Designs multi-step workflows with filters, paths, and formatters
3. **Configuration Guide**: Provides detailed setup instructions for each step
4. **Cost Estimation**: Calculates monthly task usage and pricing recommendations

## When to Use This Skill

- User mentions "zapier", "zap", or "automate my workflow"
- Requests to "connect" different apps or services together
- Asks about "automation", "integration", or "workflow"
- Describes repetitive tasks between multiple applications
- Mentions specific app combinations like "Gmail to Slack" or "Forms to Sheets"

## Examples

### Example 1: AI Email Assistant
User request: "I want to automatically draft replies to customer emails using AI"

The skill will:
1. Design a Gmail trigger → OpenAI action → Gmail send workflow
2. Configure email parsing and AI prompt templates
3. Add filters for customer vs internal emails
4. Estimate costs at $0.80/month for 100 emails

### Example 2: Lead Qualification System
User request: "Score new leads and notify my sales team of hot prospects"

The skill will:
1. Create Webhook trigger → OpenAI scoring → conditional paths
2. Configure high-score path to Slack notifications
3. Set up CRM integration for lead storage
4. Include data formatting for consistent lead records

### Example 3: Social Media Automation
User request: "Share my blog posts across all my social accounts automatically"

The skill will:
1. Set up RSS trigger for new blog posts
2. Add OpenAI formatter for platform-specific messaging
3. Create parallel paths for Twitter, LinkedIn, Facebook
4. Configure scheduling delays between posts

## Best Practices

- **Trigger Selection**: Always start with the most reliable trigger app that captures your starting event
- **Filter Usage**: Add filters early to prevent unnecessary task consumption on irrelevant data
- **Path Organization**: Use paths instead of separate Zaps when handling different scenarios from the same trigger
- **Data Formatting**: Include formatter steps to clean and structure data before final actions
- **Testing Strategy**: Recommend testing with sample data before activating automation
- **Cost Optimization**: Suggest task-efficient alternatives and highlight multi-step task consumption

## Integration

Works seamlessly with Zapier's 5000+ app ecosystem including Gmail, Slack, HubSpot, Airtable, OpenAI, and custom webhooks. Integrates with other Claude Code plugins for comprehensive automation planning, especially useful alongside API documentation and workflow planning tools.