---
name: Analyzing Project Health
description: |
  Analyzes code health, complexity, test coverage gaps, and git churn in local repositories. This skill activates when users need to assess code quality, identify technical debt, find hotspots, or evaluate test coverage. Use for code health audits, complexity analysis, churn detection, and test coverage mapping.
---

# Project Health Auditor Skill

## Overview

This skill empowers Claude Code to automatically analyze the health of a software project using the `project-health-auditor` plugin. It enables multi-dimensional code quality assessment by combining complexity metrics, change frequency (git churn), and test coverage analysis. This helps identify potential technical debt, hotspots, and areas needing improvement.

## How it Works

When triggered, this skill orchestrates the following steps using the plugin's tools:

1.  **File Discovery:** Uses `list_repo_files` to identify all relevant files within the specified repository, excluding common directories like `node_modules` and `.git`.
2.  **Complexity Analysis:** Employs `file_metrics` to calculate cyclomatic complexity, function counts, comment ratios, and generate a health score for selected files. Prioritizes analysis of files identified as high-churn or lacking test coverage.
3.  **Git Churn Analysis:** Uses `git_churn` to identify frequently modified files, pinpoint code hotspots, and track author contributions. This helps reveal areas of the codebase undergoing rapid change and potential instability.
4.  **Test Coverage Mapping:** Leverages `map_tests` to map source files to their corresponding test files, identify files lacking test coverage, and calculate the overall test coverage ratio.
5.  **Report Generation**: Combines data from all four tools into an actionable report summarizing the project's overall health, highlighting areas needing attention, and suggesting specific refactoring or testing efforts.

## When to Use

Use this skill when:

*   You want a comprehensive assessment of a project's code health.
*   You need to identify areas of high complexity or technical debt.
*   You want to understand the change frequency and stability of different parts of the codebase.
*   You need to identify files lacking adequate test coverage.
*   You want to prioritize refactoring or testing efforts based on data-driven insights.
*   The user asks to assess, audit, analyze, or review the code health of a repository.
*   The user mentions complexity, churn, or test coverage in relation to code quality.

## Examples

Here are a few example prompts that would trigger this skill:

*   "Analyze the health of my codebase in `/path/to/my-project`"
*   "Perform a code quality audit on the repository at `/path/to/repo`"
*   "Assess the complexity and test coverage of the code in `/path/to/project`"
*   "What are the most frequently changed files in my project located at `/Users/me/dev/my-project`?"
*   "Identify files missing tests in `/home/user/code/my-app`"

## Best Practices

*   Ensure the provided repository path is valid and accessible.
*   Configure appropriate exclusion patterns in `list_repo_files` to avoid analyzing irrelevant files (e.g., `node_modules`, build artifacts).
*   Focus complexity analysis on files identified as high-churn or lacking test coverage to prioritize areas of greatest risk.
*   Use the generated report to guide refactoring and testing efforts, focusing on the most critical areas of the codebase.
*   Iterate on the analysis by adjusting the analysis parameters as needed to gain deeper insights. For example, adjusting the `globs` parameter in `list_repo_files` to focus on a specific directory.
*   Consider using the "Code Health Reviewer" agent in conjunction with this skill to receive more specific refactoring recommendations.