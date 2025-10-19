#!/usr/bin/env bash

#####################################################################
# Enable PR Review Mode - Stoked Automations
#
# This script optimizes Claude Code for PR review by configuring
# token limits and providing instructions for enabling PR review plugins.
#
# Prerequisites:
# - Claude Code installed and configured
# - stoked-automations marketplace added
#
# What this script does:
# - Configures token limits for deep code analysis
# - Provides instructions for installing PR review plugins via slash commands
#
# Note: Plugin management requires interactive slash commands inside
#       Claude Code sessions. This script provides instructions but
#       cannot directly install or enable plugins.
#
# Usage:
#   scripts/modes/enable-pr-review-mode.sh
#
# After running, follow the on-screen instructions to install plugins
# using slash commands inside Claude Code.
#
#####################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Enabling PR Review Mode${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to print section headers
print_section() {
    echo -e "\n${BLUE}>>> $1${NC}"
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print warning messages
print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Function to print error messages
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Function to print info messages
print_info() {
    echo -e "${CYAN}ℹ $1${NC}"
}

# Function to detect system resources and set optimal token limits
configure_token_limits() {
    print_section "Configuring Token Limits Based on System Resources"

    # Detect system RAM (in GB)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        TOTAL_RAM_BYTES=$(sysctl -n hw.memsize)
        TOTAL_RAM_GB=$((TOTAL_RAM_BYTES / 1024 / 1024 / 1024))
        CPU_CORES=$(sysctl -n hw.ncpu)
    else
        # Linux
        TOTAL_RAM_GB=$(free -g | awk '/^Mem:/{print $2}')
        CPU_CORES=$(nproc)
    fi

    print_info "System RAM: ${TOTAL_RAM_GB}GB"
    print_info "CPU Cores: ${CPU_CORES}"

    # PR review mode token configuration
    # - Lower output (concise review comments)
    # - Higher thinking (deep code analysis)
    # - Emphasis on analytical depth over verbosity

    if [ "$TOTAL_RAM_GB" -ge 16 ]; then
        # High-end system
        MAX_OUTPUT_TOKENS=20000
        MAX_THINKING_TOKENS=20000
        print_success "High-performance configuration (16GB+ RAM)"
    elif [ "$TOTAL_RAM_GB" -ge 8 ]; then
        # Mid-range system
        MAX_OUTPUT_TOKENS=10000
        MAX_THINKING_TOKENS=8000
        print_success "Balanced configuration (8-16GB RAM)"
    else
        # Lower-end system
        MAX_OUTPUT_TOKENS=6000
        MAX_THINKING_TOKENS=5000
        print_warning "Conservative configuration (<8GB RAM)"
    fi

    # Export environment variables for Claude Code
    export CLAUDE_CODE_MAX_OUTPUT_TOKENS=$MAX_OUTPUT_TOKENS
    export MAX_THINKING_TOKENS=$MAX_THINKING_TOKENS

    print_info "Max Output Tokens: $MAX_OUTPUT_TOKENS"
    print_info "Max Thinking Tokens: $MAX_THINKING_TOKENS"

    echo ""
    echo "Token limits optimized for:"
    echo "  • Deep code analysis (higher thinking)"
    echo "  • Concise review comments (lower output)"
    echo "  • Security vulnerability detection"
    echo "  • Code quality assessment"
}

# Configure token limits based on system resources
configure_token_limits

print_section "PR Review Toolkit Plugins Setup Instructions"

echo ""
print_warning "⚠️  IMPORTANT: Plugin management requires interactive slash commands"
echo ""
echo "This script cannot directly install or enable plugins. Plugins must be"
echo "managed from INSIDE a Claude Code interactive session using slash commands."
echo ""
echo -e "${BLUE}To install PR Review Toolkit plugins:${NC}"
echo ""
echo "1. Start Claude Code in interactive mode:"
echo -e "   ${CYAN}claude${NC}"
echo ""
echo "2. Add marketplaces (if not already added):"
echo -e "   ${CYAN}/plugin marketplace add AndroidNextdoor/stoked-automations${NC}"
echo -e "   ${CYAN}/plugin marketplace add wshobson/agents${NC}"
echo ""
echo "3. Install plugins you want (inside Claude Code session):"
echo ""
echo -e "   ${GREEN}Stoked Automations - Core PR Review Agents:${NC}"
echo -e "   ${CYAN}/plugin install code-review-ai@stoked-automations${NC}"
echo ""
echo "   Available code-review-ai agents:"
echo "   • code-reviewer           - Elite code review with security scanning"
echo "   • architect-review        - Architecture patterns and design review"
echo "   • security-auditor        - Comprehensive security and compliance"
echo "   • performance-engineer    - Performance optimization and observability"
echo "   • debugger                - Error analysis and troubleshooting"
echo ""
echo -e "   ${GREEN}Seth Hobson's Production-Ready Agents (wshobson/agents):${NC}"
echo -e "   ${CYAN}/plugin install code-review-ai@wshobson${NC}"
echo ""
echo "   Features:"
echo "   • 85+ specialized AI agents with proactive activation"
echo "   • Elite code review expert with modern AI-powered analysis"
echo "   • Security vulnerability detection (2024/2025 best practices)"
echo "   • Production reliability and performance optimization"
echo "   • Integration with Trag, Bito, Codiga, GitHub Copilot"
echo "   • Minimal token usage with granular plugin architecture"
echo ""
echo "4. Enable installed plugins (inside Claude Code session):"
echo -e "   ${CYAN}/plugin enable code-review-ai@stoked-automations${NC}"
echo -e "   ${CYAN}/plugin enable code-review-ai@wshobson${NC}"
echo ""
echo "5. List installed plugins to verify:"
echo -e "   ${CYAN}/plugin list${NC}"
echo ""
echo "6. Run ${CYAN}/context${NC} to determine which agents may need to be disabled."
print_info "For more details, see the Claude Code Command Reference in CLAUDE.md"
echo ""

# Summary
print_section "PR Review Mode Configuration Complete"
echo ""
echo -e "${YELLOW}Optimizations applied:${NC}"
echo "  • Token limits optimized for code analysis"
echo "  • Output tokens: $MAX_OUTPUT_TOKENS (concise reviews)"
echo "  • Thinking tokens: $MAX_THINKING_TOKENS (deep analysis)"
echo ""
echo -e "${GREEN}Available PR Review Agents:${NC}"
echo ""
echo "Stoked Automations (code-review-ai@stoked-automations):"
echo "  • code-reviewer         - Elite code review expert"
echo "  • architect-review      - Architecture review specialist"
echo "  • security-auditor      - Security and compliance expert"
echo "  • performance-engineer  - Performance optimization expert"
echo "  • debugger              - Error analysis specialist"
echo ""
echo "Seth Hobson's Agents (code-review-ai@wshobson):"
echo "  • 85+ specialized AI agents with proactive activation"
echo "  • Elite code review with modern AI-powered analysis"
echo "  • Security vulnerability detection (2024/2025 best practices)"
echo "  • Production reliability and performance optimization"
echo ""
echo -e "${CYAN}Using PR Review Agents:${NC}"
echo ""
echo "Both agent collections are proactive - they run automatically when:"
echo "  • You complete a coding task (code-reviewer)"
echo "  • You make architectural decisions (architect-review)"
echo "  • You write security-sensitive code (security-auditor)"
echo "  • You encounter performance issues (performance-engineer)"
echo "  • You debug errors (debugger)"
echo ""
echo -e "${YELLOW}Usage examples for PR review:${NC}"
echo "  'I've completed the authentication feature. Can you review it?'"
echo "  'Review this pull request for code quality issues'"
echo "  'Check for security vulnerabilities in this code'"
echo "  'Analyze the performance of this implementation'"
echo "  'Find potential error handling issues'"
echo "  'Review the architecture design for the UserAccount module'"
echo ""
echo "To switch modes:"
echo "  scripts/modes/enable-testing-mode.sh        - Enable browser testing tools"
echo "  scripts/modes/enable-documentation-mode.sh  - Enable documentation tools"
echo ""
echo -e "${BLUE}========================================${NC}"
echo "Ready for PR review! Start Claude Code with: ${CYAN}claude${NC}"
echo -e "${BLUE}========================================${NC}"