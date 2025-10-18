---
name: Auto-formatting Code Files
description: |
  Automatically formats JavaScript, TypeScript, JSON, CSS, and Markdown files after Claude edits them using Prettier. Activates when users mention "format", "formatting", "prettier", "clean up code", "fix indentation", or "auto-format". Uses post-edit hooks to ensure consistent code style without manual intervention. Requires Node.js and works with npx to run Prettier on modified files.
---

## Overview
This skill automatically formats code files using Prettier after Claude makes edits. It uses post-tool-use hooks to detect when files are modified and applies consistent formatting without requiring manual commands.

## How It Works
1. **Hook Detection**: Monitors Write and Edit tool usage through PostToolUse hooks
2. **File Analysis**: Identifies supported file types (JS, TS, JSON, CSS, MD) that were modified
3. **Auto-Formatting**: Runs Prettier via npx to format the edited files automatically

## When to Use This Skill
- When working on projects that need consistent code formatting
- After making code edits that may have inconsistent indentation or style
- When users mention wanting cleaner, properly formatted code
- For maintaining code quality standards across JavaScript/TypeScript projects

## Examples

### Example 1: JavaScript File Editing
User request: "Fix the logic in utils.js and make sure it's properly formatted"

The skill will:
1. Detect when Claude edits utils.js using the Write tool
2. Automatically run Prettier to format the file with consistent indentation and style

### Example 2: Multiple File Changes
User request: "Update these TypeScript files and ensure they're clean"

The skill will:
1. Monitor each file edit operation
2. Apply Prettier formatting to each modified .ts file automatically

### Example 3: JSON Configuration
User request: "Update package.json with new dependencies"

The skill will:
1. Detect the JSON file modification
2. Format the JSON with proper indentation and structure using Prettier

## Best Practices
- **Prerequisites**: Ensure Node.js is installed for npx Prettier access
- **File Types**: Works best with JS, TS, JSON, CSS, and Markdown files
- **Automation**: Runs silently in background - no manual formatting commands needed
- **Integration**: Combines well with linting and code quality plugins

## Integration
Works seamlessly with other development plugins by ensuring all code modifications maintain consistent formatting. The hook-based approach means formatting happens automatically after any file editing operation, supporting continuous code quality maintenance throughout the development workflow.