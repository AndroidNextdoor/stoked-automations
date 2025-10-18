---
name: Generating REST APIs
description: |
  Generates production-ready RESTful APIs from schema definitions with comprehensive routing, validation, authentication, and OpenAPI documentation. Activates when users request API generation, REST endpoints, API scaffolding, backend services, or microservice creation. Creates complete API structures with controllers, models, middleware, tests, and follows REST best practices including proper HTTP methods, status codes, and security patterns.
---

## Overview

This skill automatically generates complete RESTful API implementations with proper routing, validation, authentication, and documentation. It creates production-ready backend services following REST principles and industry best practices.

## How It Works

1. **Requirements Gathering**: Collects API specifications including resources, operations, framework preferences, and authentication needs
2. **Structure Generation**: Creates complete API architecture with routes, controllers, models, middleware, and validation schemas
3. **Documentation Creation**: Generates OpenAPI/Swagger specifications and integration tests for all endpoints

## When to Use This Skill

- Building CRUD APIs or microservices quickly
- Creating backend services from database schemas
- Generating API scaffolding with authentication
- Implementing RESTful interfaces with validation
- Setting up APIs with comprehensive documentation
- Building production-ready backend services

## Examples

### Example 1: E-commerce API
User request: "Create a REST API for an e-commerce platform with products, orders, and users"

The skill will:
1. Generate resource-based endpoints (/api/v1/products, /api/v1/orders, /api/v1/users)
2. Create complete CRUD operations with proper HTTP methods and status codes
3. Add JWT authentication, input validation, and OpenAPI documentation
4. Include pagination, filtering, and comprehensive error handling

### Example 2: Blog Platform Backend
User request: "Generate a FastAPI backend for a blog with posts, comments, and user management"

The skill will:
1. Create Python FastAPI structure with Pydantic models and SQLAlchemy integration
2. Implement authentication middleware and role-based access control
3. Generate automated tests and interactive API documentation
4. Add rate limiting, CORS support, and standardized error responses

### Example 3: Microservice API
User request: "Build a Node.js microservice API for inventory management with Express"

The skill will:
1. Generate Express.js application with modular route structure
2. Create Joi validation schemas and PostgreSQL integration
3. Implement API versioning, logging middleware, and health check endpoints
4. Add Docker configuration and comprehensive integration tests

## Best Practices

- **REST Compliance**: Uses proper HTTP methods (GET, POST, PUT, DELETE) and status codes (200, 201, 400, 404, 500)
- **Security First**: Implements authentication, input validation, rate limiting, and security headers
- **Documentation**: Generates comprehensive OpenAPI specifications with example requests and responses
- **Testing**: Creates integration tests covering all endpoints and error scenarios
- **Scalability**: Includes pagination, filtering, sorting, and database optimization patterns

## Integration

Works seamlessly with database design tools for schema-driven development, authentication services for security implementation, and deployment platforms for production deployment. Integrates with testing frameworks and API documentation tools for complete development workflows.