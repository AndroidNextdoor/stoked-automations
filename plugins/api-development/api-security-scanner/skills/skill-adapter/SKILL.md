---
name: Scanning APIs for Security Vulnerabilities
description: |
  Automatically activates when users mention API security scanning, vulnerability assessment, OWASP API Top 10, penetration testing, security audits, or need to identify authentication flaws, authorization issues, injection vulnerabilities, and security misconfigurations in REST APIs and web services. Performs comprehensive automated security analysis with detailed remediation guidance following industry standards.
---

## Overview
This skill enables automated security vulnerability scanning for APIs using the OWASP API Security Top 10 framework. It identifies critical security flaws including broken authentication, authorization issues, injection attacks, and misconfigurations while providing actionable remediation guidance.

## How It Works
1. **Target Identification**: Analyzes API endpoints, authentication mechanisms, and data flow patterns
2. **Vulnerability Assessment**: Executes automated tests for OWASP API Top 10 vulnerabilities including broken object level authorization, broken user authentication, excessive data exposure, and security misconfiguration
3. **Report Generation**: Creates detailed security reports with vulnerability classifications, risk ratings, and step-by-step remediation instructions

## When to Use This Skill
- User mentions "scan API security", "check API vulnerabilities", or "OWASP API testing"
- Requests for "penetration testing", "security audit", or "vulnerability assessment"
- Mentions "authentication flaws", "authorization issues", or "injection vulnerabilities"
- Needs "security compliance", "PCI DSS validation", or "pre-deployment security checks"
- Asks about "API security best practices" or "security misconfiguration detection"

## Examples

### Example 1: Pre-Deployment Security Audit
User request: "I need to scan my REST API for security vulnerabilities before going live"

The skill will:
1. Activate the api-security-scanner plugin using `/scan-api-security`
2. Execute comprehensive OWASP API Top 10 vulnerability tests
3. Generate detailed security report with risk assessments and remediation steps

### Example 2: Authentication Testing
User request: "Check if my API has any authentication or authorization flaws"

The skill will:
1. Launch targeted authentication and authorization vulnerability scans
2. Test for broken object level authorization and user authentication issues
3. Provide specific remediation guidance for identified security gaps

### Example 3: Compliance Validation
User request: "Validate my API security for PCI DSS compliance requirements"

The skill will:
1. Execute security scans focused on compliance-related vulnerabilities
2. Check for data exposure, injection flaws, and security misconfigurations
3. Generate compliance-ready security assessment report

## Best Practices
- **Scope Definition**: Clearly define API endpoints and authentication methods before scanning
- **Environment Safety**: Always run security scans in dedicated testing environments, never in production
- **Regular Assessment**: Schedule periodic security scans as part of CI/CD pipeline integration
- **Remediation Priority**: Address critical and high-risk vulnerabilities first based on CVSS scores

## Integration
Works seamlessly with development workflows and CI/CD pipelines. Results can be integrated with security monitoring tools, vulnerability management systems, and compliance reporting frameworks. Compatible with API documentation tools and authentication testing suites for comprehensive security validation.