---
name: Building WebSocket Servers
description: |
  Builds production-ready WebSocket servers for real-time bidirectional communication using Socket.IO or native WebSocket implementations. Automatically generates servers with room management, authentication, broadcasting, presence tracking, and connection handling. Triggers when users mention "websocket server", "real-time communication", "socket server", "live chat", "real-time updates", "bidirectional messaging", or need instant data synchronization between clients.
---

## Overview

This skill automatically generates complete WebSocket server implementations for real-time applications. It creates production-ready servers with Socket.IO or native WebSocket support, including essential features like room management, user authentication, message broadcasting, and connection resilience.

## How It Works

1. **Server Generation**: Creates a full WebSocket server with chosen implementation (Socket.IO or native WS)
2. **Feature Integration**: Adds room management, authentication middleware, and broadcasting capabilities
3. **Connection Handling**: Implements reconnection logic, error handling, and presence tracking
4. **Production Setup**: Includes logging, security measures, and scalability configurations

## When to Use This Skill

- Building real-time chat applications or messaging systems
- Creating live collaborative editors or shared workspaces
- Implementing real-time dashboards with live data updates
- Developing multiplayer games or interactive applications
- Setting up notification systems with instant delivery
- Building live streaming or video call coordination servers

## Examples

### Example 1: Real-Time Chat Application
User request: "I need a websocket server for a chat app with multiple rooms"

The skill will:
1. Generate Socket.IO server with room management and user authentication
2. Include message broadcasting, typing indicators, and presence tracking
3. Add connection handling with automatic reconnection and error recovery

### Example 2: Live Dashboard System  
User request: "Build a socket server for real-time data updates on a dashboard"

The skill will:
1. Create native WebSocket server optimized for data streaming
2. Implement efficient broadcasting for multiple dashboard clients
3. Include data validation, rate limiting, and connection monitoring

### Example 3: Collaborative Editor
User request: "I want real-time collaboration like Google Docs with websockets"

The skill will:
1. Build Socket.IO server with document room management and operational transforms
2. Add user presence, cursor tracking, and conflict resolution
3. Include persistence layer integration and change history

## Best Practices

- **Implementation Choice**: Uses Socket.IO for complex features, native WebSocket for performance-critical applications
- **Security**: Implements authentication middleware, rate limiting, and input validation by default
- **Scalability**: Includes Redis adapter configuration for multi-server deployments
- **Error Handling**: Adds comprehensive connection monitoring and graceful degradation
- **Performance**: Optimizes message serialization and implements efficient broadcasting patterns

## Integration

Works seamlessly with database plugins for message persistence, authentication systems for user management, and deployment tools for production scaling. Integrates with existing Express.js applications and can be combined with REST API endpoints for hybrid communication patterns.