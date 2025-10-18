---
name: Generating API Documentation
description: |
  Generates comprehensive OpenAPI/Swagger documentation from existing APIs, creating interactive documentation with Swagger UI, request/response examples, authentication details, and multi-format exports. Automatically activates when users mention "API documentation", "OpenAPI spec", "Swagger docs", "document API endpoints", "generate API docs", or need to create developer documentation for REST APIs.
---

## Overview
This skill automatically generates comprehensive OpenAPI 3.0 specifications from existing API codebases or live endpoints. It creates interactive Swagger UI documentation, complete with examples, authentication flows, and exportable formats for developer consumption.

## How It Works
1. **Analysis**: Scans your codebase or analyzes live API endpoints to discover routes, parameters, and data structures
2. **Specification Generation**: Creates OpenAPI 3.0.3 compliant documentation with detailed schemas, responses, and examples
3. **Interactive UI**: Generates Swagger UI interface for testing and exploring the API directly from the documentation
4. **Export Options**: Provides multiple output formats including JSON, YAML, Postman collections, and client SDK generation

## When to Use This Skill
- User mentions "document my API" or "create API documentation"
- Need to generate OpenAPI or Swagger specifications
- Want interactive API documentation for developer portals
- Creating Postman collections or API testing suites
- Generating client SDKs from existing APIs
- Building developer onboarding materials

## Examples

### Example 1: Express.js API Documentation
User request: "I need to generate API documentation for my Express.js application"

The skill will:
1. Analyze Express routes, middleware, and request/response patterns
2. Generate OpenAPI 3.0 specification with endpoint details, parameters, and schemas
3. Create interactive Swagger UI with live testing capabilities
4. Export documentation in multiple formats including Postman collection

### Example 2: REST API Specification from Live Endpoints
User request: "Create Swagger docs by analyzing my running API at localhost:3000"

The skill will:
1. Probe live endpoints to discover available routes and methods
2. Generate comprehensive OpenAPI specification with inferred schemas
3. Document authentication requirements and response formats
4. Provide downloadable documentation bundle with interactive interface

## Best Practices
- **Route Discovery**: Ensure your API routes are clearly defined and follow RESTful conventions for best auto-detection
- **Schema Documentation**: Include JSDoc comments or type annotations in your code for richer generated schemas
- **Authentication**: Clearly define authentication middleware and security schemes for accurate documentation
- **Examples**: Provide sample request/response data in your code comments for realistic documentation examples

## Integration
Works seamlessly with popular frameworks like Express.js, FastAPI, Spring Boot, and ASP.NET Core. Integrates with development workflows by generating documentation that can be hosted alongside your application or exported to API management platforms like Postman, Insomnia, or developer portals.