---
name: Accessibility Testing with Color Analysis
description: |
  Automatically activate when users mention accessibility testing, WCAG compliance,
  color contrast issues, or need to audit a website for a11y violations. Combines
  automated accessibility scans with visual color analysis using screenshots.

  Trigger phrases: "test accessibility", "check WCAG", "color contrast", "a11y audit",
  "accessibility issues", "can users read this", "contrast ratio", "colorblind"
---

# Accessibility Testing Skill with Color Analysis

## When to Activate

This skill automatically activates when the user mentions:
- Accessibility testing or audits
- WCAG compliance checking
- Color contrast issues or concerns
- Visual readability problems
- Colorblind accessibility
- Text visibility on backgrounds
- Any mention of "a11y" or "accessibility"

## How It Works

### 1. Automated Accessibility Scan
First, run automated accessibility tests:
- HTML validation
- ARIA attribute checks
- Semantic structure analysis
- Keyboard navigation testing
- Screen reader compatibility

### 2. Visual Color Analysis
Then, enhance with visual color testing:
- Take full-page screenshot using Playwright
- Extract all color combinations visually
- Calculate exact contrast ratios (WCAG formula)
- Test against AA and AAA standards
- Simulate color blindness (protanopia, deuteranopia, tritanopia)
- Evaluate aesthetic harmony

### 3. Comprehensive Report
Combine both analyses into actionable report:
- Critical accessibility violations
- Specific contrast ratio failures
- Color blindness issues
- Keyboard navigation problems
- Screen reader issues
- Prioritized fixes with exact solutions

## Integration with Color Specialist

When color issues are detected, automatically invoke the color-expert agent:

```bash
# If contrast violations found
/color-expert

Analyze these failing combinations:
- #777777 on #FFFFFF (3.5:1 - fails AA)
- #4ECDC4 button with white text (1.8:1 - fails all)
- Link color #5C7CFA on white (2.9:1 - fails)
```

## Example Workflow

**User says:** "Test the accessibility of https://mysite.com"

**Skill Response:**
```
🔍 RUNNING COMPREHENSIVE ACCESSIBILITY AUDIT

Step 1: Automated Accessibility Scan
✅ HTML validation passed
✅ ARIA attributes correct
⚠️ 2 heading hierarchy issues found
❌ 3 missing alt texts found

Step 2: Visual Color Analysis
[Capturing screenshot with Playwright...]
[Analyzing color combinations...]

❌ CRITICAL: 5 color contrast failures detected

Step 3: Combined Report

=== ACCESSIBILITY VIOLATIONS ===

🚨 WCAG AA Failures (5):

1. Body text contrast
   #666666 on #FFFFFF = 3.5:1 ❌ Needs 4.5:1
   Fix: Use #595959 for 7.0:1 ✅ AAA

2. Button contrast
   White text on #4ECDC4 = 1.8:1 ❌ Needs 4.5:1
   Fix: Use #006B62 background for 7.5:1 ✅ AAA

3. Link insufficient contrast
   #5C7CFA on white = 2.9:1 ❌ Needs 3:1
   Fix: Use #3654D1 for 5.2:1 ✅ AA/AAA

4. Missing alt text (3 images)
   Fix: Add descriptive alt attributes

5. Heading hierarchy skip (h2 → h4)
   Fix: Use h3 between h2 and h4

=== COLOR BLINDNESS ISSUES ===

🔴 Protanopia: Red error text indistinguishable
   Fix: Add error icon (✗) or use blue

=== PRIORITY FIXES ===

High Priority (Before Launch):
1. Fix all 5 contrast ratios ← User cannot read
2. Add missing alt texts ← Screen reader users blocked
3. Fix heading hierarchy ← Navigation broken

Medium Priority (Soon):
4. Add colorblind-safe indicators
5. Test keyboard navigation thoroughly

[Detailed CSS fixes provided below...]
```

## Tools Used

1. **Playwright MCP** - Screenshot capture
2. **Color Expert Agent** - Contrast calculations
3. **Automated scanners** - HTML/ARIA validation
4. **Manual inspection** - Complex interactions

## Best Practices

- Always capture screenshots for visual analysis
- Calculate ALL text/background combinations
- Test color blindness scenarios
- Provide specific hex codes that pass
- Prioritize by user impact
- Give before/after comparisons

## Related Commands

- `/analyze-colors [url]` - Deep color analysis
- `/color-expert` - Manual color consultation
- `/accessibility-test-scanner` - Full a11y audit

## Success Criteria

Skill successfully completes when:
- All color contrast ratios calculated
- WCAG violations documented with fixes
- Color blindness issues identified
- Specific passing alternatives provided
- User has clear action plan

## Activation

When user mentions accessibility or color contrast, immediately:
1. Activate this skill
2. Run automated scans
3. Take screenshot for color analysis
4. Calculate all contrast ratios
5. Test color blindness scenarios
6. Deliver combined report with specific fixes
