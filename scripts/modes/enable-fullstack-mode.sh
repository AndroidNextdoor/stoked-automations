#!/usr/bin/env bash
set -e
BLUE='\033[0;34m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Enabling Full-Stack Development Mode${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

if [[ "$OSTYPE" == "darwin"* ]]; then
    TOTAL_RAM_GB=$(($(sysctl -n hw.memsize) / 1024 / 1024 / 1024))
else
    TOTAL_RAM_GB=$(free -g | awk '/^Mem:/{print $2}')
fi

if [ "$TOTAL_RAM_GB" -ge 32 ]; then
    MAX_OUTPUT_TOKENS=64000
    MAX_THINKING_TOKENS=32000
elif [ "$TOTAL_RAM_GB" -ge 16 ]; then
    MAX_OUTPUT_TOKENS=48000
    MAX_THINKING_TOKENS=24000
else
    MAX_OUTPUT_TOKENS=32000
    MAX_THINKING_TOKENS=16000
fi

export CLAUDE_CODE_MAX_OUTPUT_TOKENS=$MAX_OUTPUT_TOKENS
export MAX_THINKING_TOKENS=$MAX_THINKING_TOKENS

echo -e "${GREEN}Full-Stack Mode Configured${NC}"
echo -e "Output tokens: $MAX_OUTPUT_TOKENS | Thinking tokens: $MAX_THINKING_TOKENS"
echo ""
echo -e "${CYAN}Recommended plugins:${NC}"
echo "  /plugin install code-review-ai@stoked-automations"
echo "  Agents: frontend-developer, backend-architect, database-architect,"
echo "          api-documenter, test-automator"
echo ""
echo -e "${YELLOW}Use cases:${NC} Building complete applications from scratch, full-stack features"
echo -e "${BLUE}========================================${NC}"
