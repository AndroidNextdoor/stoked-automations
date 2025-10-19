#!/usr/bin/env bash

#####################################################################
# Enable Testing Mode - Stoked Automations
#
# This script optimizes Claude Code for comprehensive testing workflows
# including TDD, test automation, and QA processes.
#
# Prerequisites:
# - Claude Code installed and configured
# - stoked-automations marketplace added
#
# What this mode does:
# - Configures balanced token limits for test development
# - Provides instructions for installing testing-focused plugins
# - Optimizes for writing tests, test automation, and QA workflows
#
# Usage:
#   scripts/modes/enable-testing-mode.sh
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
echo -e "${BLUE}Enabling Testing Mode${NC}"
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

# Function to print info messages
print_info() {
    echo -e "${CYAN}ℹ $1${NC}"
}

# Function to detect system resources and set optimal token limits
configure_token_limits() {
    print_section "Configuring Token Limits for Testing Mode"

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

    # Testing mode token configuration
    # - Balanced output for test code and assertions
    # - Moderate thinking for test strategy
    # - Optimized for TDD workflow

    if [ "$TOTAL_RAM_GB" -ge 16 ]; then
        # High-end system
        MAX_OUTPUT_TOKENS=32000
        MAX_THINKING_TOKENS=16000
        print_success "High-performance configuration (16GB+ RAM)"
    elif [ "$TOTAL_RAM_GB" -ge 8 ]; then
        # Mid-range system
        MAX_OUTPUT_TOKENS=24000
        MAX_THINKING_TOKENS=12000
        print_success "Balanced configuration (8-16GB RAM)"
    else
        # Lower-end system
        MAX_OUTPUT_TOKENS=16000
        MAX_THINKING_TOKENS=10000
        print_warning "Conservative configuration (<8GB RAM)"
    fi

    # Export environment variables for Claude Code
    export CLAUDE_CODE_MAX_OUTPUT_TOKENS=$MAX_OUTPUT_TOKENS
    export MAX_THINKING_TOKENS=$MAX_THINKING_TOKENS

    print_info "Max Output Tokens: $MAX_OUTPUT_TOKENS"
    print_info "Max Thinking Tokens: $MAX_THINKING_TOKENS"

    echo ""
    echo "Token limits optimized for:"
    echo "  • Test-Driven Development (TDD)"
    echo "  • Test automation and frameworks"
    echo "  • Quality assurance workflows"
    echo "  • Unit, integration, and e2e testing"
    echo "  • Test coverage analysis"
}

# Configure token limits based on system resources
configure_token_limits

print_section "Testing Toolkit Plugins Setup Instructions"

echo ""
print_warning "⚠️  IMPORTANT: Plugin management requires interactive slash commands"
echo ""
echo "This script cannot directly install or enable plugins. Plugins must be"
echo "managed from INSIDE a Claude Code interactive session using slash commands."
echo ""
echo -e "${BLUE}To install Testing Toolkit plugins:${NC}"
echo ""
echo "1. Start Claude Code in interactive mode:"
echo -e "   ${CYAN}claude${NC}"
echo ""
echo "2. Add marketplaces (if not already added):"
echo -e "   ${CYAN}/plugin marketplace add AndroidNextdoor/stoked-automations${NC}"
echo ""
echo "3. Install testing-focused plugins (inside Claude Code session):"
echo ""

echo -e "   ${GREEN}Essential Testing Plugins:${NC}"
echo ""
echo -e "   ${CYAN}Test Automation & TDD:${NC}"
echo -e "   /plugin install code-review-ai@stoked-automations"
echo "   • test-automator          - AI-powered test automation"
echo "   • tdd-orchestrator        - TDD workflow coordination"
echo "   • debugger                - Error analysis and debugging"
echo ""

echo -e "   ${CYAN}Testing Specialists:${NC}"
echo "   Available agents from code-review-ai:"
echo "   • test-automator          - Modern testing frameworks and automation"
echo "   • tdd-orchestrator        - Red-green-refactor discipline"
echo "   • playwright-expert       - Browser testing (if available)"
echo "   • cypress-expert          - E2E testing (if available)"
echo ""

echo -e "   ${CYAN}Code Quality & Coverage:${NC}"
echo "   • code-reviewer           - Test quality review"
echo "   • performance-engineer    - Test performance optimization"
echo "   • security-auditor        - Security testing"
echo ""

echo -e "   ${CYAN}Specialized Testing Tools:${NC}"
echo -e "   /plugin install katalon-test-analyzer@stoked-automations"
echo "   • Katalon test report analysis"
echo ""

echo "4. Enable installed plugins (inside Claude Code session):"
echo -e "   ${CYAN}/plugin enable code-review-ai@stoked-automations${NC}"
echo -e "   ${CYAN}/plugin enable katalon-test-analyzer@stoked-automations${NC}"
echo ""

echo "5. List installed plugins to verify:"
echo -e "   ${CYAN}/plugin list${NC}"
echo ""

echo "6. Run ${CYAN}/context${NC} to monitor token usage and optimize context."
print_info "For more details, see the Claude Code Command Reference in CLAUDE.md"
echo ""

# Summary
print_section "Testing Mode Configuration Complete"
echo ""
echo -e "${YELLOW}Optimizations applied:${NC}"
echo "  • Token limits optimized for test development"
echo "  • Output tokens: $MAX_OUTPUT_TOKENS (test code and assertions)"
echo "  • Thinking tokens: $MAX_THINKING_TOKENS (test strategy)"
echo ""

echo -e "${GREEN}Testing Mode Features:${NC}"
echo ""
echo "  ✓ Test-Driven Development (TDD) support"
echo "  ✓ Automated test generation"
echo "  ✓ Test framework expertise (Jest, Vitest, Playwright, Cypress)"
echo "  ✓ Coverage analysis and improvement"
echo "  ✓ Test refactoring and optimization"
echo "  ✓ Integration and e2e test strategies"
echo "  ✓ Test debugging and troubleshooting"
echo ""

echo -e "${CYAN}Ideal Use Cases:${NC}"
echo ""
echo "  • Writing unit tests for new features"
echo "  • Building integration test suites"
echo "  • Creating e2e browser tests"
echo "  • Improving test coverage"
echo "  • Refactoring existing tests"
echo "  • Test automation setup"
echo "  • TDD workflow implementation"
echo "  • QA process optimization"
echo ""

echo -e "${YELLOW}Testing Mode Best Practices:${NC}"
echo ""
echo "  1. Follow TDD: Write tests before implementation"
echo "  2. Start with unit tests, then integration, then e2e"
echo "  3. Aim for meaningful coverage, not just high percentages"
echo "  4. Keep tests simple, readable, and maintainable"
echo "  5. Use descriptive test names that explain the scenario"
echo "  6. Mock external dependencies appropriately"
echo "  7. Run tests frequently during development"
echo ""

echo -e "${YELLOW}Usage examples for Testing Mode:${NC}"
echo "  'Write unit tests for the authentication service'"
echo "  'Create integration tests for the API endpoints'"
echo "  'Build e2e tests for the user registration flow'"
echo "  'Improve test coverage for the payment module'"
echo "  'Refactor these tests to be more maintainable'"
echo "  'Set up Playwright for browser testing'"
echo "  'Help me debug this failing test'"
echo ""

echo -e "${BLUE}========================================${NC}"
echo "To switch modes:"
echo "  scripts/modes/enable-pr-review-mode.sh      - Enable PR review mode"
echo "  scripts/modes/enable-30-hour-mode.sh        - Enable deep work mode"
echo "  scripts/modes/enable-documentation-mode.sh  - Enable documentation mode"
echo ""
echo "Ready for testing! Start Claude Code with: ${CYAN}claude${NC}"
echo -e "${BLUE}========================================${NC}"