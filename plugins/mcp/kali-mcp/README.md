# Kali Linux MCP Server

Kali Linux security tools integration via MCP (Model Context Protocol) - execute penetration testing commands, automate reconnaissance, run vulnerability scans, and solve CTF challenges with AI assistance directly from Claude Code.

## Overview

This MCP server provides seamless integration with Kali Linux's extensive suite of security and penetration testing tools, enabling you to:

- **Command Execution**: Run any Kali Linux security tool via AI-assisted command generation
- **Network Reconnaissance**: Automated nmap scans, port discovery, and service enumeration
- **Web Application Testing**: Directory enumeration, vulnerability scanning, and exploitation
- **CTF Challenges**: Real-time assistance solving Capture The Flag challenges
- **Exploit Research**: Search and execute exploits from ExploitDB and Metasploit
- **Password Cracking**: Leverage John the Ripper and Hashcat for credential attacks
- **Traffic Analysis**: Capture and analyze network traffic with tcpdump and Wireshark

## Features

- Lightweight API bridge connecting MCP clients to Kali Linux terminal
- Docker containerized deployment for isolated security testing
- Controlled command execution with timeout and output size limits
- Support for 600+ Kali Linux security tools
- AI-guided penetration testing workflows
- Real-time web application interaction (curl, wget, Burp Suite)
- Automated reconnaissance and exploitation assistance

## Prerequisites

Before using this plugin, you need:

1. **Docker Desktop** (recommended for containerized deployment)
   ```bash
   # Verify Docker is installed and running
   docker --version
   docker ps
   ```

   OR

   **Kali Linux Environment** (for local deployment)
   ```bash
   # Running on Kali Linux with Python 3
   python3 --version
   ```

2. **Kali Linux Security Tools**

   If using Docker, tools are pre-installed in the container.

   For local deployment, ensure you have:
   - nmap (network scanning)
   - gobuster, dirb, ffuf (directory enumeration)
   - metasploit-framework (exploitation)
   - sqlmap (SQL injection testing)
   - john, hashcat (password cracking)
   - nikto, openvas (vulnerability scanning)
   - tcpdump, wireshark (traffic analysis)
   - curl, wget (web requests)

3. **Environment Variables** (optional)

   Add these to your shell profile (`~/.zshrc` or `~/.bashrc`):

   ```bash
   # Kali MCP Configuration
   export MAX_TIMEOUT=300          # Maximum command timeout (seconds)
   export DEFAULT_TIMEOUT=60       # Default timeout for commands
   export LOG_LEVEL=INFO           # Logging level (DEBUG, INFO, WARNING, ERROR)

   # For remote API deployment:
   export KALI_API_URL="http://your-kali-server:5000"
   export KALI_API_TOKEN="your-api-token"  # If authentication enabled
   ```

   Then reload your shell:
   ```bash
   source ~/.zshrc  # or ~/.bashrc
   ```

## Installation

### Step 1: Add Stoked Automations Marketplace

```bash
/plugin marketplace add AndroidNextdoor/stoked-automations
```

### Step 2: Install Plugin

```bash
/plugin install kali-mcp@stoked-automations
```

### Step 3: Build/Pull Docker Image

**Option A: Using pre-built image (if available)**
```bash
docker pull kali-mcp-server:latest
```

**Option B: Build from source**
```bash
git clone https://github.com/Wh0am123/MCP-Kali-Server.git
cd MCP-Kali-Server
docker build -t kali-mcp-server .
```

**Option C: Local deployment without Docker**
```bash
git clone https://github.com/Wh0am123/MCP-Kali-Server.git
cd MCP-Kali-Server
python3 -m pip install -r requirements.txt
python3 kali_server.py
```

### Step 4: Restart Claude Code

Completely exit and restart Claude Code for the MCP server to activate.

### Step 5: Verify Installation

```bash
# Check that MCP tools are available
/mcp list

# You should see:
# - mcp__kali-server__execute_command
# - mcp__kali-server__run_nmap_scan
# - mcp__kali-server__web_enumeration
# - mcp__kali-server__exploit_search
# - mcp__kali-server__curl_request
# - mcp__kali-server__run_metasploit
# - mcp__kali-server__sql_injection_test
# - mcp__kali-server__password_cracking
# - mcp__kali-server__network_sniffing
# - mcp__kali-server__vulnerability_scan
```

## Usage

### Network Reconnaissance

```
Scan target 192.168.1.100 for open ports and services
```

Returns:
- Open ports (TCP/UDP)
- Service versions
- Operating system detection
- Potential vulnerabilities

### Web Directory Enumeration

```
Enumerate directories on https://target-website.com using gobuster
```

Returns:
- Discovered directories
- Hidden files and paths
- Status codes
- Content lengths

### Exploit Search

```
Search for exploits related to Apache 2.4.49
```

Returns:
- ExploitDB entries
- Metasploit modules
- Exploit descriptions
- CVE references

### SQL Injection Testing

```
Test https://target.com/login for SQL injection vulnerabilities
```

Returns:
- Vulnerable parameters
- Database type detection
- Extraction strategies
- Proof of concept payloads

### Password Cracking

```
Crack the following hash using John the Ripper: $6$salt$hash...
```

Returns:
- Cracked password
- Hash algorithm detected
- Time taken
- Wordlist used

### CTF Challenge Solving

```
I'm solving a CTF web challenge at http://ctf-target:8080
The page has a login form. Help me enumerate and exploit it.
```

The AI will:
- Analyze the target
- Suggest reconnaissance steps
- Execute appropriate tools (nmap, gobuster, curl)
- Identify vulnerabilities
- Provide exploitation guidance
- Capture flags

### Traffic Analysis

```
Capture HTTP traffic on interface eth0 for 60 seconds
```

Returns:
- Packet captures
- Protocol analysis
- Extracted credentials
- Traffic statistics

## Available MCP Tools

| Tool | Description |
|------|-------------|
| `execute_command` | Execute any Kali Linux command or security tool |
| `run_nmap_scan` | Network scanning and reconnaissance with Nmap |
| `web_enumeration` | Directory and file enumeration (gobuster, dirb, ffuf) |
| `exploit_search` | Search ExploitDB and Metasploit for exploits |
| `curl_request` | Make HTTP/HTTPS requests to web applications |
| `run_metasploit` | Execute Metasploit Framework commands |
| `sql_injection_test` | Test for SQL injection with sqlmap |
| `password_cracking` | Crack passwords with John the Ripper or Hashcat |
| `network_sniffing` | Capture network traffic with tcpdump/Wireshark |
| `vulnerability_scan` | Scan for vulnerabilities with Nikto, OpenVAS |

## Configuration

The MCP server is configured via `~/.config/claude/config.json` (automatically managed by the plugin):

```json
{
  "mcpServers": {
    "kali-server": {
      "command": "docker",
      "args": [
        "run", "--rm", "-i",
        "-e", "MAX_TIMEOUT",
        "-e", "DEFAULT_TIMEOUT",
        "-e", "LOG_LEVEL",
        "-p", "5000:5000",
        "-p", "8000:8000",
        "kali-mcp-server"
      ],
      "env": {
        "MAX_TIMEOUT": "300",
        "DEFAULT_TIMEOUT": "60",
        "LOG_LEVEL": "INFO"
      }
    }
  }
}
```

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `MAX_TIMEOUT` | 300 | Maximum command execution timeout (seconds) |
| `DEFAULT_TIMEOUT` | 60 | Default timeout for commands |
| `MAX_OUTPUT_SIZE` | 1048576 | Maximum output size (bytes) |
| `LOG_LEVEL` | INFO | Logging level (DEBUG, INFO, WARNING, ERROR) |
| `ENABLE_SANDBOX` | true | Enable sandboxed command execution |
| `WORKING_DIRECTORY` | /tmp/kali-mcp | Working directory for command execution |

## Troubleshooting

### "Connection refused" Error

- Ensure Docker container is running: `docker ps | grep kali-mcp`
- Check ports are mapped correctly: `-p 5000:5000 -p 8000:8000`
- Verify firewall allows connections to ports 5000 and 8000

### "Command timeout" Error

- Increase MAX_TIMEOUT environment variable
- Check command is valid and executable
- Verify target is reachable (network connectivity)

### "Docker not running" Error

- Start Docker Desktop
- Verify with: `docker ps`
- Rebuild image if needed: `docker build -t kali-mcp-server .`

### MCP Tools Not Appearing

- Restart Claude Code completely (not just reload)
- Check config.json syntax: `jq . ~/.config/claude/config.json`
- Verify Docker image exists: `docker images | grep kali-mcp`

### Tool Not Found in Container

- Ensure Kali Linux tools are installed in container
- Update container: `docker pull kalilinux/kali-rolling`
- Install missing tool: `docker exec -it <container> apt-get install <tool>`

## Security Best Practices

1. **Controlled Environment** - Always run in isolated Docker containers
2. **Target Authorization** - Only scan/test systems you have permission to access
3. **Rate Limiting** - Respect timeout limits to avoid resource exhaustion
4. **Logging** - Monitor command execution logs for suspicious activity
5. **Access Control** - Use API tokens for remote deployments
6. **Network Isolation** - Run on separate network segments for testing
7. **Legal Compliance** - Ensure all testing complies with local laws and regulations

## Common Workflows

### Workflow 1: Web Application Penetration Test

```
1. Reconnaissance
   → Run nmap scan to discover services
   → Enumerate web directories with gobuster

2. Vulnerability Assessment
   → Test for SQL injection with sqlmap
   → Check for XSS vulnerabilities
   → Scan with Nikto for common issues

3. Exploitation
   → Search for exploits with searchsploit
   → Execute with Metasploit if available

4. Post-Exploitation
   → Capture credentials
   → Escalate privileges
   → Document findings
```

### Workflow 2: CTF Challenge Solving

```
1. Initial Reconnaissance
   → Port scan with nmap
   → Service enumeration

2. Web Enumeration
   → Directory brute-forcing
   → Source code analysis
   → Hidden parameter discovery

3. Vulnerability Exploitation
   → SQL injection testing
   → Command injection attempts
   → File inclusion testing

4. Flag Capture
   → Execute exploitation
   → Retrieve flag
   → Document solution path
```

### Workflow 3: Network Security Assessment

```
1. Discovery
   → Network sweep with nmap
   → Identify live hosts

2. Service Analysis
   → Version detection
   → Vulnerability correlation

3. Vulnerability Validation
   → Test with exploit modules
   → Verify patches/mitigations

4. Reporting
   → Document findings
   → Prioritize risks
   → Recommend remediation
```

## Examples

### Example 1: Basic Nmap Scan

```
User: "Scan 10.10.10.5 for all TCP ports"
→ Executes: nmap -p- -sV -sC 10.10.10.5
→ Returns: Open ports, services, versions, OS detection
```

### Example 2: Web Directory Discovery

```
User: "Find hidden directories on https://example.com"
→ Executes: gobuster dir -u https://example.com -w /usr/share/wordlists/dirb/common.txt
→ Returns: Discovered paths, status codes, sizes
```

### Example 3: SQL Injection Test

```
User: "Test the id parameter at https://vulnerable-site.com/user?id=1"
→ Executes: sqlmap -u "https://vulnerable-site.com/user?id=1" --batch --dbs
→ Returns: Vulnerability status, databases found, exploitation details
```

### Example 4: Exploit Search

```
User: "Find exploits for WordPress 5.8.0"
→ Executes: searchsploit wordpress 5.8.0
→ Returns: Available exploits, ExploitDB IDs, descriptions
```

### Example 5: Password Hash Cracking

```
User: "Crack this hash: 5f4dcc3b5aa765d61d8327deb882cf99"
→ Executes: john --format=raw-md5 --wordlist=/usr/share/wordlists/rockyou.txt hash.txt
→ Returns: Cracked password: "password"
```

## Supported Kali Linux Tools

### Network Analysis
- nmap, masscan, unicornscan
- netdiscover, arp-scan
- wireshark, tcpdump, tshark

### Web Application Testing
- gobuster, dirb, ffuf, wfuzz
- burpsuite, zaproxy
- nikto, wpscan, joomscan

### Exploitation
- metasploit-framework
- sqlmap
- commix
- beef-xss

### Password Attacks
- john (John the Ripper)
- hashcat
- hydra, medusa
- crunch, cewl

### Wireless
- aircrack-ng
- reaver
- wifite

### Forensics
- autopsy
- binwalk
- foremost
- volatility

## Related Plugins

- **atlassian-mcp** - Document findings in Jira tickets
- **gitlab-mcp** - Version control security scripts and reports
- **serena** - Store engagement notes and testing procedures

## Resources

- **MCP-Kali-Server GitHub**: https://github.com/Wh0am123/MCP-Kali-Server
- **Kali Linux Documentation**: https://www.kali.org/docs/
- **Kali Tools List**: https://www.kali.org/tools/
- **MCP Protocol**: https://modelcontextprotocol.io/
- **OWASP Testing Guide**: https://owasp.org/www-project-web-security-testing-guide/

## License

MIT License - see [LICENSE](./LICENSE) for details

## Author

**Wh0am123**
- GitHub: https://github.com/Wh0am123
- Repository: https://github.com/Wh0am123/MCP-Kali-Server

## Disclaimer

This tool is intended for authorized security testing and educational purposes only. Always obtain proper authorization before testing systems you don't own. Unauthorized access to computer systems is illegal. The authors and contributors are not responsible for misuse or damage caused by this tool.

---

**Plugin Version**: 1.0.0
**Category**: security
**Last Updated**: 2025-10-18