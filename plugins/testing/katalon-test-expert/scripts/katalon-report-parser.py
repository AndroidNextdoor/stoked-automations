#!/usr/bin/env python3
"""
Katalon Report Parser
Parses Katalon Studio generated reports (XML, JSON, HTML)
"""

import json
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Dict, List, Any
import sys
import re


class KatalonReportParser:
    def __init__(self, report_folder: str):
        self.report_folder = Path(report_folder)
        if not self.report_folder.exists():
            raise FileNotFoundError(f"Report folder not found: {report_folder}")

    def parse(self) -> Dict[str, Any]:
        """Parse all Katalon reports in the folder"""
        return {
            'junit_xml': self.parse_junit_xml(),
            'execution_json': self.parse_execution_json(),
            'test_suite': self.parse_test_suite(),
            'artifacts': self.find_artifacts(),
            'session_urls': self.extract_session_urls()
        }

    def parse_junit_xml(self) -> Dict[str, Any]:
        """Parse JUnit XML report"""
        junit_files = list(self.report_folder.glob('**/JUnit_Report.xml'))
        if not junit_files:
            return {}

        try:
            tree = ET.parse(junit_files[0])
            root = tree.getroot()

            # Get test suite element (contains properties)
            testsuite = root.find('.//testsuite')
            properties = self._parse_properties(testsuite) if testsuite is not None else {}

            return {
                'suite_name': root.get('name', ''),
                'total_tests': int(root.get('tests', 0)),
                'failures': int(root.get('failures', 0)),
                'errors': int(root.get('errors', 0)),
                'skipped': int(root.get('skipped', 0)),
                'time_seconds': float(root.get('time', 0)),
                'properties': properties,
                'test_cases': self._parse_test_cases(root)
            }
        except Exception as e:
            return {'error': str(e)}

    def _parse_properties(self, testsuite: ET.Element) -> Dict[str, Any]:
        """Parse test suite properties including AWS Device Farm URLs"""
        props = {}
        properties = testsuite.find('properties')
        if properties is None:
            return props

        for prop in properties.findall('property'):
            name = prop.get('name')
            value = prop.get('value', '')

            # Parse specific important properties
            if name == 'sessionId':
                props['session_id'] = value
            elif name == 'logFolder':
                props['log_folder'] = value
            elif name == 'attachments':
                props['attachments'] = [a.strip() for a in value.split(',') if a.strip()]
            elif name == 'browser':
                props['browser'] = value
            elif name == 'remoteDriverUrl':
                props['remote_driver'] = value
            elif name == 'katalonVersion':
                props['katalon_version'] = value
            else:
                props[name] = value

        return props

    def _parse_test_cases(self, root: ET.Element) -> List[Dict[str, Any]]:
        """Parse individual test cases from XML"""
        test_cases = []
        for testcase in root.findall('.//testcase'):
            case = {
                'name': testcase.get('name'),
                'classname': testcase.get('classname'),
                'time': float(testcase.get('time', 0)),
                'status': 'PASSED'
            }

            # Check for failures
            failure = testcase.find('failure')
            if failure is not None:
                case['status'] = 'FAILED'
                case['failure_message'] = failure.get('message', '')
                case['failure_type'] = failure.get('type', '')
                case['stack_trace'] = failure.text

            # Check for errors
            error = testcase.find('error')
            if error is not None:
                case['status'] = 'ERROR'
                case['error_message'] = error.get('message', '')
                case['error_type'] = error.get('type', '')
                case['stack_trace'] = error.text

            # Check for skipped
            if testcase.find('skipped') is not None:
                case['status'] = 'SKIPPED'

            test_cases.append(case)

        return test_cases

    def parse_execution_json(self) -> Dict[str, Any]:
        """Parse execution JSON if available"""
        json_files = list(self.report_folder.glob('**/execution*.json'))
        if not json_files:
            return {}

        try:
            with open(json_files[0], 'r') as f:
                data = json.load(f)
            return data
        except Exception as e:
            return {'error': str(e)}

    def parse_test_suite(self) -> Dict[str, Any]:
        """Parse test suite information"""
        # Look for test suite XML or HTML reports
        suite_files = list(self.report_folder.glob('**/*.html'))
        if not suite_files:
            return {}

        # Parse HTML report for basic info
        try:
            with open(suite_files[0], 'r') as f:
                content = f.read()

            return {
                'report_file': str(suite_files[0]),
                'contains_screenshots': 'screenshot' in content.lower(),
                'contains_videos': 'video' in content.lower(),
                'contains_har': '.har' in content.lower()
            }
        except Exception as e:
            return {'error': str(e)}

    def find_artifacts(self) -> Dict[str, List[str]]:
        """Find all test artifacts"""
        # Note: glob doesn't support {mp4,webm} syntax, need separate searches
        videos = list(self.report_folder.glob('**/*.mp4'))
        videos.extend(self.report_folder.glob('**/*.webm'))

        return {
            'screenshots': [str(f) for f in self.report_folder.glob('**/*.png')],
            'videos': [str(f) for f in videos],
            'har_files': [str(f) for f in self.report_folder.glob('**/*.har')],
            'logs': [str(f) for f in self.report_folder.glob('**/*.log')]
        }

    def extract_session_urls(self) -> Dict[str, str]:
        """Extract LogRocket or AWS Device Farm session URLs from logs and XML"""
        urls = {}

        # Pattern for LogRocket URLs (including query parameters)
        logrocket_pattern = r'https://app\.logrocket\.com/[a-zA-Z0-9/\-\?=&]+'

        # Pattern for AWS Device Farm URLs
        device_farm_pattern = r'https://[a-z0-9\-]+\.console\.aws\.amazon\.com/devicefarm/[^\s]+'

        # Check JUnit XML first (contains both LogRocket and AWS Device Farm URLs)
        junit_files = list(self.report_folder.glob('**/JUnit_Report.xml'))
        if junit_files:
            try:
                with open(junit_files[0], 'r') as f:
                    content = f.read()

                # Check for LogRocket in MESSAGE logs
                logrocket_match = re.search(logrocket_pattern, content)
                if logrocket_match:
                    urls['logrocket_url'] = logrocket_match.group(0)

                # Check for AWS Device Farm
                device_farm_match = re.search(device_farm_pattern, content)
                if device_farm_match:
                    urls['device_farm_url'] = device_farm_match.group(0)
            except:
                pass

        # Also check log files as fallback
        log_files = list(self.report_folder.glob('**/*.log'))
        for log_file in log_files:
            try:
                with open(log_file, 'r') as f:
                    content = f.read()

                # Check for LogRocket (if not already found)
                if 'logrocket_url' not in urls:
                    logrocket_match = re.search(logrocket_pattern, content)
                    if logrocket_match:
                        urls['logrocket_url'] = logrocket_match.group(0)

                # Check for AWS Device Farm (if not already found)
                if 'device_farm_url' not in urls:
                    device_farm_match = re.search(device_farm_pattern, content)
                    if device_farm_match:
                        urls['device_farm_url'] = device_farm_match.group(0)
            except:
                continue

        # Also check HTML, PDF, CSV reports
        for ext in ['html', 'pdf', 'csv']:
            report_files = list(self.report_folder.glob(f'**/*.{ext}'))
            for report_file in report_files:
                try:
                    with open(report_file, 'r', encoding='utf-8', errors='ignore') as f:
                        content = f.read()

                    # Check for LogRocket (if not already found)
                    if 'logrocket_url' not in urls:
                        logrocket_match = re.search(logrocket_pattern, content)
                        if logrocket_match:
                            urls['logrocket_url'] = logrocket_match.group(0)

                    # Check for AWS Device Farm (if not already found)
                    if 'device_farm_url' not in urls:
                        device_farm_match = re.search(device_farm_pattern, content)
                        if device_farm_match:
                            urls['device_farm_url'] = device_farm_match.group(0)

                    # Break if we found both
                    if 'logrocket_url' in urls and 'device_farm_url' in urls:
                        break
                except:
                    continue

        return urls if urls else None


def print_report(parsed_data: Dict[str, Any]):
    """Print formatted report"""
    print("\n" + "="*80)
    print("KATALON REPORT ANALYSIS")
    print("="*80 + "\n")

    # JUnit XML Summary
    junit = parsed_data.get('junit_xml', {})
    if junit and 'total_tests' in junit:
        print("TEST EXECUTION SUMMARY")
        print("-" * 80)
        print(f"Suite: {junit.get('suite_name', 'Unknown')}")
        print(f"Total Tests: {junit['total_tests']}")
        print(f"Passed: {junit['total_tests'] - junit['failures'] - junit['errors']}")
        print(f"Failed: {junit['failures']}")
        print(f"Errors: {junit['errors']}")
        print(f"Skipped: {junit['skipped']}")
        print(f"Duration: {junit['time_seconds']:.2f}s\n")

        # Test Environment
        props = junit.get('properties', {})
        if props:
            print("TEST ENVIRONMENT")
            print("-" * 80)
            if 'browser' in props:
                print(f"Browser: {props['browser']}")
            if 'katalon_version' in props:
                print(f"Katalon Version: {props['katalon_version']}")
            if 'remote_driver' in props:
                print(f"Remote Driver: {props['remote_driver']}")
            if 'session_id' in props:
                print(f"Session ID: {props['session_id']}")
            print()

        # Failed tests
        failed_tests = [tc for tc in junit.get('test_cases', []) if tc['status'] in ['FAILED', 'ERROR']]
        if failed_tests:
            print(f"FAILED TESTS ({len(failed_tests)})")
            print("-" * 80)
            for test in failed_tests:
                print(f"\n{test['name']}")
                print(f"  Status: {test['status']}")
                print(f"  Duration: {test['time']:.2f}s")
                if 'failure_message' in test:
                    print(f"  Error: {test['failure_message']}")
            print()

    # Session URLs
    session_urls = parsed_data.get('session_urls')
    if session_urls:
        print("SESSION RECORDING LINKS")
        print("-" * 80)
        if 'logrocket_url' in session_urls:
            print(f"LogRocket: {session_urls['logrocket_url']}")
        if 'device_farm_url' in session_urls:
            print(f"AWS Device Farm: {session_urls['device_farm_url']}")
        print()

    # Artifacts
    artifacts = parsed_data.get('artifacts', {})
    if artifacts:
        print("TEST ARTIFACTS")
        print("-" * 80)
        print(f"Screenshots: {len(artifacts.get('screenshots', []))}")
        print(f"Videos: {len(artifacts.get('videos', []))}")
        print(f"HAR Files: {len(artifacts.get('har_files', []))}")
        print(f"Log Files: {len(artifacts.get('logs', []))}\n")

        if artifacts.get('har_files'):
            print("HAR Files Found:")
            for har in artifacts['har_files']:
                print(f"  - {har}")
            print()

    print("="*80 + "\n")


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 katalon-report-parser.py <report-folder> [--json output.json]")
        sys.exit(1)

    report_folder = sys.argv[1]

    try:
        parser = KatalonReportParser(report_folder)
        parsed_data = parser.parse()

        # Session URLs are already in parsed_data from parse()

        # Check for JSON export
        if '--json' in sys.argv:
            json_index = sys.argv.index('--json')
            output_file = sys.argv[json_index + 1] if len(sys.argv) > json_index + 1 else 'report.json'
            with open(output_file, 'w') as f:
                json.dump(parsed_data, f, indent=2)
            print(f"✓ Report exported to {output_file}")
        else:
            print_report(parsed_data)

    except Exception as e:
        print(f"Error parsing Katalon report: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()