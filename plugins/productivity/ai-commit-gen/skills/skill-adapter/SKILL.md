---
name: Generating AI-Powered Commit Messages
description: |
  Analyzes git diffs and generates conventional commit messages using AI. Activates when users mention "commit message", "git commit", "/commit", or need help writing commits. Creates professional commit messages following conventional commit standards by examining staged changes and determining appropriate type, scope, and description.
---

## Overview

This skill automatically generates professional commit messages by analyzing your git diff using AI. It examines your staged changes, determines the type of modification (feat, fix, docs, etc.), identifies the scope, and creates conventional commit messages that clearly describe what was changed and why.

## How It Works

1. **Analysis**: Examines `git status` and `git diff --cached` to understand staged changes
2. **Classification**: Determines commit type (feat/fix/docs/refactor/etc.) and scope based on files modified
3. **Generation**: Creates 2-3 conventional commit message options with varying detail levels
4. **Selection**: Presents options for user to choose and commit directly

## When to Use This Skill

- User says "generate commit message" or "write commit message"
- User types "/commit" or mentions "git commit"
- User asks "what should I commit this as?" or "help me commit"
- User mentions "conventional commits" or "commit standards"
- User says "I don't know what to write for this commit"

## Examples

### Example 1: Feature Addition
User request: "Generate a commit message for my changes"

The skill will:
1. Run `git diff --cached` to analyze staged authentication code changes
2. Generate: `feat(auth): implement JWT user authentication`
3. Offer detailed version: `feat(auth): implement JWT user authentication\n\nAdd email/password login with bcrypt hashing and token refresh`

### Example 2: Bug Fix
User request: "/commit"

The skill will:
1. Detect null pointer fix in validation logic
2. Generate: `fix(validation): handle null user input`
3. Provide context: `fix(validation): handle null user input\n\nPrevent crash when user object is null, return 401 instead`

### Example 3: Documentation Update
User request: "Help me commit these README changes"

The skill will:
1. Identify documentation changes in README.md
2. Generate: `docs(readme): add installation guide`
3. Offer expanded: `docs(readme): add installation guide\n\nInclude prerequisites and troubleshooting steps`

## Best Practices

- **Type Detection**: Automatically identifies feat/fix/docs/style/refactor/test/chore based on file patterns and change content
- **Scope Identification**: Uses directory structure and file names to determine appropriate scope (auth, api, ui, etc.)
- **Message Quality**: Ensures subject lines are under 50 characters, use imperative mood, and avoid periods
- **Breaking Changes**: Detects and flags breaking changes with proper BREAKING CHANGE footer
- **Issue References**: Suggests adding "Closes #123" or "Fixes #456" when appropriate

## Integration

Works seamlessly with git workflow - analyzes staged changes, generates messages, and can execute the commit command directly. Integrates with conventional commit standards and popular git hooks. Compatible with semantic versioning tools that parse conventional commits for automated releases.