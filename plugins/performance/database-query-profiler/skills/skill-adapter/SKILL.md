---
name: Profiling Database Queries
description: |
  Profiles and optimizes database queries for performance. This skill activates when users need to analyze SQL performance, identify N+1 queries, recommend indexes, detect full table scans, or optimize joins. Use for query optimization, performance troubleshooting, and database efficiency improvements.
---

## Overview

This skill leverages the `database-query-profiler` plugin to analyze and optimize database queries for performance. It helps identify common issues like N+1 queries, missing indexes, full table scans, and inefficient joins. The plugin provides recommendations for improving query performance, ensuring efficient database operations.

## How it Works

When you ask Claude to analyze or optimize database queries, this skill guides it to:

1.  **Activate the Plugin:** Claude recognizes the need for database query profiling and activates the `database-query-profiler` plugin.
2.  **Initiate Analysis:** Claude uses the `/profile-queries` command.
3.  **Analyze Query Performance:** The plugin analyzes queries across several key areas:
    *   N+1 query detection
    *   Index recommendation
    *   Full table scan identification
    *   Join optimization
    *   Query complexity analysis
    *   Connection pooling guidance
4.  **Provide Recommendations:** Based on the analysis, the plugin provides specific recommendations for query optimization.
5.  **Presents Before/After Examples:** The plugin will present code snippets demonstrating optimized SQL, when possible.

## When to Use

Use this skill when:

*   Database performance is slow or degrading.
*   You suspect inefficient queries are impacting application performance.
*   You need to optimize database queries for scalability.
*   You want to proactively identify and address potential database performance bottlenecks.
*   You're refactoring database-related code and want to ensure optimal query performance.
*   You need to identify N+1 queries.
*   You are seeing full table scans in your database logs.

## Examples

Here are a few examples of how to use this skill:

*   "Claude, analyze the database queries for performance issues."
*   "Optimize my SQL queries for faster execution."
*   "I'm experiencing slow database performance. Can you profile my queries?"
*   "Find and fix any N+1 queries in my application."
*   "Suggest indexes for my database tables to improve query performance."
*   "I want to optimize database queries used in the payment processing module."
*   "Show me examples of how to improve database query performance. Also, make sure to include before and after examples."

## Best Practices

*   **Provide Context:** Give Claude as much context as possible about the specific queries or application areas you want to analyze.
*   **Specify Goals:** Clearly state your performance goals. For example, "Reduce query execution time by 50%."
*   **Iterate:** Review the recommendations provided by the plugin and iterate on your queries based on the feedback.
*   **Test Thoroughly:** After implementing optimizations, thoroughly test your application to ensure the changes have the desired effect and don't introduce any regressions.
*   **Monitor Performance:** Continuously monitor database performance to identify any new or recurring performance issues.
*   **Use Before/After Examples:** Leverage the examples to understand the specific improvements being made to the queries.