---
name: Migrating API Versions
description: |
  Orchestrates comprehensive API version migrations with automated compatibility layers, breaking change detection, and zero-downtime deployment strategies. Activates when users mention "migrate API", "API version upgrade", "backward compatibility", "API deprecation", or need to transition between API versions while maintaining service availability.
---

## Overview
This skill manages the complete lifecycle of API version migrations, from initial compatibility analysis through deployment and legacy deprecation. It creates automated compatibility layers, detects breaking changes, and implements zero-downtime transition strategies.

## How It Works
1. **Analysis Phase**: Scans existing API definitions, identifies breaking changes, and maps compatibility requirements between versions
2. **Compatibility Layer Creation**: Generates adapter code, transformation logic, and routing rules to maintain backward compatibility
3. **Migration Orchestration**: Implements gradual rollout strategies, monitors migration progress, and manages version deprecation timelines

## When to Use This Skill
- Planning major API version upgrades while maintaining existing client compatibility
- Need to deprecate old API versions with controlled transition periods
- Implementing breaking changes that require careful client migration strategies
- Managing multiple API versions simultaneously with automated routing
- Analyzing impact of proposed API changes on existing integrations

## Examples

### Example 1: Major Version Upgrade
User request: "I need to migrate our REST API from v2 to v3 with breaking changes in the user authentication flow"

The skill will:
1. Analyze differences between v2 and v3 authentication endpoints
2. Generate compatibility adapters for legacy authentication methods
3. Create migration scripts and client transition guides
4. Set up version routing with gradual traffic shifting capabilities

### Example 2: GraphQL Schema Evolution
User request: "Help me migrate our GraphQL API schema while keeping old queries working"

The skill will:
1. Compare schema versions and identify deprecated fields
2. Implement field aliasing and transformation resolvers
3. Generate client migration documentation with query examples
4. Create deprecation warnings and sunset timeline management

### Example 3: Microservice API Coordination
User request: "I'm updating multiple service APIs that depend on each other - need backward compatibility"

The skill will:
1. Map service dependencies and API contract changes
2. Generate inter-service compatibility shims and protocol adapters
3. Create coordinated deployment scripts with rollback capabilities
4. Set up monitoring for cross-service compatibility issues

## Best Practices
- **Gradual Migration**: Always implement phased rollouts with traffic percentage controls and rollback mechanisms
- **Client Communication**: Generate comprehensive migration guides with code examples and timeline expectations
- **Monitoring Strategy**: Set up detailed metrics for version usage, error rates, and migration progress tracking
- **Deprecation Planning**: Establish clear sunset timelines with multiple notification phases for affected clients

## Integration
Works seamlessly with API gateway configurations, CI/CD pipelines, and monitoring systems. Integrates with OpenAPI/Swagger specifications, GraphQL schemas, and container orchestration platforms for automated deployment strategies.