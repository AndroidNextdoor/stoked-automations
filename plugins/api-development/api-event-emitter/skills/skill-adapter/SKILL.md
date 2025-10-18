---
name: Implementing Event-Driven APIs
description: |
  Implements event-driven API architectures with message queues, event streaming, and asynchronous communication patterns. Activates when users mention "event-driven API", "message queue", "event streaming", "publish-subscribe", "Kafka", "RabbitMQ", "event architecture", "async messaging", "microservices events", or "distributed event system". Generates event publishers, subscribers, message broker integrations, and complete event-driven workflows for scalable, decoupled systems.
---

## Overview

This skill implements production-grade event-driven API architectures that enable asynchronous communication between services through message queues and event streaming. It creates decoupled, scalable systems where services communicate via events rather than direct API calls.

## How It Works

1. **Event Architecture Setup**: Creates event schemas, publishers, and subscribers with proper error handling and retry logic
2. **Message Broker Integration**: Configures connections to Kafka, RabbitMQ, or other message brokers with production settings
3. **Event Flow Implementation**: Builds complete event-driven workflows with routing, filtering, and transformation capabilities

## When to Use This Skill

- Building microservices that need to communicate asynchronously
- Implementing publish-subscribe patterns for system decoupling
- Creating scalable APIs that handle high-volume event processing
- Setting up message queues for reliable async communication
- Developing event streaming applications with real-time processing
- Migrating from synchronous to event-driven architectures

## Examples

### Example 1: E-commerce Order Processing
User request: "Create an event-driven API for order processing with Kafka"

The skill will:
1. Generate order event schemas and publishing endpoints
2. Create inventory, payment, and shipping event subscribers
3. Set up Kafka producers/consumers with error handling and dead letter queues
4. Implement event routing and state management across services

### Example 2: Real-time Notification System
User request: "Build a message queue system for user notifications using RabbitMQ"

The skill will:
1. Create notification event publishers for different trigger types
2. Set up RabbitMQ exchanges and queues with appropriate routing
3. Implement subscriber services for email, SMS, and push notifications
4. Add event filtering and user preference handling

### Example 3: Microservices Event Communication
User request: "Implement event streaming between user service and analytics"

The skill will:
1. Create user activity event publishers with structured schemas
2. Build analytics subscribers for real-time data processing
3. Set up event transformation and aggregation pipelines
4. Implement monitoring and observability for event flows

## Best Practices

- **Event Schema Design**: Creates versioned, backward-compatible event schemas with clear naming conventions
- **Error Handling**: Implements retry policies, dead letter queues, and circuit breakers for resilient event processing
- **Security**: Adds authentication, authorization, and encryption for secure event transmission
- **Monitoring**: Includes metrics, tracing, and logging for event-driven system observability

## Integration

Works seamlessly with containerization tools for deploying event-driven services, monitoring plugins for observability, and database tools for event sourcing implementations. Integrates with cloud provider message services and on-premise broker deployments.