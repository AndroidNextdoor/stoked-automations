#!/usr/bin/env python3
"""
Katalon HAR File Analyzer
Analyzes HTTP Archive (HAR) files from Katalon tests for performance and errors
"""

import json
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any
from collections import defaultdict

try:
    from haralyzer import HarParser, HarPage
except ImportError:
    print("Error: haralyzer not installed. Run: pip3 install haralyzer")
    sys.exit(1)


class KatalonHarAnalyzer:
    def __init__(self, har_file_path: str):
        self.har_file_path = Path(har_file_path)
        if not self.har_file_path.exists():
            raise FileNotFoundError(f"HAR file not found: {har_file_path}")

        with open(self.har_file_path, 'r') as f:
            self.har_data = json.load(f)

        self.parser = HarParser(self.har_data)
        self.pages = self.parser.pages

    def analyze(self) -> Dict[str, Any]:
        """Perform complete HAR analysis"""
        return {
            'summary': self.get_summary(),
            'performance': self.analyze_performance(),
            'errors': self.analyze_errors(),
            'slow_requests': self.find_slow_requests(),
            'failed_requests': self.get_failed_requests(),
            'resource_breakdown': self.analyze_resources(),
            'timing_waterfall': self.get_timing_waterfall(),
            'recommendations': self.generate_recommendations()
        }

    def get_summary(self) -> Dict[str, Any]:
        """Get high-level summary"""
        entries = self.parser.har_data['entries']
        return {
            'total_requests': len(entries),
            'total_size_kb': sum(e.get('response', {}).get('bodySize', 0) for e in entries) / 1024,
            'total_duration_ms': sum(e.get('time', 0) for e in entries),
            'pages': len(self.pages),
            'timestamp': self.parser.har_data.get('log', {}).get('pages', [{}])[0].get('startedDateTime', 'unknown')
        }

    def analyze_performance(self) -> Dict[str, Any]:
        """Analyze performance metrics"""
        if not self.pages:
            return {}

        page = self.pages[0]  # Focus on first page
        return {
            'page_load_time_ms': page.page_load_time,
            'on_content_load_ms': page.on_content_load,
            'on_load_ms': page.on_load,
            'dns_time_ms': page.dns_time,
            'connect_time_ms': page.connect_time,
            'ssl_time_ms': page.ssl_time,
            'blocked_time_ms': page.blocked_time,
            'send_time_ms': page.send_time,
            'wait_time_ms': page.wait_time,
            'receive_time_ms': page.receive_time
        }

    def analyze_errors(self) -> Dict[str, Any]:
        """Analyze errors and failed requests"""
        entries = self.parser.har_data['entries']
        errors = []
        error_counts = defaultdict(int)

        for entry in entries:
            status = entry.get('response', {}).get('status', 0)
            if status >= 400:
                url = entry.get('request', {}).get('url', 'unknown')
                error_type = self._classify_error(status)
                errors.append({
                    'url': url,
                    'status': status,
                    'status_text': entry.get('response', {}).get('statusText', ''),
                    'type': error_type,
                    'time': entry.get('startedDateTime')
                })
                error_counts[error_type] += 1

        return {
            'total_errors': len(errors),
            'error_breakdown': dict(error_counts),
            'errors': errors[:10]  # Limit to first 10
        }

    def _classify_error(self, status: int) -> str:
        """Classify HTTP error by status code"""
        if status == 0:
            return 'Network Error'
        elif 400 <= status < 500:
            return 'Client Error'
        elif 500 <= status < 600:
            return 'Server Error'
        else:
            return 'Unknown Error'

    def find_slow_requests(self, threshold_ms: int = 1000) -> List[Dict[str, Any]]:
        """Find requests slower than threshold"""
        entries = self.parser.har_data['entries']
        slow_requests = []

        for entry in entries:
            time_ms = entry.get('time', 0)
            if time_ms > threshold_ms:
                slow_requests.append({
                    'url': entry.get('request', {}).get('url', 'unknown'),
                    'method': entry.get('request', {}).get('method', 'unknown'),
                    'time_ms': time_ms,
                    'size_kb': entry.get('response', {}).get('bodySize', 0) / 1024,
                    'status': entry.get('response', {}).get('status', 0)
                })

        return sorted(slow_requests, key=lambda x: x['time_ms'], reverse=True)

    def get_failed_requests(self) -> List[Dict[str, Any]]:
        """Get all failed requests"""
        entries = self.parser.har_data['entries']
        failed = []

        for entry in entries:
            status = entry.get('response', {}).get('status', 0)
            if status == 0 or status >= 400:
                failed.append({
                    'url': entry.get('request', {}).get('url', 'unknown'),
                    'method': entry.get('request', {}).get('method', 'unknown'),
                    'status': status,
                    'error': entry.get('response', {}).get('statusText', 'Unknown error'),
                    'time': entry.get('startedDateTime')
                })

        return failed

    def analyze_resources(self) -> Dict[str, Any]:
        """Analyze resource types and sizes"""
        entries = self.parser.har_data['entries']
        resource_stats = defaultdict(lambda: {'count': 0, 'size_kb': 0})

        for entry in entries:
            content = entry.get('response', {}).get('content', {})
            mime_type = content.get('mimeType', 'unknown')
            size_bytes = entry.get('response', {}).get('bodySize', 0)

            # Simplify MIME type
            resource_type = self._get_resource_type(mime_type)

            resource_stats[resource_type]['count'] += 1
            resource_stats[resource_type]['size_kb'] += size_bytes / 1024

        return dict(resource_stats)

    def _get_resource_type(self, mime_type: str) -> str:
        """Categorize resource by MIME type"""
        if 'javascript' in mime_type or 'json' in mime_type:
            return 'JavaScript'
        elif 'css' in mime_type:
            return 'CSS'
        elif 'html' in mime_type:
            return 'HTML'
        elif 'image' in mime_type:
            return 'Image'
        elif 'font' in mime_type:
            return 'Font'
        elif 'video' in mime_type:
            return 'Video'
        else:
            return 'Other'

    def get_timing_waterfall(self, limit: int = 20) -> List[Dict[str, Any]]:
        """Get timing waterfall data for requests"""
        entries = self.parser.har_data['entries'][:limit]
        waterfall = []

        for entry in entries:
            timings = entry.get('timings', {})
            waterfall.append({
                'url': entry.get('request', {}).get('url', 'unknown'),
                'start_time': entry.get('startedDateTime'),
                'blocked': timings.get('blocked', -1),
                'dns': timings.get('dns', -1),
                'connect': timings.get('connect', -1),
                'ssl': timings.get('ssl', -1),
                'send': timings.get('send', -1),
                'wait': timings.get('wait', -1),
                'receive': timings.get('receive', -1),
                'total': entry.get('time', 0)
            })

        return waterfall

    def generate_recommendations(self) -> List[str]:
        """Generate performance recommendations"""
        recommendations = []
        performance = self.analyze_performance()
        slow_requests = self.find_slow_requests()
        errors = self.analyze_errors()

        # Check page load time
        if performance.get('page_load_time_ms', 0) > 3000:
            recommendations.append(
                f"⚠️  Page load time is {performance['page_load_time_ms']}ms (target: <3000ms). "
                "Consider optimizing resource loading."
            )

        # Check DNS time
        if performance.get('dns_time_ms', 0) > 100:
            recommendations.append(
                f"⚠️  DNS lookup time is {performance['dns_time_ms']}ms. "
                "Consider using DNS prefetching or CDN."
            )

        # Check SSL time
        if performance.get('ssl_time_ms', 0) > 200:
            recommendations.append(
                f"⚠️  SSL handshake time is {performance['ssl_time_ms']}ms. "
                "Consider optimizing TLS configuration."
            )

        # Check slow requests
        if len(slow_requests) > 0:
            recommendations.append(
                f"⚠️  Found {len(slow_requests)} slow requests (>1s). "
                f"Slowest: {slow_requests[0]['url']} ({slow_requests[0]['time_ms']}ms)"
            )

        # Check errors
        if errors['total_errors'] > 0:
            recommendations.append(
                f"❌ Found {errors['total_errors']} failed requests. "
                f"Breakdown: {errors['error_breakdown']}"
            )

        if not recommendations:
            recommendations.append("✅ No major performance issues detected!")

        return recommendations


def print_analysis(analysis: Dict[str, Any]):
    """Print formatted analysis"""
    print("\n" + "="*80)
    print("KATALON HAR FILE ANALYSIS")
    print("="*80 + "\n")

    # Summary
    summary = analysis['summary']
    print("SUMMARY")
    print("-" * 80)
    print(f"Total Requests: {summary['total_requests']}")
    print(f"Total Size: {summary['total_size_kb']:.2f} KB")
    print(f"Total Duration: {summary['total_duration_ms']:.2f} ms")
    print(f"Timestamp: {summary['timestamp']}\n")

    # Performance
    perf = analysis['performance']
    if perf:
        print("PERFORMANCE METRICS")
        print("-" * 80)
        print(f"Page Load Time: {perf.get('page_load_time_ms', 0):.2f} ms")
        print(f"DNS Time: {perf.get('dns_time_ms', 0):.2f} ms")
        print(f"Connect Time: {perf.get('connect_time_ms', 0):.2f} ms")
        print(f"SSL Time: {perf.get('ssl_time_ms', 0):.2f} ms")
        print(f"Wait Time (TTFB): {perf.get('wait_time_ms', 0):.2f} ms")
        print(f"Receive Time: {perf.get('receive_time_ms', 0):.2f} ms\n")

    # Errors
    errors = analysis['errors']
    if errors['total_errors'] > 0:
        print(f"ERRORS ({errors['total_errors']} total)")
        print("-" * 80)
        for error in errors['errors']:
            print(f"[{error['status']}] {error['url']}")
            print(f"  Type: {error['type']} - {error['status_text']}\n")

    # Slow Requests
    slow = analysis['slow_requests']
    if slow:
        print(f"SLOW REQUESTS (>{1000}ms)")
        print("-" * 80)
        for req in slow[:5]:  # Top 5
            print(f"{req['method']} {req['url']}")
            print(f"  Time: {req['time_ms']:.2f}ms | Size: {req['size_kb']:.2f}KB | Status: {req['status']}\n")

    # Resource Breakdown
    resources = analysis['resource_breakdown']
    if resources:
        print("RESOURCE BREAKDOWN")
        print("-" * 80)
        for resource_type, stats in resources.items():
            print(f"{resource_type}: {stats['count']} requests, {stats['size_kb']:.2f} KB")
        print()

    # Recommendations
    print("RECOMMENDATIONS")
    print("-" * 80)
    for rec in analysis['recommendations']:
        print(f"{rec}\n")

    print("="*80 + "\n")


def export_json(analysis: Dict[str, Any], output_file: str):
    """Export analysis to JSON"""
    with open(output_file, 'w') as f:
        json.dump(analysis, f, indent=2, default=str)
    print(f"✓ Analysis exported to {output_file}")


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 har-analyzer.py <har-file> [--json output.json]")
        sys.exit(1)

    har_file = sys.argv[1]

    try:
        analyzer = KatalonHarAnalyzer(har_file)
        analysis = analyzer.analyze()

        # Check for JSON export
        if '--json' in sys.argv:
            json_index = sys.argv.index('--json')
            output_file = sys.argv[json_index + 1] if len(sys.argv) > json_index + 1 else 'analysis.json'
            export_json(analysis, output_file)
        else:
            print_analysis(analysis)

    except Exception as e:
        print(f"Error analyzing HAR file: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()
