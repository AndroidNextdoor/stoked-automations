---
name: Kali Linux Security Testing
description: |
  Activates when users need to perform penetration testing, security assessments, reconnaissance, vulnerability scanning, or CTF challenges. Triggers on phrases like "scan network", "test for SQL injection", "enumerate directories", "crack password", "exploit search", "nmap scan", "web enumeration", "run metasploit", "solve CTF", "find vulnerabilities", or "security assessment". Uses Kali Linux MCP server for comprehensive security testing via Docker.
---

## Overview

This skill leverages the Kali Linux MCP server to provide comprehensive security testing and penetration testing capabilities directly from Claude Code. It enables professional-grade security assessments, automated reconnaissance, exploitation, and CTF challenge solving without leaving your development environment.

## How It Works

1. **Command Execution**: Execute any Kali Linux security tool with AI-guided parameter optimization
2. **Network Reconnaissance**: Automated scanning with nmap, service enumeration, OS detection
3. **Web Application Testing**: Directory enumeration, vulnerability scanning, SQL injection testing
4. **Exploit Research**: Search and execute exploits from ExploitDB and Metasploit Framework
5. **Password Cracking**: Leverage John the Ripper and Hashcat for credential attacks
6. **Traffic Analysis**: Capture and analyze network packets with tcpdump and Wireshark
7. **CTF Assistance**: Real-time guidance for Capture The Flag challenges

## When to Use This Skill

- When performing authorized penetration testing on systems
- When solving Capture The Flag (CTF) challenges
- When conducting security assessments and vulnerability scans
- When testing web applications for security vulnerabilities
- When researching exploits for specific vulnerabilities
- When analyzing network traffic for security issues
- When cracking password hashes for security audits
- When learning offensive security techniques
- When automating reconnaissance workflows
- When documenting security findings

## MCP Tools Available

### Command Execution

- **execute_command**: Execute any Kali Linux terminal command or security tool
- Run nmap, gobuster, curl, sqlmap, john, metasploit, or any installed tool
- AI assists with command syntax and parameter optimization

### Network Reconnaissance

- **run_nmap_scan**: Network scanning and service enumeration
- Port discovery (TCP/UDP)
- Service version detection
- Operating system fingerprinting
- Vulnerability script scanning (NSE)

### Web Application Testing

- **web_enumeration**: Directory and file enumeration
- Gobuster, dirb, ffuf support
- Custom wordlist selection
- Recursive scanning
- Extension filtering

- **curl_request**: HTTP/HTTPS request testing
- Custom headers and cookies
- POST data submission
- Response analysis
- Cookie capture

### Vulnerability Assessment

- **vulnerability_scan**: Comprehensive vulnerability scanning
- Nikto web scanner
- OpenVAS integration
- CVE correlation
- Risk prioritization

- **sql_injection_test**: SQL injection testing with sqlmap
- Automated injection detection
- Database enumeration
- Data extraction
- Bypass techniques

### Exploitation

- **exploit_search**: Search exploit databases
- SearchSploit (ExploitDB)
- Metasploit module search
- CVE lookup
- Proof-of-concept code

- **run_metasploit**: Execute Metasploit Framework commands
- Exploit module execution
- Payload generation
- Post-exploitation
- Session management

### Password Attacks

- **password_cracking**: Password hash cracking
- John the Ripper
- Hashcat
- Wordlist attacks
- Rule-based attacks
- Brute force

### Traffic Analysis

- **network_sniffing**: Network traffic capture and analysis
- Tcpdump packet capture
- Wireshark analysis
- Protocol decoding
- Credential extraction

## Examples

### Example 1: Network Reconnaissance

User request: "Scan the target 192.168.1.100 for open ports and services"

The skill will:
1. Use `run_nmap_scan` with:
   - Target: 192.168.1.100
   - Scan type: SYN scan (-sS)
   - Service detection (-sV)
   - OS detection (-O)
   - Common scripts (-sC)
2. Return open ports with service versions
3. Identify potential vulnerabilities
4. Suggest next steps for exploitation

### Example 2: Web Directory Enumeration

User request: "Enumerate directories on https://target-website.com"

The skill will:
1. Use `web_enumeration` with:
   - Target URL: https://target-website.com
   - Tool: gobuster
   - Wordlist: /usr/share/wordlists/dirb/common.txt
   - Threads: 50
2. Return discovered directories and files
3. Highlight sensitive paths (admin, backup, config)
4. Suggest follow-up enumeration

### Example 3: SQL Injection Testing

User request: "Test the login form at https://vulnerable-site.com/login.php for SQL injection"

The skill will:
1. Use `curl_request` to analyze the form
2. Use `sql_injection_test` with:
   - Target: https://vulnerable-site.com/login.php
   - Parameters: username, password
   - Level: 3 (aggressive)
   - Risk: 2 (medium risk)
3. Return injection points found
4. Extract database information
5. Provide exploitation guidance

### Example 4: Exploit Research

User request: "Find exploits for Apache 2.4.49 path traversal vulnerability"

The skill will:
1. Use `exploit_search` with:
   - Keywords: "Apache 2.4.49 path traversal"
   - Sources: ExploitDB, Metasploit
2. Return matching exploits:
   - CVE-2021-41773
   - ExploitDB ID
   - Metasploit module path
3. Provide exploitation instructions
4. Suggest payload modifications

### Example 5: Password Hash Cracking

User request: "Crack this MD5 hash: 5f4dcc3b5aa765d61d8327deb882cf99"

The skill will:
1. Identify hash type: MD5
2. Use `password_cracking` with:
   - Hash: 5f4dcc3b5aa765d61d8327deb882cf99
   - Tool: john
   - Wordlist: rockyou.txt
   - Format: raw-md5
3. Return cracked password: "password"
4. Show time taken and attempts

### Example 6: CTF Web Challenge

User request: "I'm solving a CTF challenge at http://ctf.stokedautomations.com:8080. The homepage has a login form. Help me enumerate and exploit it."

The skill will:
1. **Reconnaissance**:
   - Use `run_nmap_scan` to identify services
   - Use `curl_request` to analyze the login form
2. **Enumeration**:
   - Use `web_enumeration` to find hidden directories
   - Check for /admin, /backup, /config paths
3. **Vulnerability Testing**:
   - Use `sql_injection_test` on login parameters
   - Test for authentication bypass
4. **Exploitation**:
   - Execute SQL injection payload
   - Bypass authentication
   - Capture flag from authenticated page
5. **Documentation**:
   - Provide step-by-step solution
   - Explain vulnerability
   - Show final flag capture

### Example 7: Traffic Analysis

User request: "Capture HTTP traffic on interface eth0 and extract any credentials"

The skill will:
1. Use `network_sniffing` with:
   - Interface: eth0
   - Filter: "port 80 or port 8080"
   - Duration: 60 seconds
   - Output format: pcap
2. Analyze captured packets
3. Extract HTTP POST requests
4. Identify cleartext credentials
5. Generate summary report

## Workflow Integration

### Penetration Testing Workflow

```
1. Reconnaissance
   → Use run_nmap_scan for target discovery
   → Use web_enumeration for surface mapping

2. Vulnerability Assessment
   → Use vulnerability_scan for weakness identification
   → Use sql_injection_test for specific vulnerability testing

3. Exploitation
   → Use exploit_search to find relevant exploits
   → Use run_metasploit for exploitation
   → Use execute_command for custom exploit execution

4. Post-Exploitation
   → Use password_cracking for credential access
   → Use network_sniffing for lateral movement data
   → Document findings with atlassian-mcp (Jira)

5. Reporting
   → Compile evidence and screenshots
   → Generate executive summary
   → Provide remediation recommendations
```

### CTF Challenge Workflow

```
1. Initial Reconnaissance
   → Use run_nmap_scan to identify services
   → Use curl_request to analyze web applications

2. Enumeration
   → Use web_enumeration for hidden resources
   → Use execute_command for custom recon scripts

3. Vulnerability Discovery
   → Use sql_injection_test for database flaws
   → Use execute_command for custom exploit testing

4. Exploitation
   → Use appropriate tool based on vulnerability
   → Iterate with AI guidance

5. Flag Capture
   → Execute final exploitation steps
   → Retrieve flag
   → Document solution methodology
```

## Common Scan Types

The skill understands these common scan patterns:

| User Request | Executed Command | Purpose |
|--------------|------------------|---------|
| "Quick scan" | `nmap -T4 -F target` | Fast top 100 ports |
| "Full scan" | `nmap -p- target` | All 65535 ports |
| "Stealth scan" | `nmap -sS -T2 target` | Low and slow SYN scan |
| "Service scan" | `nmap -sV -sC target` | Version detection + scripts |
| "UDP scan" | `nmap -sU target` | UDP port discovery |
| "Aggressive scan" | `nmap -A target` | OS + version + scripts + traceroute |

## Security Tool Mapping

When users request specific actions, the skill maps to appropriate tools:

| User Intent | Kali Tool | MCP Function |
|-------------|-----------|--------------|
| "Scan network" | nmap | `run_nmap_scan` |
| "Enumerate directories" | gobuster | `web_enumeration` |
| "Test SQL injection" | sqlmap | `sql_injection_test` |
| "Search exploits" | searchsploit | `exploit_search` |
| "Crack password" | john/hashcat | `password_cracking` |
| "Capture traffic" | tcpdump | `network_sniffing` |
| "Scan web vulnerabilities" | nikto | `vulnerability_scan` |
| "Test with Metasploit" | msfconsole | `run_metasploit` |

## Error Handling

The skill gracefully handles common errors:

- **Connection timeout**: Suggests checking target connectivity and firewall rules
- **Command not found**: Verifies tool is installed in Kali container
- **Permission denied**: Explains privilege requirements (sudo, root)
- **Rate limiting**: Adjusts scan timing and thread count
- **Invalid target**: Validates IP addresses and domain names

## Best Practices

1. **Authorization First** - Always confirm you have permission to test targets
2. **Start Passive** - Begin with non-intrusive reconnaissance
3. **Controlled Scope** - Define clear boundaries for testing
4. **Document Everything** - Record commands, outputs, and findings
5. **Responsible Disclosure** - Follow ethical disclosure practices
6. **Legal Compliance** - Ensure all activities comply with laws
7. **Resource Awareness** - Monitor scan intensity to avoid service disruption
8. **Clean Up** - Remove test artifacts and temporary files

## Safety Features

The skill includes built-in safety mechanisms:

- **Timeout Limits**: Commands auto-terminate after MAX_TIMEOUT (default 300s)
- **Output Limits**: Prevents memory exhaustion with MAX_OUTPUT_SIZE
- **Sandbox Mode**: Isolated execution environment in Docker container
- **Audit Logging**: All commands logged for accountability
- **Rate Limiting**: Prevents accidental DoS conditions
- **Target Validation**: Warns about private IP ranges and sensitive networks

## Configuration Requirements

Requires these environment variables:

```bash
export MAX_TIMEOUT=300           # Maximum command timeout
export DEFAULT_TIMEOUT=60        # Default timeout for commands
export LOG_LEVEL=INFO            # Logging verbosity
export ENABLE_SANDBOX=true       # Enable sandboxed execution
export WORKING_DIRECTORY=/tmp/kali-mcp  # Command working directory
```

## Troubleshooting

**Issue: "Command execution timed out"**
- Increase MAX_TIMEOUT environment variable
- Check target is responsive
- Reduce scan intensity (fewer threads, slower timing)

**Issue: "Tool not found in container"**
- Verify Docker image has Kali tools installed
- Update container: `docker pull kalilinux/kali-rolling`
- Install missing tool: `apt-get install <tool-name>`

**Issue: "Connection refused to target"**
- Verify target IP/hostname is correct
- Check network connectivity
- Ensure target firewall allows your source IP

**Issue: "Permission denied"**
- Some tools require root privileges
- Run container with `--privileged` flag if needed
- Check file/directory permissions in container

## Related Skills

- **atlassian-mcp**: Document penetration test findings in Jira tickets
- **gitlab-mcp**: Version control security scripts and exploit code
- **serena**: Store engagement notes, methodologies, and procedures
- **git-jira-workflow**: Link security findings to remediation tickets

## Legal and Ethical Considerations

**IMPORTANT**: This skill is for authorized security testing only.

### Legal Requirements
- Obtain written authorization before testing
- Define clear scope and rules of engagement
- Comply with local computer crime laws
- Respect data privacy regulations

### Ethical Guidelines
- Only test systems you own or have permission to test
- Avoid causing service disruption or data loss
- Practice responsible disclosure for vulnerabilities
- Respect intellectual property and confidentiality
- Do not access, modify, or destroy data without authorization

### Prohibited Activities
- Unauthorized access to computer systems
- Denial of service attacks without authorization
- Data theft or exfiltration
- Malware deployment
- Credential harvesting from production systems

**Violation of these principles may result in criminal prosecution.**

---

**Skill Version**: 1.0.0
**MCP Server**: kali-server
**Last Updated**: 2025-10-18