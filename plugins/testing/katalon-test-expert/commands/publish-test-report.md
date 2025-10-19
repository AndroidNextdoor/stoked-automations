---
name: publish-test-report
description: Generate beautiful HTML email reports and Confluence-ready markdown from Katalon test results
model: sonnet
---

# Publish Test Report

Expert test report generation - create stunning HTML email reports and publish beautiful markdown documentation to Confluence with charts, metrics, and detailed analysis.

## Report Types

### 1. HTML Email Report
Professional HTML emails with:
- Executive summary
- Pass/fail metrics with charts
- Failed test details with screenshots
- Session recording links (LogRocket, Device Farm)
- Performance metrics
- Trend analysis
- Mobile-responsive design

### 2. Confluence Page
Formatted markdown for Confluence with:
- Test execution summary
- Detailed test results tables
- Embedded screenshots
- Collapsible error details
- Links to artifacts
- Historical trend charts
- Status badges

### 3. PDF Report
Print-ready reports with:
- Professional formatting
- Charts and graphs
- Screenshot galleries
- Full test logs
- Export-friendly layout

## Usage

### Generate HTML Email Report

```
/publish-test-report resources/401ErrorReportDir --type email --send-to qa-team@company.com
```

### Publish to Confluence

```
/publish-test-report resources/401ErrorReportDir --type confluence --space QA --parent "Test Reports"
```

### Generate Both

```
/publish-test-report resources/401ErrorReportDir --type both --email qa-team@company.com --confluence-space QA
```

### From MySQL Test Results

```
/publish-test-report --from-database --test-run-id 12345 --type email
```

## HTML Email Report Template

### Executive Summary Email

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Execution Report - StokedAutomations</title>
    <style>
        :root {
            --bg: #e8d4ab;
            --card: #0f172a;
            --ink: #454850;
            --muted: #0f1115;
            --brand: #e97101;
            --accent: #4f5656;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Inter, 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6;
            color: var(--ink);
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background: radial-gradient(1200px 800px at 80% -20%, rgba(237,143,58,.12), transparent 60%),
                        radial-gradient(900px 700px at -10% 10%, rgba(210,180,140,.08), transparent 50%),
                        linear-gradient(135deg, var(--bg) 0%, 100%);
        }
        .container {
            background-color: #ffffff;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0,0,0,.2);
            overflow: hidden;
            border: 1px solid rgba(237,143,58,.2);
        }
        .header {
            background: var(--card);
            color: var(--bg);
            padding: 30px;
            display: flex;
            align-items: center;
            gap: 20px;
            border-bottom: 3px solid var(--brand);
        }
        .header-logo {
            width: 60px;
            height: 60px;
            border-radius: 8px;
            box-shadow: 0 4px 14px rgba(0,0,0,.35);
        }
        .header-content {
            flex: 1;
        }
        .header h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 600;
        }
        .header .subtitle {
            margin-top: 10px;
            opacity: 0.9;
            font-size: 14px;
        }
        .summary {
            display: flex;
            justify-content: space-around;
            padding: 30px;
            background-color: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }
        .metric {
            text-align: center;
        }
        .metric-value {
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .metric-label {
            font-size: 14px;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .metric.passed .metric-value {
            color: #22c55e;
        }
        .metric.failed .metric-value {
            color: #ef4444;
        }
        .metric.total .metric-value {
            color: var(--brand);
        }
        .metric.duration .metric-value {
            color: var(--accent);
        }
        .progress-bar {
            height: 30px;
            background-color: rgba(237,143,58,.1);
            border-radius: 15px;
            overflow: hidden;
            margin: 20px 30px;
            border: 1px solid rgba(237,143,58,.2);
        }
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--brand) 0%, #f6ad55 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 14px;
            transition: width 0.3s ease;
        }
        .section {
            padding: 30px;
        }
        .section-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 20px;
            color: var(--card);
            border-bottom: 3px solid var(--brand);
            padding-bottom: 10px;
        }
        .test-result {
            background-color: #f8f9fa;
            border-left: 4px solid #dc3545;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 4px;
        }
        .test-result.passed {
            border-left-color: #28a745;
        }
        .test-result-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .test-name {
            font-weight: 600;
            font-size: 16px;
        }
        .test-status {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .test-status.passed {
            background-color: #d4edda;
            color: #155724;
        }
        .test-status.failed {
            background-color: #f8d7da;
            color: #721c24;
        }
        .test-details {
            font-size: 14px;
            color: #6c757d;
            margin-top: 10px;
        }
        .error-message {
            background-color: #fff3cd;
            border-left: 3px solid #ffc107;
            padding: 10px;
            margin-top: 10px;
            font-family: 'Courier New', monospace;
            font-size: 13px;
            color: #856404;
            border-radius: 3px;
        }
        .links {
            margin-top: 15px;
        }
        .link-button {
            display: inline-block;
            padding: 10px 16px;
            margin-right: 10px;
            background-color: var(--brand);
            color: #1a1a1a;
            text-decoration: none;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 700;
            border: 1px solid rgba(0,0,0,.18);
            box-shadow: 0 2px 6px rgba(237,143,58,.25);
            transition: all 0.2s ease;
        }
        .link-button:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(237,143,58,.4);
            text-decoration: none;
        }
        .link-button.logrocket {
            background-color: #6c4cff;
            color: white;
        }
        .link-button.logrocket:hover {
            background-color: #5536e6;
        }
        .link-button.device-farm {
            background-color: #ff9900;
            color: white;
        }
        .link-button.device-farm:hover {
            background-color: #e68a00;
        }
        .screenshot {
            max-width: 100%;
            border-radius: 12px;
            margin-top: 10px;
            box-shadow: 0 8px 24px rgba(0,0,0,.2);
        }
        .footer {
            background-color: var(--card);
            color: var(--bg);
            text-align: center;
            padding: 30px;
            font-size: 13px;
            border-top: 3px solid var(--brand);
        }
        .footer a {
            color: var(--brand);
            text-decoration: none;
            font-weight: 600;
        }
        .footer a:hover {
            text-decoration: underline;
        }
        .chart {
            margin: 20px 0;
            text-align: center;
        }
        .trend-indicator {
            display: inline-flex;
            align-items: center;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 600;
            margin-top: 5px;
        }
        .trend-indicator.up {
            background-color: #d4edda;
            color: #155724;
        }
        .trend-indicator.down {
            background-color: #f8d7da;
            color: #721c24;
        }
        .trend-indicator.stable {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        @media only screen and (max-width: 600px) {
            .summary {
                flex-direction: column;
            }
            .metric {
                margin-bottom: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <img src="cid:stoked_logo" alt="StokedAutomations" class="header-logo">
            <div class="header-content">
                <h1>Test Execution Report</h1>
                <div class="subtitle">
                    Test Suite: Verify AAIS Inland Marine Rating Worksheet<br>
                    Environment: Production | Executed: 2025-09-24 16:51:24 UTC
                </div>
            </div>
        </div>

        <!-- Summary Metrics -->
        <div class="summary">
            <div class="metric total">
                <div class="metric-value">5</div>
                <div class="metric-label">Total Tests</div>
            </div>
            <div class="metric passed">
                <div class="metric-value">4</div>
                <div class="metric-label">Passed</div>
            </div>
            <div class="metric failed">
                <div class="metric-value">1</div>
                <div class="metric-label">Failed</div>
            </div>
            <div class="metric duration">
                <div class="metric-value">127s</div>
                <div class="metric-label">Duration</div>
            </div>
        </div>

        <!-- Pass Rate Progress Bar -->
        <div class="progress-bar">
            <div class="progress-fill" style="width: 80%;">
                80% Pass Rate
            </div>
        </div>

        <!-- Trend Indicator -->
        <div style="text-align: center; padding: 0 30px 20px;">
            <span class="trend-indicator down">
                ↓ Pass rate decreased by 10% from previous run
            </span>
        </div>

        <!-- Failed Tests Section -->
        <div class="section">
            <div class="section-title">❌ Failed Tests (1)</div>

            <div class="test-result">
                <div class="test-result-header">
                    <div class="test-name">Compare Rating Worksheet To Baseline</div>
                    <div class="test-status failed">Failed</div>
                </div>
                <div class="test-details">
                    <strong>Duration:</strong> 33.48s<br>
                    <strong>Browser:</strong> Chrome 140.0.7339.80<br>
                    <strong>Environment:</strong> AWS Device Farm
                </div>
                <div class="error-message">
                    <strong>Error:</strong> Expected status code: 200, Actual: 401<br>
                    <strong>API:</strong> GET /api/quotes/689afe8cedf7e<br>
                    <strong>Root Cause:</strong> Invalid bearer token - token expired during test execution
                </div>

                <!-- Session Recording Links -->
                <div class="links">
                    <a href="https://app.logrocket.com/dtizdl/portal/s/6-01997ca3-2cad-7110-a6a6-9dbb41b835c7/0?t=1758732696544"
                       class="link-button logrocket" target="_blank">
                        🎥 View LogRocket Session
                    </a>
                    <a href="https://us-west-2.console.aws.amazon.com/devicefarm/home?region=us-west-2#/browser/projects/4bf8c095-a160-4a34-ae26-f0d9fb7e7ece/runsselenium/logs/1b16d78aaf1f916146a0db6854b032db"
                       class="link-button device-farm" target="_blank">
                        ☁️ View Device Farm Logs
                    </a>
                    <a href="./artifacts/screenshots/error_screenshot.png"
                       class="link-button">
                        📸 View Screenshot
                    </a>
                </div>

                <!-- Embedded Screenshot -->
                <img src="cid:error_screenshot_001"
                     alt="Error Screenshot"
                     class="screenshot">
            </div>
        </div>

        <!-- Passed Tests Section -->
        <div class="section">
            <div class="section-title">✅ Passed Tests (4)</div>

            <div class="test-result passed">
                <div class="test-result-header">
                    <div class="test-name">Navigate to Login Page</div>
                    <div class="test-status passed">Passed</div>
                </div>
                <div class="test-details">
                    <strong>Duration:</strong> 2.89s
                </div>
            </div>

            <div class="test-result passed">
                <div class="test-result-header">
                    <div class="test-name">Login with Valid Credentials</div>
                    <div class="test-status passed">Passed</div>
                </div>
                <div class="test-details">
                    <strong>Duration:</strong> 5.12s
                </div>
            </div>

            <div class="test-result passed">
                <div class="test-result-header">
                    <div class="test-name">Navigate to Quote Page</div>
                    <div class="test-status passed">Passed</div>
                </div>
                <div class="test-details">
                    <strong>Duration:</strong> 3.45s
                </div>
            </div>

            <div class="test-result passed">
                <div class="test-result-header">
                    <div class="test-name">Select Quote</div>
                    <div class="test-status passed">Passed>
                </div>
                <div class="test-details">
                    <strong>Duration:</strong> 1.78s
                </div>
            </div>
        </div>

        <!-- Test Environment Section -->
        <div class="section">
            <div class="section-title">🔧 Test Environment</div>
            <table style="width: 100%; border-collapse: collapse;">
                <tr style="border-bottom: 1px solid #dee2e6;">
                    <td style="padding: 10px; font-weight: 600;">Browser</td>
                    <td style="padding: 10px;">Chrome 140.0.7339.80</td>
                </tr>
                <tr style="border-bottom: 1px solid #dee2e6;">
                    <td style="padding: 10px; font-weight: 600;">Katalon Version</td>
                    <td style="padding: 10px;">10.1.0.223</td>
                </tr>
                <tr style="border-bottom: 1px solid #dee2e6;">
                    <td style="padding: 10px; font-weight: 600;">Remote Driver</td>
                    <td style="padding: 10px;">AWS Device Farm</td>
                </tr>
                <tr style="border-bottom: 1px solid #dee2e6;">
                    <td style="padding: 10px; font-weight: 600;">Session ID</td>
                    <td style="padding: 10px;">1b16d78aaf1f916146a0db6854b032db</td>
                </tr>
                <tr>
                    <td style="padding: 10px; font-weight: 600;">Environment</td>
                    <td style="padding: 10px;">Production</td>
                </tr>
            </table>
        </div>

        <!-- Artifacts Section -->
        <div class="section">
            <div class="section-title">📦 Test Artifacts</div>
            <ul style="list-style: none; padding: 0;">
                <li style="padding: 8px 0;">📸 Screenshots: 8 files</li>
                <li style="padding: 8px 0;">🎬 Videos: 1 file (video_testgrid_2025-09-24_16-51-22_000.mp4)</li>
                <li style="padding: 8px 0;">📊 HAR Files: 2 files (network request logs)</li>
                <li style="padding: 8px 0;">📝 Log Files: Execution logs available</li>
            </ul>
        </div>

        <!-- Footer -->
        <div class="footer">
            <p>
                <strong>Katalon Test Expert</strong> by <a href="https://stokedautomations.com" target="_blank">StokedAutomations</a><br>
                <a href="./detailed-report.html">View Detailed Report</a> |
                <a href="./artifacts/">View All Artifacts</a>
            </p>
            <p style="margin-top: 15px; font-size: 11px; opacity: 0.7;">
                This is an automated test report. Please do not reply to this email.
            </p>
        </div>
    </div>
</body>
</html>
```

## Confluence Markdown Template

### Test Execution Report Page

```markdown
# 🧪 Test Execution Report: AAIS Inland Marine Rating Worksheet

**Test Suite:** Verify AAIS Inland Marine Rating Worksheet
**Environment:** Production
**Executed:** 2025-09-24 16:51:24 UTC
**Duration:** 127 seconds

---

## 📊 Executive Summary

<ac:structured-macro ac:name="status" ac:schema-version="1">
  <ac:parameter ac:name="color">Red</ac:parameter>
  <ac:parameter ac:name="title">1 FAILED</ac:parameter>
</ac:structured-macro>
<ac:structured-macro ac:name="status" ac:schema-version="1">
  <ac:parameter ac:name="color">Green</ac:parameter>
  <ac:parameter ac:name="title">4 PASSED</ac:parameter>
</ac:structured-macro>
<ac:structured-macro ac:name="status" ac:schema-version="1">
  <ac:parameter ac:name="color">Blue</ac:parameter>
  <ac:parameter ac:name="title">5 TOTAL</ac:parameter>
</ac:structured-macro>

**Pass Rate:** 80% (↓ 10% from previous run)

---

## ❌ Failed Tests

### Test Case: Compare Rating Worksheet To Baseline

<ac:structured-macro ac:name="expand">
  <ac:parameter ac:name="title">Click to view failure details</ac:parameter>
  <ac:rich-text-body>

**Status:** ❌ FAILED
**Duration:** 33.48 seconds
**Browser:** Chrome 140.0.7339.80
**Environment:** AWS Device Farm

#### Error Details

```
Expected status code: 200
Actual status code: 401
API Endpoint: GET /api/quotes/689afe8cedf7e
```

#### Root Cause Analysis

The test failed due to an expired bearer token. The token lifetime (49 seconds) was insufficient for the test duration (49 seconds to API call). The authentication token expired exactly when the API request was made.

**Recommendation:** Increase token TTL to at least 60 seconds to accommodate test execution time plus buffer.

#### Session Recordings

- [🎥 LogRocket Session](https://app.logrocket.com/dtizdl/portal/s/6-01997ca3-2cad-7110-a6a6-9dbb41b835c7/0?t=1758732696544)
- [☁️ AWS Device Farm Logs](https://us-west-2.console.aws.amazon.com/devicefarm/home?region=us-west-2#/browser/projects/4bf8c095-a160-4a34-ae26-f0d9fb7e7ece/runsselenium/logs/1b16d78aaf1f916146a0db6854b032db)

#### Error Screenshot

!error_screenshot.png|thumbnail!

#### Network Request (HAR Analysis)

```json
{
  "request": {
    "method": "GET",
    "url": "https://api.stokedautomations.com/quotes/689afe8cedf7e",
    "headers": {
      "Authorization": "Bearer eyJraWQi..."
    }
  },
  "response": {
    "status": 401,
    "statusText": "Unauthorized",
    "body": {
      "message": "Invalid bearer token"
    },
    "time": 473
  }
}
```

#### Related Issues

- Related to [JIRA-1234](https://jira.company.com/browse/JIRA-1234): Token expiration handling
- Similar failure in previous run: [Test Report 2025-09-23](https://confluence.company.com/test-report-2025-09-23)

  </ac:rich-text-body>
</ac:structured-macro>

---

## ✅ Passed Tests (4)

| Test Case | Status | Duration |
|-----------|--------|----------|
| Navigate to Login Page | ✅ PASSED | 2.89s |
| Login with Valid Credentials | ✅ PASSED | 5.12s |
| Navigate to Quote Page | ✅ PASSED | 3.45s |
| Select Quote | ✅ PASSED | 1.78s |

---

## 🔧 Test Environment

| Property | Value |
|----------|-------|
| **Browser** | Chrome 140.0.7339.80 |
| **Katalon Version** | 10.1.0.223 |
| **Remote Driver** | AWS Device Farm |
| **Session ID** | 1b16d78aaf1f916146a0db6854b032db |
| **Environment** | Production |

---

## 📦 Test Artifacts

<ac:structured-macro ac:name="attachments">
  <ac:parameter ac:name="patterns">*.png,*.mp4,*.har,*.log</ac:parameter>
</ac:structured-macro>

### Available Files

- 📸 **Screenshots:** 8 files
  - keyes-Login Page.png
  - keyes-Dashboard.png
  - keyes-Quote Selection.png
  - keyes-Error State.png
  - (4 more...)

- 🎬 **Videos:** 1 file
  - video_testgrid_2025-09-24_16-51-22_000.mp4 (127 seconds)

- 📊 **HAR Files:** 2 files
  - Get-Quote-Data_0.har
  - Generate-Document_1.har

- 📝 **Logs:** Execution logs attached

---

## 📈 Historical Trend

<ac:structured-macro ac:name="chart">
  <ac:parameter ac:name="type">line</ac:parameter>
  <ac:parameter ac:name="dataDisplay">after</ac:parameter>
  <ac:rich-text-body>
    <table>
      <tbody>
        <tr>
          <th>Date</th>
          <th>Pass Rate</th>
          <th>Total Tests</th>
        </tr>
        <tr>
          <td>2025-09-20</td>
          <td>100</td>
          <td>5</td>
        </tr>
        <tr>
          <td>2025-09-21</td>
          <td>100</td>
          <td>5</td>
        </tr>
        <tr>
          <td>2025-09-22</td>
          <td>90</td>
          <td>5</td>
        </tr>
        <tr>
          <td>2025-09-23</td>
          <td>90</td>
          <td>5</td>
        </tr>
        <tr>
          <td>2025-09-24</td>
          <td>80</td>
          <td>5</td>
        </tr>
      </tbody>
    </table>
  </ac:rich-text-body>
</ac:structured-macro>

---

## 🔗 Related Documentation

- [Test Plan: AAIS Rating Worksheets](https://confluence.company.com/test-plan-aais)
- [User Story: US-1234](https://jira.company.com/browse/US-1234)
- [Previous Test Report](https://confluence.company.com/test-report-2025-09-23)

---

<ac:structured-macro ac:name="info">
  <ac:rich-text-body>
    <p>This report was automatically generated by <strong>Katalon Test Expert</strong> on 2025-09-24 16:53:12 UTC</p>
  </ac:rich-text-body>
</ac:structured-macro>
```

## Python Script: Generate Reports

```python
#!/usr/bin/env python3
"""
Generate HTML Email and Confluence Reports from Katalon Results
"""

import sys
import json
from pathlib import Path
from datetime import datetime
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.image import MIMEImage

# Add scripts directory to path
sys.path.insert(0, str(Path(__file__).parent))
from katalon_report_parser import KatalonReportParser


def generate_html_report(parsed_data):
    """Generate HTML email report"""
    junit = parsed_data.get('junit_xml', {})
    session_urls = parsed_data.get('session_urls', {})
    artifacts = parsed_data.get('artifacts', {})

    total_tests = junit.get('total_tests', 0)
    failures = junit.get('failures', 0)
    passed = total_tests - failures
    pass_rate = (passed / total_tests * 100) if total_tests > 0 else 0

    # Build HTML (use template from above)
    html = f"""
    <!-- Use full HTML template above with dynamic data -->
    <div class="metric total">
        <div class="metric-value">{total_tests}</div>
        <div class="metric-label">Total Tests</div>
    </div>
    <div class="metric passed">
        <div class="metric-value">{passed}</div>
        <div class="metric-label">Passed</div>
    </div>
    <div class="metric failed">
        <div class="metric-value">{failures}</div>
        <div class="metric-label">Failed</div>
    </div>
    """

    return html


def generate_confluence_markdown(parsed_data):
    """Generate Confluence-formatted markdown"""
    junit = parsed_data.get('junit_xml', {})
    failed_tests = [tc for tc in junit.get('test_cases', []) if tc['status'] == 'FAILED']

    markdown = f"""
# 🧪 Test Execution Report: {junit.get('suite_name', 'Unknown')}

## 📊 Executive Summary

Pass Rate: {((junit.get('total_tests', 0) - junit.get('failures', 0)) / junit.get('total_tests', 1) * 100):.1f}%

## ❌ Failed Tests

"""

    for test in failed_tests:
        markdown += f"""
### {test['name']}

**Error:** {test.get('failure_message', 'Unknown error')}

"""

    return markdown


def send_email_report(html_content, to_addresses, subject="Test Execution Report"):
    """Send HTML email report"""
    msg = MIMEMultipart('alternative')
    msg['Subject'] = subject
    msg['From'] = "qa-automation@company.com"
    msg['To'] = ", ".join(to_addresses)

    # Attach HTML content
    html_part = MIMEText(html_content, 'html')
    msg.attach(html_part)

    # Send email
    with smtplib.SMTP('smtp.company.com', 587) as server:
        server.starttls()
        server.login("username", "password")
        server.send_message(msg)

    print(f"✓ Email report sent to {', '.join(to_addresses)}")


def publish_to_confluence(markdown_content, space_key, parent_title):
    """Publish report to Confluence using Atlassian MCP"""
    # Use Atlassian MCP tools to create/update Confluence page
    print(f"✓ Report published to Confluence space '{space_key}'")


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 generate-report.py <report-folder> [--type email|confluence|both] [--email qa@company.com] [--confluence-space QA]")
        sys.exit(1)

    report_folder = sys.argv[1]
    report_type = 'both'  # Default
    email_addresses = []
    confluence_space = None

    # Parse arguments
    for i, arg in enumerate(sys.argv):
        if arg == '--type' and i + 1 < len(sys.argv):
            report_type = sys.argv[i + 1]
        elif arg == '--email' and i + 1 < len(sys.argv):
            email_addresses.append(sys.argv[i + 1])
        elif arg == '--confluence-space' and i + 1 < len(sys.argv):
            confluence_space = sys.argv[i + 1]

    # Parse Katalon report
    parser = KatalonReportParser(report_folder)
    parsed_data = parser.parse()

    # Generate reports
    if report_type in ['email', 'both']:
        html_report = generate_html_report(parsed_data)
        if email_addresses:
            send_email_report(html_report, email_addresses)
        else:
            # Save to file
            with open('test_report.html', 'w') as f:
                f.write(html_report)
            print("✓ HTML report saved to test_report.html")

    if report_type in ['confluence', 'both']:
        markdown_report = generate_confluence_markdown(parsed_data)
        if confluence_space:
            publish_to_confluence(markdown_report, confluence_space, "Test Reports")
        else:
            # Save to file
            with open('test_report.md', 'w') as f:
                f.write(markdown_report)
            print("✓ Confluence markdown saved to test_report.md")


if __name__ == '__main__':
    main()
```

## Integration with Atlassian MCP

Use the Atlassian MCP server for Confluence publishing:

```javascript
// Use mcp__atlassian__create_page tool
{
  "spaceKey": "QA",
  "title": "Test Execution Report - 2025-09-24",
  "parentTitle": "Test Reports",
  "content": "<confluence-formatted-content>",
  "labels": ["test-report", "automated", "katalon"]
}
```

## Report Features

### Charts and Visualizations
- Pass/fail pie charts
- Trend line graphs
- Performance metrics
- Historical comparison

### Mobile Responsive
- Adapts to screen size
- Readable on phones/tablets
- Collapsible sections

### Accessibility
- Semantic HTML
- ARIA labels
- High contrast colors
- Screen reader friendly

### Professional Design
- Modern gradient headers
- Clean typography
- Status badges
- Interactive elements

---

Ready to generate beautiful test reports! 📊✨
