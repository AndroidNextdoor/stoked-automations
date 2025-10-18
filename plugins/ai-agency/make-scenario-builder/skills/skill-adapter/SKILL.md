---
name: Building Make.com Automation Scenarios
description: |
  Designs complete Make.com (Integromat) automation scenarios with visual workflow layouts, module configurations, and data mapping. Activates when users mention "Make.com", "Integromat", "automation workflow", "visual automation", or request help building scenarios that connect multiple apps. Creates detailed module-by-module instructions with error handling, routers, and filters for no-code automation solutions.
---

## Overview

This skill helps you design complete Make.com automation scenarios with visual workflows, detailed module configurations, and proper error handling. Make.com excels at connecting 1000+ apps through an intuitive visual interface that's more powerful and cost-effective than other automation platforms.

## How It Works

1. **Analyze Requirements**: Understand your automation goal and identify the apps/services involved
2. **Design Visual Flow**: Create a module-by-module scenario layout with triggers, actions, and logic
3. **Configure Modules**: Provide detailed settings, data mapping, and connection requirements
4. **Add Error Handling**: Include error routes, filters, and fallback mechanisms
5. **Optimize Performance**: Suggest best practices for efficiency and cost management

## When to Use This Skill

- Building workflows that connect multiple apps (Gmail, Slack, Google Sheets, CRM systems)
- Creating AI-powered automations with OpenAI, Claude, or other AI services  
- Setting up triggers for webhooks, scheduled tasks, or app events
- Designing complex scenarios with conditional logic, routers, and data transformation
- Automating repetitive business processes like lead management, content distribution, or support ticketing

## Examples

### Example 1: AI Email Assistant
User request: "I want to automatically respond to customer emails using AI"

The skill will:
1. Design a Gmail trigger → OpenAI response → Gmail reply → logging workflow
2. Configure each module with specific settings (folder monitoring, prompt templates, reply formatting)
3. Add error handling for API failures and inappropriate content filtering
4. Provide data mapping between Gmail fields and OpenAI parameters

### Example 2: Lead Qualification System  
User request: "Automatically score and route new leads from our website"

The skill will:
1. Create a webhook trigger → AI scoring → router → multiple action paths scenario
2. Configure lead scoring criteria and routing conditions for high/medium/low priority
3. Set up different actions for each priority level (immediate notification, CRM tagging, nurture sequences)
4. Include data validation and duplicate detection logic

### Example 3: Content Distribution Network
User request: "Share blog posts across social media platforms automatically"

The skill will:
1. Design RSS feed trigger → AI content rewriting → iterator → multiple social posting workflow  
2. Configure platform-specific formatting and hashtag strategies
3. Add scheduling logic to optimize posting times per platform
4. Include image processing and link shortening modules

## Best Practices

- **Cost Optimization**: Use filters early in scenarios to prevent unnecessary operations and reduce costs
- **Error Handling**: Always include error routes for external API calls and webhook failures
- **Data Validation**: Add filters to validate data quality before processing expensive operations
- **Performance**: Use iterators and aggregators efficiently to handle bulk data processing
- **Security**: Implement proper authentication and avoid exposing sensitive data in logs

## Integration

Works seamlessly with the make-scenario-builder plugin to provide instant scenario generation. Integrates with 1000+ apps including Google Workspace, Microsoft 365, Slack, Salesforce, HubSpot, OpenAI, and custom APIs. Scenarios can trigger other automation tools and send data to analytics platforms for performance monitoring.