---
name: Testing API Performance Under Load
description: |
  Executes comprehensive load tests on APIs using k6, Artillery, or Gatling to measure performance, identify bottlenecks, and validate scalability under realistic traffic patterns. Activates when users mention "load test", "stress test", "performance test", "API load", "traffic simulation", "concurrent users", "throughput testing", or "scalability validation". Automatically selects appropriate testing tools, configures realistic scenarios, and provides detailed performance metrics and recommendations.
---

## Overview

This skill enables comprehensive API load testing using industry-standard tools like k6, Artillery, and Gatling. It automatically configures realistic traffic patterns, executes performance tests, and provides actionable insights about API scalability and bottlenecks.

## How It Works

1. **Test Configuration**: Analyzes API endpoints and automatically selects the most appropriate load testing tool based on requirements
2. **Scenario Creation**: Generates realistic load testing scenarios with configurable user loads, ramp-up patterns, and duration settings
3. **Execution & Monitoring**: Runs tests while monitoring key performance metrics like response times, throughput, and error rates
4. **Results Analysis**: Processes test results and provides detailed performance reports with bottleneck identification and optimization recommendations

## When to Use This Skill

- When you need to "load test" or "stress test" APIs before production deployment
- To validate API "scalability" and "performance under load"
- When measuring "throughput", "response times", or "concurrent user capacity"
- For "performance benchmarking" and identifying system bottlenecks
- When simulating realistic "traffic patterns" or "user behavior"
- To validate SLA requirements and capacity planning

## Examples

### Example 1: Basic API Load Testing
User request: "I need to load test my REST API to see how it handles 100 concurrent users"

The skill will:
1. Configure k6 with 100 virtual users and appropriate ramp-up patterns
2. Execute load tests measuring response times, throughput, and error rates
3. Generate comprehensive performance reports with recommendations

### Example 2: Complex Scenario Testing
User request: "Can you stress test our e-commerce API with realistic shopping scenarios?"

The skill will:
1. Create multi-stage scenarios simulating browsing, cart operations, and checkout flows
2. Use Artillery to configure realistic user journeys with varying load patterns
3. Provide detailed analysis of performance across different API endpoints

### Example 3: Performance Validation
User request: "We need to validate our API can handle Black Friday traffic levels"

The skill will:
1. Configure high-volume load tests with peak traffic simulation
2. Monitor system behavior under extreme load conditions
3. Identify breaking points and provide capacity planning recommendations

## Best Practices

- **Tool Selection**: Automatically chooses k6 for developer-friendly testing, Artillery for scenario complexity, or Gatling for enterprise-scale loads
- **Realistic Scenarios**: Configures authentic user behavior patterns rather than simple endpoint hammering
- **Gradual Loading**: Implements proper ramp-up and ramp-down patterns to avoid unrealistic traffic spikes
- **Comprehensive Metrics**: Captures response times, error rates, throughput, and resource utilization data
- **Result Interpretation**: Provides actionable insights and specific optimization recommendations

## Integration

Works seamlessly with CI/CD pipelines for automated performance validation, integrates with monitoring tools for baseline comparisons, and supports various API formats including REST, GraphQL, and WebSocket endpoints. Results can be exported to common formats for integration with performance monitoring dashboards and reporting systems.