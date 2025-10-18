---
name: Orchestrating Complex Workflows
description: |
  Orchestrates complex multi-step workflows using DAG-based execution with parallel task processing and comprehensive run history tracking. Automatically activates when users mention "workflow orchestration", "task dependencies", "parallel execution", "DAG workflow", "automated pipeline", "workflow automation", "task orchestration", or need to manage complex multi-step processes with dependencies. Creates directed acyclic graphs of tasks, executes independent tasks concurrently, tracks execution history, and provides real-time status monitoring with graceful error handling.
---

## Overview
This skill enables sophisticated workflow automation through DAG (Directed Acyclic Graph) based task orchestration. It manages complex multi-step processes with task dependencies, executes independent tasks in parallel, and maintains comprehensive execution history with real-time monitoring.

## How It Works
1. **Workflow Creation**: Define workflows with tasks, dependencies, and execution commands in a structured DAG format
2. **Dependency Resolution**: Analyze task relationships to determine optimal execution order and identify parallel opportunities  
3. **Parallel Execution**: Execute independent tasks concurrently while respecting dependency constraints
4. **Progress Tracking**: Monitor workflow status, task completion, and execution history in real-time

## When to Use This Skill
- Building CI/CD pipelines with build, test, and deployment stages
- Creating data processing workflows with ETL dependencies
- Automating complex deployment procedures across multiple environments  
- Managing batch processing jobs with interdependent tasks
- Orchestrating testing workflows with parallel test execution
- Setting up multi-stage automation processes

## Examples

### Example 1: CI/CD Pipeline
User request: "Create a workflow to lint, test, build and deploy my application with proper dependencies"

The skill will:
1. Create a DAG workflow with lint → test → build → deploy dependency chain
2. Execute tasks sequentially respecting dependencies, with parallel execution where possible
3. Track execution progress and provide status updates for each stage

### Example 2: Data Processing Pipeline  
User request: "Set up a workflow to process data with extraction, transformation, validation, and loading steps"

The skill will:
1. Define workflow with ETL tasks and dependency relationships
2. Execute data extraction and transformation in parallel where dependencies allow
3. Monitor progress and maintain execution history for audit purposes

### Example 3: Parallel Testing Workflow
User request: "Create a testing workflow that runs unit tests, integration tests, and security scans in parallel"

The skill will:
1. Structure independent test tasks for concurrent execution
2. Execute all test suites simultaneously to minimize total runtime
3. Aggregate results and provide comprehensive status reporting

## Best Practices
- **Task Design**: Keep tasks focused and atomic for better parallelization opportunities
- **Dependency Management**: Define clear task dependencies to avoid circular references in the DAG
- **Error Handling**: Design workflows with appropriate failure recovery and rollback strategies
- **Resource Management**: Consider system resources when configuring parallel execution limits
- **Monitoring**: Regularly check workflow execution history to identify optimization opportunities

## Integration
Works seamlessly with CI/CD systems, deployment tools, testing frameworks, and data processing platforms. Integrates with existing automation scripts and can trigger external services through command execution. Complements other development plugins by providing orchestration layer for complex multi-tool workflows.