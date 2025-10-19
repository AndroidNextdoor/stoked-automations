#!/bin/bash

# Katalon MySQL Connector
# Connects to Docker MySQL container and queries Katalon test results
# Usage: ./mysql-connector.sh <query>

set -e

# Configuration
MYSQL_CONTAINER="${KATALON_MYSQL_CONTAINER:-katalon-mysql}"
MYSQL_USER="${KATALON_MYSQL_USER:-root}"
MYSQL_PASSWORD="${KATALON_MYSQL_PASSWORD:-password}"
MYSQL_DATABASE="${KATALON_MYSQL_DB:-katalon_test_results}"
MYSQL_HOST="${KATALON_MYSQL_HOST:-127.0.0.1}"
MYSQL_PORT="${KATALON_MYSQL_PORT:-3306}"

# Colors
RED='\033[0.31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if Docker container exists and is running
check_docker_container() {
    if docker ps --format '{{.Names}}' | grep -q "^${MYSQL_CONTAINER}$"; then
        echo -e "${GREEN}✓ MySQL container '${MYSQL_CONTAINER}' is running${NC}"
        return 0
    elif docker ps -a --format '{{.Names}}' | grep -q "^${MYSQL_CONTAINER}$"; then
        echo -e "${YELLOW}⚠ MySQL container '${MYSQL_CONTAINER}' exists but is not running${NC}"
        echo "Starting container..."
        docker start "${MYSQL_CONTAINER}"
        sleep 2
        return 0
    else
        echo -e "${RED}✗ MySQL container '${MYSQL_CONTAINER}' not found${NC}"
        return 1
    fi
}

# Function to execute MySQL query via Docker
query_via_docker() {
    local query="$1"
    docker exec -i "${MYSQL_CONTAINER}" mysql \
        -u "${MYSQL_USER}" \
        -p"${MYSQL_PASSWORD}" \
        -D "${MYSQL_DATABASE}" \
        -e "${query}" \
        2>/dev/null
}

# Function to execute MySQL query via TCP
query_via_tcp() {
    local query="$1"
    mysql -h "${MYSQL_HOST}" \
        -P "${MYSQL_PORT}" \
        -u "${MYSQL_USER}" \
        -p"${MYSQL_PASSWORD}" \
        -D "${MYSQL_DATABASE}" \
        -e "${query}" \
        2>/dev/null
}

# Function to get test execution results
get_test_executions() {
    local limit="${1:-10}"
    local query="
    SELECT
        id,
        test_suite_name,
        test_case_name,
        status,
        start_time,
        end_time,
        TIMESTAMPDIFF(SECOND, start_time, end_time) as duration_seconds,
        error_message,
        logrocket_url
    FROM test_execution
    ORDER BY start_time DESC
    LIMIT ${limit};
    "
    execute_query "${query}"
}

# Function to get failed tests
get_failed_tests() {
    local hours="${1:-24}"
    local query="
    SELECT
        id,
        test_suite_name,
        test_case_name,
        error_message,
        start_time,
        logrocket_url
    FROM test_execution
    WHERE status = 'FAILED'
      AND start_time >= DATE_SUB(NOW(), INTERVAL ${hours} HOUR)
    ORDER BY start_time DESC;
    "
    execute_query "${query}"
}

# Function to get test by ID
get_test_by_id() {
    local test_id="$1"
    local query="
    SELECT
        id,
        test_suite_name,
        test_case_name,
        status,
        start_time,
        end_time,
        error_message,
        stack_trace,
        har_file_path,
        screenshot_path,
        video_path,
        logrocket_url,
        report_folder_path
    FROM test_execution
    WHERE id = '${test_id}';
    "
    execute_query "${query}"
}

# Function to get test performance metrics
get_performance_metrics() {
    local test_id="$1"
    local query="
    SELECT
        metric_name,
        metric_value,
        metric_unit,
        recorded_at
    FROM test_performance_metrics
    WHERE test_execution_id = '${test_id}'
    ORDER BY recorded_at;
    "
    execute_query "${query}"
}

# Function to export test results to JSON
export_to_json() {
    local test_id="$1"
    local output_file="${2:-test_${test_id}.json}"

    local query="
    SELECT JSON_OBJECT(
        'test_execution', (
            SELECT JSON_OBJECT(
                'id', id,
                'suite', test_suite_name,
                'case', test_case_name,
                'status', status,
                'start_time', start_time,
                'end_time', end_time,
                'duration_seconds', TIMESTAMPDIFF(SECOND, start_time, end_time),
                'error_message', error_message,
                'stack_trace', stack_trace,
                'har_file', har_file_path,
                'screenshot', screenshot_path,
                'video', video_path,
                'logrocket_url', logrocket_url,
                'report_folder', report_folder_path
            )
            FROM test_execution
            WHERE id = '${test_id}'
        ),
        'performance_metrics', (
            SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'name', metric_name,
                    'value', metric_value,
                    'unit', metric_unit,
                    'time', recorded_at
                )
            )
            FROM test_performance_metrics
            WHERE test_execution_id = '${test_id}'
        )
    ) as test_data;
    "

    execute_query "${query}" | tail -n +2 > "${output_file}"
    echo -e "${GREEN}✓ Exported to ${output_file}${NC}"
}

# Main query executor
execute_query() {
    local query="$1"

    # Try Docker first
    if check_docker_container 2>/dev/null; then
        query_via_docker "${query}"
    else
        # Fall back to TCP
        echo -e "${YELLOW}Trying TCP connection to ${MYSQL_HOST}:${MYSQL_PORT}${NC}"
        query_via_tcp "${query}"
    fi
}

# Main script logic
main() {
    local command="${1:-help}"

    case "${command}" in
        "list")
            echo "Recent Test Executions:"
            get_test_executions "${2:-10}"
            ;;
        "failed")
            echo "Failed Tests (last ${2:-24} hours):"
            get_failed_tests "${2:-24}"
            ;;
        "get")
            if [ -z "$2" ]; then
                echo -e "${RED}Error: Test ID required${NC}"
                echo "Usage: $0 get <test-id>"
                exit 1
            fi
            echo "Test Details for ID: $2"
            get_test_by_id "$2"
            ;;
        "metrics")
            if [ -z "$2" ]; then
                echo -e "${RED}Error: Test ID required${NC}"
                echo "Usage: $0 metrics <test-id>"
                exit 1
            fi
            echo "Performance Metrics for Test ID: $2"
            get_performance_metrics "$2"
            ;;
        "export")
            if [ -z "$2" ]; then
                echo -e "${RED}Error: Test ID required${NC}"
                echo "Usage: $0 export <test-id> [output-file]"
                exit 1
            fi
            export_to_json "$2" "$3"
            ;;
        "query")
            if [ -z "$2" ]; then
                echo -e "${RED}Error: SQL query required${NC}"
                echo "Usage: $0 query \"SELECT * FROM test_execution LIMIT 5\""
                exit 1
            fi
            execute_query "$2"
            ;;
        "help"|*)
            cat << EOF
Katalon MySQL Connector

Usage: $0 <command> [options]

Commands:
  list [limit]           List recent test executions (default: 10)
  failed [hours]         List failed tests (default: last 24 hours)
  get <test-id>          Get detailed information for a specific test
  metrics <test-id>      Get performance metrics for a test
  export <test-id> [file] Export test data to JSON
  query "<sql>"          Execute custom SQL query
  help                   Show this help message

Environment Variables:
  KATALON_MYSQL_CONTAINER   MySQL Docker container name (default: katalon-mysql)
  KATALON_MYSQL_USER        MySQL username (default: root)
  KATALON_MYSQL_PASSWORD    MySQL password (default: password)
  KATALON_MYSQL_DB          Database name (default: katalon_test_results)
  KATALON_MYSQL_HOST        MySQL host for TCP (default: 127.0.0.1)
  KATALON_MYSQL_PORT        MySQL port for TCP (default: 3306)

Examples:
  # List recent tests
  $0 list

  # Get failed tests from last 48 hours
  $0 failed 48

  # Get specific test details
  $0 get TEST-12345

  # Export test to JSON
  $0 export TEST-12345 my_test.json

  # Custom query
  $0 query "SELECT COUNT(*) FROM test_execution WHERE status='FAILED'"

EOF
            ;;
    esac
}

# Run main function
main "$@"
