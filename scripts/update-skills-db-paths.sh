#!/bin/bash

# Script to update plugin paths in skills_generation.db
# This updates paths from the old codebase to the current machine's path
#
# WHY THIS IS NEEDED:
# The vertex-skills-generator-safe.py script stores absolute paths in the database
# (line 108: plugin_path parameter). When the codebase is cloned to a new machine
# or moved to a different directory, these paths become incorrect.
#
# INTEGRATION WITH VERTEX GENERATOR:
# To prevent this issue in future runs, the vertex-skills-generator-safe.py should
# be modified to store relative paths instead of absolute paths. Change line 108 from:
#   str(plugin_path)
# to:
#   str(plugin_path.relative_to(repo_root))
#
# Or better yet, use a consistent base path pattern that can be easily updated.
#
# Usage: ./update-skills-db-paths.sh [database_path] [new_base_path]
# Example: ./update-skills-db-paths.sh backups/skills-audit/skills_generation.db /Users/andrew.nixdorf/Projects/stoked-automations

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Default values
DB_PATH="${1:-backups/skills-audit/skills_generation.db}"
NEW_BASE_PATH="${2:-$(pwd)}"

# Resolve to absolute path if relative
if [[ ! "$DB_PATH" = /* ]]; then
    DB_PATH="$(pwd)/$DB_PATH"
fi

# Check if database exists
if [ ! -f "$DB_PATH" ]; then
    echo -e "${RED}Error: Database not found at $DB_PATH${NC}"
    echo "Usage: $0 [database_path] [new_base_path]"
    exit 1
fi

# Check if sqlite3 is installed
if ! command -v sqlite3 &> /dev/null; then
    echo -e "${RED}Error: sqlite3 is not installed${NC}"
    echo "Install with: brew install sqlite (macOS) or apt-get install sqlite3 (Linux)"
    exit 1
fi

echo -e "${YELLOW}Skills Database Path Updater${NC}"
echo "================================"
echo "Database: $DB_PATH"
echo "New base path: $NEW_BASE_PATH"
echo ""

# Get current paths to show what will be changed
echo -e "${YELLOW}Current plugin paths in database:${NC}"
OLD_PATHS=$(sqlite3 "$DB_PATH" "SELECT DISTINCT SUBSTR(plugin_path, 1, INSTR(plugin_path || '/', '/plugins/') + 7) FROM skill_generations WHERE plugin_path LIKE '%/plugins/%'")
echo "$OLD_PATHS" | head -5
echo ""

# Count total records
TOTAL=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM skill_generations")
echo -e "${YELLOW}Total records: $TOTAL${NC}"
echo ""

# Show sample of records that will be updated
echo -e "${YELLOW}Sample records before update:${NC}"
sqlite3 "$DB_PATH" "SELECT plugin_name, plugin_path FROM skill_generations LIMIT 5" | column -t -s '|'
echo ""

# Confirm before proceeding
read -p "Do you want to update all paths? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Update cancelled${NC}"
    exit 0
fi

# Create backup
BACKUP_PATH="${DB_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
echo -e "${YELLOW}Creating backup at: $BACKUP_PATH${NC}"
cp "$DB_PATH" "$BACKUP_PATH"

# Detect old base paths and update them
echo -e "${YELLOW}Updating paths...${NC}"

# Common old paths to replace
OLD_BASE_PATHS=(
    "/home/jeremy/000-projects/claude-code-plugins"
    "/home/jeremy/claude-code-plugins"
    "/Users/jeremy/Projects/claude-code-plugins"
)

UPDATED_COUNT=0
for OLD_BASE in "${OLD_BASE_PATHS[@]}"; do
    COUNT=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM skill_generations WHERE plugin_path LIKE '${OLD_BASE}%'")
    if [ "$COUNT" -gt 0 ]; then
        echo "  Updating $COUNT records from: $OLD_BASE"
        sqlite3 "$DB_PATH" "UPDATE skill_generations SET plugin_path = REPLACE(plugin_path, '$OLD_BASE', '$NEW_BASE_PATH') WHERE plugin_path LIKE '${OLD_BASE}%'"
        UPDATED_COUNT=$((UPDATED_COUNT + COUNT))
    fi
done

echo ""
echo -e "${GREEN}✓ Updated $UPDATED_COUNT records${NC}"
echo ""

# Show sample of updated records
echo -e "${YELLOW}Sample records after update:${NC}"
sqlite3 "$DB_PATH" "SELECT plugin_name, plugin_path FROM skill_generations LIMIT 5" | column -t -s '|'
echo ""

# Verify all paths are now correct
REMAINING_OLD=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM skill_generations WHERE plugin_path NOT LIKE '${NEW_BASE_PATH}%'")
if [ "$REMAINING_OLD" -gt 0 ]; then
    echo -e "${YELLOW}Warning: $REMAINING_OLD records still have paths not starting with $NEW_BASE_PATH${NC}"
    echo "These might need manual review:"
    sqlite3 "$DB_PATH" "SELECT DISTINCT SUBSTR(plugin_path, 1, 50) FROM skill_generations WHERE plugin_path NOT LIKE '${NEW_BASE_PATH}%'" | head -5
else
    echo -e "${GREEN}✓ All paths successfully updated!${NC}"
fi

echo ""
echo -e "${GREEN}Done! Backup saved at: $BACKUP_PATH${NC}"
echo ""
echo "To restore from backup if needed:"
echo "  cp $BACKUP_PATH $DB_PATH"
