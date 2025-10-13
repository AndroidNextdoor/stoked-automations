# Pull Request

## Type of Change

<!-- Select all that apply -->

- [ ] 🔌 New plugin submission
- [ ] ⬆️ Plugin update/enhancement
- [ ] 📚 Documentation improvement
- [ ] 🐛 Bug fix
- [ ] 🏗️ Infrastructure/CI improvement
- [ ] 🎨 Marketplace website update
- [ ] 🔧 Configuration change
- [ ] 🧪 Tests added/updated
- [ ] 🔐 Security fix
- [ ] 🚀 Performance improvement
- [ ] ♻️ Refactoring
- [ ] 🌐 Translation/i18n
- [ ] 🗑️ Deprecation/removal
- [ ] 📦 Dependency update
- [ ] 🎯 Other (please describe)

## Description

<!-- Provide a clear and concise description of your changes -->

**Summary:**

**Motivation:**

**Related Issues:**
<!-- Link to related issues: Closes #123, Fixes #456 -->

## Plugin Details (for plugin submissions/updates)

**Plugin Name:**
**Category:**
**Version:**
**Keywords:**

**Components Included:**
- [ ] Commands (how many: )
- [ ] Agents (how many: )
- [ ] Hooks (how many: )
- [ ] Scripts (how many: )
- [ ] MCP servers

**Dependencies:**
<!-- List any external dependencies required -->

## Checklist

### For All PRs
- [ ] I have read the [CONTRIBUTING.md](../CONTRIBUTING.md) guidelines
- [ ] My code follows the project's style and conventions
- [ ] I have performed a self-review of my code
- [ ] I have commented my code where necessary
- [ ] My changes generate no new warnings or errors
- [ ] Documentation has been updated (if applicable)

### For Plugin Submissions/Updates
- [ ] Plugin has valid `.claude-plugin/plugin.json` with all required fields
- [ ] `plugin.json` validated with `jq empty plugin.json`
- [ ] README.md is comprehensive with installation, usage, and examples
- [ ] LICENSE file is included (MIT or Apache-2.0 recommended)
- [ ] All shell scripts are executable (`chmod +x scripts/*.sh`)
- [ ] No hardcoded secrets, API keys, or credentials
- [ ] Marketplace.json has been updated with plugin entry
- [ ] Plugin tested locally with `/plugin install`
- [ ] Commands include YAML frontmatter (name, description)
- [ ] Agents include YAML frontmatter (name, description, model)
- [ ] Hooks use `${CLAUDE_PLUGIN_ROOT}` for portable paths
- [ ] All JSON files are valid (`jq empty *.json`)

### For Marketplace Website Changes
- [ ] Website builds successfully (`cd marketplace && npm run build`)
- [ ] No broken links or missing assets
- [ ] Mobile-responsive design verified
- [ ] SEO metadata updated (if applicable)
- [ ] Accessibility standards followed (WCAG 2.1)

### For Documentation Changes
- [ ] Spelling and grammar checked
- [ ] Code examples tested and working
- [ ] Links verified and not broken
- [ ] Screenshots/diagrams updated (if applicable)
- [ ] Version references updated

## Testing Evidence

<!-- Describe how you tested your changes -->

**Test Environment:**
- OS:
- Claude Code Version:
- Python Version (if applicable):
- Node Version (if applicable):

**Test Commands Run:**
```bash
# Example:
/plugin install my-plugin@test
/my-command --option value
```

**Test Results:**
<!-- Paste relevant output, screenshots, or describe results -->

**Edge Cases Tested:**
- [ ] Works with minimal configuration
- [ ] Handles errors gracefully
- [ ] Works across different platforms (macOS, Linux, Windows)
- [ ] Performance is acceptable for large inputs
- [ ] Security considerations addressed

## Breaking Changes

<!-- Does this PR introduce any breaking changes? -->

- [ ] Yes (describe below)
- [ ] No

**If yes, describe:**

## Screenshots / Recordings (if applicable)

<!-- Add screenshots or recordings showing your changes in action -->

## Performance Impact

<!-- Does this change affect performance? -->

- [ ] No performance impact
- [ ] Minor performance impact (negligible)
- [ ] Moderate performance impact (describe below)
- [ ] Significant performance impact (describe and justify below)

## Security Considerations

<!-- Any security implications? -->

- [ ] No security impact
- [ ] Reviewed for common vulnerabilities (XSS, injection, etc.)
- [ ] No sensitive data exposure
- [ ] Secrets management properly handled
- [ ] Input validation implemented

## Rollback Plan

<!-- How can these changes be rolled back if needed? -->

## Additional Notes

<!-- Any other information reviewers should know -->

## Reviewer Checklist (for maintainers)

- [ ] Code quality meets standards
- [ ] Tests pass (CI/CD green)
- [ ] Security review completed
- [ ] Documentation is clear and complete
- [ ] Breaking changes documented
- [ ] Version bumped appropriately
- [ ] CHANGELOG.md updated
- [ ] Ready to merge

---

**By submitting this PR, I confirm:**
- [ ] I have the right to submit this code under the project's license
- [ ] I understand my contributions will be publicly available
- [ ] I agree to the project's [Code of Conduct](../CODE_OF_CONDUCT.md) (if exists)
