---
name: craft-test-case
description: Craft detailed Katalon test cases with fine-grained steps, data-driven testing, and comprehensive assertions
model: sonnet
---

# Craft Katalon Test Case

Expert test case authoring for Katalon Studio - create well-structured, maintainable, data-driven test cases with comprehensive assertions and clear documentation.

## Test Case Design Principles

### Bite-Sized Test Steps
Each test case should be composed of small, focused steps that:
- Do ONE thing clearly
- Can be debugged independently
- Can be reused across test cases
- Have clear pass/fail criteria
- Log meaningful information

### Fine-Grained Tuning
Test cases should support:
- Parameterized inputs for flexibility
- Configurable timeouts and waits
- Environment-specific settings
- Feature flags for conditional execution
- Retry logic for flaky operations

### Layered Testing Strategy
Structure tests in layers:
1. **Smoke Tests** - Critical path, fast execution
2. **Functional Tests** - Feature-complete validation
3. **Integration Tests** - Cross-system verification
4. **Regression Tests** - Prevent feature breakage
5. **Performance Tests** - Response time validation

## Usage

### Create New Test Case

```
/craft-test-case "Login with Valid Credentials"
```

### From User Story

```
/craft-test-case --from-story "As a user I want to generate a rating worksheet so I can review insurance quotes"
```

### Data-Driven Test Case

```
/craft-test-case "Multi-State Quote Generation" --data-driven --source mysql
```

### From Existing Test (Refactor)

```
/craft-test-case --refactor "Test Cases/Legacy/Old_Login_Test"
```

## Test Case Structure

### Basic Template

```groovy
import static com.kms.katalon.core.checkpoint.CheckpointFactory.findCheckpoint
import static com.kms.katalon.core.testcase.TestCaseFactory.findTestCase
import static com.kms.katalon.core.testdata.TestDataFactory.findTestData
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.webui.keyword.WebUiBuiltInKeywords as WebUI
import com.kms.katalon.core.model.FailureHandling as FailureHandling
import internal.GlobalVariable as GlobalVariable

/**
 * Test Case: Login with Valid Credentials
 *
 * Purpose: Verify users can successfully authenticate with valid credentials
 *
 * Prerequisites:
 * - Application is accessible
 * - Test user exists in database: test_user_001
 * - Database connection is configured
 *
 * Test Data:
 * - Data File: Data Files/Users/ValidUsers
 * - Database Query: SELECT * FROM test_users WHERE role='standard'
 *
 * Expected Results:
 * - User successfully logs in
 * - Dashboard page loads within 3 seconds
 * - User name displayed in header
 * - Session created in database
 *
 * Related User Stories:
 * - US-1234: User Authentication
 * - US-1235: Session Management
 */

// Test Configuration
def testConfig = [
    maxRetries: 2,
    pageLoadTimeout: 30,
    elementTimeout: 10,
    screenshotOnFailure: true,
    logLevel: 'INFO'
]

// Test Data Setup
def testData = findTestData('Data Files/Users/ValidUsers')
def username = testData.getValue('username', 1)
def password = testData.getValue('password', 1)

try {
    // Step 1: Navigate to Login Page
    WebUI.comment("Step 1: Navigate to application login page")
    WebUI.openBrowser(GlobalVariable.BASE_URL + '/login')
    WebUI.maximizeWindow()

    // Assertion: Login page loads
    WebUI.verifyElementPresent(
        findTestObject('Page_Login/input_Username'),
        testConfig.elementTimeout,
        FailureHandling.STOP_ON_FAILURE
    )
    WebUI.takeScreenshot('screenshots/01_login_page_loaded.png')

    // Step 2: Enter Username
    WebUI.comment("Step 2: Enter username: ${username}")
    WebUI.setText(
        findTestObject('Page_Login/input_Username'),
        username
    )

    // Assertion: Username field populated
    def enteredUsername = WebUI.getAttribute(
        findTestObject('Page_Login/input_Username'),
        'value'
    )
    assert enteredUsername == username : "Username not entered correctly"

    // Step 3: Enter Password
    WebUI.comment("Step 3: Enter password")
    WebUI.setEncryptedText(
        findTestObject('Page_Login/input_Password'),
        password
    )

    // Step 4: Click Login Button
    WebUI.comment("Step 4: Click login button")
    def loginStartTime = System.currentTimeMillis()
    WebUI.click(findTestObject('Page_Login/button_Login'))

    // Step 5: Wait for Dashboard
    WebUI.comment("Step 5: Verify dashboard loads")
    WebUI.waitForPageLoad(testConfig.pageLoadTimeout)

    // Assertion: Dashboard loaded
    WebUI.verifyElementPresent(
        findTestObject('Page_Dashboard/div_Dashboard'),
        testConfig.elementTimeout,
        FailureHandling.STOP_ON_FAILURE
    )

    def loginDuration = System.currentTimeMillis() - loginStartTime
    WebUI.comment("Login completed in ${loginDuration}ms")

    // Assertion: Login duration within acceptable range
    assert loginDuration < 3000 : "Login took longer than 3 seconds: ${loginDuration}ms"

    // Step 6: Verify User Name Displayed
    WebUI.comment("Step 6: Verify user name displayed in header")
    def displayedName = WebUI.getText(findTestObject('Page_Dashboard/span_UserName'))
    def expectedName = testData.getValue('fullName', 1)

    // Assertion: User name matches
    assert displayedName == expectedName : "Expected '${expectedName}', got '${displayedName}'"

    WebUI.takeScreenshot('screenshots/06_dashboard_loaded.png')

    // Step 7: Verify Session in Database
    WebUI.comment("Step 7: Verify session created in database")
    CustomKeywords.'database.DatabaseKeywords.verifySessionExists'(username)

    // Step 8: Log Test Results
    WebUI.comment("Step 8: Log test results to database")
    CustomKeywords.'database.DatabaseKeywords.logTestResult'(
        testCaseId: 'TC_Login_001',
        status: 'PASSED',
        duration: loginDuration,
        username: username,
        environment: GlobalVariable.ENVIRONMENT
    )

    WebUI.comment("✓ Test Passed: User successfully logged in")

} catch (Exception e) {
    // Failure handling
    WebUI.comment("✗ Test Failed: ${e.message}")
    WebUI.takeScreenshot("screenshots/FAILURE_${System.currentTimeMillis()}.png")

    // Log failure to database
    CustomKeywords.'database.DatabaseKeywords.logTestResult'(
        testCaseId: 'TC_Login_001',
        status: 'FAILED',
        errorMessage: e.message,
        stackTrace: e.stackTrace.toString(),
        screenshot: "FAILURE_${System.currentTimeMillis()}.png"
    )

    throw e

} finally {
    // Cleanup
    WebUI.comment("Cleanup: Closing browser")
    WebUI.closeBrowser()
}
```

## Data-Driven Testing

### MySQL Integration

#### Database Test Data Provider

```groovy
/**
 * Custom Keyword: Fetch test data from MySQL
 * Location: Keywords/database/DatabaseKeywords.groovy
 */
class DatabaseKeywords {

    @Keyword
    static List<Map> getTestData(String query) {
        def results = []
        def connection = null

        try {
            // Connect to test database
            connection = CustomKeywords.'database.DatabaseConnection.connect'()

            def statement = connection.createStatement()
            def resultSet = statement.executeQuery(query)
            def metadata = resultSet.getMetaData()
            def columnCount = metadata.getColumnCount()

            // Convert ResultSet to List of Maps
            while (resultSet.next()) {
                def row = [:]
                for (int i = 1; i <= columnCount; i++) {
                    def columnName = metadata.getColumnName(i)
                    row[columnName] = resultSet.getObject(i)
                }
                results.add(row)
            }

            KeywordUtil.logInfo("Fetched ${results.size()} rows from database")

        } catch (SQLException e) {
            KeywordUtil.markFailed("Database query failed: ${e.message}")
        } finally {
            if (connection != null) {
                connection.close()
            }
        }

        return results
    }

    @Keyword
    static void logTestResult(Map testResult) {
        def connection = null

        try {
            connection = CustomKeywords.'database.DatabaseConnection.connect'()

            def sql = """
                INSERT INTO test_results (
                    test_case_id,
                    status,
                    duration_ms,
                    username,
                    environment,
                    error_message,
                    stack_trace,
                    screenshot_path,
                    video_path,
                    har_file_path,
                    logrocket_url,
                    device_farm_url,
                    executed_at
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
            """

            def statement = connection.prepareStatement(sql)
            statement.setString(1, testResult.testCaseId)
            statement.setString(2, testResult.status)
            statement.setLong(3, testResult.duration ?: 0)
            statement.setString(4, testResult.username)
            statement.setString(5, testResult.environment)
            statement.setString(6, testResult.errorMessage)
            statement.setString(7, testResult.stackTrace)
            statement.setString(8, testResult.screenshot)
            statement.setString(9, testResult.video)
            statement.setString(10, testResult.harFile)
            statement.setString(11, testResult.logrocketUrl)
            statement.setString(12, testResult.deviceFarmUrl)

            statement.executeUpdate()

            KeywordUtil.logInfo("Test result logged to database")

        } catch (SQLException e) {
            KeywordUtil.markError("Failed to log test result: ${e.message}")
        } finally {
            if (connection != null) {
                connection.close()
            }
        }
    }
}
```

#### Data-Driven Test Execution

```groovy
/**
 * Test Case: Multi-State Quote Generation (Data-Driven)
 *
 * Purpose: Verify quote generation across multiple states
 *
 * Test Data Source: MySQL database
 * Query: SELECT * FROM test_data_states WHERE active = 1
 */

// Fetch test data from database
def query = """
    SELECT
        state_code,
        state_name,
        test_address,
        expected_base_rate,
        expected_state_multiplier
    FROM test_data_states
    WHERE active = 1
    ORDER BY state_code
"""

def testDataRows = CustomKeywords.'database.DatabaseKeywords.getTestData'(query)

WebUI.comment("Executing test for ${testDataRows.size()} states")

// Loop through each state
testDataRows.eachWithIndex { testData, index ->
    WebUI.comment("================================================")
    WebUI.comment("Test Iteration ${index + 1}/${testDataRows.size()}")
    WebUI.comment("State: ${testData.state_name} (${testData.state_code})")
    WebUI.comment("================================================")

    try {
        // Navigate to quote page
        WebUI.navigateToUrl(GlobalVariable.BASE_URL + '/quotes/new')

        // Enter state-specific test data
        WebUI.selectOptionByValue(
            findTestObject('Page_Quote/select_State'),
            testData.state_code,
            false
        )

        WebUI.setText(
            findTestObject('Page_Quote/input_Address'),
            testData.test_address
        )

        // Generate quote
        WebUI.click(findTestObject('Page_Quote/button_GenerateQuote'))
        WebUI.waitForPageLoad(30)

        // Extract quote details
        def baseRate = WebUI.getText(findTestObject('Page_Quote/span_BaseRate'))
        def stateMultiplier = WebUI.getText(findTestObject('Page_Quote/span_StateMultiplier'))

        // Assertions
        assert baseRate == testData.expected_base_rate :
            "State ${testData.state_code}: Expected base rate ${testData.expected_base_rate}, got ${baseRate}"

        assert stateMultiplier == testData.expected_state_multiplier :
            "State ${testData.state_code}: Expected multiplier ${testData.expected_state_multiplier}, got ${stateMultiplier}"

        WebUI.comment("✓ State ${testData.state_code} validation passed")

        // Log success to database
        CustomKeywords.'database.DatabaseKeywords.logTestResult'(
            testCaseId: "TC_MultiState_${testData.state_code}",
            status: 'PASSED',
            username: 'system',
            environment: GlobalVariable.ENVIRONMENT
        )

    } catch (Exception e) {
        WebUI.comment("✗ State ${testData.state_code} validation failed: ${e.message}")

        // Log failure to database
        CustomKeywords.'database.DatabaseKeywords.logTestResult'(
            testCaseId: "TC_MultiState_${testData.state_code}",
            status: 'FAILED',
            errorMessage: e.message,
            username: 'system',
            environment: GlobalVariable.ENVIRONMENT
        )

        // Continue to next state (don't stop entire test)
        WebUI.comment("Continuing to next state...")
    }
}

WebUI.comment("Data-driven test completed for all states")
```

### CSV Integration

#### CSV to MySQL Mapping

```groovy
/**
 * Custom Keyword: Import CSV test data to MySQL
 * Location: Keywords/database/CSVImporter.groovy
 */
class CSVImporter {

    @Keyword
    static void importCSVToDatabase(String csvFilePath, String tableName, Map columnMapping) {
        def connection = null

        try {
            // Read CSV file
            def csvFile = new File(csvFilePath)
            def lines = csvFile.readLines()
            def headers = lines[0].split(',')

            connection = CustomKeywords.'database.DatabaseConnection.connect'()

            // Build INSERT statement dynamically
            def columns = columnMapping.keySet().join(', ')
            def placeholders = columnMapping.keySet().collect { '?' }.join(', ')
            def sql = "INSERT INTO ${tableName} (${columns}) VALUES (${placeholders})"

            def statement = connection.prepareStatement(sql)

            // Process each data row
            lines.drop(1).each { line ->
                def values = line.split(',')
                def rowData = [:]

                headers.eachWithIndex { header, i ->
                    rowData[header.trim()] = values[i].trim()
                }

                // Map CSV columns to database columns
                columnMapping.eachWithIndex { dbColumn, csvColumn, paramIndex ->
                    statement.setString(paramIndex + 1, rowData[csvColumn])
                }

                statement.executeUpdate()
            }

            KeywordUtil.logInfo("Imported ${lines.size() - 1} rows from CSV to ${tableName}")

        } catch (Exception e) {
            KeywordUtil.markFailed("CSV import failed: ${e.message}")
        } finally {
            if (connection != null) {
                connection.close()
            }
        }
    }
}
```

#### CSV Mapping Configuration

```groovy
// Data Files/Mappings/StateDataMapping.groovy

def csvToDbMapping = [
    // Database Column : CSV Column
    'state_code': 'State',
    'state_name': 'StateName',
    'test_address': 'TestAddress',
    'expected_base_rate': 'BaseRate',
    'expected_state_multiplier': 'StateMultiplier',
    'active': 'IsActive'
]

// Import CSV to database before test execution
CustomKeywords.'database.CSVImporter.importCSVToDatabase'(
    'Data Files/TestData/StateData.csv',
    'test_data_states',
    csvToDbMapping
)
```

## User Story Mapping

### From User Story to Test Cases

When you provide a user story like:

> "As a user I want to generate a rating worksheet so I can review insurance quotes"

The expert will:

1. **Decompose into test scenarios:**
   - Successful worksheet generation
   - Invalid input handling
   - Multiple quote comparison
   - Data persistence verification
   - Performance validation

2. **Identify all assertions:**
   - User is authenticated
   - Quote exists in database
   - Worksheet generates within 3 seconds
   - All fields populated correctly
   - PDF download works
   - Data saved to database
   - Session logged to LogRocket

3. **Map to test steps:**
   - Navigate to quote page
   - Select quote
   - Click "Generate Worksheet"
   - Verify worksheet displays
   - Verify data accuracy
   - Verify performance
   - Verify database state

4. **Create comprehensive test case:**
   - Covers happy path
   - Covers edge cases
   - Includes error scenarios
   - Has clear assertions
   - Logs detailed results

## Expert Commands

I'll help you craft test cases with these expert capabilities:

### 1. Analyze User Story
```
Tell me the user story and I'll:
- Break it into testable scenarios
- Identify all assertions needed
- Map acceptance criteria to test steps
- Suggest test data requirements
```

### 2. Design Test Structure
```
I'll create a well-structured test with:
- Bite-sized, focused steps
- Clear assertions at each step
- Database verification where needed
- Performance measurements
- Comprehensive logging
```

### 3. Add Data-Driven Logic
```
I'll integrate:
- MySQL queries for test data
- CSV import capabilities
- Data iteration logic
- Result logging to database
```

### 4. Implement Database Integration
```
I'll add:
- Connection management
- Query execution
- Result verification
- Test result logging
- Relational data handling
```

## Example: Complete User Story Test

**User Story:**
> "As an insurance agent, I want to generate a rating worksheet for a quote so I can present multiple coverage options to my client"

**Generated Test Suite:**

```
Test Suite: Rating Worksheet Generation
├── TC_001_Generate_Worksheet_Valid_Quote
├── TC_002_Generate_Worksheet_Multiple_Coverages
├── TC_003_Generate_Worksheet_Performance
├── TC_004_Generate_Worksheet_Invalid_Quote
├── TC_005_Generate_Worksheet_Database_Verification
└── TC_006_Generate_Worksheet_PDF_Download
```

Each test case will include all identified assertions and comprehensive database verification.

## Tell Me What You Need

Describe your testing requirement and I'll craft:
- Complete test cases
- Data-driven test suites
- Database integration code
- Custom keywords
- Test result logging
- Comprehensive assertions

I'm your Katalon Test Expert - ready to build professional, maintainable test automation! 🎯
