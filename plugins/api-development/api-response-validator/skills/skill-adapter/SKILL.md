---
name: Validating API Response Schemas
description: |
  Validates API responses against JSON Schema, OpenAPI specifications, and custom business rules to ensure data integrity and contract compliance. Automatically activates when users mention "validate API responses", "check schema compliance", "API contract testing", "response validation", or "schema validation". Helps catch contract violations, verify data types and formats, and implement automated testing workflows.
---

## Overview
This skill enables comprehensive validation of API responses against predefined schemas and contracts. It automatically detects when validation is needed and guides the implementation of robust response checking using JSON Schema, OpenAPI specs, and custom validation rules.

## How It Works
1. **Schema Detection**: Identifies available schemas from OpenAPI specs, JSON Schema files, or custom definitions
2. **Response Analysis**: Examines API response structure, data types, and content against expected contracts
3. **Validation Implementation**: Creates validation logic with detailed error reporting and compliance checking
4. **Integration Setup**: Configures validation within existing test suites or production monitoring

## When to Use This Skill
- Implementing API contract testing in CI/CD pipelines
- Adding runtime response validation to production applications
- Debugging API integration issues with schema mismatches
- Creating comprehensive test suites for external API dependencies
- Ensuring third-party API responses meet expected contracts
- Setting up monitoring for API contract drift detection

## Examples

### Example 1: OpenAPI Contract Validation
User request: "I need to validate our REST API responses against our OpenAPI spec"

The skill will:
1. Analyze the OpenAPI specification and extract response schemas
2. Generate validation code that checks responses against defined schemas
3. Create comprehensive error reporting for contract violations
4. Set up automated testing integration

### Example 2: JSON Schema Response Checking
User request: "Check if this API response matches our JSON schema"

The skill will:
1. Load the relevant JSON Schema definitions
2. Validate response structure, required fields, and data types
3. Report specific validation errors with field-level details
4. Suggest schema updates if legitimate response changes are detected

### Example 3: Custom Business Rule Validation
User request: "Validate API responses with custom business logic beyond basic schema"

The skill will:
1. Implement custom validation rules alongside schema checking
2. Create flexible validation pipelines with multiple validation stages
3. Generate detailed compliance reports with business context
4. Set up alerts for critical validation failures

## Best Practices
- **Schema Management**: Keep schemas versioned and synchronized with API documentation
- **Error Handling**: Implement graceful degradation when validation fails in production
- **Performance**: Cache schemas and optimize validation for high-throughput scenarios
- **Monitoring**: Set up alerts for validation failure patterns and schema drift

## Integration
Works seamlessly with testing frameworks, CI/CD pipelines, and API monitoring tools. Integrates with OpenAPI documentation workflows and complements API development and debugging plugins.