#!/usr/bin/env bash

#####################################################################
# Enable Documentation Mode - Stoked Automations
#
# This script optimizes Claude Code for technical writing and
# comprehensive documentation generation.
#
# Prerequisites:
# - Claude Code installed and configured
# - stoked-automations marketplace added
#
# What this mode does:
# - Configures high output tokens for documentation generation
# - Provides instructions for installing documentation plugins
# - Optimizes for API docs, tutorials, and technical writing
#
# Usage:
#   scripts/modes/enable-documentation-mode.sh
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
echo -e "${BLUE}Enabling Documentation Mode${NC}"
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
    print_section "Configuring Token Limits for Documentation Mode"

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

    # Documentation mode token configuration
    # - High output for comprehensive documentation
    # - Moderate thinking for content structure
    # - Optimized for long-form technical writing

    if [ "$TOTAL_RAM_GB" -ge 16 ]; then
        # High-end system
        MAX_OUTPUT_TOKENS=48000
        MAX_THINKING_TOKENS=16000
        print_success "High-performance configuration (16GB+ RAM)"
    elif [ "$TOTAL_RAM_GB" -ge 8 ]; then
        # Mid-range system
        MAX_OUTPUT_TOKENS=32000
        MAX_THINKING_TOKENS=12000
        print_success "Balanced configuration (8-16GB RAM)"
    else
        # Lower-end system
        MAX_OUTPUT_TOKENS=24000
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
    echo "  • Comprehensive technical documentation"
    echo "  • API reference generation"
    echo "  • Tutorial and guide creation"
    echo "  • Architecture documentation"
    echo "  • User-facing documentation"
}

# Configure token limits based on system resources
configure_token_limits

print_section "Documentation Toolkit Plugins Setup Instructions"

echo ""
print_warning "⚠️  IMPORTANT: Plugin management requires interactive slash commands"
echo ""
echo "This script cannot directly install or enable plugins. Plugins must be"
echo "managed from INSIDE a Claude Code interactive session using slash commands."
echo ""
echo -e "${BLUE}To install Documentation Toolkit plugins:${NC}"
echo ""
echo "1. Start Claude Code in interactive mode:"
echo -e "   ${CYAN}claude${NC}"
echo ""
echo "2. Add marketplaces (if not already added):"
echo -e "   ${CYAN}/plugin marketplace add AndroidNextdoor/stoked-automations${NC}"
echo ""
echo "3. Install documentation-focused plugins (inside Claude Code session):"
echo ""

echo -e "   ${GREEN}Essential Documentation Plugins:${NC}"
echo ""
echo -e "   ${CYAN}Documentation Specialists:${NC}"
echo -e "   /plugin install code-review-ai@stoked-automations"
echo "   • docs-architect          - Technical documentation from code"
echo "   • api-documenter          - OpenAPI 3.1 & API documentation"
echo "   • tutorial-engineer       - Step-by-step tutorials"
echo "   • mermaid-expert          - Diagrams for visual documentation"
echo "   • reference-builder       - Exhaustive technical references"
echo ""

echo -e "   ${CYAN}Architecture & Design:${NC}"
echo "   • architect-review        - System architecture documentation"
echo "   • ui-ux-designer          - Design system documentation"
echo ""

echo -e "   ${CYAN}Content Quality:${NC}"
echo "   • code-reviewer           - Documentation quality review"
echo "   • seo-content-writer      - User-friendly content (if needed)"
echo ""

echo "4. Enable installed plugins (inside Claude Code session):"
echo -e "   ${CYAN}/plugin enable code-review-ai@stoked-automations${NC}"
echo ""

echo "5. List installed plugins to verify:"
echo -e "   ${CYAN}/plugin list${NC}"
echo ""

echo "6. Run ${CYAN}/context${NC} to monitor token usage and optimize context."
print_info "For more details, see the Claude Code Command Reference in CLAUDE.md"
echo ""

# Summary
print_section "Documentation Mode Configuration Complete"
echo ""
echo -e "${YELLOW}Optimizations applied:${NC}"
echo "  • Token limits optimized for documentation generation"
echo "  • Output tokens: $MAX_OUTPUT_TOKENS (comprehensive content)"
echo "  • Thinking tokens: $MAX_THINKING_TOKENS (content structure)"
echo ""

echo -e "${GREEN}Documentation Mode Features:${NC}"
echo ""
echo "  ✓ API documentation generation (OpenAPI, JSDoc, etc.)"
echo "  ✓ Tutorial and guide creation"
echo "  ✓ Architecture documentation with diagrams"
echo "  ✓ Technical reference generation"
echo "  ✓ User guide creation"
echo "  ✓ README and contributing guide enhancement"
echo "  ✓ Mermaid diagram generation"
echo "  ✓ Documentation quality review"
echo ""

echo -e "${CYAN}Ideal Use Cases:${NC}"
echo ""
echo "  • Writing comprehensive API documentation"
echo "  • Creating step-by-step tutorials"
echo "  • Building architecture documentation"
echo "  • Generating technical references"
echo "  • Writing user guides and FAQs"
echo "  • Creating design system documentation"
echo "  • Building knowledge bases"
echo "  • Documentation site creation"
echo ""

echo -e "${YELLOW}Documentation Mode Best Practices:${NC}"
echo ""
echo "  1. Start with an outline before writing"
echo "  2. Use clear, simple language for user-facing docs"
echo "  3. Include code examples and use cases"
echo "  4. Add diagrams for complex concepts"
echo "  5. Keep documentation up-to-date with code"
echo "  6. Use consistent formatting and style"
echo "  7. Include troubleshooting sections"
echo "  8. Add links to related documentation"
echo ""

echo -e "${YELLOW}Usage examples for Documentation Mode:${NC}"
echo "  'Create API documentation for the REST endpoints'"
echo "  'Write a tutorial for getting started with this library'"
echo "  'Generate architecture documentation with Mermaid diagrams'"
echo "  'Build a comprehensive reference for configuration options'"
echo "  'Create a user guide for the authentication flow'"
echo "  'Write contributing guidelines for the project'"
echo "  'Document the database schema and relationships'"
echo ""

echo -e "${BLUE}========================================${NC}"
echo "To switch modes:"
echo "  scripts/modes/enable-pr-review-mode.sh      - Enable PR review mode"
echo "  scripts/modes/enable-30-hour-mode.sh        - Enable deep work mode"
echo "  scripts/modes/enable-testing-mode.sh        - Enable testing mode"
echo ""
echo "Ready for documentation! Start Claude Code with: ${CYAN}claude${NC}"
echo -e "${BLUE}========================================${NC}"