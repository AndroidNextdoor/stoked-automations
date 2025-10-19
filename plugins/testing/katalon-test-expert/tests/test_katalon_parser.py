#!/usr/bin/env python3
"""
Unit tests for Katalon Report Parser
Tests report parsing, URL extraction, HAR analysis, and data structuring
"""

import unittest
import sys
import json
import tempfile
import shutil
from pathlib import Path

# Add parent directory to path to import the parser
sys.path.insert(0, str(Path(__file__).parent.parent / 'scripts'))

# Import by running the script module
import importlib.util
spec = importlib.util.spec_from_file_location(
    "katalon_report_parser",
    str(Path(__file__).parent.parent / 'scripts' / 'katalon-report-parser.py')
)
katalon_report_parser = importlib.util.module_from_spec(spec)
spec.loader.exec_module(katalon_report_parser)
KatalonReportParser = katalon_report_parser.KatalonReportParser


class TestKatalonReportParser(unittest.TestCase):
    """Test suite for Katalon Report Parser"""

    @classmethod
    def setUpClass(cls):
        """Set up test fixtures"""
        cls.sample_report_dir = Path(__file__).parent.parent / 'resources' / '401ErrorReportDir'

        # Create temporary test directory
        cls.temp_dir = Path(tempfile.mkdtemp())

    @classmethod
    def tearDownClass(cls):
        """Clean up test fixtures"""
        if cls.temp_dir.exists():
            shutil.rmtree(cls.temp_dir)

    def test_parser_initialization(self):
        """Test parser can be initialized with valid directory"""
        parser = KatalonReportParser(str(self.sample_report_dir))
        self.assertIsNotNone(parser)
        self.assertEqual(parser.report_folder, self.sample_report_dir)

    def test_parser_invalid_directory(self):
        """Test parser raises error for invalid directory"""
        with self.assertRaises(FileNotFoundError):
            KatalonReportParser("/nonexistent/directory")

    def test_parse_junit_xml(self):
        """Test JUnit XML parsing"""
        parser = KatalonReportParser(str(self.sample_report_dir))
        result = parser.parse_junit_xml()

        # Check basic structure
        self.assertIn('suite_name', result)
        self.assertIn('total_tests', result)
        self.assertIn('failures', result)
        self.assertIn('errors', result)
        self.assertIn('properties', result)
        self.assertIn('test_cases', result)

        # Check specific values from sample data
        self.assertEqual(result['suite_name'], 'Verify AAIS Inland Marine Rating Worksheet')
        self.assertEqual(result['total_tests'], 5)
        self.assertEqual(result['failures'], 1)
        self.assertEqual(result['errors'], 0)

    def test_parse_properties(self):
        """Test test suite properties parsing"""
        parser = KatalonReportParser(str(self.sample_report_dir))
        result = parser.parse_junit_xml()
        props = result['properties']

        # Check key properties exist
        self.assertIn('browser', props)
        self.assertIn('katalon_version', props)
        self.assertIn('session_id', props)
        self.assertIn('remote_driver', props)

        # Check specific values
        self.assertEqual(props['browser'], 'Chrome 140.0.7339.80')
        self.assertEqual(props['katalon_version'], '10.1.0.223')
        self.assertEqual(props['session_id'], '1b16d78aaf1f916146a0db6854b032db')
        self.assertEqual(props['remote_driver'], 'Device Farm')

    def test_parse_test_cases(self):
        """Test individual test case parsing"""
        parser = KatalonReportParser(str(self.sample_report_dir))
        result = parser.parse_junit_xml()
        test_cases = result['test_cases']

        # Check we have test cases
        self.assertGreater(len(test_cases), 0)
        self.assertEqual(len(test_cases), 5)

        # Check test case structure
        for tc in test_cases:
            self.assertIn('name', tc)
            self.assertIn('status', tc)
            self.assertIn('time', tc)

        # Find the failed test
        failed_tests = [tc for tc in test_cases if tc['status'] == 'FAILED']
        self.assertEqual(len(failed_tests), 1)

        failed_test = failed_tests[0]
        self.assertIn('Compare Rating Worksheet To Baseline', failed_test['name'])
        self.assertIn('failure_message', failed_test)

    def test_extract_logrocket_url(self):
        """Test LogRocket URL extraction from JUnit XML"""
        parser = KatalonReportParser(str(self.sample_report_dir))
        urls = parser.extract_session_urls()

        self.assertIsNotNone(urls)
        self.assertIn('logrocket_url', urls)

        logrocket_url = urls['logrocket_url']

        # Check URL structure
        self.assertTrue(logrocket_url.startswith('https://app.logrocket.com/'))
        self.assertIn('/s/', logrocket_url)

        # Check it includes session ID
        self.assertIn('6-01997ca3-2cad-7110-a6a6-9dbb41b835c7', logrocket_url)

        # Check query parameters are included
        self.assertIn('?t=', logrocket_url)

    def test_extract_device_farm_url(self):
        """Test AWS Device Farm URL extraction from JUnit XML"""
        parser = KatalonReportParser(str(self.sample_report_dir))
        urls = parser.extract_session_urls()

        self.assertIsNotNone(urls)
        self.assertIn('device_farm_url', urls)

        device_farm_url = urls['device_farm_url']

        # Check URL structure
        self.assertTrue(device_farm_url.startswith('https://'))
        self.assertIn('console.aws.amazon.com/devicefarm', device_farm_url)
        self.assertIn('/logs/', device_farm_url)

        # Check it includes session ID
        self.assertIn('1b16d78aaf1f916146a0db6854b032db', device_farm_url)

    def test_find_artifacts(self):
        """Test artifact discovery"""
        parser = KatalonReportParser(str(self.sample_report_dir))
        artifacts = parser.find_artifacts()

        # Check artifact types exist
        self.assertIn('screenshots', artifacts)
        self.assertIn('videos', artifacts)
        self.assertIn('har_files', artifacts)
        self.assertIn('logs', artifacts)

        # Check sample data has artifacts
        self.assertGreater(len(artifacts['screenshots']), 0)
        self.assertGreater(len(artifacts['videos']), 0)
        self.assertGreater(len(artifacts['har_files']), 0)

        # Verify specific counts from sample data
        self.assertEqual(len(artifacts['screenshots']), 8)
        self.assertEqual(len(artifacts['videos']), 1)
        self.assertEqual(len(artifacts['har_files']), 2)

    def test_har_file_paths(self):
        """Test HAR files are in correct location"""
        parser = KatalonReportParser(str(self.sample_report_dir))
        artifacts = parser.find_artifacts()
        har_files = artifacts['har_files']

        # Check HAR files exist
        self.assertEqual(len(har_files), 2)

        # Check they're in requests/main/ directory
        for har_file in har_files:
            self.assertIn('requests/main/', har_file)

        # Check specific file names
        har_names = [Path(h).name for h in har_files]
        self.assertIn('Get-Quote-Data_0.har', har_names)
        self.assertIn('Generate-Document_1.har', har_names)

    def test_full_parse(self):
        """Test complete parsing workflow"""
        parser = KatalonReportParser(str(self.sample_report_dir))
        data = parser.parse()

        # Check all top-level keys exist
        self.assertIn('junit_xml', data)
        self.assertIn('execution_json', data)
        self.assertIn('test_suite', data)
        self.assertIn('artifacts', data)
        self.assertIn('session_urls', data)

        # Check data is populated
        self.assertIsNotNone(data['junit_xml'])
        self.assertIsNotNone(data['artifacts'])
        self.assertIsNotNone(data['session_urls'])

    def test_parse_execution_json(self):
        """Test execution.properties JSON parsing"""
        parser = KatalonReportParser(str(self.sample_report_dir))
        result = parser.parse_execution_json()

        # Check execution data exists
        self.assertIsNotNone(result)

        # Check key fields
        if 'Name' in result:
            self.assertIn('Remote', result['Name'])

        if 'execution' in result:
            self.assertIn('general', result['execution'])

    def test_url_extraction_with_query_params(self):
        """Test LogRocket URL extraction preserves query parameters"""
        parser = KatalonReportParser(str(self.sample_report_dir))
        urls = parser.extract_session_urls()

        logrocket_url = urls['logrocket_url']

        # Verify query parameter is preserved
        self.assertIn('?t=', logrocket_url)
        self.assertIn('1758732696544', logrocket_url)

        # Full URL should match expected format
        expected_base = 'https://app.logrocket.com/dtizdl/portal/s/6-01997ca3-2cad-7110-a6a6-9dbb41b835c7/0'
        self.assertTrue(logrocket_url.startswith(expected_base))


class TestURLExtractionEdgeCases(unittest.TestCase):
    """Test edge cases for URL extraction"""

    @classmethod
    def setUpClass(cls):
        """Create temporary test directories with various URL formats"""
        cls.temp_dir = Path(tempfile.mkdtemp())

        # Create test case 1: LogRocket URL only
        cls.logrocket_only_dir = cls.temp_dir / 'logrocket_only'
        cls.logrocket_only_dir.mkdir()

        junit_xml_logrocket = """<?xml version="1.0" encoding="UTF-8"?>
<testsuites name="Test Suite" time="10.0" tests="1" failures="0" errors="0">
    <testsuite name="Test Suite" tests="1" failures="0" errors="0" time="10.0">
        <testcase name="Test Case" time="10.0" status="PASSED">
            <system-out><![CDATA[
[MESSAGE][INFO] - LogRocket Session: https://app.logrocket.com/org123/project456/s/session-789/0?t=1234567890
            ]]></system-out>
        </testcase>
    </testsuite>
</testsuites>
"""
        (cls.logrocket_only_dir / 'JUnit_Report.xml').write_text(junit_xml_logrocket)

        # Create test case 2: Device Farm URL only
        cls.device_farm_only_dir = cls.temp_dir / 'device_farm_only'
        cls.device_farm_only_dir.mkdir()

        junit_xml_device_farm = """<?xml version="1.0" encoding="UTF-8"?>
<testsuites name="Test Suite" time="10.0" tests="1" failures="0" errors="0">
    <testsuite name="Test Suite" tests="1" failures="0" errors="0" time="10.0">
        <testcase name="Test Case" time="10.0" status="PASSED">
            <system-out><![CDATA[
[MESSAGE][INFO] - Device Farm Session: https://us-west-2.console.aws.amazon.com/devicefarm/home?region=us-west-2#/browser/projects/abc123/runsselenium/logs/def456
            ]]></system-out>
        </testcase>
    </testsuite>
</testsuites>
"""
        (cls.device_farm_only_dir / 'JUnit_Report.xml').write_text(junit_xml_device_farm)

        # Create test case 3: No URLs
        cls.no_urls_dir = cls.temp_dir / 'no_urls'
        cls.no_urls_dir.mkdir()

        junit_xml_no_urls = """<?xml version="1.0" encoding="UTF-8"?>
<testsuites name="Test Suite" time="10.0" tests="1" failures="0" errors="0">
    <testsuite name="Test Suite" tests="1" failures="0" errors="0" time="10.0">
        <testcase name="Test Case" time="10.0" status="PASSED">
            <system-out><![CDATA[
[MESSAGE][INFO] - Test completed successfully
            ]]></system-out>
        </testcase>
    </testsuite>
</testsuites>
"""
        (cls.no_urls_dir / 'JUnit_Report.xml').write_text(junit_xml_no_urls)

    @classmethod
    def tearDownClass(cls):
        """Clean up temporary directories"""
        if cls.temp_dir.exists():
            shutil.rmtree(cls.temp_dir)

    def test_logrocket_only(self):
        """Test extraction when only LogRocket URL present"""
        parser = KatalonReportParser(str(self.logrocket_only_dir))
        urls = parser.extract_session_urls()

        self.assertIsNotNone(urls)
        self.assertIn('logrocket_url', urls)
        self.assertNotIn('device_farm_url', urls)

        self.assertIn('https://app.logrocket.com/', urls['logrocket_url'])

    def test_device_farm_only(self):
        """Test extraction when only Device Farm URL present"""
        parser = KatalonReportParser(str(self.device_farm_only_dir))
        urls = parser.extract_session_urls()

        self.assertIsNotNone(urls)
        self.assertIn('device_farm_url', urls)
        self.assertNotIn('logrocket_url', urls)

        self.assertIn('console.aws.amazon.com/devicefarm', urls['device_farm_url'])

    def test_no_urls(self):
        """Test extraction when no session URLs present"""
        parser = KatalonReportParser(str(self.no_urls_dir))
        urls = parser.extract_session_urls()

        # Should return None when no URLs found
        self.assertIsNone(urls)


class TestReportFormats(unittest.TestCase):
    """Test URL extraction from different report formats"""

    @classmethod
    def setUpClass(cls):
        """Create test reports in different formats"""
        cls.temp_dir = Path(tempfile.mkdtemp())

        # Create HTML report with LogRocket URL
        html_content = """
<!DOCTYPE html>
<html>
<head><title>Test Report</title></head>
<body>
    <div class="session-info">
        <p>LogRocket Session: <a href="https://app.logrocket.com/test/project/s/html-session-123/0?t=9999999999">View Session</a></p>
    </div>
</body>
</html>
"""
        (cls.temp_dir / 'report.html').write_text(html_content)

        # Create CSV report with LogRocket URL
        csv_content = """Test Name,Status,Duration,Session URL
Test Case 1,PASSED,10.5,https://app.logrocket.com/test/project/s/csv-session-456/0?t=8888888888
"""
        (cls.temp_dir / 'report.csv').write_text(csv_content)

        # Create minimal JUnit XML (no URLs)
        junit_xml = """<?xml version="1.0" encoding="UTF-8"?>
<testsuites name="Test Suite" time="10.0" tests="1" failures="0" errors="0">
    <testsuite name="Test Suite" tests="1" failures="0" errors="0" time="10.0">
        <testcase name="Test Case" time="10.0" status="PASSED"/>
    </testsuite>
</testsuites>
"""
        (cls.temp_dir / 'JUnit_Report.xml').write_text(junit_xml)

    @classmethod
    def tearDownClass(cls):
        """Clean up temporary directories"""
        if cls.temp_dir.exists():
            shutil.rmtree(cls.temp_dir)

    def test_extract_from_html(self):
        """Test LogRocket URL extraction from HTML report"""
        parser = KatalonReportParser(str(self.temp_dir))
        urls = parser.extract_session_urls()

        self.assertIsNotNone(urls)
        self.assertIn('logrocket_url', urls)

        # Should find URL from HTML
        self.assertIn('html-session-123', urls['logrocket_url'])

    def test_extract_from_csv(self):
        """Test LogRocket URL extraction from CSV report"""
        parser = KatalonReportParser(str(self.temp_dir))
        urls = parser.extract_session_urls()

        self.assertIsNotNone(urls)
        self.assertIn('logrocket_url', urls)

        # Could be from HTML or CSV, either is valid
        logrocket_url = urls['logrocket_url']
        self.assertTrue(
            'html-session-123' in logrocket_url or
            'csv-session-456' in logrocket_url
        )


if __name__ == '__main__':
    # Run tests with verbose output
    unittest.main(verbosity=2)