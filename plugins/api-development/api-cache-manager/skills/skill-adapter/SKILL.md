---
name: Managing API Cache Strategies
description: |
  Implements comprehensive multi-level API caching strategies using Redis, CDN integration, and HTTP headers. Activates when users mention "cache", "caching", "performance optimization", "reduce API load", "Redis cache", "CDN setup", or "cache invalidation". Creates browser cache policies, server-side Redis caching, CDN configurations, and intelligent cache invalidation systems to dramatically improve API response times and reduce database load.
---

## Overview

This skill implements enterprise-grade multi-level API caching strategies combining browser cache, CDN cache, and server-side Redis cache. It automatically configures intelligent cache invalidation, cache warming strategies, and performance monitoring to optimize API response times and reduce backend load.

## How It Works

1. **Cache Strategy Analysis**: Analyzes API endpoints and data patterns to determine optimal caching levels and TTL values
2. **Redis Implementation**: Sets up Redis caching with connection pooling, serialization, and cluster support
3. **HTTP Header Configuration**: Implements Cache-Control, ETag, and Last-Modified headers for browser and CDN caching
4. **CDN Integration**: Configures CDN rules, edge caching policies, and purge mechanisms
5. **Invalidation Logic**: Creates smart cache invalidation based on data dependencies and update patterns

## When to Use This Skill

- Need to improve API performance and reduce response times
- High database load requiring server-side caching with Redis
- Want to implement CDN caching for static and dynamic content
- Building cache invalidation strategies for data consistency
- Setting up cache warming for frequently accessed endpoints
- Creating cache monitoring and analytics dashboards

## Examples

### Example 1: E-commerce API Optimization
User request: "Our product API is slow and hitting the database too much, need caching"

The skill will:
1. Implement Redis caching for product data with 1-hour TTL
2. Set up CDN caching for product images and static content
3. Create cache invalidation triggers when products are updated
4. Add cache-aside pattern with automatic fallback to database

### Example 2: User Profile Caching
User request: "Cache user profiles but ensure real-time updates for critical data"

The skill will:
1. Configure Redis with write-through caching for user profiles
2. Set up cache tags for selective invalidation by user groups
3. Implement cache warming for frequently accessed profiles
4. Create real-time invalidation for security-critical profile changes

### Example 3: Content Management System
User request: "Need CDN caching for our CMS API with smart cache invalidation"

The skill will:
1. Set up multi-tier caching with browser, CDN, and Redis layers
2. Configure cache purging based on content relationships
3. Implement cache preloading for published content
4. Add cache performance monitoring and hit rate analytics

## Best Practices

- **TTL Strategy**: Sets appropriate Time-To-Live values based on data volatility and business requirements
- **Cache Keys**: Uses hierarchical, descriptive cache keys with namespace prefixes for easy management
- **Invalidation**: Implements tag-based and dependency-based cache invalidation to maintain data consistency
- **Monitoring**: Adds comprehensive cache metrics, hit rates, and performance monitoring
- **Fallback**: Ensures graceful degradation when cache services are unavailable
- **Security**: Implements cache isolation and prevents cache poisoning attacks

## Integration

Works seamlessly with existing API frameworks (Express, FastAPI, Django), Redis clusters, CDN providers (CloudFlare, AWS CloudFront), and monitoring tools (Prometheus, Grafana). Integrates with CI/CD pipelines for cache warming during deployments and provides cache analytics for performance optimization decisions.