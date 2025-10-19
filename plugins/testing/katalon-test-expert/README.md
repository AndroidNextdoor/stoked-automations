# Katalon Test Expert

**Comprehensive Katalon Studio testing assistant with deep insurance domain expertise**

The Katalon Test Expert is a complete testing solution that combines expert test authoring, failure analysis, beautiful reporting, and deep insurance industry knowledge. Whether you're crafting new test cases, debugging failures, or generating executive reports, this plugin provides professional-grade assistance.

## 🎯 Core Capabilities

### 1. Expert Test Case Crafting
- **Bite-sized test steps** - Small, focused, debuggable steps
- **Fine-grained tuning** - Parameterized inputs, configurable timeouts, feature flags
- **Layered testing** - Smoke, functional, integration, regression, performance
- **Data-driven testing** - MySQL and CSV integration
- **User story mapping** - From requirements to comprehensive test cases

### 2. Failure Analysis
- **Deep dive into test failures** - Root cause analysis
- **HAR file analysis** - Network request debugging
- **Session recording integration** - LogRocket & AWS Device Farm
- **Automated JIRA ticket creation** - Smart BUG vs TASK classification
- **MySQL test result queries** - Historical data analysis

### 3. Beautiful Reporting
- **HTML email reports** - Executive summaries with charts and metrics
- **Confluence publishing** - Professional markdown documentation
- **PDF reports** - Print-ready with graphs and screenshots
- **Trend analysis** - Historical performance tracking
- **Mobile-responsive design** - Readable on all devices

### 4. Insurance Domain Expertise
- **All 50 US states** - State-specific regulations and requirements
- **Global markets** - Europe, Asia-Pacific, Latin America, Middle East
- **Insurance products** - Property, casualty, auto, specialty lines
- **Rating algorithms** - Premium calculations, ISO rating, credit scoring
- **Financial calculations** - Actuarial concepts, loss ratios, premium financing
- **Regulatory compliance** - State mandates, fair pricing, consumer protection

## 📦 Installation

```bash
/plugin install katalon-test-expert@stoked-automations
```

## 🚀 Quick Start

### Craft a Test Case

```
/craft-test-case "Login with Valid Credentials"
```

I'll create a complete, well-structured test case with comprehensive assertions, database verification, and detailed logging.

### Analyze a Test Failure

```
python3 scripts/katalon-report-parser.py resources/401ErrorReportDir
```

Provides root cause analysis, network debugging, session recording links, and fix recommendations.

### Generate Reports

```
/publish-test-report resources/401ErrorReportDir --type email --send-to qa-team@company.com
```

Creates professional HTML emails with charts, metrics, and trend indicators.

### Create JIRA Ticket

```
/create-jira-ticket resources/401ErrorReportDir
```

Automatically classifies as BUG (application issues) or TASK (test updates).

## 🏦 Insurance Domain Expertise

I understand:
- **All 50 US states** with state-specific regulations
- **Insurance products** (property, auto, liability, specialty)
- **Rating algorithms** and premium calculations
- **Financial concepts** (loss ratios, actuarial calculations)
- **Regulatory compliance** (state mandates, Prop 103, etc.)

Example test scenario:
```groovy
// Florida coastal property with hurricane coverage
def testData = [
    state: 'FL',
    address: '123 Ocean Drive, Miami Beach',
    dwellingLimit: 450000,
    hurricaneDeductible: '5%',  // Florida-specific
    windMitigation: true,
    expectedPremium: 3200
]
```

## 📚 Available Commands

- `/craft-test-case` - Create expert test cases with data-driven logic
- `/analyze-test` - Deep dive into test failures (via scripts)
- `/create-jira-ticket` - Automated ticket creation with classification
- `/scrape-session` - Extract LogRocket/Device Farm session data
- `/publish-test-report` - Generate HTML/Confluence/PDF reports

## 📋 Prerequisites

- Python 3.7+ with haralyzer
- MySQL client
- Firecrawl MCP (for session scraping)
- Atlassian MCP (for JIRA integration)

## 🎓 Best Practices

1. **Keep test steps small** - Each step does ONE thing
2. **Use database for test data** - Central source of truth
3. **Generate reports automatically** - After every test run
4. **Add assertions everywhere** - Verify at each step
5. **Log results to database** - Track trends over time

---

**Author:** Andrew Nixdorf (andrew@stokedautomations.com)
**Version:** 1.0.0
**Category:** Testing
**Repository:** https://github.com/AndroidNextdoor/stoked-automations
