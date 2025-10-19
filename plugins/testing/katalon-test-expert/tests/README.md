# Katalon Test Analyzer - Test Suite

Comprehensive unit tests for the Katalon Report Parser validating all core functionality.

## Test Coverage

### ✅ **17 Tests - All Passing**

```
test_extract_device_farm_url ......................... ok
test_extract_logrocket_url ........................... ok
test_find_artifacts .................................. ok
test_full_parse ...................................... ok
test_har_file_paths .................................. ok
test_parse_execution_json ............................ ok
test_parse_junit_xml ................................. ok
test_parse_properties ................................ ok
test_parse_test_cases ................................ ok
test_parser_initialization ........................... ok
test_parser_invalid_directory ........................ ok
test_url_extraction_with_query_params ................ ok
test_extract_from_csv ................................ ok
test_extract_from_html ............................... ok
test_device_farm_only ................................ ok
test_logrocket_only .................................. ok
test_no_urls ......................................... ok

----------------------------------------------------------------------
Ran 17 tests in 0.032s - OK
```

## Test Categories

### 1. Parser Initialization (2 tests)
- ✅ Valid directory initialization
- ✅ Invalid directory error handling

### 2. JUnit XML Parsing (4 tests)
- ✅ Basic XML structure parsing
- ✅ Test suite properties extraction
- ✅ Individual test case parsing
- ✅ Full parsing workflow

### 3. URL Extraction (6 tests)
- ✅ LogRocket URL extraction from XML
- ✅ AWS Device Farm URL extraction from XML
- ✅ Query parameter preservation
- ✅ LogRocket URL only
- ✅ Device Farm URL only
- ✅ No URLs present

### 4. Report Formats (2 tests)
- ✅ LogRocket URL from HTML reports
- ✅ LogRocket URL from CSV reports

### 5. Artifact Discovery (3 tests)
- ✅ All artifact types found
- ✅ Correct artifact counts
- ✅ HAR files in correct locations

## Running Tests

### Quick Run

```bash
cd plugins/testing/katalon-test-analyzer
python3 tests/test_katalon_parser.py
```

### Using Test Runner

```bash
cd plugins/testing/katalon-test-analyzer
./tests/run_tests.sh
```

### With Verbose Output

```bash
python3 tests/test_katalon_parser.py -v
```

### Run Specific Test Class

```bash
python3 tests/test_katalon_parser.py TestKatalonReportParser
```

### Run Specific Test Method

```bash
python3 tests/test_katalon_parser.py TestKatalonReportParser.test_extract_logrocket_url
```

## Test Data

Tests use two data sources:

1. **Real Sample Data** (`resources/401ErrorReportDir/`)
   - Actual Katalon report from failed test
   - Contains JUnit XML, execution.properties, HAR files
   - LogRocket and AWS Device Farm session URLs
   - 8 screenshots, 1 video, 2 HAR files

2. **Generated Test Data** (temporary directories)
   - Edge cases: LogRocket only, Device Farm only, no URLs
   - Different report formats: HTML, CSV
   - Created/destroyed dynamically during test runs

## Key Test Assertions

### LogRocket URL Extraction

```python
def test_extract_logrocket_url(self):
    parser = KatalonReportParser(str(self.sample_report_dir))
    urls = parser.extract_session_urls()

    # Verifies:
    # - URL starts with https://app.logrocket.com/
    # - Contains /s/ session path
    # - Includes session ID
    # - Preserves query parameters (?t=timestamp)
```

**Tested URL:**
```
https://app.logrocket.com/dtizdl/portal/s/6-01997ca3-2cad-7110-a6a6-9dbb41b835c7/0?t=1758732696544
```

### AWS Device Farm URL Extraction

```python
def test_extract_device_farm_url(self):
    parser = KatalonReportParser(str(self.sample_report_dir))
    urls = parser.extract_session_urls()

    # Verifies:
    # - URL contains console.aws.amazon.com/devicefarm
    # - Contains /logs/ path
    # - Includes session ID
```

**Tested URL:**
```
https://us-west-2.console.aws.amazon.com/devicefarm/home?region=us-west-2#/browser/projects/4bf8c095-a160-4a34-ae26-f0d9fb7e7ece/runsselenium/logs/1b16d78aaf1f916146a0db6854b032db
```

### Test Properties Parsing

```python
def test_parse_properties(self):
    parser = KatalonReportParser(str(self.sample_report_dir))
    result = parser.parse_junit_xml()
    props = result['properties']

    # Verifies exact values from sample data:
    assert props['browser'] == 'Chrome 140.0.7339.80'
    assert props['katalon_version'] == '10.1.0.223'
    assert props['session_id'] == '1b16d78aaf1f916146a0db6854b032db'
    assert props['remote_driver'] == 'Device Farm'
```

### Artifact Counts

```python
def test_find_artifacts(self):
    parser = KatalonReportParser(str(self.sample_report_dir))
    artifacts = parser.find_artifacts()

    # Verifies exact counts from sample data:
    assert len(artifacts['screenshots']) == 8
    assert len(artifacts['videos']) == 1
    assert len(artifacts['har_files']) == 2
```

## Edge Cases Tested

### 1. LogRocket URL Only
Creates a test report with LogRocket URL but no AWS Device Farm URL.

**Verifies:**
- `logrocket_url` key exists
- `device_farm_url` key does NOT exist
- Returns correct LogRocket URL

### 2. AWS Device Farm URL Only
Creates a test report with Device Farm URL but no LogRocket URL.

**Verifies:**
- `device_farm_url` key exists
- `logrocket_url` key does NOT exist
- Returns correct Device Farm URL

### 3. No Session URLs
Creates a test report with no session recording URLs.

**Verifies:**
- Returns `None` (not an empty dict)
- No exceptions raised
- Parser handles gracefully

### 4. HTML Report Format
Tests URL extraction from HTML files.

**HTML Content:**
```html
<div class="session-info">
    <p>LogRocket Session: <a href="https://app.logrocket.com/test/project/s/html-session-123/0?t=9999999999">View Session</a></p>
</div>
```

**Verifies:**
- Extracts URL from HTML anchor tags
- Preserves query parameters
- Handles HTML encoding

### 5. CSV Report Format
Tests URL extraction from CSV files.

**CSV Content:**
```csv
Test Name,Status,Duration,Session URL
Test Case 1,PASSED,10.5,https://app.logrocket.com/test/project/s/csv-session-456/0?t=8888888888
```

**Verifies:**
- Extracts URL from CSV columns
- Handles comma-separated values
- Preserves full URL format

## Test Fixtures

### Sample Report Directory Structure

```
resources/401ErrorReportDir/
├── JUnit_Report.xml              # Main test results
├── execution.properties          # Test configuration
├── 20250924_164932.html          # HTML report
├── 20250924_164932.csv           # CSV report
├── 20250924_164932.pdf           # PDF report
├── keyes/                        # Screenshots
│   ├── keyes-Login Page.png
│   ├── keyes-Error State.png
│   └── ... (8 total)
├── requests/main/                # HAR files
│   ├── Get-Quote-Data_0.har
│   └── Generate-Document_1.har
└── video_testgrid_*.mp4          # Test video
```

### Temporary Test Directories

Created dynamically during test execution:

```
/tmp/katalon_test_XXXXX/
├── logrocket_only/
│   └── JUnit_Report.xml
├── device_farm_only/
│   └── JUnit_Report.xml
├── no_urls/
│   └── JUnit_Report.xml
└── report_formats/
    ├── report.html
    ├── report.csv
    └── JUnit_Report.xml
```

## Continuous Integration

### Run in CI/CD

```yaml
# .github/workflows/test.yml
name: Test Katalon Parser

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.9'

      - name: Run tests
        run: |
          cd plugins/testing/katalon-test-analyzer
          python3 tests/test_katalon_parser.py
```

## Adding New Tests

### Test Template

```python
def test_new_feature(self):
    """Test description"""
    # Arrange
    parser = KatalonReportParser(str(self.sample_report_dir))

    # Act
    result = parser.some_method()

    # Assert
    self.assertIsNotNone(result)
    self.assertEqual(result['key'], 'expected_value')
```

### Testing URL Extraction

```python
def test_new_url_format(self):
    """Test new session recording service"""
    # Create test data
    temp_dir = Path(tempfile.mkdtemp())
    junit_xml = """<?xml version="1.0" encoding="UTF-8"?>
<testsuites name="Test" time="1.0" tests="1" failures="0">
    <testsuite name="Test" tests="1" failures="0" time="1.0">
        <testcase name="Test" time="1.0" status="PASSED">
            <system-out><![CDATA[
New Service URL: https://newsservice.com/session/abc123
            ]]></system-out>
        </testcase>
    </testsuite>
</testsuites>
"""
    (temp_dir / 'JUnit_Report.xml').write_text(junit_xml)

    # Test extraction
    parser = KatalonReportParser(str(temp_dir))
    urls = parser.extract_session_urls()

    # Verify
    self.assertIn('new_service_url', urls)
    self.assertIn('newsservice.com', urls['new_service_url'])

    # Cleanup
    shutil.rmtree(temp_dir)
```

## Troubleshooting Tests

### Test Fails: File Not Found

**Problem:** Sample data directory doesn't exist

**Solution:**
```bash
# Verify sample data exists
ls -la resources/401ErrorReportDir/

# If missing, tests will fail
# Make sure you're in the correct directory:
cd plugins/testing/katalon-test-analyzer
```

### Test Fails: Import Error

**Problem:** Can't import `katalon-report-parser.py`

**Solution:**
```python
# The test uses dynamic import to handle hyphenated filename
import importlib.util
spec = importlib.util.spec_from_file_location(
    "katalon_report_parser",
    "scripts/katalon-report-parser.py"
)
```

### Test Fails: URL Not Extracted

**Problem:** LogRocket URL not found in test data

**Solution:**
```bash
# Check if URL exists in sample data
grep -r "logrocket.com" resources/401ErrorReportDir/

# Should find:
# JUnit_Report.xml: https://app.logrocket.com/dtizdl/...
```

### Test Fails: Assertion Mismatch

**Problem:** Expected value doesn't match actual

**Solution:**
```bash
# Run parser manually to see actual values
python3 scripts/katalon-report-parser.py resources/401ErrorReportDir/

# Update test expectations based on actual output
```

## Test Maintenance

### Update Test Data

When sample data changes:

1. Re-run parser to get new values:
   ```bash
   python3 scripts/katalon-report-parser.py resources/401ErrorReportDir/ --json test_data.json
   ```

2. Update test assertions:
   ```python
   # Old
   self.assertEqual(len(artifacts['screenshots']), 8)

   # New (if sample data now has 10 screenshots)
   self.assertEqual(len(artifacts['screenshots']), 10)
   ```

3. Re-run tests to verify:
   ```bash
   python3 tests/test_katalon_parser.py
   ```

### Add Test for New Feature

1. Write the new parser method
2. Write the test first (TDD):
   ```python
   def test_new_parser_method(self):
       parser = KatalonReportParser(str(self.sample_report_dir))
       result = parser.new_method()
       self.assertIsNotNone(result)
   ```
3. Run test (should fail)
4. Implement the method
5. Run test (should pass)

## Performance

Tests run in **0.032 seconds** on average:

- **Fast:** Dynamic test data creation using `tempfile`
- **Efficient:** Reuses sample data across test methods
- **Parallelizable:** Independent test classes can run concurrently

## Coverage Goals

Current coverage: **100%** of parser methods

- ✅ `parse()` - Full parsing workflow
- ✅ `parse_junit_xml()` - JUnit XML parsing
- ✅ `parse_execution_json()` - Execution properties
- ✅ `parse_test_suite()` - HTML/CSV reports
- ✅ `find_artifacts()` - Artifact discovery
- ✅ `extract_session_urls()` - URL extraction (all formats)
- ✅ `_parse_properties()` - Property parsing
- ✅ `_parse_test_cases()` - Test case parsing

## Future Test Ideas

### Additional Test Coverage

- [ ] Test malformed XML handling
- [ ] Test large file performance (1000+ test cases)
- [ ] Test Unicode characters in URLs
- [ ] Test binary file handling (PDF)
- [ ] Test concurrent parsing (thread safety)
- [ ] Integration test with HAR analyzer
- [ ] Integration test with MySQL connector

### Edge Cases

- [ ] Empty JUnit XML file
- [ ] XML with only passed tests (no failures)
- [ ] Multiple LogRocket URLs in one report
- [ ] Malformed URLs (missing protocol, invalid format)
- [ ] Very long session IDs
- [ ] Special characters in file paths

---

**Last Updated:** October 2025
**Test Framework:** Python unittest
**Python Version:** 3.7+
**Test Count:** 17 tests, all passing