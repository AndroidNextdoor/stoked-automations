---
name: Implementing API Request Logging
description: |
  Implements production-grade structured logging for API requests with correlation IDs, request/response capture, and PII redaction. Activates when users mention "logging", "audit trails", "request tracking", "correlation IDs", "observability", "debugging API issues", "compliance logging", or need to monitor API usage patterns and performance across distributed services.
---

## Overview

This skill implements comprehensive API request logging infrastructure with structured logging, correlation tracking, and audit capabilities. It automatically sets up logging middleware, correlation ID generation, PII redaction, and integration with log aggregation platforms for production-ready observability.

## How It Works

1. **Logging Setup**: Configures structured logging middleware with correlation ID generation and request/response capture
2. **PII Protection**: Implements automatic redaction of sensitive data in logs while maintaining audit trail integrity  
3. **Integration**: Connects with log aggregation platforms and monitoring systems for centralized observability

## When to Use This Skill

- User mentions debugging production API issues or tracking request flows
- Need to implement audit trails for compliance (GDPR, SOX, HIPAA)
- Want to analyze API performance patterns and usage analytics
- Investigating security incidents requiring detailed request forensics
- Setting up observability for microservices or distributed systems
- Need correlation tracking across multiple services

## Examples

### Example 1: Production Debugging
User request: "I need to debug API issues in production with proper logging"

The skill will:
1. Set up structured logging middleware with correlation IDs
2. Configure request/response capture with PII redaction
3. Integrate with log aggregation platforms for searchable audit trails

### Example 2: Compliance Requirements  
User request: "We need audit trails for API access to meet compliance requirements"

The skill will:
1. Implement comprehensive request logging with user context
2. Set up log retention policies and secure storage
3. Configure audit report generation for compliance reviews

### Example 3: Performance Monitoring
User request: "I want to track API performance and usage patterns across services"

The skill will:
1. Add performance metrics logging with timing data
2. Set up correlation tracking across distributed services
3. Configure dashboards for API analytics and monitoring

## Best Practices

- **Security**: Always redact PII and sensitive data from logs while preserving audit value
- **Performance**: Use async logging to minimize impact on API response times  
- **Storage**: Implement log rotation and retention policies to manage storage costs
- **Correlation**: Include correlation IDs in all service calls for end-to-end tracing

## Integration

Works seamlessly with monitoring platforms (Datadog, New Relic), log aggregation systems (ELK stack, Splunk), and APM tools. Integrates with existing authentication middleware and API gateways for comprehensive observability without code changes.