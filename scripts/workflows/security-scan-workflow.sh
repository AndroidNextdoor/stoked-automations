#!/usr/bin/env bash
# Automated security scanning workflow with Serena memory integration
# Runs comprehensive security scans and stores results for future context
# Author: Andrew Nixdorf <andrew@stokedautomation.com>

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${ORANGE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${ORANGE}║  Security Scan Workflow with Serena Integration           ║${NC}"
echo -e "${ORANGE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Parse arguments
TARGET="${1:-localhost:4321}"
SCAN_TYPE="${2:-full}"

echo -e "${BLUE}Target:${NC} $TARGET"
echo -e "${BLUE}Scan Type:${NC} $SCAN_TYPE"
echo ""

# Load previous security context from Serena
echo -e "${ORANGE}[1/5] Loading historical security context...${NC}"
"${SCRIPT_DIR}/../serena/search-context.sh" "security vulnerabilities $TARGET" 5 "security_findings" > /tmp/security-context.txt 2>&1
echo -e "${GREEN}✓ Context loaded${NC}"
echo ""

# Run network reconnaissance
echo -e "${ORANGE}[2/5] Running network reconnaissance (nmap)...${NC}"
if command -v nmap &> /dev/null; then
  NMAP_RESULTS=$(nmap -sV -T4 "$TARGET" 2>&1 || echo "Nmap scan failed")
  echo "$NMAP_RESULTS" > /tmp/nmap-results.txt
  echo -e "${GREEN}✓ Network scan complete${NC}"

  # Store nmap results in Serena
  OPEN_PORTS=$(echo "$NMAP_RESULTS" | grep -E "^[0-9]+/tcp" | wc -l || echo "0")
  "${SCRIPT_DIR}/../serena/create-memory.sh" \
    "Nmap scan of $TARGET found $OPEN_PORTS open ports. Results: $NMAP_RESULTS" \
    "security,nmap,network,ports,scan" \
    "security_findings" > /dev/null 2>&1
else
  echo -e "${RED}⚠ nmap not installed - skipping network scan${NC}"
  echo "Install: brew install nmap (macOS) or apt-get install nmap (Linux)"
fi
echo ""

# Check for common web vulnerabilities
echo -e "${ORANGE}[3/5] Checking web application security...${NC}"

# Check HTTPS configuration
if [[ "$TARGET" =~ ^https:// ]]; then
  echo -e "${BLUE}  → Checking SSL/TLS configuration...${NC}"
  SSL_CHECK=$(curl -vI "$TARGET" 2>&1 | grep -E "SSL|TLS" || echo "SSL check failed")
  echo "$SSL_CHECK" > /tmp/ssl-check.txt
  echo -e "${GREEN}  ✓ SSL/TLS check complete${NC}"
else
  echo -e "${RED}  ⚠ Target not using HTTPS - security risk${NC}"
  "${SCRIPT_DIR}/../serena/create-memory.sh" \
    "Security risk: $TARGET not using HTTPS" \
    "security,https,ssl,risk,vulnerability" \
    "security_findings" > /dev/null 2>&1
fi

# Check security headers
echo -e "${BLUE}  → Checking security headers...${NC}"
SECURITY_HEADERS=$(curl -I "$TARGET" 2>&1 | grep -iE "X-Frame-Options|X-Content-Type-Options|Content-Security-Policy|Strict-Transport-Security" || echo "No security headers found")
echo "$SECURITY_HEADERS" > /tmp/security-headers.txt

MISSING_HEADERS=()
[[ ! "$SECURITY_HEADERS" =~ "X-Frame-Options" ]] && MISSING_HEADERS+=("X-Frame-Options")
[[ ! "$SECURITY_HEADERS" =~ "X-Content-Type-Options" ]] && MISSING_HEADERS+=("X-Content-Type-Options")
[[ ! "$SECURITY_HEADERS" =~ "Content-Security-Policy" ]] && MISSING_HEADERS+=("Content-Security-Policy")
[[ ! "$SECURITY_HEADERS" =~ "Strict-Transport-Security" ]] && MISSING_HEADERS+=("Strict-Transport-Security")

if [[ ${#MISSING_HEADERS[@]} -gt 0 ]]; then
  echo -e "${RED}  ⚠ Missing security headers: ${MISSING_HEADERS[*]}${NC}"
  "${SCRIPT_DIR}/../serena/create-memory.sh" \
    "Security headers missing on $TARGET: ${MISSING_HEADERS[*]}" \
    "security,headers,vulnerability,web" \
    "security_findings" > /dev/null 2>&1
else
  echo -e "${GREEN}  ✓ All security headers present${NC}"
fi
echo ""

# Static code analysis
echo -e "${ORANGE}[4/5] Running static code analysis...${NC}"

# Check for hardcoded secrets
echo -e "${BLUE}  → Scanning for hardcoded secrets...${NC}"
SECRET_PATTERNS=(
  "password\s*=\s*['\"][^'\"]{8,}"
  "api[_-]?key\s*=\s*['\"][^'\"]{20,}"
  "secret\s*=\s*['\"][^'\"]{16,}"
  "token\s*=\s*['\"][^'\"]{20,}"
)

SECRETS_FOUND=0
for pattern in "${SECRET_PATTERNS[@]}"; do
  MATCHES=$(grep -rE "$pattern" "$REPO_ROOT" --exclude-dir={node_modules,.git,dist,build} 2>/dev/null | wc -l || echo "0")
  SECRETS_FOUND=$((SECRETS_FOUND + MATCHES))
done

if [[ $SECRETS_FOUND -gt 0 ]]; then
  echo -e "${RED}  ⚠ Found $SECRETS_FOUND potential hardcoded secrets${NC}"
  "${SCRIPT_DIR}/../serena/create-memory.sh" \
    "CRITICAL: Found $SECRETS_FOUND potential hardcoded secrets in codebase" \
    "security,secrets,credentials,critical,vulnerability" \
    "security_findings" > /dev/null 2>&1
else
  echo -e "${GREEN}  ✓ No hardcoded secrets detected${NC}"
fi

# Check for SQL injection patterns
echo -e "${BLUE}  → Scanning for SQL injection vulnerabilities...${NC}"
SQL_PATTERNS=(
  "execute\(.*\+.*\)"
  "query\(.*\+.*\)"
  "WHERE.*\+.*"
)

SQL_ISSUES=0
for pattern in "${SQL_PATTERNS[@]}"; do
  MATCHES=$(grep -rE "$pattern" "$REPO_ROOT" --include="*.{ts,js,py}" --exclude-dir={node_modules,.git,dist,build} 2>/dev/null | wc -l || echo "0")
  SQL_ISSUES=$((SQL_ISSUES + MATCHES))
done

if [[ $SQL_ISSUES -gt 0 ]]; then
  echo -e "${RED}  ⚠ Found $SQL_ISSUES potential SQL injection points${NC}"
  "${SCRIPT_DIR}/../serena/create-memory.sh" \
    "Found $SQL_ISSUES potential SQL injection vulnerabilities - review string concatenation in queries" \
    "security,sql-injection,vulnerability,database" \
    "security_findings" > /dev/null 2>&1
else
  echo -e "${GREEN}  ✓ No SQL injection patterns detected${NC}"
fi
echo ""

# Generate security report
echo -e "${ORANGE}[5/5] Generating security report...${NC}"

REPORT_FILE="/tmp/security-scan-report-$(date +%Y%m%d-%H%M%S).txt"
cat > "$REPORT_FILE" <<EOF
╔════════════════════════════════════════════════════════════╗
║            Security Scan Report                            ║
╚════════════════════════════════════════════════════════════╝

Target: $TARGET
Scan Type: $SCAN_TYPE
Timestamp: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
Repository: AndroidNextdoor/stoked-automations

════════════════════════════════════════════════════════════

NETWORK RECONNAISSANCE
$(cat /tmp/nmap-results.txt 2>/dev/null || echo "Nmap not available")

════════════════════════════════════════════════════════════

SECURITY HEADERS
$(cat /tmp/security-headers.txt 2>/dev/null || echo "No headers checked")

Missing Headers: ${MISSING_HEADERS[*]:-None}

════════════════════════════════════════════════════════════

STATIC CODE ANALYSIS

Hardcoded Secrets: $SECRETS_FOUND potential issues
SQL Injection Patterns: $SQL_ISSUES potential issues

════════════════════════════════════════════════════════════

RECOMMENDATIONS

EOF

# Add recommendations based on findings
if [[ ${#MISSING_HEADERS[@]} -gt 0 ]]; then
  cat >> "$REPORT_FILE" <<EOF
1. Add missing security headers to web server configuration:
   - X-Frame-Options: DENY
   - X-Content-Type-Options: nosniff
   - Content-Security-Policy: default-src 'self'
   - Strict-Transport-Security: max-age=31536000

EOF
fi

if [[ $SECRETS_FOUND -gt 0 ]]; then
  cat >> "$REPORT_FILE" <<EOF
2. Remove hardcoded secrets:
   - Use environment variables for sensitive data
   - Implement secrets management (e.g., AWS Secrets Manager)
   - Rotate any exposed credentials immediately

EOF
fi

if [[ $SQL_ISSUES -gt 0 ]]; then
  cat >> "$REPORT_FILE" <<EOF
3. Fix SQL injection vulnerabilities:
   - Use parameterized queries or prepared statements
   - Never concatenate user input directly into SQL
   - Implement input validation and sanitization

EOF
fi

cat >> "$REPORT_FILE" <<EOF
════════════════════════════════════════════════════════════

Next Steps:
1. Review findings in detail
2. Prioritize critical vulnerabilities (secrets, SQL injection)
3. Implement recommended security controls
4. Re-run scan to verify fixes
5. Store remediation actions in Serena for tracking

════════════════════════════════════════════════════════════

Report saved to: $REPORT_FILE
EOF

echo -e "${GREEN}✓ Security report generated${NC}"
echo ""

# Display report
cat "$REPORT_FILE"

# Store complete report in Serena
"${SCRIPT_DIR}/../serena/create-memory.sh" \
  "Security scan of $TARGET completed. Secrets: $SECRETS_FOUND, SQL issues: $SQL_ISSUES, Missing headers: ${#MISSING_HEADERS[@]}. Full report: $REPORT_FILE" \
  "security,scan,report,vulnerability-assessment" \
  "security_findings" > /dev/null 2>&1

echo ""
echo -e "${ORANGE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Security scan complete!${NC}"
echo -e "${BLUE}Report:${NC} $REPORT_FILE"
echo -e "${BLUE}Findings stored in Serena for future reference${NC}"
echo -e "${ORANGE}════════════════════════════════════════════════════════════${NC}"