---
name: analyze-colors
description: Take screenshot of a webpage and analyze all colors for contrast issues, accessibility violations, and aesthetic problems. Provides WCAG compliance report with specific fixes.
model: sonnet
---

# Visual Color Analysis Command

## Purpose
This command launches a browser, captures a screenshot of the specified URL, and performs comprehensive color analysis from a user's visual perspective.

## Workflow

### Step 1: Capture Screenshot
Use Playwright MCP to:
1. Launch browser (headless or headed for debugging)
2. Navigate to the URL
3. Wait for page to fully load
4. Take full-page screenshot
5. Save screenshot for analysis

**Commands:**
```bash
# Launch browser
/mcp playwright launch_browser browserType="chromium" headless=true

# Navigate to page
/mcp playwright navigate url="[USER_PROVIDED_URL]" waitUntil="networkidle"

# Take screenshot
/mcp playwright screenshot path="./color-analysis.png" fullPage=true
```

### Step 2: Read Screenshot
Use the Read tool to load the screenshot:
```bash
Read file_path="./color-analysis.png"
```

### Step 3: Extract Colors from Visual
Analyze the screenshot visually and identify:
- Background colors in different sections
- Text colors (headings, body, links, buttons)
- Accent colors (borders, highlights, icons)
- Interactive element colors (buttons, inputs, focus states)
- Alert/status colors (success, warning, error, info)

### Step 4: Calculate Contrast Ratios
For EVERY text/background combination found:
1. Identify foreground color (text)
2. Identify background color
3. Calculate relative luminance for both
4. Calculate contrast ratio
5. Test against WCAG AA (4.5:1) and AAA (7:1)
6. Flag violations

### Step 5: Test Color Blindness
Mentally simulate how colors appear with:
- Protanopia (no red cones)
- Deuteranopia (no green cones)
- Tritanopia (no blue cones)

Identify combinations that become indistinguishable.

### Step 6: Evaluate Aesthetics
- Color harmony and balance
- Visual hierarchy effectiveness
- Professional polish level
- Brand consistency
- Temperature and weight distribution

### Step 7: Generate Report
Provide comprehensive report with:
- ✅ Passing combinations
- ❌ Failing combinations with specific fixes
- ⚠️ Close calls (4.0-4.4:1)
- 🔴 Color blindness issues
- 🎨 Aesthetic recommendations
- 📋 Complete passing color palette

## Formulas

### Relative Luminance (sRGB)
```
For RGB values 0-255, convert to 0-1 range:
RsRGB = R/255
GsRGB = G/255
BsRGB = B/255

Linearize (gamma correction):
if RsRGB <= 0.03928:
    R = RsRGB / 12.92
else:
    R = ((RsRGB + 0.055) / 1.055) ^ 2.4

Same for G and B

Relative Luminance:
L = 0.2126 * R + 0.7152 * G + 0.0722 * B
```

### Contrast Ratio
```
Contrast = (Lmax + 0.05) / (Lmin + 0.05)
Where Lmax is lighter color, Lmin is darker
```

### WCAG Requirements
- **AA Normal Text** (< 18pt): 4.5:1
- **AA Large Text** (≥ 18pt or 14pt bold): 3:1
- **AAA Normal Text**: 7:1
- **AAA Large Text**: 4.5:1
- **UI Components**: 3:1

## Example Usage

**User Request:**
"Analyze the colors on https://stokedautomations.com/"

**Your Response:**
```
I'll analyze the colors on the Stoked Automations homepage
by taking a screenshot and examining all color combinations.

[Takes screenshot using Playwright]
[Reads screenshot]
[Performs comprehensive analysis]

🎨 COLOR ANALYSIS REPORT: Stoked Automations Homepage

=== SCREENSHOT CAPTURED ===
Full page screenshot saved to ./color-analysis.png
Analyzing visual color combinations...

=== COLOR INVENTORY ===

**Background Colors:**
- Primary: #f8f4ed (Light cream)
- Secondary: #e8d4ab (Tan)
- Card Dark: #2d1f0f (Deep brown)

**Text Colors:**
- Primary: #2d1f0f (Dark brown)
- Secondary: #5d4f3f (Medium brown)
- Muted: #7d6f5f (Light brown)

**Brand Accent:**
- Orange Primary: #e97101
- Orange Light: #f6ad55

=== CONTRAST ANALYSIS ===

✅ PASSING (10 combinations)

1. Dark brown text (#2d1f0f) on cream (#f8f4ed)
   - Ratio: 8.2:1 ✅ AAA compliant
   - Perfect readability

2. Dark brown (#2d1f0f) on tan (#e8d4ab)
   - Ratio: 6.5:1 ✅ AAA compliant
   - Excellent contrast

[Continue for all combinations...]

❌ FAILING (3 combinations)

1. Light brown text (#7d6f5f) on tan background (#e8d4ab)
   - Current: 2.8:1 ❌ FAILS AA (needs 4.5:1)
   - Issue: Insufficient contrast for body text
   - Fix: Use #5d4f3f for 5.2:1 ✅ AA/AAA
   - Alternative: Use #2d1f0f for 8.2:1 ✅ AAA

[Continue for failures...]

=== COLOR BLINDNESS TEST ===

Protanopia (Red-Blind):
✅ No issues detected - brown/cream palette remains distinct

Deuteranopia (Green-Blind):
✅ No issues detected - warm tones work well

Tritanopia (Blue-Blind):
✅ No issues detected - no blue dependencies

=== AESTHETIC EVALUATION ===

**Harmony**: 9/10 - Beautiful warm earth tone palette
**Balance**: 8/10 - Good distribution, slightly warm-heavy
**Hierarchy**: 9/10 - Clear visual levels with color
**Polish**: 9/10 - Professional, refined execution

**Overall Grade**: A - Exceptionally well-executed color system

=== RECOMMENDATIONS ===

Quick Wins:
1. Darken muted text (#7d6f5f → #5d4f3f) for AA compliance
2. Add focus indicators with 3:1 contrast
3. Ensure button states have 3:1 contrast

Updated Palette:
```css
/* Fully accessible color system */
--bg-primary: #f8f4ed;    /* 8.2:1 with text ✅ */
--bg-secondary: #e8d4ab;  /* 6.5:1 with text ✅ */
--text-primary: #2d1f0f;  /* Dark brown - use for all body text */
--text-secondary: #5d4f3f; /* 5.2:1 on tan ✅ */
--accent-orange: #e97101; /* 3.4:1 on cream (large text OK) */
```

=== SUMMARY ===

Overall: Well-designed warm color palette with excellent
contrast on primary surfaces. Minor improvements needed
for secondary text combinations. Passes all color
blindness tests. Professional aesthetic execution.
```

## Important Notes

- Always take full-page screenshot to see entire color usage
- Test EVERY text/background combination, not just obvious ones
- Consider button hover states, focus states, disabled states
- Check that icons/UI elements have 3:1 contrast
- Look for text overlaying images (often problematic)
- Test both light and dark sections if page has variety

## When to Use This Command

- User wants accessibility audit of a live website
- Checking compliance before launch
- Investigating user reports of readability issues
- Comparing color schemes between pages
- Validating design implementation matches specs

## Activation

When user provides a URL and requests color analysis, immediately:
1. Launch Playwright
2. Capture screenshot
3. Perform comprehensive visual analysis
4. Deliver detailed report with actionable fixes
