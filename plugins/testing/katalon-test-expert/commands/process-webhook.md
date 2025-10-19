---
name: process-webhook
description: Process incoming Teams webhook with Katalon test results from S3
model: sonnet
---

# Process Katalon Test Results from Teams Webhook

This command processes incoming webhook data from Microsoft Teams that contains a signed S3 URL pointing to Katalon test results.

## Workflow

When you receive a Teams webhook notification about test results:

1. **Extract the webhook payload** - Copy the JSON payload from Teams
2. **Run the webhook processor** - Pass the payload to the webhook receiver script
3. **Download test results** - Automatically download from the signed S3 URL
4. **Parse and analyze** - Process the Katalon report and extract insights
5. **Present findings** - Show test results, failures, and recommendations

## Usage

### Option 1: Direct Payload Processing

```bash
/process-webhook '{"s3_url": "https://bucket.s3.amazonaws.com/test-results.zip?signature=..."}'
```

### Option 2: From File

```bash
/process-webhook --file /path/to/webhook-payload.json
```

### Option 3: Interactive Mode

```
/process-webhook
```

I'll prompt you to paste the webhook payload.

## Webhook Payload Format

The webhook should contain a JSON payload with one of these structures:

### Format 1: Simple S3 URL
```json
{
  "s3_url": "https://bucket.s3.amazonaws.com/test-results.zip?AWSAccessKeyId=...",
  "testSuite": "Regression Suite",
  "environment": "Production",
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### Format 2: Nested Structure
```json
{
  "testResults": {
    "url": "https://bucket.s3.amazonaws.com/results.tar.gz?...",
    "buildId": "BUILD-12345",
    "suite": "Smoke Tests"
  },
  "metadata": {
    "timestamp": "2025-01-15T10:30:00Z",
    "environment": "Staging"
  }
}
```

### Format 3: Teams Adaptive Card
```json
{
  "type": "message",
  "attachments": [{
    "contentType": "application/vnd.microsoft.card.adaptive",
    "contentUrl": "https://bucket.s3.amazonaws.com/report.zip?..."
  }],
  "text": "Test results are ready"
}
```

## Processing Steps

When you run this command, I will:

1. **Validate the payload**
   - Check JSON syntax
   - Verify S3 URL is present
   - Extract metadata (suite name, environment, timestamp)

2. **Download test results**
   - Use the signed S3 URL to download the file
   - Handle retries (up to 3 attempts)
   - Extract archives (ZIP/TAR) automatically
   - Store in `resources/webhook-downloads/`

3. **Locate Katalon report**
   - Find `execution.properties` file
   - Locate JUnit XML, CSV, and HTML reports
   - Identify screenshots and HAR files

4. **Parse test results**
   - Run `katalon-report-parser.py`
   - Extract test summary (total, passed, failed, errors)
   - Identify failed test cases
   - Analyze stack traces and error messages

5. **Analyze failures** (if any)
   - Parse HAR files for network issues
   - Check for common failure patterns
   - Correlate with session recordings
   - Classify as BUG vs TASK

6. **Present findings**
   - Show test execution summary
   - List failed tests with details
   - Provide fix recommendations
   - Offer to create JIRA tickets

## Example Session

```
User: /process-webhook '{"s3_url": "https://test-bucket.s3.amazonaws.com/results.zip?..."}'
Claude: Received webhook payload. Processing...

[Downloading test results from S3...]
✅ Download successful: /resources/webhook-downloads/test-results-20250118_103000/

[Extracting archive...]
✅ Extracted 247 files

[Parsing Katalon report...]
✅ Test Results Summary:
- Total Tests: 45
- Passed: 42
- Failed: 3
- Errors: 0
- Duration: 8m 32s

[Analyzing failures...]

❌ Failed Test 1: TC_Login_InvalidCredentials
- Error: Element 'input#password' not found
- Stack Trace: com.kms.katalon.core.exception.StepFailedException
- Likely Cause: UI element changed or page load timeout
- Classification: BUG
- Recommendation: Check if password field ID changed in recent deployment

❌ Failed Test 2: TC_Quote_PremiumCalculation
- Error: Expected: 3200, Actual: 3245
- Likely Cause: Premium calculation logic change or test data issue
- Classification: TASK (update expected value)
- Recommendation: Verify if premium calculation was intentionally updated

❌ Failed Test 3: TC_API_GetQuoteData
- Error: HTTP 401 Unauthorized
- HAR Analysis: Authentication token expired
- Likely Cause: Token refresh logic not working
- Classification: BUG
- Recommendation: Check API authentication middleware

Would you like me to:
1. Create JIRA tickets for these failures?
2. Generate an HTML report for the team?
3. Analyze the HAR files in more detail?
```

## Implementation

When processing a webhook, I will:

1. **Parse the webhook payload**
   ```bash
   ${CLAUDE_PLUGIN_ROOT}/scripts/webhook-receiver.sh '<payload>'
   ```

2. **Monitor the download progress**
   - Show real-time status
   - Handle errors gracefully
   - Provide download location

3. **Automatically trigger analysis**
   - Parse reports
   - Extract failures
   - Classify issues
   - Generate insights

4. **Present actionable recommendations**
   - Link to session recordings
   - Suggest fixes
   - Offer to create tickets
   - Generate reports

## Supported Archive Formats

- ZIP (`.zip`)
- TAR+GZIP (`.tar.gz`, `.tgz`)
- Single Katalon report directory

## Error Handling

If processing fails, I will:
1. Show the exact error
2. Provide troubleshooting steps
3. Offer manual fallback options
4. Save the download for manual inspection

## Environment Variables

Optional configuration:

```bash
# Custom download directory
export KATALON_DOWNLOAD_DIR="/path/to/downloads"

# Keep downloaded files (default: cleanup after 7 days)
export KEEP_WEBHOOK_DOWNLOADS=true
```

## Security Notes

- S3 URLs must be pre-signed with valid signatures
- URLs expire based on S3 bucket configuration
- Downloaded files are stored locally and not shared
- Sensitive data in reports remains on your machine

## Next Steps

After processing, you can:
- `/create-jira-ticket <report-dir>` - Create tickets for failures
- `/publish-test-report <report-dir>` - Generate HTML/PDF reports
- `/analyze-test <report-dir>` - Deep dive into specific failures
- `/scrape-session <logrocket-url>` - Get detailed session data
