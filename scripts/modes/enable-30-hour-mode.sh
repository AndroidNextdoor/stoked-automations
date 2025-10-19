#!/usr/bin/env bash

#####################################################################
# Enable 30-Hour Deep Work Mode - Stoked Automations
#
# This script optimizes Claude Code for extended deep work sessions
# by configuring maximum token limits and providing instructions for
# enabling comprehensive toolkit plugins.
#
# Prerequisites:
# - Claude Code installed and configured
# - stoked-automations marketplace added
#
# What this script does:
# - Configures maximum token limits for extended deep work
# - Provides instructions for installing comprehensive toolkit plugins
# - Optimizes for long-running, complex problem-solving sessions
#
# Note: Plugin management requires interactive slash commands inside
#       Claude Code sessions. This script provides instructions but
#       cannot directly install or enable plugins.
#
# Usage:
#   scripts/modes/enable-30-hour-mode.sh
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
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${MAGENTA}========================================${NC}"
echo -e "${MAGENTA}Enabling 30-Hour Deep Work Mode${NC}"
echo -e "${MAGENTA}========================================${NC}"
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
    print_section "Configuring Maximum Token Limits for Extended Deep Work"

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

    # 30-hour mode token configuration
    # - Maximum output for comprehensive documentation and implementation
    # - Maximum thinking for deep problem-solving
    # - Optimized for long-running complex tasks
    # - Balanced for sustained deep work sessions

    if [ "$TOTAL_RAM_GB" -ge 32 ]; then
        # High-end workstation
        MAX_OUTPUT_TOKENS=64000
        MAX_THINKING_TOKENS=32000
        print_success "Maximum performance configuration (32GB+ RAM)"
    elif [ "$TOTAL_RAM_GB" -ge 16 ]; then
        # High-performance system
        MAX_OUTPUT_TOKENS=48000
        MAX_THINKING_TOKENS=24000
        print_success "High-performance configuration (16-32GB RAM)"
    elif [ "$TOTAL_RAM_GB" -ge 8 ]; then
        # Mid-range system
        MAX_OUTPUT_TOKENS=32000
        MAX_THINKING_TOKENS=16000
        print_success "Balanced configuration (8-16GB RAM)"
    else
        # Lower-end system
        MAX_OUTPUT_TOKENS=20000
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
    echo "  • Extended deep work sessions (30+ hours)"
    echo "  • Complex problem-solving and architecture design"
    echo "  • Comprehensive documentation generation"
    echo "  • Large-scale refactoring and code transformations"
    echo "  • Full-stack application development"
    echo "  • Research and deep code analysis"
}

# Configure token limits based on system resources
configure_token_limits

print_section "30-Hour Deep Work Toolkit Setup Instructions"

echo ""
print_warning "⚠️  IMPORTANT: Plugin management requires interactive slash commands"
echo ""
echo "This script cannot directly install or enable plugins. Plugins must be"
echo "managed from INSIDE a Claude Code interactive session using slash commands."
echo ""
echo -e "${BLUE}To install Deep Work Toolkit plugins:${NC}"
echo ""
echo "1. Start Claude Code in interactive mode:"
echo -e "   ${CYAN}claude${NC}"
echo ""
echo "2. Add marketplaces (if not already added):"
echo -e "   ${CYAN}/plugin marketplace add AndroidNextdoor/stoked-automations${NC}"
echo ""
echo "3. Install comprehensive toolkit plugins (inside Claude Code session):"
echo ""

echo -e "   ${GREEN}Essential Deep Work Plugins:${NC}"
echo ""
echo -e "   ${CYAN}Architecture & Design:${NC}"
echo -e "   /plugin install code-review-ai@stoked-automations"
echo "   • architect-review        - Master software architect"
echo "   • cloud-architect         - Cloud infrastructure design"
echo "   • backend-architect       - Backend system architecture"
echo "   • database-architect      - Database design from scratch"
echo "   • kubernetes-architect    - K8s cloud-native architecture"
echo ""

echo -e "   ${CYAN}Development & Implementation:${NC}"
echo -e "   /plugin install skills-powerkit@stoked-automations"
echo "   • plugin-creator          - Create new plugins"
echo "   • plugin-validator        - Validate plugin structure"
echo "   • version-bumper          - Semantic versioning automation"
echo ""
echo -e "   /plugin install pi-pathfinder@stoked-automations"
echo "   • skill-adapter           - Auto-selects best plugin for tasks"
echo ""

echo -e "   ${CYAN}Code Quality & Security:${NC}"
echo -e "   /plugin install code-review-ai@stoked-automations"
echo "   • code-reviewer           - Elite code review expert"
echo "   • security-auditor        - Comprehensive security analysis"
echo "   • performance-engineer    - Performance optimization"
echo "   • tdd-orchestrator        - Test-driven development"
echo ""

echo -e "   ${CYAN}Language-Specific Experts:${NC}"
echo "   • python-pro              - Python 3.12+ with modern patterns"
echo "   • typescript-pro          - TypeScript with advanced types"
echo "   • rust-pro                - Rust 1.75+ systems programming"
echo "   • golang-pro              - Go 1.21+ with modern patterns"
echo "   • java-pro                - Java 21+ with virtual threads"
echo ""

echo -e "   ${CYAN}Documentation & Analysis:${NC}"
echo "   • docs-architect          - Technical documentation from code"
echo "   • api-documenter          - OpenAPI 3.1 & API documentation"
echo "   • tutorial-engineer       - Step-by-step tutorials"
echo "   • mermaid-expert          - Diagrams for visual documentation"
echo ""

echo -e "   ${CYAN}DevOps & Infrastructure:${NC}"
echo "   • terraform-specialist    - Advanced IaC automation"
echo "   • deployment-engineer     - CI/CD pipelines & GitOps"
echo "   • observability-engineer  - Monitoring, logging, tracing"
echo "   • incident-responder      - SRE incident management"
echo ""

echo -e "   ${CYAN}Database & Data:${NC}"
echo "   • database-optimizer      - Database performance tuning"
echo "   • sql-pro                 - Modern SQL optimization"
echo "   • data-engineer           - Data pipelines & warehouses"
echo "   • ml-engineer             - Production ML systems"
echo ""

echo -e "   ${CYAN}Debugging & Troubleshooting:${NC}"
echo "   • debugger                - Error analysis specialist"
echo "   • error-detective         - Log analysis & root cause"
echo "   • devops-troubleshooter   - Incident response & debugging"
echo ""

echo -e "   ${CYAN}Skill Enhancers:${NC}"
echo -e "   /plugin install web-to-github-issue@stoked-automations"
echo "   • research-and-ticket     - Web research → GitHub issues"
echo ""
echo -e "   /plugin install git-jira-workflow@stoked-automations"
echo "   • Enterprise GitLab Flow with Jira integration"
echo ""

echo "4. Enable installed plugins (inside Claude Code session):"
echo -e "   ${CYAN}/plugin enable skills-powerkit@stoked-automations${NC}"
echo -e "   ${CYAN}/plugin enable pi-pathfinder@stoked-automations${NC}"
echo -e "   ${CYAN}/plugin enable code-review-ai@stoked-automations${NC}"
echo -e "   ${CYAN}/plugin enable web-to-github-issue@stoked-automations${NC}"
echo ""

echo "5. List installed plugins to verify:"
echo -e "   ${CYAN}/plugin list${NC}"
echo ""

echo "6. Run ${CYAN}/context${NC} to monitor token usage and optimize context."
print_info "For more details, see the Claude Code Command Reference in CLAUDE.md"
echo ""

# Summary
print_section "30-Hour Deep Work Mode Configuration Complete"
echo ""
echo -e "${YELLOW}Optimizations applied:${NC}"
echo "  • Token limits maximized for extended sessions"
echo "  • Output tokens: $MAX_OUTPUT_TOKENS (comprehensive implementation)"
echo "  • Thinking tokens: $MAX_THINKING_TOKENS (deep problem-solving)"
echo "  • Optimized for sustained deep work (30+ hours)"
echo ""

echo -e "${GREEN}30-Hour Mode Features:${NC}"
echo ""
echo "  ✓ Maximum token capacity for complex tasks"
echo "  ✓ Extended thinking for architectural decisions"
echo "  ✓ Comprehensive toolkit of specialized agents"
echo "  ✓ Full-stack development capabilities"
echo "  ✓ Enterprise-grade security and performance"
echo "  ✓ Advanced debugging and troubleshooting"
echo "  ✓ Documentation and diagram generation"
echo "  ✓ DevOps and infrastructure automation"
echo ""

echo -e "${CYAN}Ideal Use Cases:${NC}"
echo ""
echo "  • Building full-stack applications from scratch"
echo "  • Large-scale refactoring and modernization"
echo "  • System architecture design and review"
echo "  • Comprehensive documentation projects"
echo "  • Complex debugging and performance optimization"
echo "  • Research and deep code analysis"
echo "  • Multi-day feature development"
echo "  • Repository-wide transformations"
echo ""

echo -e "${YELLOW}Best Practices for 30-Hour Sessions:${NC}"
echo ""
echo "  1. Break work into logical checkpoints"
echo "  2. Commit frequently to preserve progress"
echo "  3. Monitor /context regularly to optimize token usage"
echo "  4. Use PI Pathfinder to auto-select the right agent"
echo "  5. Document architectural decisions as you go"
echo "  6. Run validators and tests incrementally"
echo "  7. Take breaks - 30 hours is a marathon, not a sprint"
echo ""

echo -e "${MAGENTA}========================================${NC}"
echo "To switch modes:"
echo "  scripts/modes/enable-pr-review-mode.sh      - Enable PR review mode"
echo "  scripts/modes/enable-testing-mode.sh        - Enable testing mode"
echo "  scripts/modes/enable-documentation-mode.sh  - Enable documentation mode"
echo ""
echo "Ready for deep work! Start Claude Code with: ${CYAN}claude${NC}"
echo -e "${MAGENTA}========================================${NC}"