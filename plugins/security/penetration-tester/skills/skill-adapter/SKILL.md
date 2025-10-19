---
name: Performing Penetration Testing
description: |
  This skill enables automated penetration testing of web applications using Kali Linux security tools via MCP. It uses the penetration-tester plugin combined with the kali-mcp server to identify vulnerabilities, including OWASP Top 10 threats, and suggests exploitation techniques. Use this skill when the user requests a "penetration test", "pentest", "vulnerability assessment", "security scan", "nmap scan", "run metasploit", or asks to "exploit" a web application. It provides comprehensive reporting on identified security flaws with real-time tool execution.
---

## Overview

This skill automates the process of penetration testing for web applications, identifying vulnerabilities and suggesting exploitation techniques. It leverages the penetration-tester plugin combined with the **Kali Linux MCP server** to assess web application security posture using professional-grade security tools (nmap, metasploit, nikto, etc.).

## How It Works

1. **Target Identification**: Analyzes the user's request to identify the target web application or API endpoint.
2. **Reconnaissance**: Uses Kali MCP tools (nmap, gobuster) to map the attack surface and identify services.
3. **Vulnerability Scanning**: Executes automated scans using Kali tools to discover potential vulnerabilities, covering OWASP Top 10 risks.
4. **Exploitation**: Leverages Metasploit and other Kali tools for proof-of-concept exploitation.
5. **Reporting**: Generates a detailed penetration test report, including identified vulnerabilities, risk ratings, and remediation recommendations.

## When to Use This Skill

This skill activates when you need to:
- Perform a penetration test on a web application.
- Identify vulnerabilities in a web application or API.
- Assess the security posture of a web application.
- Generate a report detailing security flaws and remediation steps.

## Examples

### Example 1: Performing a Full Penetration Test

User request: "Run a penetration test on example.com"

The skill will:
1. **Reconnaissance** - Use `mcp__kali-server__run_nmap_scan` to discover open ports and services
2. **Web Enumeration** - Use `mcp__kali-server__web_enumeration` with gobuster to find hidden directories
3. **Vulnerability Scanning** - Use `mcp__kali-server__vulnerability_scan` with nikto for web vulnerabilities
4. **Exploitation** - Use `mcp__kali-server__sql_injection_test` and `mcp__kali-server__run_metasploit` for proof-of-concept
5. Generate a detailed report outlining identified vulnerabilities, including SQL injection, XSS, and CSRF

**Kali MCP Tools Used:**
- `run_nmap_scan`: Port scanning and service detection
- `web_enumeration`: Directory enumeration with gobuster
- `vulnerability_scan`: Nikto web vulnerability scanning
- `sql_injection_test`: SQLmap for injection testing
- `exploit_search`: SearchSploit for exploit research

### Example 2: Assessing API Security

User request: "Perform vulnerability assessment on the /api/users endpoint"

The skill will:
1. **HTTP Analysis** - Use `mcp__kali-server__curl_request` to analyze API responses
2. **Authentication Testing** - Test for authentication bypass vulnerabilities
3. **Authorization Testing** - Check for broken access control (IDOR, privilege escalation)
4. **Injection Testing** - Use `mcp__kali-server__sql_injection_test` on API parameters
5. Identify potential security flaws in the API, such as authentication bypass or authorization issues, and provide remediation advice

**Kali MCP Tools Used:**
- `curl_request`: HTTP request analysis and testing
- `sql_injection_test`: API parameter injection testing
- `execute_command`: Custom API testing scripts

### Example 3: Network Reconnaissance

User request: "Scan the network 192.168.1.0/24 for vulnerabilities"

The skill will:
1. **Network Discovery** - Use `mcp__kali-server__run_nmap_scan` with -sn flag for host discovery
2. **Port Scanning** - Full TCP/UDP port scan on discovered hosts
3. **Service Detection** - Identify running services and versions
4. **Vulnerability Correlation** - Use `mcp__kali-server__exploit_search` to find exploits for identified services
5. Generate network security assessment report

**Kali MCP Tools Used:**
- `run_nmap_scan`: Comprehensive network reconnaissance
- `exploit_search`: CVE and exploit database queries
- `execute_command`: Custom nmap NSE scripts

### Example 4: Web Application Exploitation

User request: "Test https://target.com/login for SQL injection and exploit it"

The skill will:
1. **Initial Testing** - Use `mcp__kali-server__curl_request` to capture login form
2. **SQLi Detection** - Use `mcp__kali-server__sql_injection_test` with sqlmap for automated detection
3. **Database Enumeration** - Extract database names, tables, and columns
4. **Data Exfiltration** - Demonstrate data access via SQL injection
5. **Remediation Guidance** - Provide parameterized query examples

**Kali MCP Tools Used:**
- `curl_request`: Form analysis and request capture
- `sql_injection_test`: Automated SQL injection with sqlmap
- `execute_command`: Manual injection payload testing

## Kali MCP Integration

This skill leverages the **kali-mcp** plugin to execute real penetration testing tools. Ensure the Kali MCP server is installed and configured:

```bash
# Install Kali MCP plugin
/plugin install kali-mcp@stoked-automations

# Verify MCP tools are available
/mcp list | grep kali-server
```

### Available Kali MCP Tools

| MCP Tool | Security Function | Use Case |
|----------|-------------------|----------|
| `run_nmap_scan` | Port scanning, service detection | Network reconnaissance, attack surface mapping |
| `web_enumeration` | Directory/file discovery | Hidden resource discovery, backup file finding |
| `vulnerability_scan` | Web vulnerability scanning | OWASP Top 10 detection, misconfiguration finding |
| `sql_injection_test` | SQL injection detection | Database vulnerability testing, data extraction |
| `curl_request` | HTTP request testing | API testing, authentication analysis |
| `exploit_search` | Exploit database queries | CVE research, proof-of-concept finding |
| `run_metasploit` | Exploitation framework | Vulnerability exploitation, payload generation |
| `password_cracking` | Hash cracking | Credential access, password policy testing |
| `network_sniffing` | Traffic capture and analysis | Credential interception, protocol analysis |
| `execute_command` | Custom Kali tool execution | Specialized testing, custom scripts |

### Penetration Testing Workflow

```
1. Reconnaissance Phase
   └─ mcp__kali-server__run_nmap_scan (target discovery)
   └─ mcp__kali-server__web_enumeration (surface mapping)

2. Vulnerability Assessment Phase
   └─ mcp__kali-server__vulnerability_scan (automated scanning)
   └─ mcp__kali-server__sql_injection_test (injection testing)
   └─ mcp__kali-server__execute_command (custom checks)

3. Exploitation Phase
   └─ mcp__kali-server__exploit_search (find exploits)
   └─ mcp__kali-server__run_metasploit (exploitation)
   └─ mcp__kali-server__curl_request (manual testing)

4. Post-Exploitation Phase
   └─ mcp__kali-server__password_cracking (credential access)
   └─ mcp__kali-server__network_sniffing (lateral movement)

5. Reporting Phase
   └─ Document findings with atlassian-mcp (Jira tickets)
   └─ Store artifacts with serena (persistent memory)
```

## Best Practices

- **Authorization**: Always ensure you have explicit authorization before performing penetration testing on any system.
- **Scope Definition**: Clearly define the scope of the penetration test to avoid unintended consequences.
- **Safe Exploitation**: Use exploitation techniques carefully to demonstrate vulnerabilities without causing damage.
- **Tool Selection**: Choose the right Kali MCP tool for each testing phase to maximize efficiency.
- **Rate Limiting**: Respect timeout limits and avoid overwhelming target systems.
- **Legal Compliance**: Ensure all testing complies with local laws and regulations.

## Integration with Other Plugins

This skill integrates seamlessly with other security and productivity plugins:

- **atlassian-mcp**: Create Jira tickets for identified vulnerabilities with full details
- **gitlab-mcp**: Version control exploitation scripts and proof-of-concepts
- **serena**: Store penetration test notes, methodologies, and findings for future reference
- **vulnerability-scanner**: Combine with SAST scanning for comprehensive coverage
- **sql-injection-detector**: Validate findings from automated scans with manual testing

### Example: Full Security Workflow

```
1. Run penetration test with Kali MCP tools
2. Document findings with atlassian-mcp (create Jira tickets)
3. Store detailed notes with serena (persistent memory)
4. Commit PoC scripts to GitLab with gitlab-mcp
5. Track remediation progress in Jira
6. Re-test after fixes with Kali MCP tools
7. Close Jira tickets when vulnerabilities resolved
```

## Security and Legal Considerations

**CRITICAL**: This skill executes real penetration testing tools that can cause damage if misused.

### Legal Requirements
- Written authorization required before testing
- Clear scope and rules of engagement
- Compliance with local computer crime laws
- Respect for data privacy regulations

### Ethical Guidelines
- Only test systems you own or have permission to test
- Avoid causing service disruption or data loss
- Practice responsible disclosure for vulnerabilities
- Do not access, modify, or destroy data without authorization

**Unauthorized penetration testing is illegal and may result in criminal prosecution.**