---
name: Generating Client SDKs from OpenAPI Specifications
description: |
  Automatically generates type-safe, production-ready client SDKs from OpenAPI/Swagger specifications for multiple programming languages. Activates when users mention "generate SDK", "client library", "API wrapper", "OpenAPI client", "Swagger codegen", "SDK generation", or need to create language-specific API clients. Handles TypeScript, Python, Go, Java, and other popular languages with comprehensive documentation, error handling, and authentication support.
---

## Overview
This skill generates professional client SDKs from OpenAPI specifications, creating type-safe libraries that developers can use to interact with APIs. It transforms API documentation into ready-to-use code libraries with proper error handling, authentication, and comprehensive documentation.

## How It Works
1. **Specification Analysis**: Reads and validates OpenAPI/Swagger specifications from files or URLs
2. **Language Selection**: Prompts for target programming languages and customization options
3. **Code Generation**: Creates complete SDK packages with models, clients, and documentation
4. **Package Preparation**: Structures output with proper build files, tests, and publishing configurations

## When to Use This Skill
- Creating official client libraries for your REST APIs
- Maintaining consistent SDK interfaces across multiple programming languages
- Reducing manual coding effort for API integration
- Ensuring type safety and proper error handling in API clients
- Publishing SDKs to package repositories (npm, PyPI, Maven, etc.)
- Keeping client libraries synchronized with API specification changes

## Examples

### Example 1: Multi-Language SDK Generation
User request: "I need to generate client SDKs for our payment API in TypeScript and Python"

The skill will:
1. Load the OpenAPI specification for the payment API
2. Generate TypeScript SDK with proper types and async/await patterns
3. Create Python SDK with dataclasses and requests integration
4. Include authentication handling and comprehensive error types
5. Generate documentation and usage examples for both languages

### Example 2: Enterprise API Client Library
User request: "Create a Java SDK from our Swagger spec with custom authentication"

The skill will:
1. Parse the Swagger specification and identify authentication schemes
2. Generate Java client with proper OOP structure and Maven configuration
3. Implement custom authentication handlers and retry logic
4. Create comprehensive Javadoc documentation and unit test templates
5. Package everything for Maven Central publishing

### Example 3: Rapid Prototyping Client
User request: "Generate a quick Go client for this OpenAPI spec to test our endpoints"

The skill will:
1. Analyze the OpenAPI specification for available endpoints
2. Create lightweight Go client with struct definitions
3. Generate example usage code for each endpoint
4. Include proper error handling and JSON marshaling
5. Provide go.mod file for immediate usage

## Best Practices
- **Specification Quality**: Ensure OpenAPI specs are complete with proper schemas, descriptions, and examples
- **Authentication Handling**: Configure authentication methods (API keys, OAuth, JWT) before generation
- **Version Management**: Use semantic versioning for generated SDKs to track API changes
- **Documentation**: Include comprehensive README files and code examples in generated packages
- **Testing**: Generate test templates and mock data for comprehensive SDK validation

## Integration
Works seamlessly with API development workflows, CI/CD pipelines for automated SDK publishing, and version control systems for tracking generated code changes. Integrates with package managers and build systems for each target language, enabling automatic distribution to repositories like npm, PyPI, and Maven Central.