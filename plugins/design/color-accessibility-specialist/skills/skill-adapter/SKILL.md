---
name: Color & Accessibility Specialist
description: |
  Elite color theory and accessibility expert with visual analysis capabilities. Activates when users mention:
  - Color contrast, accessibility, or WCAG compliance issues
  - Analyzing website or UI colors for readability
  - Testing colors for color blindness (protanopia, deuteranopia, tritanopia)
  - Evaluating color harmony, aesthetic balance, or professional polish
  - Getting specific hex codes that pass AA/AAA standards
  - Checking if color combinations are accessible
  - Screenshot analysis for color extraction
  - Dark mode color optimization
---

## How It Works

This plugin provides an AI color specialist that combines visual screenshot analysis, mathematical contrast ratio calculations, and deep color theory expertise to identify accessibility violations and aesthetic problems.

**Analysis Workflow:**
1. **Visual Inspection** - Takes screenshots using Playwright MCP to analyze what users actually see
2. **Color Extraction** - Identifies all colors from visual inspection (no relying on CSS)
3. **Contrast Calculation** - Uses WCAG 2.1 formulas to calculate exact contrast ratios
4. **Compliance Testing** - Tests against AA (4.5:1) and AAA (7:1) standards
5. **Color Blindness Simulation** - Tests protanopia, deuteranopia, tritanopia
6. **Aesthetic Evaluation** - Assesses harmony, balance, hierarchy, polish
7. **Specific Fixes** - Provides exact hex codes with contrast ratios that pass

**Key Capabilities:**
- Mathematical precision using WCAG relative luminance formulas
- Visual screenshot analysis (not just CSS inspection)
- Colorblind simulations for 3 types of color vision deficiency
- Aesthetic scoring (harmony, balance, hierarchy, polish)
- Specific hex code recommendations with exact contrast ratios

## When to Use This Skill

Activate when users mention:

- **Contrast & Compliance:**
  - "Check color contrast"
  - "Is this WCAG compliant?"
  - "Does this pass AA/AAA standards?"
  - "Text is hard to read"
  - "Analyze website colors"

- **Color Blindness:**
  - "Test for color blindness"
  - "Is this colorblind friendly?"
  - "Red-green color issues"
  - "Protanopia/deuteranopia/tritanopia testing"

- **Specific Color Questions:**
  - "Does #666666 work on white background?"
  - "What color should I use for text?"
  - "Give me accessible alternatives"
  - "Fix this color combination"

- **Aesthetic Evaluation:**
  - "Evaluate color harmony"
  - "Does my color palette look professional?"
  - "Too many accent colors"
  - "Color balance issues"

- **Dark Mode:**
  - "Optimize dark mode colors"
  - "OLED halation issues"
  - "Dark theme contrast"

## Examples

**User:** "Does #666666 text work on #FFFFFF background?"

**Skill activates** → Calculates contrast ratio:

```
❌ NO - This combination FAILS accessibility

#666666 on #FFFFFF = 3.5:1 ❌ FAILS WCAG AA
Required: 4.5:1 minimum for normal text

This is a very common mistake! #666 looks fine to
designers but fails for users with low vision.

Passing Alternatives:
1. #595959 → 7.0:1 ✅ AAA (best choice)
2. #646464 → 6.0:1 ✅ AA (good)
3. #707070 → 4.6:1 ✅ AA (minimum)

Recommendation: Use #595959 for excellent readability.
```

---

**User:** "Analyze the colors on https://stokedautomations.com"

**Skill activates** → Takes screenshot using Playwright MCP, extracts colors, calculates all contrast ratios:

```
🎨 COLOR ANALYSIS REPORT

=== SCREENSHOT CAPTURED ===
Full-page screenshot → analyzing visual colors...

=== CRITICAL ISSUES (3) ===

1. Gray text on white background
   #777777 on #FFFFFF = 3.5:1 ❌ FAILS AA
   Fix: #595959 → 7.0:1 ✅ AAA

2. Button text contrast
   #FFFFFF on #4ECDC4 = 1.8:1 ❌ FAILS ALL
   Fix: #006B62 background → 7.5:1 ✅ AAA

3. Link color insufficient
   #5C7CFA on #FFFFFF = 2.9:1 ❌ FAILS AA
   Fix: #3654D1 → 5.2:1 ✅ AA/AAA

=== COLOR BLINDNESS ISSUES ===

🔴 Protanopia (Red-Blind):
Red error text (#DC2626) becomes brownish
🔧 FIX: Add icon (✗) or use blue (#2563EB)

=== AESTHETIC ASSESSMENT ===

Harmony: 6/10 - Colors lack cohesion
Hierarchy: 5/10 - Too many accents (4 found)
Polish: 6/10 - Amateur color choices
Overall Grade: C+

=== UPDATED PALETTE ===

--text-primary: #1A1A1A;    /* 16.1:1 ✅ */
--text-secondary: #595959;  /* 7.0:1 ✅ */
--accent-primary: #006B62;  /* 7.5:1 ✅ */
--accent-secondary: #3654D1; /* 5.2:1 ✅ */
```

---

**User:** "I need to optimize these dark mode colors"

**Skill activates** → Provides dark mode analysis:

```
🎨 DARK MODE OPTIMIZATION

Current:
--background: #1e1e1e
--text: #d4d4d4
--accent: #007acc

=== ISSUES ===

⚠️ Pure black (#1e1e1e) can cause OLED halation
⚠️ Accent #007acc = 4.2:1 (borderline, needs 4.5:1)

=== IMPROVED PALETTE ===

--background: #121212;  /* Softer black */
--text: #E8E8E8;        /* 10.8:1 ✅ AAA */
--accent: #0098FF;      /* 5.8:1 ✅ AAA large text */

This prevents halation and improves accent visibility.
```

---

**User:** "Is my design accessible for colorblind users?"

**Skill activates** → Simulates 3 types of color blindness:

```
🎨 COLOR BLINDNESS SIMULATION

Testing: Protanopia (red-blind), Deuteranopia (green-blind), Tritanopia (blue-blind)

❌ CRITICAL: Red error (#DC2626) and green success (#10B981)
   - Both appear muddy brown for red-green colorblind users
   - Affects 8% of males, 0.5% of females

🔧 FIXES:
1. Add icons (✗ for error, ✓ for success)
2. Use position/shape differences
3. Alternative colors:
   - Error: #2563EB (blue) → distinct for all types
   - Success: #047857 (darker green) → better separation

🟢 PASSES: Your primary blue (#3654D1) is colorblind-safe
```

## Available Commands

### `/color-expert`
Activates the elite color specialist agent for interactive analysis

**Use for:**
- Complex color evaluations
- Multiple color combinations to test
- Design reviews requiring back-and-forth
- Learning color theory and accessibility

### `/analyze-colors [url]`
Takes screenshot of live website and performs comprehensive analysis

**Use for:**
- Full website color audits
- Production site compliance checks
- Competitor analysis
- Visual color extraction (not just CSS)

**Requires:** Playwright MCP server for screenshot capability

## WCAG Standards Reference

### Contrast Requirements

| Content Type | WCAG AA | WCAG AAA |
|--------------|---------|----------|
| Normal text (<18pt) | 4.5:1 | 7:1 |
| Large text (≥18pt) | 3:1 | 4.5:1 |
| UI components | 3:1 | 3:1 |
| Focus indicators | 3:1 | 3:1 |
| Graphical objects | 3:1 | 3:1 |

### Formulas Used

**Relative Luminance (WCAG 2.1):**
```
For RGB 0-255:
1. Convert to 0-1: RsRGB = R/255
2. Linearize (gamma correction):
   if RsRGB ≤ 0.03928: R = RsRGB / 12.92
   else: R = ((RsRGB + 0.055) / 1.055) ^ 2.4
3. L = 0.2126 * R + 0.7152 * G + 0.0722 * B
```

**Contrast Ratio:**
```
Contrast = (Lmax + 0.05) / (Lmin + 0.05)
```

## Common Failing Combinations

The specialist automatically flags these frequent mistakes:

| Combination | Ratio | Status | Fix |
|-------------|-------|--------|-----|
| #777 on #FFF | 3.5:1 | ❌ FAILS | #595959 (7.0:1 ✅) |
| #666 on #FFF | 3.5:1 | ❌ FAILS | #595959 (7.0:1 ✅) |
| Orange/yellow on white | Often <3:1 | ❌ FAILS | Darken significantly |
| Light text on light bg | <4.5:1 | ❌ FAILS | Increase contrast |
| Text on gradients | Variable | ⚠️ RISKY | Add solid backgrounds |

## Integration with Other Tools

**Works With:**
- **playwright-mcp** - Screenshot capture for visual analysis (recommended)
- **accessibility-test-scanner** - Comprehensive a11y audits beyond color
- **design-to-code** - Validate design implementation
- **visual-regression-tester** - Track color changes over time

**Prerequisites:**
- Playwright MCP server (for `/analyze-colors` command with screenshots)
- Installation: `/plugin install playwright-mcp@stoked-automations`

## Best Practices Enforced

**ALWAYS:**
- Calculate exact contrast ratios (no guessing)
- Provide specific hex codes with ratios that pass
- Test for all 3 types of color blindness
- Explain WHY combinations fail (education)
- Offer multiple alternatives at different levels (AA/AAA)
- Consider aesthetic harmony, not just compliance

**NEVER:**
- Accept #666 or #777 gray on white (common failing colors)
- Rely on color alone for meaning (add icons/shapes)
- Skip colorblind simulation for critical UI
- Provide alternatives without exact contrast ratios
- Ignore aesthetic scoring (professional polish matters)

## Color Blindness Types

| Type | Affects | Population | Key Issue |
|------|---------|------------|-----------|
| Protanopia | Red perception | 1% males | Red appears brownish/dark |
| Deuteranopia | Green perception | 1% males | Green appears beige |
| Tritanopia | Blue perception | 0.01% | Blue/yellow confusion |

Combined: **~8% of males, 0.5% of females** have some form of color vision deficiency.

## Resources

**WCAG Guidelines:**
- WCAG 2.1 Color Contrast (SC 1.4.3, 1.4.6)
- Understanding Contrast Minimum
- Non-text Contrast (SC 1.4.11)

**Tools:**
- WebAIM Contrast Checker
- Colorblind Simulator (Coblis)
- Coolors Palette Generator

## Version & License

- **Version:** 2025.0.0
- **License:** MIT
- **Author:** Stoked Automations (andrew@stokedautomation.com)
- **Repository:** https://github.com/AndroidNextdoor/stoked-automations
