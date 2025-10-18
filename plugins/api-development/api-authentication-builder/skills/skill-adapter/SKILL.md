---
name: Building API Authentication Systems
description: |
  Automatically builds comprehensive API authentication and authorization systems when users mention "auth", "authentication", "login", "JWT", "OAuth", "API keys", "user management", or "access control". Creates production-ready authentication middleware, user registration/login endpoints, JWT token handling, OAuth2 flows, API key management, role-based permissions, and multi-factor authentication. Generates complete auth infrastructure including password hashing, session management, token refresh mechanisms, and security middleware for protecting API routes.
---

## Overview

This skill automatically activates when users need to implement authentication systems for their APIs. It builds complete auth infrastructure including JWT tokens, OAuth2 flows, API keys, user management, and role-based access control with production-ready security practices.

## How It Works

1. **Authentication Method Selection**: Analyzes requirements to choose appropriate auth methods (JWT, OAuth2, API keys, sessions)
2. **Security Infrastructure Generation**: Creates middleware, password hashing, token management, and validation systems
3. **User Management Implementation**: Builds registration, login, profile management, and permission systems
4. **Integration Setup**: Configures route protection, CORS, rate limiting, and security headers

## When to Use This Skill

- Starting a new API project that needs user authentication
- Adding login/registration functionality to existing applications
- Implementing JWT token-based authentication
- Setting up OAuth2 integration with providers like Google, GitHub, or Facebook
- Creating API key management systems for third-party access
- Building role-based access control (RBAC) systems
- Adding multi-factor authentication (MFA) to existing auth
- Securing API endpoints with middleware protection

## Examples

### Example 1: JWT Authentication System
User request: "I need to add JWT authentication to my Node.js API with user registration and login"

The skill will:
1. Generate JWT middleware for token validation and route protection
2. Create user registration/login endpoints with password hashing
3. Implement token refresh mechanisms and secure cookie handling
4. Add user profile management and password reset functionality

### Example 2: OAuth2 Integration
User request: "Set up Google OAuth login for my React app backend"

The skill will:
1. Configure OAuth2 client credentials and redirect URLs
2. Create authorization endpoints and callback handlers
3. Implement user profile synchronization and account linking
4. Generate frontend integration code for OAuth flow

### Example 3: API Key Management
User request: "Build an API key system for third-party developers to access my API"

The skill will:
1. Create API key generation, rotation, and revocation systems
2. Implement rate limiting and usage tracking per API key
3. Build admin dashboard for key management and analytics
4. Add scope-based permissions and access control

## Best Practices

- **Security First**: Implements bcrypt password hashing, secure JWT secrets, and HTTPS enforcement
- **Token Management**: Uses short-lived access tokens with refresh token rotation
- **Rate Limiting**: Applies authentication rate limits to prevent brute force attacks
- **Validation**: Includes comprehensive input validation and sanitization
- **Error Handling**: Provides secure error messages that don't leak sensitive information
- **Logging**: Implements audit logging for authentication events and security monitoring

## Integration

Works seamlessly with database plugins for user storage, API framework plugins for endpoint creation, and frontend plugins for client-side auth integration. Automatically configures CORS, security headers, and middleware chains for complete API protection.