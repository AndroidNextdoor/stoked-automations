---
name: Managing API Versions
description: |
  Implements comprehensive API versioning strategies with backward compatibility, deprecation workflows, and migration paths. Activates when users mention "API versions", "version management", "backward compatibility", "API migration", "deprecation strategy", "API evolution", "version control for APIs", or need to support multiple API versions simultaneously while ensuring smooth client transitions.
---

## Overview

This skill enables systematic API version management with proper backward compatibility, deprecation strategies, and migration planning. It helps maintain multiple API versions simultaneously while providing clear upgrade paths for consumers.

## How It Works

1. **Version Strategy Selection**: Analyzes current API structure and recommends appropriate versioning strategy (URL path, header-based, or query parameter)
2. **Compatibility Assessment**: Evaluates breaking changes and creates compatibility matrices between versions
3. **Migration Planning**: Generates detailed migration guides with code examples and timeline recommendations
4. **Deprecation Management**: Implements sunset headers, deprecation notices, and automated client notifications

## When to Use This Skill

- Introducing breaking changes to existing APIs without disrupting current clients
- Planning major API updates that require coordinated client migrations
- Implementing sunset policies for outdated API versions
- Setting up automated compatibility testing between API versions
- Creating migration documentation and client communication strategies
- Establishing versioning standards for new API development

## Examples

### Example 1: Breaking Change Implementation
User request: "I need to add required authentication to my REST API but don't want to break existing clients"

The skill will:
1. Analyze current API endpoints and identify breaking changes
2. Create new versioned endpoints (e.g., /v2/) with authentication requirements
3. Generate migration guide with code examples for both versions
4. Set up deprecation timeline with sunset headers for v1 endpoints

### Example 2: Multi-Version Support Setup
User request: "Help me support three different API versions with proper deprecation strategy"

The skill will:
1. Create version routing strategy with clear URL patterns or header detection
2. Implement compatibility testing suite for all three versions
3. Generate deprecation timeline with specific sunset dates
4. Create automated client notification system for version updates

### Example 3: API Evolution Planning
User request: "I want to restructure my API response format but need smooth migration"

The skill will:
1. Design backward-compatible response wrapper for gradual migration
2. Create feature flags for new response format adoption
3. Generate client SDK updates with version-specific implementations
4. Plan phased rollout strategy with monitoring and rollback procedures

## Best Practices

- **Semantic Versioning**: Use clear version numbering that indicates breaking vs non-breaking changes
- **Deprecation Timeline**: Provide minimum 6-month notice before sunsetting older versions
- **Documentation**: Maintain separate documentation for each supported API version
- **Testing Strategy**: Implement automated compatibility tests for all supported versions
- **Client Communication**: Use sunset headers and proactive notifications for version changes

## Integration

Works seamlessly with CI/CD pipelines for automated version deployment, testing frameworks for compatibility validation, and documentation generators for maintaining version-specific API docs. Integrates with monitoring tools to track version usage and plan deprecation timelines.