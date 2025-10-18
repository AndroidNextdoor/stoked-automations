---
name: Debugging REST API Failures
description: |
  Systematically debugs REST API failures by loading OpenAPI specifications, analyzing HTTP request/response logs, identifying root causes, and generating reproducible test commands. Activates when users mention "API debugging", "API failures", "HTTP errors", "OpenAPI analysis", or need help with failed API calls.
---

## Overview

This skill transforms API troubleshooting from guesswork into systematic analysis. It combines OpenAPI specification validation with actual HTTP log analysis to pinpoint why API calls fail and provides actionable solutions with reproducible test commands.

## How It Works

1. **Load API Documentation**: Parse OpenAPI 3.x specifications to understand expected API behavior, required parameters, and valid response formats
2. **Ingest HTTP Logs**: Import actual request/response data from HAR files, JSON logs, or direct input to analyze what actually happened
3. **Analyze Failures**: Compare actual requests against OpenAPI specs to identify mismatches, missing fields, authentication issues, and protocol violations
4. **Generate Solutions**: Create working cURL, HTTPie, and JavaScript fetch commands to reproduce and test fixes

## When to Use This Skill

- User reports "API call returning 400/401/403/404/422/500 errors"
- Need to "debug API failures" or "troubleshoot REST endpoints"
- Want to "validate requests against OpenAPI spec"
- User mentions "HTTP logs analysis" or "HAR file debugging"
- Need to "generate cURL commands" or "reproduce API issues"
- Requests help with "API authentication problems" or "parameter validation"

## Examples

### Example 1: 400 Bad Request Analysis

User request: "My POST request to /users keeps returning 400 errors. I have the OpenAPI spec and browser network logs."

The skill will:
1. Load the OpenAPI specification using `load_openapi` to understand required fields and formats
2. Import HTTP logs via `ingest_logs` from HAR export or JSON format
3. Use `explain_failure` to identify missing required fields, incorrect data types, or validation failures
4. Generate a corrected `make_repro` cURL command with proper headers and request body

### Example 2: Authentication Debugging

User request: "Getting 401 unauthorized errors even though I'm sending the API key. Can you help debug this?"

The skill will:
1. Parse OpenAPI spec to identify authentication scheme (bearer token, API key header, etc.)
2. Analyze actual request headers from HTTP logs to spot missing or malformed authentication
3. Explain the authentication mismatch with specific header requirements
4. Provide working cURL command with correctly formatted authentication headers

### Example 3: Bulk Error Analysis

User request: "I have hundreds of failed API calls in my logs. What are the main issues?"

The skill will:
1. Ingest large log files showing request/response patterns
2. Provide statistical breakdown of status codes, error types, and failure patterns
3. Identify top 10 most common errors with root cause analysis
4. Generate representative test commands for each major error category

## Best Practices

- **Load Specs First**: Always load OpenAPI specifications before analyzing logs to establish the expected baseline behavior
- **Use Real Logs**: Import actual HAR files from browser DevTools or server logs rather than reconstructing requests manually
- **Analyze Systematically**: Use explain_failure on representative samples rather than every single failed request
- **Validate Fixes**: Use generated cURL commands to verify solutions work before implementing changes in application code

## Integration

Works seamlessly with development workflows by accepting standard formats (OpenAPI JSON/YAML, HAR files) and generating portable test commands. Integrates with browser DevTools exports, API testing tools like Postman, and CI/CD pipelines for automated API validation.