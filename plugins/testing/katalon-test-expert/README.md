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

- `/process-webhook` - **NEW!** Process Teams webhook with S3 test results
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
- Microsoft Teams webhook (optional, for automatic notifications)

## 🔗 Teams Webhook Integration

This plugin receives webhook notifications from Microsoft Teams containing signed S3 URLs to Katalon test results, then automatically downloads and analyzes them.

### How It Works

1. **Teams sends webhook** → Test results are uploaded to S3, Teams sends notification with signed URL
2. **Claude Code receives payload** → You use `/process-webhook` command with the JSON payload
3. **Auto-download from S3** → Script downloads the test results archive
4. **Extract and analyze** → Automatically parses Katalon reports and identifies failures
5. **Present insights** → Shows test summary, failures, and actionable recommendations

### Setup

No configuration required! Just receive the webhook payload from Teams and process it.

### Usage

When you receive a Teams notification about test results:

```bash
# Copy the JSON payload from Teams and run:
/process-webhook '{"s3_url": "https://bucket.s3.amazonaws.com/test-results.zip?signature=..."}'
```

### Webhook Payload Format

Your Teams webhook should send JSON with a signed S3 URL:

```json
{
  "s3_url": "https://bucket.s3.amazonaws.com/test-results.zip?AWSAccessKeyId=...&Signature=...",
  "testSuite": "Regression Suite",
  "environment": "Production",
  "timestamp": "2025-01-18T10:30:00Z",
  "buildId": "BUILD-12345"
}
```

The plugin supports multiple JSON structures - it will automatically find the S3 URL regardless of nesting.

### What Gets Processed

After downloading from S3, the plugin:
- ✅ **Extracts archives** - Handles ZIP and TAR.GZ files
- 📊 **Parses Katalon reports** - Reads execution.properties, JUnit XML, CSV reports
- 🔍 **Analyzes failures** - Extracts error messages, stack traces, HAR files
- 📸 **Locates screenshots** - Finds failure screenshots and videos
- 🎥 **Links session recordings** - Identifies LogRocket and AWS Device Farm URLs
- 🏷️ **Classifies issues** - Determines if failures are BUGs or TASKs

### Automatic Hook

After processing completes, a post-webhook analysis hook automatically:
- Counts failed tests and errors
- Identifies available HAR files for network analysis
- Locates screenshots for visual debugging
- Detects session recording links

### Example Workflow

```
User: I just got a Teams notification about test failures

Claude: Please paste the webhook payload from Teams

User: {"s3_url": "https://bucket.s3.amazonaws.com/results.zip?..."}

Claude: Processing webhook...
[Downloading from S3...]
✅ Downloaded 15.3 MB
[Extracting archive...]
✅ Extracted 247 files
[Analyzing results...]

📊 Test Results Summary:
- Total: 45 tests
- Passed: 42 ✅
- Failed: 3 ❌
- Duration: 8m 32s

❌ Failed Tests:
1. TC_Login_InvalidCredentials - Element not found
2. TC_Quote_PremiumCalculation - Assertion failed (expected 3200, got 3245)
3. TC_API_GetQuoteData - HTTP 401 Unauthorized

Would you like me to:
1. Create JIRA tickets for these failures?
2. Analyze HAR files for network issues?
3. Generate an HTML report?
```

## 🎓 Best Practices

1. **Keep test steps small** - Each step does ONE thing
2. **Use database for test data** - Central source of truth
3. **Generate reports automatically** - After every test run
4. **Add assertions everywhere** - Verify at each step
5. **Log results to database** - Track trends over time
6. **Enable Teams notifications** - Get instant alerts on test failures

---

**Author:** Andrew Nixdorf (andrew@stokedautomations.com)
**Version:** 2025.0.0
**Category:** Testing
**Repository:** https://github.com/AndroidNextdoor/stoked-automations
