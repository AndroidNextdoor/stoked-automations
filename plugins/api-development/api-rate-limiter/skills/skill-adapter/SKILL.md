---
name: Implementing API Rate Limiting
description: |
  Automatically implements production-ready rate limiting for API endpoints using token bucket, sliding window, or fixed window algorithms with Redis backend. Activates when users mention "rate limiting", "throttling", "API protection", "prevent abuse", "usage limits", "DDoS protection", or "fair usage". Creates middleware, Redis integration, per-user limits, rate limit headers, and burst handling capabilities for distributed applications.
---

## Overview

This skill implements comprehensive rate limiting solutions for API endpoints to protect against abuse, enforce usage policies, and ensure fair resource allocation. It automatically detects requests for API protection and implements appropriate rate limiting strategies with Redis-backed distributed state management.

## How It Works

1. **Algorithm Selection**: Analyzes requirements and selects optimal rate limiting algorithm (token bucket for burst handling, sliding window for precision, fixed window for simplicity)
2. **Redis Integration**: Sets up Redis connection and key management for distributed rate limiting across multiple server instances
3. **Middleware Implementation**: Creates rate limiting middleware with proper error handling, headers, and bypass mechanisms
4. **Configuration Setup**: Implements tiered limits, user identification, and monitoring capabilities

## When to Use This Skill

- Building APIs that need protection from abuse or DDoS attacks
- Implementing freemium models with usage-based pricing tiers
- Controlling costs for expensive operations or third-party API calls
- Ensuring fair resource allocation among users
- Meeting compliance requirements for rate limiting
- Preventing resource exhaustion from runaway clients
- Adding throttling to existing endpoints without code changes

## Examples

### Example 1: API Protection
User request: "I need to add rate limiting to my REST API to prevent abuse"

The skill will:
1. Implement token bucket middleware with Redis backend
2. Add rate limit headers (X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset)
3. Configure per-IP and per-user limits with appropriate error responses

### Example 2: Tiered Usage Limits
User request: "Set up different API limits for free and premium users"

The skill will:
1. Create user-tier detection middleware
2. Implement sliding window algorithm with tier-specific limits
3. Add usage tracking and quota enforcement with upgrade prompts

### Example 3: Distributed Rate Limiting
User request: "Add throttling across multiple server instances"

The skill will:
1. Configure Redis cluster for shared rate limit state
2. Implement distributed token bucket with atomic operations
3. Add health checks and failover mechanisms

## Best Practices

- **Algorithm Choice**: Use token bucket for APIs needing burst capacity, sliding window for strict rate enforcement, fixed window for simple use cases
- **Key Strategy**: Implement composite keys (IP + user ID) for accurate user identification and prevent bypassing
- **Error Handling**: Always include graceful degradation when Redis is unavailable
- **Monitoring**: Add metrics and logging for rate limit violations and system health
- **Headers**: Include standard rate limiting headers for client awareness and proper backoff

## Integration

Works seamlessly with existing web frameworks (Express, FastAPI, Django) and cloud platforms. Integrates with monitoring tools like Prometheus, logging systems, and API gateways. Compatible with load balancers and reverse proxies while maintaining accurate rate limiting across distributed deployments.