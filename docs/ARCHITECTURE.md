# Stoked Automations Architecture

**System architecture documentation with visual diagrams**

**Author:** Andrew Nixdorf <andrew@stokedautomation.com>
**Version:** 2025.0.0
**Last Updated:** October 2025

---

## Table of Contents

1. [System Overview](#system-overview)
2. [Repository Structure](#repository-structure)
3. [Mode System Architecture](#mode-system-architecture)
4. [Serena Integration Architecture](#serena-integration-architecture)
5. [MCP Server Architecture](#mcp-server-architecture)
6. [Workflow Automation Architecture](#workflow-automation-architecture)
7. [Marketplace Website Architecture](#marketplace-website-architecture)
8. [Data Flow Diagrams](#data-flow-diagrams)

---

## System Overview

```mermaid
graph TB
    User[👤 User] --> Claude[Claude Code CLI]

    Claude --> Modes[🎯 Development Modes]
    Claude --> Plugins[🔌 Plugin System]
    Claude --> MCP[🔧 MCP Servers]

    Modes --> Scripts[📜 Mode Scripts]
    Modes --> Config[⚙️ modes.json]

    Plugins --> Commands[📝 Commands]
    Plugins --> Skills[🎓 Skills]
    Plugins --> Agents[🤖 Agents]

    MCP --> Serena[💾 Serena Memory]
    MCP --> Kali[🔒 Kali Security]
    MCP --> Browser[🌐 Browser Testing]
    MCP --> Others[... 12 More MCPs]

    Scripts --> Workflows[⚡ Automated Workflows]
    Workflows --> Serena

    Serena --> Memory[(Memory Storage)]

    style User fill:#e97101
    style Claude fill:#f8f4ed
    style Modes fill:#d4c4a0
    style Serena fill:#2d1f0f,color:#f8f4ed
```

**Key Components:**
- **10 Development Modes** - Context-aware environments
- **231 Plugins** - Commands, Skills, Agents
- **15 MCP Servers** - Extended capabilities
- **Serena Integration** - Persistent memory layer
- **3 Automated Workflows** - Security, Testing, PR Review

---

## Repository Structure

```mermaid
graph LR
    Root[stoked-automations/]

    Root --> Plugins[plugins/]
    Root --> Scripts[scripts/]
    Root --> Docs[docs/]
    Root --> Marketplace[marketplace/]
    Root --> Config[config/]

    Plugins --> Security[security/]
    Plugins --> Testing[testing/]
    Plugins --> MCP[mcp/]
    Plugins --> More[... 12 more categories]

    Scripts --> Modes[modes/]
    Scripts --> Workflows[workflows/]
    Scripts --> Serena[serena/]

    MCP --> SerenaPlugin[serena/]
    MCP --> KaliPlugin[kali-mcp/]
    MCP --> BrowserPlugin[browser-testing-suite/]

    Modes --> PRReview[enable-pr-review-mode.sh]
    Modes --> Security2[enable-security-audit-mode.sh]
    Modes --> More2[... 8 more modes]

    Workflows --> SecScan[security-scan-workflow.sh]
    Workflows --> TestFlow[test-workflow.sh]
    Workflows --> PRFlow[pr-review-workflow.sh]

    Serena --> CreateMem[create-memory.sh]
    Serena --> SearchCtx[search-context.sh]
    Serena --> ModeCtx[mode-context.sh]

    style Root fill:#e97101
    style Scripts fill:#d4c4a0
    style Serena fill:#2d1f0f,color:#f8f4ed
```

---

## Mode System Architecture

### Mode Lifecycle

```mermaid
sequenceDiagram
    participant User
    participant ModeScript as Mode Script
    participant Serena as Serena MCP
    participant Config as modes.json
    participant Workflow as Workflows

    User->>ModeScript: ./enable-pr-review-mode.sh

    ModeScript->>Config: Load mode configuration
    Config-->>ModeScript: Token limits, plugins, agents

    ModeScript->>Serena: Load historical context
    Note over Serena: mode-context.sh pr-review
    Serena-->>ModeScript: Security findings (7d)<br/>Test failures<br/>Code patterns

    ModeScript->>Workflow: Run pre-checks
    Note over Workflow: Optional automated scans
    Workflow-->>ModeScript: Baseline established

    ModeScript->>User: ✓ PR Review Mode Active<br/>Context loaded<br/>Ready to review

    User->>ModeScript: [Works in mode]

    User->>ModeScript: [Exits mode]
    ModeScript->>Serena: Store session summary
    Note over Serena: create-memory.sh
```

### Mode Selection Logic

```mermaid
flowchart TD
    Start[User starts task] --> Analyze[Analyze context]

    Analyze --> Branch{Git branch?}
    Branch -->|feature/*| FullStack[Full-Stack Mode]
    Branch -->|hotfix/*| QuickFix[Quick Fix Mode]
    Branch -->|docs/*| Documentation[Documentation Mode]
    Branch -->|security/*| SecurityAudit[Security Audit Mode]
    Branch -->|other| TestCheck{Tests failing?}

    TestCheck -->|Yes| Testing[Testing Mode]
    TestCheck -->|No| PRCheck{PR pending?}

    PRCheck -->|Yes| PRReview[PR Review Mode]
    PRCheck -->|No| Complexity{Task complexity?}

    Complexity -->|High| Mode30H[30-Hour Mode]
    Complexity -->|Medium| FullStack
    Complexity -->|Low| QuickFix

    style Start fill:#e97101
    style Mode30H fill:#2d1f0f,color:#f8f4ed
    style PRReview fill:#d4c4a0
    style SecurityAudit fill:#d4c4a0
```

---

## Serena Integration Architecture

### Memory Flow

```mermaid
graph TD
    Events[Development Events] --> Capture{Event Type?}

    Capture -->|Security Scan| SecScript[security-scan-workflow.sh]
    Capture -->|Test Run| TestScript[test-workflow.sh]
    Capture -->|PR Review| PRScript[pr-review-workflow.sh]
    Capture -->|Manual| CreateMem[create-memory.sh]

    SecScript --> Serena[Serena MCP]
    TestScript --> Serena
    PRScript --> Serena
    CreateMem --> Serena

    Serena --> CreateMemTool[create_memory]
    CreateMemTool --> Embeddings[Generate Embeddings]
    Embeddings --> Storage[(Memory Storage)]

    Storage --> Index[Semantic Index]

    Future[Future Work] --> Search[search-context.sh]
    Search --> SearchTool[search_memories]
    SearchTool --> Index
    Index --> Results[Relevant Context]
    Results --> User[👤 User]

    style Serena fill:#2d1f0f,color:#f8f4ed
    style Storage fill:#e97101
```

### Context Loading Pipeline

```mermaid
sequenceDiagram
    participant Mode as Mode Script
    participant ModeCtx as mode-context.sh
    participant Serena as Serena MCP
    participant Storage as Memory Storage

    Mode->>ModeCtx: Load context for "pr-review"

    ModeCtx->>Serena: Query 1: "security findings last 7 days"
    Serena->>Storage: Semantic search
    Storage-->>Serena: 5 results (similarity > 0.65)
    Serena-->>ModeCtx: Security context

    ModeCtx->>Serena: Query 2: "test failures unresolved"
    Serena->>Storage: Semantic search
    Storage-->>Serena: 3 results
    Serena-->>ModeCtx: Test context

    ModeCtx->>Serena: Query 3: "code review patterns"
    Serena->>Storage: Semantic search
    Storage-->>Serena: 8 results
    Serena-->>ModeCtx: Review patterns

    ModeCtx->>Serena: Query 4: "architecture decisions"
    Serena->>Storage: Semantic search
    Storage-->>Serena: 10 results
    Serena-->>ModeCtx: Architecture context

    ModeCtx-->>Mode: 26 relevant memories loaded
```

---

## MCP Server Architecture

### MCP Communication Flow

```mermaid
graph LR
    Claude[Claude Code] -->|MCP Protocol| Serena[Serena MCP]
    Claude -->|MCP Protocol| Kali[Kali MCP]
    Claude -->|MCP Protocol| Browser[Browser Testing]

    Serena --> Tools1[create_memory<br/>search_memories<br/>get_project_context<br/>create_prompt<br/>analyze_codebase<br/>list_memories]

    Kali --> Tools2[execute_kali_command]
    Tools2 --> KaliTools[nmap<br/>nikto<br/>sqlmap<br/>gobuster<br/>metasploit<br/>600+ tools]

    Browser --> Tools3[run_playwright_test<br/>capture_screenshot<br/>run_accessibility_scan<br/>measure_performance<br/>visual_regression_test]

    Tools1 --> Storage[(Memory<br/>Storage)]
    Tools2 --> Docker[Docker<br/>Container]
    Tools3 --> Playwright[Playwright<br/>Engine]

    style Serena fill:#2d1f0f,color:#f8f4ed
    style Kali fill:#d4c4a0
    style Browser fill:#d4c4a0
```

### MCP Server Lifecycle

```mermaid
stateDiagram-v2
    [*] --> Stopped

    Stopped --> Starting : claude-mcp-start
    Starting --> Running : Server initialized
    Starting --> Failed : Initialization error

    Running --> Processing : Tool call received
    Processing --> Running : Tool executed
    Processing --> Error : Tool error
    Error --> Running : Error handled

    Running --> Stopping : claude-mcp-stop
    Stopping --> Stopped : Server shutdown

    Failed --> Stopped : Error logged

    Running --> HealthCheck : Health check ping
    HealthCheck --> Running : Healthy
    HealthCheck --> Failed : Unhealthy
```

---

## Workflow Automation Architecture

### Security Scan Workflow

```mermaid
flowchart TD
    Start[Start Security Scan] --> LoadCtx[Load Historical Context]
    LoadCtx --> Serena1[search-context.sh<br/>"security vulnerabilities"]

    Serena1 --> Nmap[Run nmap Scan]
    Nmap --> Headers[Check Security Headers]
    Headers --> Static[Static Code Analysis]

    Static --> Secrets{Hardcoded<br/>Secrets?}
    Secrets -->|Yes| Store1[store-memory.sh<br/>CRITICAL]
    Secrets -->|No| SQL{SQL Injection<br/>Patterns?}

    SQL -->|Yes| Store2[store-memory.sh<br/>HIGH]
    SQL -->|No| Report[Generate Report]

    Store1 --> Report
    Store2 --> Report

    Report --> Serena2[Store Complete Scan]
    Serena2 --> End[Display Report]

    style Start fill:#e97101
    style Serena1 fill:#2d1f0f,color:#f8f4ed
    style Serena2 fill:#2d1f0f,color:#f8f4ed
    style Store1 fill:#d4c4a0
    style Store2 fill:#d4c4a0
```

### Test Workflow

```mermaid
flowchart TD
    Start[Start Test Workflow] --> LoadHistory[Load Test History]
    LoadHistory --> Flaky[Check for Flaky Tests]

    Flaky --> Unit[Run Unit Tests]
    Unit --> UnitPass{Passed?}

    UnitPass -->|Yes| StoreSuccess1[Store Success]
    UnitPass -->|No| StoreFailure1[Store Failure<br/>+ Error Details]

    StoreSuccess1 --> E2E[Run E2E Tests]
    StoreFailure1 --> E2E

    E2E --> E2EPass{Passed?}

    E2EPass -->|Yes| StoreSuccess2[Store Success]
    E2EPass -->|No| IsFlaky{Matches Flaky<br/>Pattern?}

    IsFlaky -->|Yes| StoreFlaky[Store as Flaky]
    IsFlaky -->|No| StoreFailure2[Store Failure]

    StoreSuccess2 --> Types[Run Type Check]
    StoreFlaky --> Types
    StoreFailure2 --> Types

    Types --> Lint[Run Linting]
    Lint --> Report[Generate Report]
    Report --> Summary[Store Summary]

    Summary --> End{All Passed?}
    End -->|Yes| Success[Exit 0]
    End -->|No| Failure[Exit 1]

    style Start fill:#e97101
    style LoadHistory fill:#2d1f0f,color:#f8f4ed
    style StoreSuccess1 fill:#d4c4a0
    style StoreFailure1 fill:#d4c4a0
```

---

## Marketplace Website Architecture

### Build & Deploy Pipeline

```mermaid
flowchart LR
    Source[marketplace/src/] --> Build[Astro Build]

    Build --> Pages[Generate Pages]
    Build --> Components[Render Components]
    Build --> Styles[Process Styles]

    Pages --> HTML[Static HTML]
    Components --> HTML
    Styles --> CSS[Optimized CSS]

    HTML --> Dist[marketplace/dist/]
    CSS --> Dist

    Dist --> Deploy[GitHub Actions]
    Deploy --> Pages2[GitHub Pages]
    Pages2 --> Live[stokedautomations.com]

    style Source fill:#e97101
    style Live fill:#2d1f0f,color:#f8f4ed
```

### Component Hierarchy

```mermaid
graph TD
    Layout[Layout.astro] --> Header[Header Component]
    Layout --> Main[Main Content]
    Layout --> Footer[Footer Component]

    Main --> Home{Page Type?}

    Home -->|index| Hero[Hero.astro]
    Home -->|category| Category[CategoryPage.astro]
    Home -->|plugin| Plugin[PluginDetail.astro]

    Hero --> Stats[StatsDisplay]
    Hero --> Install[InstallInstructions]

    Category --> Grid[PluginGrid]
    Grid --> Card[PluginCard]

    Plugin --> Details[PluginDetails]
    Plugin --> Install

    style Layout fill:#e97101
    style Hero fill:#d4c4a0
    style Category fill:#d4c4a0
```

---

## Data Flow Diagrams

### Plugin Installation Flow

```mermaid
sequenceDiagram
    participant User
    participant CLI as Claude CLI
    participant Marketplace as Marketplace JSON
    participant GitHub
    participant Local as Local Files

    User->>CLI: /plugin install plugin-name@stoked-automations

    CLI->>Marketplace: Read marketplace.json
    Marketplace-->>CLI: Plugin metadata + source path

    CLI->>GitHub: Clone repository
    GitHub-->>CLI: Repository files

    CLI->>Local: Copy plugin files
    Note over Local: ~/.claude-plugins/plugin-name/

    CLI->>Local: Validate plugin.json
    CLI->>Local: Make scripts executable

    CLI->>User: ✓ Plugin installed successfully
```

### Mode Enhancement Flow

```mermaid
graph TD
    User[User Activates Mode] --> Script[Mode Script]

    Script --> Step1[Step 1: Load Config]
    Step1 --> JSON[modes.json]

    Script --> Step2[Step 2: Load Context]
    Step2 --> Serena[Serena MCP]
    Serena --> Queries[4 Context Queries]
    Queries --> Results[Historical Context]

    Script --> Step3[Step 3: Run Workflows]
    Step3 --> PreChecks[Pre-flight Checks]
    PreChecks --> Baseline[Establish Baseline]

    Script --> Step4[Step 4: Configure Tools]
    Step4 --> Plugins[Install Plugins]
    Step4 --> Agents[Configure Agents]

    Results --> Display[Display to User]
    Baseline --> Display
    Plugins --> Display
    Agents --> Display

    Display --> Ready[Mode Ready]

    style User fill:#e97101
    style Serena fill:#2d1f0f,color:#f8f4ed
    style Ready fill:#d4c4a0
```

---

## System Integration Diagram

```mermaid
graph TB
    subgraph "User Layer"
        User[👤 Developer]
    end

    subgraph "Interface Layer"
        CLI[Claude Code CLI]
        Web[Marketplace Website]
    end

    subgraph "Mode System"
        Modes[Development Modes]
        Scripts[Mode Scripts]
        Config[modes.json]
    end

    subgraph "Plugin System"
        Commands[Commands]
        Skills[Skills]
        Agents[Agents]
    end

    subgraph "MCP Layer"
        Serena[Serena MCP]
        Kali[Kali MCP]
        Browser[Browser Testing]
        Others[12 Other MCPs]
    end

    subgraph "Automation Layer"
        SecWorkflow[Security Workflow]
        TestWorkflow[Test Workflow]
        PRWorkflow[PR Review Workflow]
    end

    subgraph "Data Layer"
        Memory[(Memory Storage)]
        Git[(Git Repository)]
        Files[(File System)]
    end

    User --> CLI
    User --> Web

    CLI --> Modes
    CLI --> Plugin System

    Modes --> Scripts
    Scripts --> Config
    Scripts --> MCP Layer
    Scripts --> Automation Layer

    MCP Layer --> Serena
    Serena --> Memory

    Automation Layer --> MCP Layer
    Automation Layer --> Git
    Automation Layer --> Files

    Plugin System --> CLI

    style User fill:#e97101
    style Serena fill:#2d1f0f,color:#f8f4ed
    style Memory fill:#e97101
```

---

## Deployment Architecture

```mermaid
graph LR
    subgraph "Development"
        Dev[Developer Machine]
        Local[Local Testing]
    end

    subgraph "Repository"
        GitHub[GitHub Repository]
        Actions[GitHub Actions]
    end

    subgraph "CI/CD"
        Validate[Validate Plugins]
        Build[Build Marketplace]
        Test[Run Tests]
    end

    subgraph "Production"
        Pages[GitHub Pages]
        CDN[CloudFlare CDN]
        Live[stokedautomations.com]
    end

    Dev --> Local
    Local --> GitHub

    GitHub --> Actions
    Actions --> Validate
    Validate --> Build
    Build --> Test

    Test --> Pages
    Pages --> CDN
    CDN --> Live

    style Dev fill:#e97101
    style Live fill:#2d1f0f,color:#f8f4ed
```

---

## Future Architecture Enhancements

```mermaid
mindmap
    root((Stoked<br/>Automations))
        AI Enhancements
            GPT-4 Code Analysis
            Automated PR Comments
            Intelligent Mode Suggestions
            Predictive Context Loading

        Team Features
            Shared Memory Pools
            Team Mode Sync
            Collaborative Workflows
            Cross-repo Learning

        Performance
            Memory Caching
            Query Optimization
            Distributed MCP Servers
            CDN for Plugin Distribution

        Integration
            IDE Plugins
            CI/CD Native Integration
            Slack Notifications
            Metrics Dashboard

        Advanced MCP
            Multi-model Support
            Vector Database Integration
            Real-time Collaboration
            Enterprise SSO
```

---

## Resources

- **Serena Integration:** `docs/SERENA_INTEGRATION_ARCHITECTURE.md`
- **Mode System:** `docs/MODE_SYSTEM_GUIDE.md`
- **Mode Enhancers:** `docs/MODE_ENHANCERS.md`
- **MCP Servers:** `docs/MCP_SERVER_GUIDE.md`
- **Plugin Standards:** `docs/PLUGIN_DEVELOPMENT_STANDARDS.md`
- **Workflow Automation:** `scripts/workflows/README.md`

---

**Last Updated:** October 2025
**Repository Version:** 2025.0.0
**Status:** Production-ready architecture