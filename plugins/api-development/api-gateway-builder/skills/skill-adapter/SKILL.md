---
name: Building API Gateways
description: |
  Builds production-ready API gateways with microservice routing, JWT authentication, rate limiting, and load balancing. Activates when users mention "api gateway", "microservice proxy", "service mesh", "api routing", or need to consolidate multiple backend services behind a single entry point. Generates complete gateway configurations with circuit breakers, request/response transformation, and monitoring capabilities.
---

## Overview

This skill automatically creates production-ready API gateways that serve as single entry points for microservice architectures. It generates complete gateway implementations with intelligent routing, authentication middleware, rate limiting, and load balancing capabilities.

## How It Works

1. **Architecture Analysis**: Examines existing services and defines routing requirements, authentication needs, and performance constraints
2. **Gateway Generation**: Creates complete gateway implementation using Kong, Express Gateway, or custom Node.js with all middleware configured
3. **Integration Setup**: Configures service discovery, health checks, circuit breakers, and monitoring dashboards

## When to Use This Skill

- Building microservice architectures that need unified API access
- Consolidating multiple backend services behind single endpoint
- Implementing cross-cutting concerns like auth and rate limiting
- Setting up API proxies with load balancing and failover
- Creating service mesh entry points with traffic management

## Examples

### Example 1: Microservice Consolidation
User request: "I need an api gateway to route requests to my user service, order service, and payment service with JWT auth"

The skill will:
1. Generate Express Gateway configuration with route definitions for each service
2. Configure JWT authentication middleware with token validation
3. Set up health checks and circuit breakers for each downstream service

### Example 2: Production API Proxy
User request: "Build a gateway with rate limiting and load balancing for my e-commerce APIs"

The skill will:
1. Create Kong gateway with rate limiting policies per client
2. Configure upstream load balancing with multiple service instances
3. Add request/response logging and metrics collection

### Example 3: Service Mesh Entry Point
User request: "Need a microservice proxy with request transformation and monitoring"

The skill will:
1. Build custom Node.js gateway with request/response transformation middleware
2. Integrate Prometheus metrics and health check endpoints
3. Configure service discovery and dynamic routing tables

## Best Practices

- **Security First**: Always implement authentication, input validation, and CORS policies
- **Performance Monitoring**: Include metrics collection, request tracing, and performance dashboards
- **Resilience Patterns**: Configure circuit breakers, timeouts, and graceful degradation
- **Documentation**: Generate OpenAPI specs and routing documentation automatically

## Integration

Works seamlessly with Docker containerization, Kubernetes service discovery, monitoring tools like Prometheus/Grafana, and CI/CD pipelines. Integrates with existing authentication providers, service registries, and load balancers for complete production deployments.