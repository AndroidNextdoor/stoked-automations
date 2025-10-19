#!/usr/bin/env bash

#####################################################################
# Mode Manager - Stoked Automations
#
# Unified mode management system for easy switching between
# different development modes.
#
# Usage:
#   scripts/modes/mode-manager.sh [command] [mode-name]
#
# Commands:
#   list       - List all available modes
#   current    - Show current active mode
#   switch     - Switch to a different mode
#   info       - Show detailed information about a mode
#   help       - Show this help message
#
#####################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Get repository root
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

# Modes configuration file
MODES_CONFIG="config/modes.json"
CURRENT_MODE_FILE=".current-mode"

# Function to print section headers
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print error messages
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Function to print info messages
print_info() {
    echo -e "${CYAN}ℹ $1${NC}"
}

# List all available modes
list_modes() {
    print_header "Available Development Modes"
    echo ""

    if [ ! -f "$MODES_CONFIG" ]; then
        print_error "Modes configuration not found: $MODES_CONFIG"
        exit 1
    fi

    # Parse modes from JSON and display
    echo -e "${CYAN}Mode${NC}                ${CYAN}Description${NC}"
    echo "────────────────────────────────────────────────────────"

    jq -r '.modes | to_entries[] | "\(.value.icon) \(.key)|\(.value.description)"' "$MODES_CONFIG" | \
    while IFS='|' read -r mode desc; do
        printf "%-20s %s\n" "$mode" "$desc"
    done

    echo ""
    print_info "Use 'mode-manager.sh info <mode>' for detailed information"
    print_info "Use 'mode-manager.sh switch <mode>' to activate a mode"
}

# Show current active mode
show_current() {
    if [ -f "$CURRENT_MODE_FILE" ]; then
        CURRENT=$(cat "$CURRENT_MODE_FILE")
        print_header "Current Active Mode"
        echo ""

        MODE_NAME=$(jq -r --arg mode "$CURRENT" '.modes[$mode].name // "Unknown"' "$MODES_CONFIG")
        MODE_ICON=$(jq -r --arg mode "$CURRENT" '.modes[$mode].icon // ""' "$MODES_CONFIG")
        MODE_DESC=$(jq -r --arg mode "$CURRENT" '.modes[$mode].description // "No description"' "$MODES_CONFIG")

        echo -e "${GREEN}${MODE_ICON} ${MODE_NAME}${NC}"
        echo -e "${CYAN}$MODE_DESC${NC}"
        echo ""
    else
        print_info "No active mode set"
        echo ""
        echo "Set a mode using:"
        echo -e "  ${CYAN}./scripts/modes/mode-manager.sh switch <mode-name>${NC}"
    fi
}

# Show detailed information about a mode
show_info() {
    local mode_key="$1"

    if [ -z "$mode_key" ]; then
        print_error "Please specify a mode name"
        echo "Usage: mode-manager.sh info <mode-name>"
        exit 1
    fi

    # Check if mode exists
    MODE_EXISTS=$(jq -r --arg mode "$mode_key" '.modes | has($mode)' "$MODES_CONFIG")

    if [ "$MODE_EXISTS" != "true" ]; then
        print_error "Mode '$mode_key' not found"
        echo ""
        echo "Available modes:"
        jq -r '.modes | keys[]' "$MODES_CONFIG"
        exit 1
    fi

    # Extract mode information
    MODE_NAME=$(jq -r --arg mode "$mode_key" '.modes[$mode].name' "$MODES_CONFIG")
    MODE_ICON=$(jq -r --arg mode "$mode_key" '.modes[$mode].icon' "$MODES_CONFIG")
    MODE_DESC=$(jq -r --arg mode "$mode_key" '.modes[$mode].description' "$MODES_CONFIG")
    MODE_SCRIPT=$(jq -r --arg mode "$mode_key" '.modes[$mode].script' "$MODES_CONFIG")

    print_header "${MODE_ICON} ${MODE_NAME}"
    echo ""
    echo -e "${CYAN}Description:${NC}"
    echo "  $MODE_DESC"
    echo ""

    # Token limits
    echo -e "${CYAN}Token Limits:${NC}"
    jq -r --arg mode "$mode_key" '.modes[$mode].tokenLimits | to_entries[] | "  \(.key): Output=\(.value.output) | Thinking=\(.value.thinking)"' "$MODES_CONFIG"
    echo ""

    # Recommended plugins
    echo -e "${CYAN}Recommended Plugins:${NC}"
    jq -r --arg mode "$mode_key" '.modes[$mode].recommendedPlugins[]? // empty | "  • \(.)"' "$MODES_CONFIG"
    echo ""

    # Recommended agents
    echo -e "${CYAN}Recommended Agents:${NC}"
    jq -r --arg mode "$mode_key" '.modes[$mode].recommendedAgents[]? // empty | "  • \(.)"' "$MODES_CONFIG"
    echo ""

    # Use cases
    echo -e "${CYAN}Use Cases:${NC}"
    jq -r --arg mode "$mode_key" '.modes[$mode].useCases[]? // empty | "  • \(.)"' "$MODES_CONFIG"
    echo ""

    # Script location
    echo -e "${CYAN}Activation Script:${NC}"
    echo "  $MODE_SCRIPT"
    echo ""
}

# Switch to a different mode
switch_mode() {
    local mode_key="$1"

    if [ -z "$mode_key" ]; then
        print_error "Please specify a mode name"
        echo "Usage: mode-manager.sh switch <mode-name>"
        exit 1
    fi

    # Check if mode exists
    MODE_EXISTS=$(jq -r --arg mode "$mode_key" '.modes | has($mode)' "$MODES_CONFIG")

    if [ "$MODE_EXISTS" != "true" ]; then
        print_error "Mode '$mode_key' not found"
        echo ""
        echo "Available modes:"
        jq -r '.modes | keys[]' "$MODES_CONFIG"
        exit 1
    fi

    # Get mode script
    MODE_SCRIPT=$(jq -r --arg mode "$mode_key" '.modes[$mode].script' "$MODES_CONFIG")
    MODE_NAME=$(jq -r --arg mode "$mode_key" '.modes[$mode].name' "$MODES_CONFIG")
    MODE_ICON=$(jq -r --arg mode "$mode_key" '.modes[$mode].icon' "$MODES_CONFIG")

    print_header "Switching to ${MODE_ICON} ${MODE_NAME}"
    echo ""

    # Check if script exists
    if [ ! -f "$MODE_SCRIPT" ]; then
        print_error "Mode script not found: $MODE_SCRIPT"
        exit 1
    fi

    # Execute mode script
    print_info "Executing: $MODE_SCRIPT"
    echo ""
    bash "$MODE_SCRIPT"

    # Save current mode
    echo "$mode_key" > "$CURRENT_MODE_FILE"

    echo ""
    print_success "Switched to ${MODE_NAME}"
    echo ""
    print_info "Run '/context' in Claude Code to verify token limits"
}

# Show help message
show_help() {
    print_header "Mode Manager - Help"
    echo ""
    echo "Unified mode management for Stoked Automations"
    echo ""
    echo -e "${CYAN}Usage:${NC}"
    echo "  ./scripts/modes/mode-manager.sh [command] [options]"
    echo ""
    echo -e "${CYAN}Commands:${NC}"
    echo "  list                List all available modes"
    echo "  current             Show current active mode"
    echo "  switch <mode>       Switch to a different mode"
    echo "  info <mode>         Show detailed information about a mode"
    echo "  help                Show this help message"
    echo ""
    echo -e "${CYAN}Examples:${NC}"
    echo "  ./scripts/modes/mode-manager.sh list"
    echo "  ./scripts/modes/mode-manager.sh current"
    echo "  ./scripts/modes/mode-manager.sh info testing"
    echo "  ./scripts/modes/mode-manager.sh switch documentation"
    echo ""
    echo -e "${CYAN}Available Modes:${NC}"
    jq -r '.modes | keys[] | "  • \(.)"' "$MODES_CONFIG"
    echo ""
}

# Main command handler
case "${1:-help}" in
    list)
        list_modes
        ;;
    current)
        show_current
        ;;
    info)
        show_info "$2"
        ;;
    switch)
        switch_mode "$2"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac