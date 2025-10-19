# Color & Accessibility Specialist

![Version](https://img.shields.io/badge/version-2025.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Category](https://img.shields.io/badge/category-design-purple)

**Elite color theory and accessibility expert** with exceptional eye for contrast issues, WCAG compliance, and aesthetic harmony. Automatically analyzes websites with screenshots and provides specific, actionable fixes.

---

## Overview

This plugin provides an **AI color specialist** that combines visual analysis, mathematical precision, and deep color theory knowledge to identify accessibility violations and aesthetic problems that human designers often miss.

### What Makes This Special

- **🎨 Visual Analysis** - Takes screenshots and analyzes what users actually see
- **📐 Mathematical Precision** - Calculates exact contrast ratios using WCAG formulas
- **👁️ Color Blindness Testing** - Simulates protanopia, deuteranopia, tritanopia
- **✨ Aesthetic Expertise** - Evaluates color harmony, balance, and professional polish
- **🔧 Specific Fixes** - Provides exact hex codes that pass compliance
- **📊 Comprehensive Reports** - Detailed analysis with severity ratings

---

## Features

### 1. Automated Color Analysis
- Takes full-page screenshots of websites
- Extracts all colors from visual inspection
- Calculates contrast ratios for every combination
- Tests against WCAG 2.1 AA and AAA standards

### 2. WCAG Compliance Testing
- **Normal Text**: Minimum 4.5:1 (AA), 7:1 (AAA)
- **Large Text**: Minimum 3:1 (AA), 4.5:1 (AAA)
- **UI Components**: Minimum 3:1 contrast
- **Focus Indicators**: 3:1 against adjacent colors
- **Graphical Objects**: 3:1 minimum

### 3. Color Blindness Simulation
- **Protanopia** (red-blind) - 1% of males
- **Deuteranopia** (green-blind) - 1% of males
- **Tritanopia** (blue-blind) - 0.01% of population
- Identifies problematic color combinations
- Suggests colorblind-safe alternatives

### 4. Aesthetic Evaluation
- Color harmony analysis (complementary, analogous, triadic)
- Temperature balance (warm vs cool)
- Saturation and brightness distribution
- Visual hierarchy effectiveness
- Professional polish assessment
- Brand consistency evaluation

### 5. Actionable Recommendations
- Specific hex codes that pass compliance
- Multiple alternatives at different contrast levels
- Quick wins vs major enhancements
- Complete updated color palette
- CSS variable suggestions

---

## Installation

```bash
# Claude Code
/plugin install color-accessibility-specialist@stoked-automations

# Prerequisites (for screenshot analysis)
/plugin install playwright-mcp@stoked-automations
```

---

## Usage

### Example 1: Analyze Website Colors

```bash
# Activate the color expert agent
/color-expert

# Analyze a live website
/analyze-colors https://example.com
```

**Output:**
```
🎨 COLOR ANALYSIS REPORT: example.com

=== SCREENSHOT CAPTURED ===
Full-page screenshot saved → analyzing visual colors...

=== CONTRAST ANALYSIS ===

❌ CRITICAL ISSUES (3 found)

1. Gray text on white background
   Current: #777777 on #FFFFFF = 3.5:1 ❌ FAILS AA
   Required: 4.5:1 minimum
   Fix: Use #595959 for 7.0:1 ✅ AAA compliant

2. Button text contrast
   Current: #FFFFFF on #4ECDC4 = 1.8:1 ❌ FAILS ALL
   Required: 4.5:1 minimum
   Fix: Use #006B62 background for 7.5:1 ✅ AAA

3. Link color insufficient
   Current: #5C7CFA on #FFFFFF = 2.9:1 ❌ FAILS AA
   Required: 3:1 minimum OR underline
   Fix: Use #3654D1 for 5.2:1 ✅ AA/AAA

=== COLOR BLINDNESS ISSUES ===

🔴 Protanopia (Red-Blind):
- Red error text (#DC2626) becomes brownish, hard to distinguish
- 🔧 FIX: Add error icon (✗) or use blue (#2563EB)

=== AESTHETIC ASSESSMENT ===

Harmony: 6/10 - Colors lack cohesion
Balance: 7/10 - Good distribution
Hierarchy: 5/10 - Too many accent colors (4 found, recommend 2-3)
Polish: 6/10 - Amateur color choices

Overall Grade: C+ - Functional but needs refinement

=== RECOMMENDATIONS ===

Updated Palette (Fully Accessible):
```css
--bg-primary: #FFFFFF;
--text-primary: #1A1A1A;    /* 16.1:1 ✅ */
--text-secondary: #595959;  /* 7.0:1 ✅ */
--accent-primary: #006B62;  /* 7.5:1 with white text ✅ */
--accent-secondary: #3654D1; /* 5.2:1 ✅ */
--error: #B91C1C;           /* 5.9:1 ✅ */
--success: #047857;         /* 5.3:1 ✅ */
```
```

### Example 2: Analyze Code Colors

```bash
/color-expert

# Paste CSS or show file
Analyze these colors:
--background: #1e1e1e
--text: #d4d4d4
--accent: #007acc
```

**Output:**
```
🎨 CODE COLOR ANALYSIS

=== CONTRAST RATIOS ===

✅ Text on background
#d4d4d4 on #1e1e1e = 10.4:1 ✅ AAA compliant
Excellent readability for dark theme

⚠️ Accent on background
#007acc on #1e1e1e = 4.2:1 ⚠️ Close to failing
Borderline for AA (needs 4.5:1)
Recommendation: Lighten to #0098FF for 5.8:1 ✅

=== DARK MODE OPTIMIZATION ===

Current Issues:
- Pure black (#1e1e1e) can cause halation on OLED
- Accent could be brighter for better visibility

Improved Palette:
--background: #121212;      /* Softer black */
--text: #E8E8E8;            /* Slightly dimmed white */
--accent: #0098FF;          /* 5.8:1 ✅ AAA for large text */
```

### Example 3: Quick Color Check

```bash
/color-expert

Does #666666 text work on #FFFFFF background?
```

**Output:**
```
❌ NO - This combination FAILS accessibility

#666666 on #FFFFFF = 3.5:1 ❌ FAILS WCAG AA
Required: 4.5:1 minimum for normal text

This is a very common mistake! #666 looks fine to
designers but fails for users with low vision, older
users, or anyone in bright sunlight.

Passing Alternatives:
1. #595959 → 7.0:1 ✅ AAA (best choice)
2. #646464 → 6.0:1 ✅ AA (good)
3. #707070 → 4.6:1 ✅ AA (minimum, not recommended)

Recommendation: Use #595959. It provides excellent
readability without being too harsh.
```

---

## Commands

### `/color-expert`
Activates the elite color specialist agent for manual analysis

### `/analyze-colors [url]`
Takes screenshot of website and performs comprehensive color analysis

---

## Integration with Other Plugins

### Works With
- **playwright-mcp** - Screenshot capture for visual analysis
- **accessibility-test-scanner** - Comprehensive a11y audits
- **visual-regression-tester** - Compare color changes over time
- **design-to-code** - Validate design implementation colors

### Enhances
- **UI/UX workflows** - Ensures accessible color choices
- **Design reviews** - Catches contrast issues early
- **Compliance testing** - WCAG 2.1 validation
- **Brand guidelines** - Maintain color consistency

---

## Color Analysis Formulas

### Relative Luminance (WCAG 2.1)
```
For RGB values 0-255:
1. Convert to 0-1 range: RsRGB = R/255
2. Linearize (gamma correction):
   if RsRGB ≤ 0.03928:
       R = RsRGB / 12.92
   else:
       R = ((RsRGB + 0.055) / 1.055) ^ 2.4
3. Calculate luminance:
   L = 0.2126 * R + 0.7152 * G + 0.0722 * B
```

### Contrast Ratio
```
Contrast = (Lmax + 0.05) / (Lmin + 0.05)
Where Lmax is lighter color, Lmin is darker
```

### WCAG Standards
- **AA Normal** (< 18pt): 4.5:1
- **AA Large** (≥ 18pt): 3:1
- **AAA Normal**: 7:1
- **AAA Large**: 4.5:1
- **UI Components**: 3:1

---

## Common Issues Detected

### Automatic Red Flags
- Gray text on white (#777 on #FFF = 3.5:1 ❌)
- Light text on light backgrounds
- Orange/yellow on white (often fails)
- Red/green as only differentiators (colorblind issue)
- Low contrast borders (frequently ignored)
- Focus indicators without 3:1 contrast
- Text overlaying images without backgrounds
- Gradient backgrounds with inconsistent contrast

---

## Best Practices

### For Developers
1. Always test with color specialist before launch
2. Use CSS variables for consistent color usage
3. Provide multiple contrast levels (AA and AAA)
4. Include focus indicators with proper contrast
5. Never rely on color alone for meaning

### For Designers
1. Design with grayscale first, add color second
2. Test in colorblind simulators
3. Provide designs with contrast ratios documented
4. Use tools to validate before handoff
5. Consider light/dark mode simultaneously

---

## Resources

### WCAG Guidelines
- [WCAG 2.1 Color Contrast](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)
- [Understanding SC 1.4.3](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum)
- [Understanding SC 1.4.6](https://www.w3.org/WAI/WCAG21/Understanding/contrast-enhanced)

### Color Tools
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [Colorblind Simulator](https://www.color-blindness.com/coblis-color-blindness-simulator/)
- [Coolors Palette Generator](https://coolors.co/)

---

## License

MIT License

---

## Version History

### v2025.0.0 (2025-10-18)
- Initial release
- Visual screenshot analysis with Playwright integration
- WCAG 2.1 AA/AAA compliance testing
- Color blindness simulation (protanopia, deuteranopia, tritanopia)
- Aesthetic evaluation with scoring
- Specific hex code recommendations
- Elite color expert agent
