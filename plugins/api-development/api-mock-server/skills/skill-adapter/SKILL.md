---
name: Creating Mock API Servers
description: |
  Creates mock API servers from OpenAPI specifications for testing and development. Generates realistic fake data, supports stateful operations, and simulates various response scenarios including errors and latency. Activates when users mention "mock server", "API testing", "fake API", "stub endpoints", or need to test frontend applications without backend dependencies.
---

## Overview

This skill automatically creates production-grade mock API servers from OpenAPI/Swagger specifications. It generates Express.js-based servers with realistic fake data using faker.js, enabling developers to test applications without requiring actual backend services.

## How It Works

1. **Specification Analysis**: Parses OpenAPI/Swagger files to extract endpoint definitions, schemas, and response structures
2. **Server Generation**: Creates Express.js mock server with routes matching the API specification
3. **Data Population**: Uses faker.js to generate realistic fake data based on schema types and formats
4. **Response Simulation**: Implements configurable latency, error scenarios, and stateful behavior

## When to Use This Skill

- Need to test frontend applications before backend APIs are ready
- Want to simulate API responses for integration testing
- Require realistic fake data for development and demos
- Need to prototype API behavior without implementing full backend
- Want to test error handling and edge cases in applications
- Developing applications that consume third-party APIs

## Examples

### Example 1: Frontend Development Testing
User request: "I need a mock server for my user management API to test my React app"

The skill will:
1. Generate Express.js server from OpenAPI spec with user endpoints
2. Create realistic user data with names, emails, and profiles
3. Implement CRUD operations with stateful responses

### Example 2: API Integration Testing
User request: "Create a fake payment API for testing error scenarios"

The skill will:
1. Build mock server with payment endpoints from specification
2. Configure error response simulation (timeouts, failures)
3. Add customizable latency to simulate real-world conditions

### Example 3: Third-Party API Simulation
User request: "I need to stub a weather API while developing offline"

The skill will:
1. Generate mock weather service from OpenAPI documentation
2. Create realistic weather data with proper data types
3. Implement location-based responses and seasonal variations

## Best Practices

- **Specification Quality**: Ensure OpenAPI specs are well-defined with proper schemas and examples
- **Data Realism**: Configure faker.js appropriately for domain-specific realistic data
- **Error Testing**: Include various HTTP status codes and error scenarios in mock responses
- **Performance**: Add realistic latency simulation to match production API behavior
- **State Management**: Use stateful mocking for testing CRUD operations and data persistence

## Integration

Works seamlessly with frontend development workflows, testing frameworks like Jest or Cypress, and CI/CD pipelines. Mock servers can be containerized with Docker and integrated into development environments. Supports hot-reloading for rapid iteration during development and can export server configurations for team sharing.