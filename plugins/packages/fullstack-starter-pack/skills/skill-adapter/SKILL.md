---
name: Building Fullstack Applications
description: |
  Provides comprehensive fullstack development capabilities through 15 specialized plugins (8 AI agents + 7 commands) for React, Express/FastAPI, and PostgreSQL applications. Automatically activates when users mention "fullstack project", "build an app", "create MVP", "scaffold project", "React backend", "API database", "full application", or request complete web development solutions. Includes frontend components, backend APIs, database design, authentication, and deployment guidance.
---

## Overview

This skill provides a complete fullstack development toolkit with 15 specialized plugins covering React frontend, Express/FastAPI backend, PostgreSQL database, and deployment integration. It automatically scaffolds production-ready applications and provides expert guidance through specialized AI agents.

## How It Works

1. **Project Analysis**: Identifies fullstack development needs and recommends appropriate plugin combinations
2. **Scaffolding**: Uses command plugins to generate boilerplate code, schemas, and project structure
3. **Expert Guidance**: Activates specialized AI agents for architecture, design patterns, and best practices
4. **Integration**: Coordinates between frontend, backend, database, and deployment components

## When to Use This Skill

- Building complete web applications from scratch
- Creating MVPs or prototypes quickly
- Setting up React frontends with backend APIs
- Designing database schemas with API integration
- Implementing authentication and user management
- Deploying fullstack applications to production
- Standardizing development patterns across teams

## Examples

### Example 1: New MVP Development
User request: "I need to build a fullstack task management app with React and Express"

The skill will:
1. Activate project-scaffold command to create complete application structure
2. Use react-specialist agent for component architecture guidance
3. Generate Express API with express-api-scaffold command
4. Create database schema with prisma-schema-gen command
5. Set up authentication with auth-setup command

### Example 2: Frontend-Backend Integration
User request: "Help me connect my React components to a FastAPI backend with PostgreSQL"

The skill will:
1. Activate api-builder agent for API design recommendations
2. Use component-generator to create React components with API integration
3. Generate FastAPI boilerplate with fastapi-scaffold command
4. Design database relationships with database-designer agent
5. Configure environment variables with env-config-setup command

### Example 3: Production Deployment
User request: "My fullstack app is ready, how do I deploy it with Docker and CI/CD?"

The skill will:
1. Activate deployment-specialist agent for architecture recommendations
2. Generate Docker configurations and deployment scripts
3. Set up environment configuration for different deployment stages
4. Provide CI/CD pipeline guidance for automated deployment
5. Configure database migrations and production optimizations

## Best Practices

- **Project Structure**: Use project-scaffold command first to establish consistent folder organization
- **Component Design**: Leverage react-specialist agent for hooks, performance, and modern React patterns
- **API Architecture**: Consult backend-architect agent before implementing complex business logic
- **Database Design**: Use database-designer agent for schema normalization and indexing strategies
- **Security**: Always implement auth-setup command for JWT/OAuth authentication patterns
- **Performance**: Apply UI/UX expert recommendations for responsive design and accessibility

## Integration

Works seamlessly with existing development workflows and tools. The plugin system coordinates between frontend (React), backend (Express/FastAPI), database (PostgreSQL/Prisma), and deployment (Docker/CI-CD) layers. Each command plugin generates TypeScript-ready code that integrates with the AI agents' architectural guidance. The skill automatically suggests plugin combinations based on project requirements and maintains consistency across the entire application stack.