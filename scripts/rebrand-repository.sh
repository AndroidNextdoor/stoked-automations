#!/usr/bin/env bash

#####################################################################
# Repository Rebranding Script - Stoked Automations
#
# This script updates all plugins with new author attribution and
# JetBrains-style versioning (YYYY.MAJOR.MINOR).
#
# What this script does:
# - Updates all plugin.json files with Andrew Nixdorf as author
# - Converts all versions to JetBrains style starting at 2025.0.0
# - Updates marketplace.extended.json with new versioning
# - Preserves all other metadata
#
# Usage:
#   scripts/rebrand-repository.sh [--dry-run]
#
# Options:
#   --dry-run    Show what would be changed without making changes
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

DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
fi

# Get repository root
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Repository Rebranding Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

if $DRY_RUN; then
    echo -e "${YELLOW}DRY RUN MODE - No changes will be made${NC}"
    echo ""
fi

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

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is required but not installed.${NC}"
    echo "Install with: brew install jq (macOS) or apt-get install jq (Linux)"
    exit 1
fi

# Count total plugins
TOTAL_PLUGINS=$(find plugins -name "plugin.json" -type f | wc -l | tr -d ' ')
print_info "Found $TOTAL_PLUGINS plugin.json files to update"

# Update all plugin.json files
print_section "Updating plugin.json files"

UPDATED_COUNT=0
SKIPPED_COUNT=0

while IFS= read -r plugin_file; do
    # Extract plugin name from path
    PLUGIN_NAME=$(echo "$plugin_file" | sed 's|plugins/.*/\([^/]*\)/.claude-plugin/plugin.json|\1|')

    # Read current version
    CURRENT_VERSION=$(jq -r '.version' "$plugin_file")

    # Check if already has correct author
    CURRENT_AUTHOR=$(jq -r '.author.name' "$plugin_file")

    if [[ "$CURRENT_AUTHOR" == "Andrew Nixdorf" ]] && [[ "$CURRENT_VERSION" == "2025.0.0" ]]; then
        SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
        continue
    fi

    if $DRY_RUN; then
        echo -e "${YELLOW}Would update:${NC} $PLUGIN_NAME"
        echo "  Current version: $CURRENT_VERSION → New version: 2025.0.0"
        echo "  Current author: $CURRENT_AUTHOR → New author: Andrew Nixdorf"
    else
        # Create temporary file with updates
        jq --arg version "2025.0.0" \
           --arg author_name "Andrew Nixdorf" \
           --arg author_email "[email protected]" \
           '.version = $version |
            .author.name = $author_name |
            .author.email = $author_email' \
           "$plugin_file" > "${plugin_file}.tmp"

        # Replace original file
        mv "${plugin_file}.tmp" "$plugin_file"

        echo -e "${GREEN}✓${NC} Updated: $PLUGIN_NAME (v$CURRENT_VERSION → v2025.0.0)"
    fi

    UPDATED_COUNT=$((UPDATED_COUNT + 1))
done < <(find plugins -name "plugin.json" -type f)

echo ""
print_success "Updated $UPDATED_COUNT plugin.json files"
if [[ $SKIPPED_COUNT -gt 0 ]]; then
    print_info "Skipped $SKIPPED_COUNT files (already up to date)"
fi

# Update marketplace.extended.json
print_section "Updating marketplace.extended.json"

MARKETPLACE_FILE=".claude-plugin/marketplace.extended.json"

if $DRY_RUN; then
    echo -e "${YELLOW}Would update:${NC} $MARKETPLACE_FILE"
    echo "  • Change all plugin versions to 2025.0.0"
    echo "  • Update author to Andrew Nixdorf"
    echo "  • Preserve all other metadata"
else
    # Update all plugin versions in marketplace
    jq --arg version "2025.0.0" \
       --arg author_name "Andrew Nixdorf" \
       --arg author_email "[email protected]" \
       '.plugins = [
          .plugins[] |
          .version = $version |
          if .author then
            .author.name = $author_name |
            .author.email = $author_email
          else
            .author = {
              name: $author_name,
              email: $author_email
            }
          end
        ]' \
       "$MARKETPLACE_FILE" > "${MARKETPLACE_FILE}.tmp"

    # Replace original file
    mv "${MARKETPLACE_FILE}.tmp" "$MARKETPLACE_FILE"

    print_success "Updated marketplace.extended.json"
fi

# Summary
print_section "Rebranding Summary"
echo ""
echo -e "${GREEN}Changes applied:${NC}"
echo "  • Plugin files updated: $UPDATED_COUNT"
echo "  • New version format: 2025.0.0 (JetBrains style: YYYY.MAJOR.MINOR)"
echo "  • Author: Andrew Nixdorf <[email protected]>"
echo ""

if $DRY_RUN; then
    echo -e "${YELLOW}This was a DRY RUN - no files were modified${NC}"
    echo "Run without --dry-run to apply changes"
else
    print_warning "Next steps:"
    echo "  1. Run: pnpm run sync-marketplace"
    echo "  2. Run: ./scripts/validate-all.sh"
    echo "  3. Commit changes: git add -A && git commit -m 'Rebrand: Update to Andrew Nixdorf + JetBrains versioning (2025.0.0)'"
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo "Rebranding complete!"
echo -e "${BLUE}========================================${NC}"