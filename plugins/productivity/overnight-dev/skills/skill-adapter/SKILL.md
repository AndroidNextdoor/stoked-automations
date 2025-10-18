---
name: Running Overnight Development Sessions
description: |
  Orchestrates autonomous overnight development sessions where Claude works for 6-8 hours using TDD and Git hooks. Activates when users mention "overnight development", "autonomous coding", "work while I sleep", "TDD sessions", or "overnight-dev plugin". Sets up Git hooks that block commits until all tests pass, then runs continuous development cycles with automatic debugging and iteration until morning.
---

## Overview

This skill enables Claude to work autonomously overnight using test-driven development enforced by Git hooks. Users start a session before bed and wake up to fully tested, production-ready features that passed all quality gates.

## How It Works

1. **Setup Phase**: Install Git hooks that block commits until tests pass, configure TDD workflow, establish session goals
2. **Development Cycles**: Write failing tests first, implement features, debug until tests pass, commit only when green
3. **Autonomous Iteration**: When hooks block commits due to failing tests, automatically analyze errors and retry fixes
4. **Quality Enforcement**: Maintain test coverage, follow conventional commits, ensure clean code throughout the night

## When to Use This Skill

- User mentions "overnight development", "work while I sleep", or "autonomous coding"
- Requests for "TDD sessions", "overnight-dev", or "autonomous testing"
- Wants to "wake up to finished features" or "let Claude work overnight"
- Needs "continuous development" or "automated test-driven development"

## Examples

### Example 1: Feature Development Session
User request: "Set up overnight development to build JWT authentication with full test coverage"

The skill will:
1. Configure Git hooks and TDD workflow for the project
2. Start with failing authentication tests, then implement features iteratively
3. Debug and retry commits until all tests pass and coverage targets are met

### Example 2: Bug Fix Marathon
User request: "Run overnight session to fix all failing integration tests"

The skill will:
1. Analyze current test failures and prioritize fixes
2. Work through each failing test with TDD approach
3. Ensure no regressions while fixing issues throughout the night

### Example 3: Refactoring Session
User request: "Overnight refactoring session to improve code quality while maintaining 90% test coverage"

The skill will:
1. Set up coverage monitoring and quality gates
2. Refactor code incrementally, ensuring tests remain green
3. Improve architecture while maintaining or exceeding coverage targets

## Best Practices

- **Test-First Approach**: Always write failing tests before implementation to ensure proper TDD workflow
- **Incremental Commits**: Make small, focused commits that pass all quality gates
- **Error Analysis**: When hooks block commits, thoroughly analyze test failures before attempting fixes
- **Coverage Monitoring**: Maintain or improve test coverage throughout the session
- **Documentation**: Update documentation and commit messages following conventional commit standards

## Integration

Works seamlessly with existing testing frameworks (Jest, PyTest, RSpec, etc.) and CI/CD pipelines. Git hooks integrate with your current workflow without disrupting team practices. Sessions can be paused, resumed, or configured for specific time windows. Compatible with coverage tools, linters, and code quality checkers already in your project.