#!/usr/bin/env bash

#####################################################################
# Start 30-Hour Architecture & Documentation Session
#
# This script initializes a comprehensive 30-hour deep work session
# focused on architecture, documentation, and testing infrastructure.
#
# Usage:
#   ./scripts/start-30h-architecture-session.sh
#
#####################################################################

set -e

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

echo -e "${MAGENTA}========================================${NC}"
echo -e "${MAGENTA}30-Hour Architecture & Documentation Session${NC}"
echo -e "${MAGENTA}========================================${NC}"
echo ""

# Get repository root
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# 1. Enable 30-hour mode
echo -e "${BLUE}>>> Step 1: Enabling 30-Hour Mode${NC}"
./scripts/modes/enable-30-hour-mode.sh
echo ""

# 2. Display the comprehensive prompt
echo -e "${BLUE}>>> Step 2: Loading Comprehensive Prompt${NC}"
echo ""
PROMPT_FILE=".claude/prompts/enable-30h-documentation-architecture.md"

if [ -f "$PROMPT_FILE" ]; then
    echo -e "${GREEN}✓ Comprehensive prompt loaded from:${NC}"
    echo -e "  ${CYAN}$PROMPT_FILE${NC}"
    echo ""
    echo -e "${YELLOW}The prompt includes:${NC}"
    echo "  • 7 comprehensive phases"
    echo "  • 8 new mode scripts to create"
    echo "  • Complete documentation overhaul"
    echo "  • Testing infrastructure setup"
    echo "  • Architecture unification"
    echo "  • Quality assurance improvements"
    echo "  • Community resources"
    echo ""
else
    echo -e "${YELLOW}⚠ Prompt file not found${NC}"
fi

# 3. Create working branch
echo -e "${BLUE}>>> Step 3: Creating Working Branch${NC}"
BRANCH_NAME="feature/30h-architecture-documentation-$(date +%Y%m%d)"
git checkout -b "$BRANCH_NAME" 2>/dev/null || echo "Branch already exists or couldn't be created"
echo -e "${GREEN}✓ Branch: ${CYAN}$BRANCH_NAME${NC}"
echo ""

# 4. Create session tracking
echo -e "${BLUE}>>> Step 4: Session Tracking${NC}"
SESSION_FILE=".claude/session-$(date +%Y%m%d-%H%M).md"
cat > "$SESSION_FILE" << EOF
# 30-Hour Session: Architecture & Documentation
**Started:** $(date)
**Branch:** $BRANCH_NAME

## Session Goals
- Create 8 new mode scripts
- Complete architecture documentation
- Build testing infrastructure
- Enhance all plugin documentation
- Unify configuration system
- Improve developer experience

## Progress Tracking
- [ ] Phase 1: Environment Setup (1h)
- [ ] Phase 2: Architecture Analysis (6h)
- [ ] Phase 3: Documentation Enhancement (8h)
- [ ] Phase 4: Testing Infrastructure (5h)
- [ ] Phase 5: Architecture Unification (4h)
- [ ] Phase 6: Quality Assurance (4h)
- [ ] Phase 7: Community & Ecosystem (2h)

## Notes
<!-- Add notes here as you progress -->

EOF
echo -e "${GREEN}✓ Session tracker created: ${CYAN}$SESSION_FILE${NC}"
echo ""

# 5. Recommended plugins summary
echo -e "${BLUE}>>> Step 5: Recommended Plugin Installation${NC}"
echo ""
echo -e "${YELLOW}To install recommended plugins, run these in Claude Code:${NC}"
echo ""
echo -e "${CYAN}/plugin marketplace add AndroidNextdoor/stoked-automations${NC}"
echo -e "${CYAN}/plugin install code-review-ai@stoked-automations${NC}"
echo -e "${CYAN}/plugin install skills-powerkit@stoked-automations${NC}"
echo -e "${CYAN}/plugin install pi-pathfinder@stoked-automations${NC}"
echo ""
echo -e "${YELLOW}Then enable specific agents:${NC}"
echo "  • architect-review (architecture design)"
echo "  • docs-architect (documentation generation)"
echo "  • api-documenter (API documentation)"
echo "  • tutorial-engineer (tutorial creation)"
echo "  • test-automator (testing infrastructure)"
echo "  • security-auditor (security review)"
echo "  • performance-engineer (optimization)"
echo ""

# 6. Display next steps
echo -e "${BLUE}>>> Next Steps${NC}"
echo ""
echo -e "${GREEN}1. Start Claude Code:${NC}"
echo -e "   ${CYAN}claude${NC}"
echo ""
echo -e "${GREEN}2. Install recommended plugins${NC} (see above)"
echo ""
echo -e "${GREEN}3. Load the comprehensive prompt:${NC}"
echo -e "   ${CYAN}Read the file: $PROMPT_FILE${NC}"
echo ""
echo -e "${GREEN}4. Begin with Phase 1: Environment Setup${NC}"
echo ""
echo -e "${GREEN}5. Track progress in:${NC}"
echo -e "   ${CYAN}$SESSION_FILE${NC}"
echo ""

# 7. Create checkpoint directories
echo -e "${BLUE}>>> Step 6: Creating Work Directories${NC}"
mkdir -p docs/architecture
mkdir -p docs/user-guides
mkdir -p docs/tutorials
mkdir -p docs/reference
mkdir -p docs/testing
mkdir -p docs/contributors
mkdir -p tests/unit
mkdir -p tests/integration
mkdir -p tests/e2e
mkdir -p config
mkdir -p templates
mkdir -p scripts/workflows
echo -e "${GREEN}✓ Work directories created${NC}"
echo ""

# 8. Summary
echo -e "${MAGENTA}========================================${NC}"
echo -e "${GREEN}Session Initialized Successfully!${NC}"
echo -e "${MAGENTA}========================================${NC}"
echo ""
echo -e "${YELLOW}Session Details:${NC}"
echo -e "  Branch: ${CYAN}$BRANCH_NAME${NC}"
echo -e "  Tracker: ${CYAN}$SESSION_FILE${NC}"
echo -e "  Prompt: ${CYAN}$PROMPT_FILE${NC}"
echo ""
echo -e "${YELLOW}Ready for 30 hours of deep work! 🚀${NC}"
echo ""