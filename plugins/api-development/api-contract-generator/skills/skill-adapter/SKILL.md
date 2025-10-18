---
name: Generating API Contracts
description: |
  Generates comprehensive API contracts for consumer-driven contract testing using Pact and other frameworks. Automatically creates contract specifications between microservices to ensure API compatibility and prevent breaking changes. Triggers when users mention "contract testing", "API contracts", "Pact contracts", "consumer-driven testing", "microservice contracts", or need to verify API compatibility between services.
---

## Overview

This skill generates API contracts for consumer-driven contract testing, creating specifications that define expected interactions between API consumers and providers. It produces contracts in multiple formats including Pact, Spring Cloud Contract, and OpenAPI to support various testing frameworks and ensure microservice compatibility.

## How It Works

1. **Analysis**: Examines existing API endpoints, request/response schemas, and service dependencies
2. **Contract Generation**: Creates consumer-driven contracts specifying expected API interactions
3. **Multi-Format Output**: Generates contracts in Pact JSON, Spring Cloud Contract, and OpenAPI formats
4. **Validation Rules**: Includes matching rules, headers, and status code expectations
5. **Documentation**: Produces human-readable contract documentation with examples

## When to Use This Skill

- Setting up consumer-driven contract testing for microservices
- Preventing breaking changes between API consumers and providers
- Establishing API compatibility verification in CI/CD pipelines
- Documenting expected API behavior for distributed systems
- Creating test doubles and mock services based on contracts
- Migrating from manual API testing to automated contract testing

## Examples

### Example 1: Microservice Contract Creation
User request: "Generate a Pact contract for our user service API that handles user registration and profile updates"

The skill will:
1. Analyze the user service endpoints and data models
2. Create Pact contract files with expected request/response interactions
3. Generate matching rules for dynamic data like timestamps and IDs
4. Produce contract test files for both consumer and provider verification

### Example 2: Multi-Service Contract Suite
User request: "Create API contracts for contract testing between our order service, payment service, and inventory service"

The skill will:
1. Map the interactions between all three services
2. Generate separate contract files for each consumer-provider relationship
3. Create Spring Cloud Contract specifications with Groovy DSL
4. Provide setup instructions for contract testing pipeline integration

### Example 3: Legacy API Contract Documentation
User request: "Generate contracts for our existing REST API to start doing consumer-driven testing"

The skill will:
1. Reverse-engineer contracts from existing API documentation or code
2. Create OpenAPI specifications with contract testing annotations
3. Generate Pact broker configuration for contract sharing
4. Provide migration guide from current testing approach to contract testing

## Best Practices

- **Contract Granularity**: Focus on actual consumer needs rather than all possible API capabilities
- **Matching Rules**: Use flexible matching for dynamic data while keeping essential fields strict
- **Version Management**: Include contract versioning strategy and backward compatibility checks
- **Provider States**: Define clear provider states for different test scenarios
- **Continuous Integration**: Integrate contract verification into both consumer and provider pipelines

## Integration

Works seamlessly with testing frameworks like Jest, JUnit, and pytest for contract verification. Integrates with Pact Broker for contract sharing between teams and CI/CD systems like Jenkins, GitHub Actions, and GitLab CI for automated contract testing. Complements API documentation tools and service mesh configurations for comprehensive microservice testing strategies.