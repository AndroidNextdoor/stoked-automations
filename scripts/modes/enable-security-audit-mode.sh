#!/usr/bin/env bash
set -e
BLUE='\033[0;34m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Enabling Security Audit Mode${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Detect RAM
if [[ "$OSTYPE" == "darwin"* ]]; then
    TOTAL_RAM_GB=$(($(sysctl -n hw.memsize) / 1024 / 1024 / 1024))
else
    TOTAL_RAM_GB=$(free -g | awk '/^Mem:/{print $2}')
fi

# Set token limits (high thinking for deep security analysis)
if [ "$TOTAL_RAM_GB" -ge 16 ]; then
    MAX_OUTPUT_TOKENS=24000
    MAX_THINKING_TOKENS=24000
elif [ "$TOTAL_RAM_GB" -ge 8 ]; then
    MAX_OUTPUT_TOKENS=20000
    MAX_THINKING_TOKENS=20000
else
    MAX_OUTPUT_TOKENS=16000
    MAX_THINKING_TOKENS=16000
fi

export CLAUDE_CODE_MAX_OUTPUT_TOKENS=$MAX_OUTPUT_TOKENS
export MAX_THINKING_TOKENS=$MAX_THINKING_TOKENS

echo -e "${GREEN}Security Audit Mode Configured${NC}"
echo -e "Output tokens: $MAX_OUTPUT_TOKENS | Thinking tokens: $MAX_THINKING_TOKENS"
echo ""
echo -e "${CYAN}Recommended plugins:${NC}"
echo "  /plugin install code-review-ai@stoked-automations"
echo "  Agents: security-auditor, backend-security-coder, frontend-security-coder"
echo ""
echo -e "${YELLOW}Use cases:${NC} Security reviews, vulnerability scanning, compliance audits"
echo -e "${BLUE}========================================${NC}"
