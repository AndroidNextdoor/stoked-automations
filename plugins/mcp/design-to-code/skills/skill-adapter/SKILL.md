---
name: Converting Designs to Production Code
description: |
  Automatically converts Figma designs and UI screenshots into production-ready React, Svelte, or Vue components with built-in accessibility features. Activates when users mention "convert design to code", "Figma to React", "screenshot to component", "design system", or "accessible components". Extracts layouts, styling, and generates semantic HTML with ARIA labels, keyboard navigation, and WCAG compliance.
---

## Overview
This skill transforms visual designs into functional code components by parsing Figma JSON exports or analyzing UI screenshots. It generates production-ready components with accessibility features built-in, supporting React, Svelte, and Vue frameworks.

## How It Works
1. **Design Input**: Parse Figma JSON exports or analyze screenshot images to extract UI layout and styling information
2. **Layout Analysis**: Identify components, hierarchy, colors, typography, and spacing from the design source
3. **Code Generation**: Create framework-specific components with semantic HTML, ARIA attributes, and accessibility features

## When to Use This Skill
- Converting Figma designs into React, Svelte, or Vue components
- Transforming UI mockups or screenshots into functional code
- Building accessible components from design specifications
- Extracting design tokens and styling from visual layouts
- Creating component libraries from design systems

## Examples

### Example 1: Figma to React Component
User request: "Convert this Figma button design to a React component with accessibility"

The skill will:
1. Parse the Figma JSON export using `parse_figma` tool
2. Generate a React component with proper ARIA labels, semantic HTML, and keyboard navigation support

### Example 2: Screenshot Analysis
User request: "Turn this dashboard screenshot into Svelte components"

The skill will:
1. Analyze the screenshot using `analyze_screenshot` to identify UI elements and layout structure
2. Generate Svelte components with extracted styling and accessibility features

### Example 3: Custom Layout Generation
User request: "Create an accessible form component based on this design spec"

The skill will:
1. Use `generate_component` with the layout specification
2. Output a component with WCAG AA compliant styling, proper form labels, and keyboard navigation

## Best Practices
- **Framework Selection**: Choose React for complex state management, Svelte for performance-critical apps, Vue for balanced approach
- **Accessibility First**: Always include ARIA labels, semantic HTML elements, and keyboard navigation in generated components
- **Design Fidelity**: Maintain visual consistency while ensuring code follows framework conventions and best practices
- **Component Structure**: Generate modular, reusable components that can be easily integrated into existing codebases

## Integration
Works seamlessly with development workflows by generating components that integrate with existing design systems and component libraries. Generated code includes proper TypeScript types, CSS-in-JS styling, and follows framework-specific conventions for immediate use in production applications.