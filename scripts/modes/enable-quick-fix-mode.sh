#!/usr/bin/env bash
set -e
BLUE='\033[0;34m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Enabling Quick Fix Mode${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

if [[ "$OSTYPE" == "darwin"* ]]; then
    TOTAL_RAM_GB=$(($(sysctl -n hw.memsize) / 1024 / 1024 / 1024))
else
    TOTAL_RAM_GB=$(free -g | awk '/^Mem:/{print $2}')
fi

# Conservative token limits for fast fixes
MAX_OUTPUT_TOKENS=16000
MAX_THINKING_TOKENS=12000

export CLAUDE_CODE_MAX_OUTPUT_TOKENS=$MAX_OUTPUT_TOKENS
export MAX_THINKING_TOKENS=$MAX_THINKING_TOKENS

echo -e "${GREEN}Quick Fix Mode Configured${NC}"
echo -e "Output tokens: $MAX_OUTPUT_TOKENS | Thinking tokens: $MAX_THINKING_TOKENS"
echo ""
echo -e "${CYAN}Recommended plugins:${NC}"
echo "  /plugin install code-review-ai@stoked-automations"
echo "  Agents: debugger, error-detective, code-reviewer"
echo ""
echo -e "${YELLOW}Use cases:${NC} Hot fixes, debugging, small patches, quick bug resolution"
echo -e "${BLUE}========================================${NC}"
