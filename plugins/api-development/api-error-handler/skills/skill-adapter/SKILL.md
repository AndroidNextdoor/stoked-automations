---
name: Implementing API Error Handling
description: |
  Automatically implements standardized API error handling middleware when users mention "error handling," "HTTP status codes," "API errors," "exception handling," or "error middleware." Creates custom error classes, consistent error response formats, proper HTTP status code mapping, and comprehensive logging for Node.js, Python, and other backend frameworks. Generates production-ready error recovery strategies and client-friendly error messages.
---

## Overview

This skill automatically detects when you need to implement proper API error handling in your backend applications. It creates standardized error classes, middleware, and response formats that ensure consistent client experiences and easier debugging across your entire API.

## How It Works

1. **Detection**: Activates when you mention error handling, HTTP status codes, or API exceptions
2. **Analysis**: Examines your project structure to determine the appropriate framework and patterns
3. **Implementation**: Generates custom error classes, middleware, and standardized response formats
4. **Integration**: Adds comprehensive logging and error recovery strategies

## When to Use This Skill

- Building new APIs that need consistent error responses
- Refactoring existing applications with inconsistent error handling
- Adding proper HTTP status codes to API endpoints
- Implementing error logging and monitoring
- Creating client-friendly error messages
- Setting up exception handling middleware
- Standardizing error formats across microservices

## Examples

### Example 1: New Express.js API
User request: "I need to implement proper error handling for my Express API with correct HTTP status codes"

The skill will:
1. Create custom error classes (ValidationError, NotFoundError, etc.)
2. Generate Express middleware for centralized error handling
3. Set up proper HTTP status code mapping and JSON response formats

### Example 2: Python FastAPI Service
User request: "Add standardized exception handling to my FastAPI service"

The skill will:
1. Create custom exception classes inheriting from HTTPException
2. Implement exception handlers with structured error responses
3. Add request validation error handling and logging integration

### Example 3: Microservices Error Consistency
User request: "I need consistent error formats across my Node.js microservices"

The skill will:
1. Generate reusable error handling modules
2. Create standardized error response schemas
3. Implement error propagation patterns between services

## Best Practices

- **Status Codes**: Uses appropriate HTTP status codes (400 for validation, 404 for not found, 500 for server errors)
- **Response Format**: Creates consistent JSON error responses with error codes, messages, and context
- **Logging**: Includes structured logging with error tracking and correlation IDs
- **Security**: Sanitizes error messages to prevent information leakage in production
- **Recovery**: Implements graceful degradation and retry strategies where appropriate

## Integration

Works seamlessly with logging plugins, monitoring tools, and API documentation generators. Integrates with popular frameworks like Express.js, FastAPI, Django, and Spring Boot. Compatible with error tracking services like Sentry and application monitoring solutions.