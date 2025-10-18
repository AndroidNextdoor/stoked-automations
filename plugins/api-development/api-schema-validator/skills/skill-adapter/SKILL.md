---
name: Validating API Schemas
description: |
  Implements comprehensive schema validation for APIs using JSON Schema, Joi, Yup, or Zod libraries. Automatically activates when users mention "validate schemas", "API validation", "schema validation", "type safety", "data validation", "request validation", "response validation", or need to enforce data contracts. Creates validation schemas, implements validation middleware, generates TypeScript types, and ensures data integrity across API endpoints.
---

## Overview

This skill implements robust API schema validation using modern validation libraries like JSON Schema, Joi, Yup, or Zod. It automatically sets up validation middleware, creates reusable schemas, and ensures type safety across your API endpoints.

## How It Works

1. **Schema Analysis**: Examines existing API endpoints and data structures to identify validation requirements
2. **Library Selection**: Chooses the most appropriate validation library (JSON Schema, Joi, Yup, or Zod) based on project needs
3. **Validation Implementation**: Creates comprehensive validation schemas with proper error handling and middleware integration

## When to Use This Skill

- Setting up validation for new API endpoints or refactoring existing ones
- Implementing request/response validation middleware
- Creating type-safe API contracts with detailed error messages
- Generating TypeScript types from validation schemas
- Establishing data integrity rules for complex nested objects
- Building reusable validation schemas across multiple endpoints

## Examples

### Example 1: Request Validation Setup
User request: "I need to validate API requests for my user registration endpoint"

The skill will:
1. Create validation schemas for registration data (email, password, profile fields)
2. Implement middleware to validate incoming requests
3. Set up detailed error responses for validation failures
4. Generate TypeScript interfaces matching the validation schema

### Example 2: Response Schema Validation
User request: "Add schema validation to ensure our API responses are consistent"

The skill will:
1. Analyze existing response structures across endpoints
2. Create validation schemas for each response type
3. Implement response validation middleware
4. Add automated tests to verify schema compliance

### Example 3: Complex Validation Rules
User request: "I need conditional validation where certain fields are required based on user type"

The skill will:
1. Design conditional validation logic using the chosen library's features
2. Implement custom validation rules for business logic
3. Create comprehensive test cases for all validation scenarios
4. Set up clear error messages for each validation case

## Best Practices

- **Library Choice**: Selects Zod for TypeScript projects, Joi for Node.js applications, and JSON Schema for language-agnostic APIs
- **Error Handling**: Implements detailed validation error messages with field-specific feedback
- **Performance**: Optimizes validation schemas for minimal runtime overhead
- **Maintainability**: Creates modular, reusable validation components that can be shared across endpoints

## Integration

Works seamlessly with Express.js, Fastify, NestJS, and other Node.js frameworks. Integrates with OpenAPI/Swagger documentation generation and can be combined with testing frameworks to ensure schema compliance. Compatible with TypeScript code generation and API documentation tools.