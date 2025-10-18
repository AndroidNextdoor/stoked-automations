---
name: Creating API Monitoring Dashboards
description: |
  Creates comprehensive monitoring dashboards for API health, metrics, and alerts. Automatically activates when users mention "monitoring dashboard", "API metrics", "observability", "SLO tracking", "RED metrics", "performance monitoring", "service health", or need to track API uptime, response times, and error rates. Builds complete monitoring infrastructure with real-time alerts and executive dashboards.
---

## Overview

This skill creates comprehensive API monitoring dashboards that provide full observability into your services. It establishes metrics collection, alerting systems, and visualization dashboards to track API health, performance, and reliability in real-time.

## How It Works

1. **Assessment**: Analyzes your API architecture and identifies key monitoring points
2. **Dashboard Creation**: Builds monitoring infrastructure with metrics, logs, and traces
3. **Alert Configuration**: Sets up intelligent alerting for SLO violations and anomalies
4. **Validation**: Tests monitoring setup and provides optimization recommendations

## When to Use This Skill

- Setting up production API observability and health tracking
- Creating executive dashboards for service reliability metrics
- Implementing SRE practices with RED metrics monitoring
- Debugging performance issues with distributed tracing
- Establishing real-time alerting for API downtime or errors
- Building compliance dashboards for SLA monitoring

## Examples

### Example 1: Production API Health Dashboard
User request: "I need to monitor my REST API's performance and set up alerts for downtime"

The skill will:
1. Create comprehensive dashboard tracking response times, error rates, and throughput
2. Configure intelligent alerts for SLO violations and anomaly detection

### Example 2: Microservices Observability
User request: "Set up monitoring for our microservices architecture with distributed tracing"

The skill will:
1. Build service mesh monitoring with request flow visualization
2. Implement distributed tracing to track requests across service boundaries

### Example 3: Executive Reporting Dashboard
User request: "Create a high-level dashboard showing API health metrics for stakeholders"

The skill will:
1. Design executive-friendly visualizations showing uptime, performance trends, and SLA compliance
2. Configure automated reporting and summary metrics for business stakeholders

## Best Practices

- **Metric Selection**: Focus on RED metrics (Rate, Errors, Duration) for comprehensive coverage
- **Alert Tuning**: Start with conservative thresholds and adjust based on baseline performance
- **Dashboard Design**: Create role-specific views for developers, SREs, and executives
- **Data Retention**: Configure appropriate retention policies for different metric types

## Integration

Works seamlessly with popular monitoring tools like Prometheus, Grafana, DataDog, and New Relic. Integrates with existing CI/CD pipelines and deployment workflows. Compatible with cloud-native environments including Kubernetes, AWS, Azure, and GCP monitoring services.