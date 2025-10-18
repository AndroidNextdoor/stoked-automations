---
name: Building GraphQL Servers
description: |
  Activates when users mention building GraphQL APIs, creating schema-first servers, setting up Apollo servers, implementing GraphQL subscriptions, or need real-time API development. Automatically generates production-ready GraphQL servers with type-safe schemas, optimized resolvers using DataLoader, authentication directives, Relay-style pagination, and comprehensive tooling including GraphQL Playground for development.
---

## Overview
This skill automatically detects when users want to create GraphQL APIs and uses the graphql-server-builder plugin to generate complete, production-ready GraphQL servers. It implements schema-first design principles with type-safe resolvers, real-time subscriptions, and performance optimizations.

## How It Works
1. **Schema Generation**: Creates GraphQL Schema Definition Language (SDL) files with proper type definitions, queries, mutations, and subscriptions
2. **Resolver Implementation**: Builds type-safe resolvers with DataLoader integration to prevent N+1 query problems
3. **Server Setup**: Configures Apollo Server with authentication, error handling, and GraphQL Playground for development

## When to Use This Skill
- User mentions "GraphQL server", "GraphQL API", or "Apollo server"
- Request for schema-first design or SDL implementation
- Need for real-time subscriptions or WebSocket connections
- Building flexible APIs with client-specified data fetching
- Implementing type-safe API contracts
- Setting up GraphQL playground or development tools

## Examples

### Example 1: E-commerce API
User request: "I need a GraphQL API for my e-commerce app with products, users, and orders"

The skill will:
1. Generate schema files for Product, User, and Order types with relationships
2. Create resolvers with DataLoader for efficient database queries
3. Set up mutations for cart operations and authentication directives

### Example 2: Real-time Chat Application
User request: "Build a GraphQL server with real-time messaging capabilities"

The skill will:
1. Create subscription resolvers for real-time message delivery
2. Implement WebSocket configuration with proper authentication
3. Generate schema with Message types and subscription fields

### Example 3: Content Management System
User request: "I want to create a headless CMS API using GraphQL"

The skill will:
1. Build schema with content types, categories, and user roles
2. Implement Relay-style pagination for large content collections
3. Add authentication directives for content management permissions

## Best Practices
- **Schema Design**: Uses schema-first approach with clear type definitions and proper field relationships
- **Performance**: Implements DataLoader pattern to batch and cache database requests, preventing N+1 queries
- **Security**: Includes authentication directives and proper error handling without exposing sensitive data
- **Development**: Sets up GraphQL Playground for easy API exploration and testing

## Integration
Works seamlessly with database plugins for data layer integration, authentication systems for security implementation, and frontend frameworks that consume GraphQL APIs. The generated server structure follows industry standards and can be easily deployed to various hosting platforms.