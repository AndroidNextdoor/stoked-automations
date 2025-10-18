---
name: Managing Plugin Development Workflows
description: |
  Automatically manages the complete plugin development lifecycle in the claude-code-plugins marketplace. Activates when users say "create plugin", "validate plugin", "audit plugin", "sync marketplace", or "bump version". Provides 5 specialized skills: Plugin Creator (scaffolds new plugins), Plugin Validator (checks compliance), Marketplace Manager (syncs catalogs), Plugin Auditor (security/quality review), and Version Bumper (semantic versioning). Handles repository structure, marketplace.json updates, schema validation, and automated workflows.
---

## Overview

The Skills Powerkit is a meta-plugin that automates plugin development workflows in the claude-code-plugins repository. It provides 5 specialized Agent Skills that handle everything from initial plugin creation to marketplace management and quality auditing.

## How It Works

1. **Trigger Detection**: Listens for specific phrases related to plugin management tasks
2. **Skill Selection**: Automatically selects the appropriate skill based on user intent
3. **Workflow Execution**: Runs repository-specific workflows with full context of marketplace structure
4. **Validation & Sync**: Ensures all changes meet standards and updates catalogs automatically

## When to Use This Skill

- Creating new plugins from scratch with proper scaffolding
- Validating existing plugins for marketplace compliance
- Auditing plugins for security vulnerabilities and best practices
- Managing marketplace catalog synchronization
- Updating plugin versions with semantic versioning
- Performing quality checks before commits

## Examples

### Example 1: Creating a New Plugin
User request: "Create a security plugin called 'vulnerability-scanner' with CLI commands"

The skill will:
1. Generate complete directory structure in plugins/security/vulnerability-scanner/
2. Create plugin.json with proper schema and metadata
3. Generate README.md, LICENSE, and component files
4. Add entry to marketplace.extended.json
5. Run npm run sync-marketplace to update catalogs
6. Validate entire plugin structure

### Example 2: Validating Plugin Compliance
User request: "Validate the skills-powerkit plugin for marketplace readiness"

The skill will:
1. Check plugin.json against official schema
2. Verify all required files exist (README, LICENSE, etc.)
3. Validate markdown frontmatter in skill files
4. Check script permissions and security
5. Ensure marketplace catalog entries are correct
6. Generate comprehensive validation report

### Example 3: Marketplace Synchronization
User request: "Add the new data-processor plugin to marketplace"

The skill will:
1. Update marketplace.extended.json with plugin metadata
2. Execute npm run sync-marketplace command
3. Validate both marketplace.json and marketplace.extended.json
4. Check for duplicate entries or conflicts
5. Verify catalog integrity and structure

### Example 4: Security Audit
User request: "Audit the file-manager plugin for production deployment"

The skill will:
1. Scan all files for hardcoded secrets or credentials
2. Check for known security vulnerabilities in dependencies
3. Validate proper permission handling in scripts
4. Review CLAUDE.md compliance and best practices
5. Generate quality score and security recommendations

## Best Practices

- **Repository Context**: Always works within claude-code-plugins repository structure
- **Marketplace Sync**: Automatically syncs catalogs after any plugin modifications  
- **Schema Compliance**: Validates against official plugin.json schema requirements
- **Security First**: Includes security scanning in all validation workflows
- **Version Management**: Follows semantic versioning standards for all updates
- **Quality Gates**: Ensures plugins meet marketplace standards before approval

## Integration

Works seamlessly with the claude-code-plugins repository ecosystem, including marketplace.json synchronization scripts, validation schemas, and automated workflows. Integrates with existing git workflows and can be used alongside other development tools without conflicts. Designed specifically for the two-tier marketplace structure (marketplace.json and marketplace.extended.json).