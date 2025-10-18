---
name: Creating Secure Webhook Handlers
description: |
  Creates production-ready webhook endpoints with signature verification, idempotency handling, and retry logic for reliable third-party integrations. Automatically generates secure handlers when users mention webhooks, payment notifications, event processing, API callbacks, real-time events, or need to receive data from external services like Stripe, GitHub, or Slack.
---

## Overview

This skill automatically creates secure, production-ready webhook endpoints with built-in signature verification, idempotency handling, and retry mechanisms. It generates comprehensive webhook handlers that can reliably process events from third-party services while maintaining security and resilience.

## How It Works

1. **Handler Generation**: Creates webhook endpoint with proper routing and event processing structure
2. **Security Implementation**: Adds HMAC signature verification and request validation
3. **Resilience Features**: Implements idempotency checks, retry logic with exponential backoff, and dead letter queuing

## When to Use This Skill

- Processing payment notifications from Stripe, PayPal, or other payment providers
- Handling repository events from GitHub, GitLab, or Bitbucket
- Receiving chat notifications from Slack, Discord, or Microsoft Teams
- Building event-driven architectures with external service triggers
- Creating API callbacks for third-party integrations
- Setting up real-time data synchronization between services

## Examples

### Example 1: Payment Processing
User request: "I need to handle Stripe webhook notifications for payment confirmations"

The skill will:
1. Generate a secure webhook endpoint with Stripe signature verification
2. Create event handlers for payment_intent.succeeded and other payment events
3. Add idempotency handling to prevent duplicate payment processing

### Example 2: Repository Automation
User request: "Create a webhook to trigger CI/CD when code is pushed to GitHub"

The skill will:
1. Build a GitHub webhook handler with proper signature validation
2. Implement event routing for push, pull_request, and release events
3. Add retry logic for failed CI/CD triggers with exponential backoff

### Example 3: Chat Integration
User request: "Set up webhooks to process Slack slash commands and events"

The skill will:
1. Generate Slack webhook endpoints with proper verification tokens
2. Create handlers for interactive components and slash commands
3. Implement error handling and response formatting for Slack's requirements

## Best Practices

- **Security First**: Always implements signature verification using service-specific methods (HMAC-SHA256 for most services)
- **Idempotency**: Includes duplicate event detection using request IDs or event timestamps
- **Error Handling**: Provides comprehensive logging, graceful failure handling, and dead letter queues
- **Performance**: Implements async processing for heavy operations to ensure quick webhook responses

## Integration

Works seamlessly with API frameworks (Express.js, FastAPI, Flask) and cloud platforms (AWS Lambda, Vercel, Railway). Integrates with monitoring tools for webhook delivery tracking and includes database schemas for event storage and processing status.