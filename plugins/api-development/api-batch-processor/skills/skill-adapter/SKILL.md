---
name: Processing Batch API Operations
description: |
  Implements high-performance batch API processing systems with job queues, progress tracking, and error recovery. Activates when users mention "batch processing", "bulk API operations", "job queues", "process multiple requests", "batch jobs", or need to handle large-scale API operations efficiently. Creates asynchronous processing pipelines with Bull/BullMQ for handling thousands of API calls without overwhelming servers.
---

## Overview
This skill implements robust batch API processing systems that handle large-scale operations through job queues and asynchronous processing. It creates production-ready batch processing infrastructure with progress tracking, intelligent retry mechanisms, and comprehensive error handling.

## How It Works
1. **Queue Setup**: Configures Bull/BullMQ job queues with Redis backend for reliable job persistence
2. **Batch Creation**: Implements job creation endpoints that accept bulk data and split into processable chunks
3. **Processing Engine**: Sets up workers that process jobs asynchronously with configurable concurrency
4. **Progress Tracking**: Adds real-time progress monitoring with status updates and completion notifications
5. **Error Recovery**: Implements intelligent retry logic, dead letter queues, and failure handling

## When to Use This Skill
- Processing thousands of API requests without overwhelming servers
- Implementing bulk data operations (imports, exports, transformations)
- Creating background job processing systems
- Building resilient APIs that handle high-volume operations
- Adding asynchronous processing to existing synchronous workflows
- Implementing batch email sending, file processing, or data synchronization

## Examples

### Example 1: Bulk Email Processing
User request: "I need to send marketing emails to 50,000 subscribers without timing out"

The skill will:
1. Create a Bull queue for email jobs with Redis persistence
2. Implement batch creation endpoint that chunks subscribers into manageable groups
3. Set up email worker processes with rate limiting and retry logic
4. Add progress tracking dashboard showing sent/failed/pending counts

### Example 2: Data Migration Pipeline
User request: "Create a system to migrate millions of records between databases"

The skill will:
1. Design job queue architecture for database migration tasks
2. Implement chunked processing to handle large datasets efficiently
3. Add comprehensive error handling with dead letter queues
4. Create monitoring endpoints for tracking migration progress and identifying bottlenecks

### Example 3: Image Processing Service
User request: "Build batch image resizing for user uploads"

The skill will:
1. Set up file processing queue with configurable worker concurrency
2. Implement job creation for bulk image operations with size variants
3. Add progress tracking with real-time status updates
4. Create failure recovery system for corrupted or problematic images

## Best Practices
- **Queue Configuration**: Uses Redis for job persistence and implements proper connection pooling
- **Concurrency Control**: Configures worker concurrency based on external API rate limits and server capacity
- **Error Handling**: Implements exponential backoff, maximum retry limits, and dead letter queues
- **Monitoring**: Adds comprehensive logging, metrics collection, and health check endpoints
- **Resource Management**: Implements proper cleanup, memory management, and connection handling

## Integration
Works seamlessly with existing Express.js/FastAPI applications, integrates with monitoring tools like Prometheus, and connects to various databases and external APIs. Compatible with containerized deployments and cloud job processing services like AWS SQS or Google Cloud Tasks.