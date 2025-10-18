---
name: Designing n8n Workflows
description: |
  Activates when users discuss n8n workflows, automation design, or workflow building. Creates production-ready n8n workflow JSON files with complex logic including loops, branching, error handling, and AI integrations. Triggers on phrases like "n8n workflow", "automation workflow", "build workflow", "workflow design", or any mention of connecting services, APIs, or automating processes. Provides complete importable workflows optimized for performance and cost-effectiveness.
---

## Overview

This skill transforms user automation requirements into complete, production-ready n8n workflow JSON files. It specializes in complex workflows with branching logic, loops, error handling, and AI integrations that go beyond simple trigger-action pairs.

## How It Works

1. **Requirement Analysis**: Parse user's automation needs and identify data flow patterns
2. **Workflow Architecture**: Design optimal node structure with proper branching and error handling
3. **JSON Generation**: Create complete, importable n8n workflow files with all configurations
4. **Optimization Guidance**: Provide performance tuning and cost optimization recommendations

## When to Use This Skill

- User mentions "n8n workflow", "automation workflow", or "build workflow"
- Requests to connect multiple services or APIs together
- Needs complex logic like loops, conditions, or data transformations
- Wants to automate business processes with AI integration
- Discusses workflow optimization or error handling strategies
- Asks about self-hosted automation alternatives to Zapier/Make

## Examples

### Example 1: AI Customer Support
User request: "Create an n8n workflow that processes support emails, classifies them with AI, and routes urgent ones to Slack"

The skill will:
1. Generate Gmail trigger node with proper filters
2. Add OpenAI classification node with prompt engineering
3. Create conditional routing based on urgency scores
4. Include Slack notification and database logging nodes
5. Implement error handling for API failures

### Example 2: Content Automation Pipeline
User request: "I need a workflow that takes RSS feeds, enhances content with AI, and publishes to multiple social platforms"

The skill will:
1. Design RSS polling trigger with duplicate detection
2. Add content enhancement using AI models
3. Create parallel branches for different platforms
4. Include rate limiting and scheduling logic
5. Add performance monitoring and retry mechanisms

### Example 3: Lead Processing Automation
User request: "Build a workflow that processes form submissions, enriches data, scores leads with AI, and updates our CRM"

The skill will:
1. Create webhook trigger for form submissions
2. Add data enrichment nodes (email validation, company lookup)
3. Implement AI lead scoring with custom prompts
4. Design conditional routing based on score thresholds
5. Include CRM integration with proper field mapping

## Best Practices

- **Error Handling**: Always include retry logic and fallback paths for external API calls
- **Performance**: Use batch processing for large datasets and implement proper rate limiting
- **Cost Optimization**: Cache AI responses and use conditional logic to minimize API calls
- **Monitoring**: Add logging nodes to track workflow execution and identify bottlenecks
- **Security**: Implement proper credential management and data sanitization

## Integration

Works seamlessly with the `/n8n` command to generate workflow JSON files. Automatically provides self-hosting guidance and compares capabilities with other automation platforms. Integrates with AI models through native n8n nodes and provides custom JavaScript code when needed for complex transformations.