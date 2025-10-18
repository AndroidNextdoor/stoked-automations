---
name: Generating gRPC Services
description: |
  Automatically generates production-ready gRPC services with Protocol Buffer schemas, streaming RPCs, and multi-language implementations. Activates when users mention "gRPC", "Protocol Buffers", "protobuf", "microservices", "streaming RPC", "binary protocol", "service contracts", or need high-performance inter-service communication. Creates complete service definitions with unary and streaming methods, TLS security, interceptors, load balancing, and client/server code for Go, Python, Java, and other languages.
---

## Overview

This skill generates complete gRPC services with Protocol Buffer definitions, streaming support, and production-ready patterns. It creates strongly-typed service contracts that work across multiple programming languages with high performance and built-in features like load balancing, security, and service discovery.

## How It Works

1. **Service Design**: Analyzes requirements to design Protocol Buffer schemas with appropriate message types and RPC methods
2. **Code Generation**: Creates complete gRPC service implementations with both client and server code
3. **Production Setup**: Adds TLS security, interceptors, health checks, and deployment configurations

## When to Use This Skill

- Building microservices that need high-performance communication
- Implementing real-time streaming between services
- Creating type-safe APIs that work across multiple programming languages
- Developing internal service-to-service communication
- Building systems that require bidirectional streaming
- Migrating from REST APIs to more efficient binary protocols
- Setting up service mesh architectures

## Examples

### Example 1: User Management Service
User request: "Create a gRPC service for user management with authentication"

The skill will:
1. Generate Protocol Buffer definitions for User, AuthRequest, and AuthResponse messages
2. Create service methods for CreateUser, GetUser, AuthenticateUser, and streaming UserUpdates
3. Implement server code with authentication interceptors and client libraries
4. Add TLS configuration and health check endpoints

### Example 2: Real-time Chat Service
User request: "I need a streaming gRPC service for real-time messaging"

The skill will:
1. Design bidirectional streaming RPCs for chat functionality
2. Create Protocol Buffers for Message, ChatRoom, and User presence
3. Implement streaming server with connection management and client code
4. Add service discovery and load balancing configuration

### Example 3: Data Processing Pipeline
User request: "Build a microservice that processes data streams with protobuf"

The skill will:
1. Create streaming RPC definitions for data ingestion and processing
2. Generate efficient Protocol Buffer schemas for data payloads
3. Implement server with backpressure handling and batch processing
4. Add monitoring, logging, and error handling patterns

## Best Practices

- **Schema Evolution**: Designs Protocol Buffers with forward/backward compatibility in mind
- **Streaming Patterns**: Implements appropriate streaming patterns (client, server, or bidirectional) based on use case
- **Security**: Always includes TLS configuration and authentication interceptors
- **Performance**: Optimizes message sizes and uses efficient serialization patterns
- **Monitoring**: Adds gRPC metrics, health checks, and distributed tracing
- **Error Handling**: Implements proper gRPC status codes and error propagation

## Integration

Works seamlessly with container orchestration platforms like Kubernetes, service mesh solutions like Istio, and monitoring tools like Prometheus. Generated services integrate with existing CI/CD pipelines and can be deployed alongside REST APIs or as complete microservice replacements.