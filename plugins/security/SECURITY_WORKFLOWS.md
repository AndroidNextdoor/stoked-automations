# Comprehensive Security Testing Workflows with Kali MCP

Complete security testing workflows integrating all Stoked Automations security plugins with Kali Linux MCP tools for professional-grade security assessments.

## Table of Contents

1. [Overview](#overview)
2. [Plugin Ecosystem](#plugin-ecosystem)
3. [Kali MCP Integration](#kali-mcp-integration)
4. [Complete Security Workflows](#complete-security-workflows)
5. [Specialized Testing Workflows](#specialized-testing-workflows)
6. [CI/CD Integration](#cicd-integration)
7. [Reporting and Remediation](#reporting-and-remediation)

## Overview

This guide provides comprehensive security testing workflows that combine:
- **Static Analysis (SAST)**: Code-level vulnerability detection
- **Dynamic Analysis (DAST)**: Runtime security testing with Kali tools
- **Interactive Testing (IAST)**: Combined static and dynamic approaches
- **LLM Security**: AI-specific vulnerability testing

### Security Testing Maturity Levels

**Level 1: Basic** (Pre-Commit)
- Secret scanning
- Dependency vulnerability checking
- Quick code analysis
- Duration: 30-60 seconds

**Level 2: Standard** (Pre-Deployment)
- Full SAST analysis
- Dependency audit with exploit research
- Basic DAST (nmap, nikto)
- Duration: 5-10 minutes

**Level 3: Comprehensive** (Production Audit)
- Complete SAST + DAST
- Full Kali MCP toolkit
- Exploitation validation
- Network infrastructure scan
- LLM security testing
- Duration: 30-60 minutes

**Level 4: Advanced** (Red Team Exercise)
- Complete Level 3
- Manual penetration testing
- Social engineering simulation
- Physical security assessment
- Duration: Days to weeks

## Plugin Ecosystem

### Security Testing Plugins

| Plugin | Primary Function | Kali MCP Integration | OWASP Coverage |
|--------|------------------|----------------------|----------------|
| **penetration-tester** | Full penetration testing | All 10 Kali tools | OWASP Top 10 |
| **vulnerability-scanner** | SAST + DAST scanning | nmap, nikto, openvas, sqlmap | OWASP Top 10 |
| **sql-injection-detector** | SQL injection testing | sqlmap | OWASP A03 |
| **xss-vulnerability-scanner** | XSS detection | curl, custom scripts | OWASP A03 |
| **llm-security-tester** | LLM/AI security | curl, custom LLM tools | OWASP LLM Top 10 |
| **secret-scanner** | Exposed secrets | grep, file analysis | OWASP A07 |
| **dependency-checker** | CVE detection | exploit-db search | OWASP A06 |

### MCP Server Plugins

| Plugin | Primary Function | Key Tools |
|--------|------------------|-----------|
| **kali-mcp** | Security tool execution | nmap, metasploit, sqlmap, nikto, gobuster |
| **atlassian-mcp** | Vulnerability tracking | Jira ticket management |
| **gitlab-mcp** | Code remediation | Merge request creation |
| **serena** | Security knowledge base | Historical test tracking |

## Kali MCP Integration

### Installation and Setup

```bash
# Install Kali MCP server
/plugin marketplace add AndroidNextdoor/stoked-automations
/plugin install kali-mcp@stoked-automations

# Verify installation
/mcp list | grep kali-server

# Expected output:
# mcp__kali-server__run_nmap_scan
# mcp__kali-server__web_enumeration
# mcp__kali-server__vulnerability_scan
# mcp__kali-server__sql_injection_test
# mcp__kali-server__curl_request
# mcp__kali-server__run_metasploit
# mcp__kali-server__password_cracking
# mcp__kali-server__network_sniffing
# mcp__kali-server__exploit_search
# mcp__kali-server__execute_command
```

### Kali MCP Tool Reference

| Tool | Scanner | Use Case | Example |
|------|---------|----------|---------|
| `run_nmap_scan` | Nmap | Network reconnaissance | Port/service discovery, OS detection |
| `web_enumeration` | Gobuster, dirb | Web attack surface | Hidden directories, backup files |
| `vulnerability_scan` | Nikto, OpenVAS | Automated vuln scanning | OWASP Top 10, CVE detection |
| `sql_injection_test` | SQLmap | Database injection | Auth bypass, data extraction |
| `curl_request` | cURL | HTTP testing | API analysis, manual testing |
| `run_metasploit` | Metasploit | Exploitation | PoC development, exploitation |
| `password_cracking` | John, Hashcat | Credential attacks | Password policy testing |
| `network_sniffing` | Tcpdump, Wireshark | Traffic analysis | Credential interception |
| `exploit_search` | SearchSploit | CVE research | Exploit availability check |
| `execute_command` | Any Kali tool | Custom testing | Specialized scans |

## Complete Security Workflows

### Workflow 1: Full Web Application Security Assessment

**Objective**: Comprehensive security testing of a web application from code to production.

**Prerequisites**:
- Source code access
- Deployed application URL
- Valid test credentials
- Authorization to test

**Phase 1: Reconnaissance** (5 minutes)
```bash
1. Network Discovery
   → Use mcp__kali-server__run_nmap_scan
   → Target: application IP/domain
   → Scan type: -sV -sC (service + scripts)
   → Identify: Open ports, services, versions

2. Web Surface Mapping
   → Use mcp__kali-server__web_enumeration
   → Tool: gobuster
   → Wordlist: /usr/share/wordlists/dirb/common.txt
   → Discover: Hidden directories, admin panels, backup files

3. Technology Stack Identification
   → Analyze HTTP headers, cookies, responses
   → Identify frameworks, languages, servers
   → Note: Potential version-specific vulnerabilities
```

**Phase 2: Static Analysis (10 minutes)**
```bash
4. Code Vulnerability Scan
   → Plugin: vulnerability-scanner (SAST mode)
   → Scan entire codebase
   → Detect: SQL injection patterns, XSS, hardcoded secrets

5. Dependency Audit
   → Plugin: dependency-checker
   → Check: npm/pip/composer dependencies
   → Use mcp__kali-server__exploit_search for CVE research

6. Secret Scanning
   → Plugin: secret-scanner
   → Scan: Git history, config files, environment variables
   → Detect: API keys, passwords, tokens
```

**Phase 3: Dynamic Web Testing (15 minutes)**
```bash
7. Automated Vulnerability Scanning
   → Use mcp__kali-server__vulnerability_scan
   → Tool: nikto
   → Target: https://stokedautomations.com
   → Detect: OWASP Top 10, configuration issues

8. SQL Injection Testing
   → Plugin: sql-injection-detector
   → Use mcp__kali-server__sql_injection_test (sqlmap)
   → Test: All input parameters (GET, POST, cookies, headers)
   → Attempt: Database enumeration, data extraction

9. XSS Vulnerability Scanning
   → Plugin: xss-vulnerability-scanner
   → Test: Reflected, stored, DOM-based XSS
   → Validate: Content Security Policy

10. Authentication & Session Testing
    → Plugin: authentication-validator
    → Test: Brute force protection, session management
    → Validate: Password policy, MFA implementation
```

**Phase 4: Exploitation (15 minutes)**
```bash
11. Exploit Research
    → Use mcp__kali-server__exploit_search
    → Search for: Identified services and versions
    → Research: ExploitDB, Metasploit modules

12. Proof-of-Concept Exploitation
    → Use mcp__kali-server__run_metasploit
    → Execute: Relevant exploit modules
    → Demonstrate: Real-world exploitability
    → Capture: Evidence and screenshots

13. Advanced Testing
    → Use mcp__kali-server__execute_command
    → Run: Custom security scripts
    → Test: Business logic flaws, race conditions
```

**Phase 5: Reporting (10 minutes)**
```bash
14. Consolidate Findings
    → Aggregate results from all plugins
    → Prioritize by severity (CVSS scoring)
    → Group by OWASP category

15. Create Jira Tickets
    → Use atlassian-mcp
    → Create ticket for each vulnerability
    → Include: Description, PoC, remediation, CVSS

16. Store Knowledge Base
    → Use serena
    → Store: Test methodology, findings, evidence
    → Tag: For future reference and team learning
```

**Expected Output**:
```
SECURITY ASSESSMENT SUMMARY
===========================
Target: https://stokedautomations.com
Date: 2025-10-18
Duration: 55 minutes
Tester: Stoked Automations Security Suite

EXECUTIVE SUMMARY
-----------------
Overall Risk: HIGH
Total Vulnerabilities: 12
├─ Critical: 2
├─ High: 4
├─ Medium: 4
└─ Low: 2

CRITICAL FINDINGS
-----------------
1. SQL Injection in /api/login
   - CVSS: 9.8
   - Exploit: Authentication bypass + data extraction
   - Status: Jira ticket SEC-101 created

2. Remote Code Execution via File Upload
   - CVSS: 9.4
   - Exploit: Shell upload successful
   - Status: Jira ticket SEC-102 created

RECOMMENDATIONS
---------------
Priority 1: Fix critical vulnerabilities (SEC-101, SEC-102)
Priority 2: Address high severity issues
Priority 3: Implement WAF and security monitoring
Priority 4: Security training for development team

NEXT STEPS
----------
1. Development team addresses findings
2. Re-test after remediation
3. Schedule quarterly security assessments
4. Implement CI/CD security gates
```

### Workflow 2: DevSecOps Pipeline Integration

**Objective**: Automated security testing in CI/CD pipeline with intelligent failure thresholds.

```yaml
# .github/workflows/security-pipeline.yml
name: Comprehensive Security Testing

on:
  pull_request:
    branches: [main, develop]
  push:
    branches: [main]

jobs:
  quick-security-check:
    name: Quick Security Scan (Pre-Merge)
    runs-on: ubuntu-latest
    timeout-minutes: 5

    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0  # Full history for secret scanning

      - name: Secret Scanning
        run: |
          /plugin secret-scanner
          # Blocks: Any secrets found

      - name: Dependency Vulnerability Check
        run: |
          /plugin dependency-checker
          # Blocks: Critical or High CVEs

      - name: Quick Code Analysis
        run: |
          /plugin vulnerability-scanner --quick
          # Blocks: Critical vulnerabilities only

  comprehensive-security-test:
    name: Full Security Assessment (Pre-Deployment)
    runs-on: ubuntu-latest
    timeout-minutes: 30
    needs: quick-security-check
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'

    steps:
      - uses: actions/checkout@v3

      - name: Setup Kali MCP
        run: |
          docker pull kali-mcp-server
          /plugin install kali-mcp@stoked-automations

      - name: Full SAST Analysis
        run: |
          /plugin vulnerability-scanner --full
          # Generates: SAST report

      - name: Deploy to Staging
        run: |
          # Deploy application to staging environment
          ./scripts/deploy-staging.sh

      - name: DAST with Kali Tools
        run: |
          # Network reconnaissance
          echo "Running nmap scan..."
          # Uses: mcp__kali-server__run_nmap_scan

          # Web vulnerability scanning
          echo "Running nikto scan..."
          # Uses: mcp__kali-server__vulnerability_scan

          # SQL injection testing
          echo "Testing for SQL injection..."
          # Uses: mcp__kali-server__sql_injection_test

      - name: LLM Security Testing (if applicable)
        if: contains(github.event.head_commit.message, '[llm]')
        run: |
          /plugin llm-security-tester
          /llm-test --target $STAGING_URL

      - name: Generate Security Report
        run: |
          # Consolidate all findings
          ./scripts/generate-security-report.sh

      - name: Create Jira Tickets
        if: failure()
        run: |
          # Use atlassian-mcp to create tickets
          # for each vulnerability found

      - name: Block Deployment
        if: failure()
        run: |
          echo "❌ Security tests failed. Deployment blocked."
          exit 1

  post-deployment-validation:
    name: Production Security Validation
    runs-on: ubuntu-latest
    needs: comprehensive-security-test
    if: success()

    steps:
      - name: External Penetration Test
        run: |
          /plugin penetration-tester
          /pentest --target $PRODUCTION_URL

      - name: Continuous Monitoring Setup
        run: |
          # Enable security monitoring
          ./scripts/enable-monitoring.sh
```

### Workflow 3: LLM Application Security Testing

**Objective**: Comprehensive security testing of AI-powered applications, chatbots, and RAG systems.

**Phase 1: LLM Application Reconnaissance** (5 minutes)
```bash
1. API Structure Analysis
   → Use mcp__kali-server__curl_request
   → Analyze: Authentication, rate limiting, API structure
   → Identify: LLM provider, model type

2. Endpoint Discovery
   → Use mcp__kali-server__web_enumeration
   → Discover: Chat endpoints, admin panels, configuration files
   → Map: Tool/plugin capabilities

3. RAG Architecture Detection
   → Analyze: Vector database, retrieval mechanisms
   → Identify: Knowledge base structure
   → Note: Context injection points
```

**Phase 2: OWASP LLM Top 10 Testing** (30 minutes)
```bash
4. Prompt Injection Testing (LLM01)
   → Plugin: llm-security-tester
   → Test: 100+ direct injection payloads
   → Test: Indirect injection (RAG poisoning)
   → Attempt: System prompt extraction

5. Output Security Testing (LLM02)
   → Test: XSS in LLM outputs
   → Test: Command injection
   → Validate: Content filtering

6. Training Data Poisoning (LLM03)
   → Test: Membership inference
   → Attempt: Extract training examples
   → Validate: Data privacy

7. Model DoS Testing (LLM04)
   → Test: Context flooding
   → Test: Token limit abuse
   → Validate: Rate limiting

8. Information Disclosure (LLM06)
   → Attempt: System prompt extraction
   → Test: Training data leakage
   → Validate: PII protection

9. Excessive Agency Testing (LLM08)
   → Test: Unauthorized tool usage
   → Test: Permission boundaries
   → Validate: Human-in-the-loop

10. Model Theft Testing (LLM10)
    → Test: API extraction attempts
    → Validate: Rate limit enforcement
    → Validate: Anomaly detection
```

**Phase 3: Jailbreaking Attempts** (10 minutes)
```bash
11. DAN (Do Anything Now) Variants
    → Test: DAN 6.0, 7.0, 8.0, 9.0
    → Test: Universal jailbreaks
    → Validate: Safety guardrails

12. Role-Playing Bypasses
    → Test: Character simulation attacks
    → Test: Fictional scenario bypasses
    → Validate: Content policy enforcement

13. Encoding Bypasses
    → Test: Base64, ROT13, Unicode tricks
    → Test: Obfuscation techniques
    → Validate: Input normalization
```

**Phase 4: RAG Security Testing** (10 minutes)
```bash
14. Context Poisoning
    → Inject: Malicious documents
    → Test: Hidden instruction execution
    → Validate: Context sanitization

15. Retrieval Manipulation
    → Test: Adversarial queries
    → Test: Semantic search bypass
    → Validate: Access control

16. Cross-User Data Access
    → Attempt: Retrieve other users' documents
    → Test: Vector store isolation
    → Validate: Multi-tenancy
```

**Phase 5: Reporting** (5 minutes)
```bash
17. OWASP LLM Compliance Report
    → Generate: Compliance scorecard
    → Document: All vulnerabilities
    → Provide: Remediation guidance

18. Create Jira Tickets
    → Use: atlassian-mcp
    → Track: Each LLM vulnerability
    → Include: Exploitation PoC

19. Knowledge Base Storage
    → Use: serena
    → Store: Test methodology
    → Track: Remediation progress
```

### Workflow 4: Red Team Exercise (Advanced)

**Objective**: Full adversarial simulation combining all techniques.

**Scope**:
- External network penetration
- Web application exploitation
- LLM security testing
- Privilege escalation
- Data exfiltration simulation

**Day 1: External Reconnaissance**
```bash
# Network discovery
mcp__kali-server__run_nmap_scan --target 10.0.0.0/24 --scan-type full

# Service enumeration
mcp__kali-server__run_nmap_scan --scripts vuln,exploit

# Web surface mapping
mcp__kali-server__web_enumeration --recursive --threads 50

# Subdomain enumeration
mcp__kali-server__execute_command --tool subfinder

# OSINT gathering (external scope)
```

**Day 2: Vulnerability Assessment**
```bash
# Automated vulnerability scanning
/plugin vulnerability-scanner --comprehensive

# Manual testing for business logic flaws
/plugin penetration-tester --focus business-logic

# LLM application testing
/plugin llm-security-tester --full-owasp

# Identify attack chains
- Combine vulnerabilities for maximum impact
- Prioritize paths leading to critical data access
```

**Day 3-4: Exploitation**
```bash
# Initial access
- Exploit identified vulnerabilities
- Establish foothold

# Privilege escalation
mcp__kali-server__exploit_search --cve CVE-XXXX-XXXX
mcp__kali-server__run_metasploit --module exploit/...

# Lateral movement
- Network sniffing for credentials
- Pass-the-hash attacks
- Token theft

# Data access
- Database enumeration
- File system access
- Cloud storage access
```

**Day 5: Reporting**
```bash
# Comprehensive report
- Executive summary
- Attack path diagram
- All findings with CVSS scores
- Business impact analysis
- Detailed remediation roadmap

# Presentation to stakeholders
- Demonstrate attack chain
- Show business impact
- Present remediation plan
```

## Specialized Testing Workflows

### API Security Testing

```bash
# 1. API Discovery
mcp__kali-server__web_enumeration --target https://api.stokedautomations.com
mcp__kali-server__curl_request --target https://api.stokedautomations.com/swagger.json

# 2. Authentication Testing
/plugin authentication-validator --focus api

# 3. Authorization Testing
- Test IDOR (Insecure Direct Object References)
- Test privilege escalation
- Test horizontal and vertical access control

# 4. Injection Testing
mcp__kali-server__sql_injection_test --api-mode
- NoSQL injection
- Command injection
- XML injection

# 5. Rate Limiting & DoS
- Test rate limits
- Resource exhaustion
- Business logic abuse
```

### Container Security Testing

```bash
# 1. Image Vulnerability Scanning
docker scan my-app:latest

# 2. Runtime Security
- Test privilege escalation
- Test container escape
- Test network segmentation

# 3. Kubernetes Security
- Test RBAC misconfigurations
- Test secret exposure
- Test network policies
```

### Cloud Security Testing (AWS/Azure/GCP)

```bash
# 1. IAM Assessment
- Test permission boundaries
- Test privilege escalation paths
- Validate least privilege

# 2. Storage Security
- Test S3/Blob public access
- Test encryption configuration
- Test backup security

# 3. Network Security
- Test security group rules
- Test VPC isolation
- Test firewall configurations
```

## CI/CD Integration

### Pre-Commit Hooks

```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "🔒 Running security pre-commit checks..."

# 1. Secret scanning (BLOCKS commit)
/plugin secret-scanner --pre-commit
if [ $? -ne 0 ]; then
  echo "❌ Secrets detected! Commit blocked."
  exit 1
fi

# 2. Dependency check (WARNING only)
/plugin dependency-checker --quick
if [ $? -ne 0 ]; then
  echo "⚠️  WARNING: Vulnerable dependencies found."
  echo "Run '/plugin dependency-checker' for details."
fi

echo "✅ Pre-commit security checks passed!"
```

### GitHub Actions Integration

See **Workflow 2** above for comprehensive CI/CD pipeline example.

### GitLab CI Integration

```yaml
# .gitlab-ci.yml
stages:
  - security-quick
  - build
  - security-full
  - deploy

secret-scan:
  stage: security-quick
  script:
    - /plugin secret-scanner
  allow_failure: false  # Block pipeline

dependency-check:
  stage: security-quick
  script:
    - /plugin dependency-checker
  allow_failure: false  # Block on critical/high

sast-scan:
  stage: security-full
  script:
    - /plugin vulnerability-scanner --full
  artifacts:
    reports:
      sast: security-report.json

dast-scan:
  stage: security-full
  script:
    - /plugin install kali-mcp@stoked-automations
    - /plugin penetration-tester --target $STAGING_URL
  artifacts:
    reports:
      dast: dast-report.json
```

## Reporting and Remediation

### Automated Ticket Creation

```javascript
// Example: Create Jira ticket for vulnerability
async function createVulnerabilityTicket(finding) {
  const ticket = {
    project: "SEC",
    issueType: "Bug",
    summary: `[${finding.severity}] ${finding.title}`,
    description: `
**Vulnerability**: ${finding.category}
**CVSS Score**: ${finding.cvss}
**Location**: ${finding.location}

**Description**:
${finding.description}

**Proof of Concept**:
\`\`\`
${finding.poc}
\`\`\`

**Impact**:
${finding.impact}

**Remediation**:
${finding.remediation}

**References**:
${finding.references.join('\n')}

---
🤖 Generated by Stoked Automations Security Suite
    `,
    priority: finding.severity === "Critical" ? "Highest" : "High",
    labels: ["security", "automated", finding.category],
  };

  // Use atlassian-mcp to create
  await mcp.atlassian.createIssue(ticket);
}
```

### Remediation Tracking

```bash
# 1. Initial vulnerability detection
/plugin vulnerability-scanner --target https://stokedautomations.com
# Result: 12 vulnerabilities found

# 2. Create Jira tickets
# Uses atlassian-mcp to create SEC-101 through SEC-112

# 3. Store in knowledge base
# Uses serena to track baseline

# 4. Developers fix issues
# Merge requests created via gitlab-mcp

# 5. Re-test to verify fixes
/plugin vulnerability-scanner --retest --baseline previous-scan.json
# Result: 8 vulnerabilities fixed, 4 remain

# 6. Update Jira tickets
# Uses atlassian-mcp to mark SEC-101 through SEC-108 as resolved

# 7. Update knowledge base
# Uses serena to track progress
```

### Security Metrics Dashboard

Track security posture over time:

```python
# Example: Security metrics tracking
metrics = {
    "vulnerability_density": issues_per_1000_loc,
    "mean_time_to_detect": avg_detection_time,
    "mean_time_to_remediate": avg_remediation_time,
    "security_debt": total_unfixed_issues,
    "compliance_score": {
        "owasp_top_10": 85,  # % compliant
        "owasp_llm_top_10": 70,
        "pci_dss": 90,
    },
    "risk_score": weighted_cvss_score,
    "coverage": {
        "sast": 95,  # % of codebase scanned
        "dast": 80,  # % of endpoints tested
        "llm": 100,  # % of LLM features tested
    }
}
```

## Best Practices

### Defense in Depth

Layer multiple security controls:
```
1. Input Validation → Reject malicious inputs
2. Output Encoding → Prevent injection
3. Authentication → Verify identity
4. Authorization → Enforce permissions
5. Encryption → Protect data
6. Logging → Detect anomalies
7. Monitoring → Real-time alerts
```

### Continuous Security

```bash
# Daily
- Secret scanning on commits
- Dependency vulnerability monitoring

# Weekly
- SAST scans
- Quick DAST scans

# Monthly
- Full penetration testing
- LLM security testing (if applicable)
- Security metrics review

# Quarterly
- Red team exercises
- Compliance audits
- Security training
```

### Legal and Ethical

- ✅ **Always get authorization** before testing
- ✅ **Define clear scope** and boundaries
- ✅ **Document everything** for accountability
- ✅ **Practice responsible disclosure** for findings
- ✅ **Comply with regulations** (GDPR, HIPAA, etc.)
- ❌ **Never test without permission** (illegal)
- ❌ **Never cause service disruption** (unethical)
- ❌ **Never access/exfiltrate real data** (criminal)

## Resources

### OWASP Resources
- **OWASP Top 10 (2021)**: https://owasp.org/Top10/
- **OWASP LLM Top 10**: https://owasp.org/www-project-top-10-for-large-language-model-applications/
- **OWASP Testing Guide**: https://owasp.org/www-project-web-security-testing-guide/
- **OWASP Cheat Sheets**: https://cheatsheetseries.owasp.org/

### Tools Documentation
- **Kali Linux Tools**: https://www.kali.org/tools/
- **Metasploit**: https://docs.metasploit.com/
- **SQLmap**: https://sqlmap.org/
- **Nmap**: https://nmap.org/book/

### Training Resources
- **Hack The Box**: https://www.hackthebox.com/
- **TryHackMe**: https://tryhackme.com/
- **PortSwigger Web Security Academy**: https://portswigger.net/web-security
- **OWASP WebGoat**: https://owasp.org/www-project-webgoat/

---

**Document Version**: 1.0.0
**Last Updated**: 2025-10-18
**Author**: Andrew Nixdorf
**Repository**: https://github.com/AndroidNextdoor/stoked-automations
