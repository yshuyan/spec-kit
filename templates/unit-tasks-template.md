# Unit Test Tasks: [TEST SUITE NAME]

**Input**: Test design documents from `/tests/[###-unit-test-name]/`
**Prerequisites**: test-plan.md (required), test-strategy.md, test-data.md, test-setup.md, mocks/

## Execution Flow (main)
```
1. Load test-plan.md from test directory
   → If not found: ERROR "No test implementation plan found"
   → Extract: test framework, strategy, target components
2. Load optional test design documents:
   → test-strategy.md: Extract approach → setup tasks
   → test-data.md: Extract data sets → test data tasks
   → test-setup.md: Extract configuration → setup tasks
   → mocks/: Each mock spec → mock implementation task
3. Generate tasks by category:
   → Setup: test framework, environment, dependencies
   → Mocks: mock implementations, test doubles
   → Unit Tests: individual component tests
   → Integration Tests: component interaction tests
   → Validation: coverage, performance, CI integration
4. Apply task rules:
   → Different test files = mark [P] for parallel
   → Same test file = sequential (no [P])
   → Mocks before tests that use them
5. Number tasks sequentially (UT001, UT002...)
6. Generate dependency graph
7. Create parallel execution examples
8. Validate task completeness:
   → All target components have tests?
   → All mocks are implemented?
   → All test scenarios covered?
9. Return: SUCCESS (test tasks ready for execution)
```

## Format: `[ID] [P?] Description`
- **[P]**: Can run in parallel (different files, no dependencies)
- Include exact test file paths in descriptions

## Test Path Conventions
- **Unit tests**: `tests/unit/` at repository root
- **Integration tests**: `tests/integration/`
- **Mock objects**: `tests/mocks/` or alongside test files
- **Test data**: `tests/fixtures/` or `tests/data/`
- Paths shown below assume standard test structure - adjust based on test-plan.md

## Phase UT.1: Test Setup
- [ ] UT001 Initialize test framework [Go testing/pytest/Jest/JUnit/XCTest] with configuration
- [ ] UT002 Configure test runner and discovery settings (go.mod, test flags)
- [ ] UT003 [P] Setup test reporting and coverage tools (go test -cover, go test -json)
- [ ] UT004 [P] Configure CI/CD test pipeline integration
- [ ] UT005 Create test directory structure per test plan

## Phase UT.2: Mock Implementation ⚠️ MUST COMPLETE BEFORE UT.3
**CRITICAL: Mock objects MUST be implemented before tests that depend on them**
- [ ] UT006 [P] Mock UserService in mocks/mock_user_service.go (or tests/mocks/mock_user_service.py)
- [ ] UT007 [P] Mock DatabaseConnection in mocks/mock_database.go (or tests/mocks/mock_database.py)
- [ ] UT008 [P] Mock ExternalAPI in mocks/mock_external_api.go (or tests/mocks/mock_external_api.py)
- [ ] UT009 [P] Test data fixtures in testdata/user_data.json (or tests/fixtures/user_data.json)

## Phase UT.3: Unit Tests (ONLY after mocks are ready)
- [ ] UT010 [P] Test User.ValidateEmail() in user_test.go (or tests/unit/test_user_validation.py)
- [ ] UT011 [P] Test User.HashPassword() in user_test.go (or tests/unit/test_user_security.py)
- [ ] UT012 [P] Test UserService.CreateUser() in userservice_test.go (or tests/unit/test_user_service.py)
- [ ] UT013 [P] Test UserService.FindByEmail() in userservice_test.go (or tests/unit/test_user_service.py)
- [ ] UT014 [P] Test AuthController.Login() in auth_test.go (or tests/unit/test_auth_controller.py)
- [ ] UT015 [P] Test AuthController.Logout() in auth_test.go (or tests/unit/test_auth_controller.py)
- [ ] UT016 [P] Test InputValidator.Sanitize() in validator_test.go (or tests/unit/test_input_validator.py)

## Phase UT.4: Integration Tests
- [ ] UT017 Test user registration flow in tests/integration/test_user_registration.py
- [ ] UT018 Test authentication workflow in tests/integration/test_auth_workflow.py
- [ ] UT019 Test database transactions in tests/integration/test_database_integration.py
- [ ] UT020 Test API endpoint integration in tests/integration/test_api_integration.py

## Phase UT.5: Edge Cases & Error Handling
- [ ] UT021 [P] Test invalid email formats in tests/unit/test_user_validation_edge_cases.py
- [ ] UT022 [P] Test password strength requirements in tests/unit/test_password_validation.py
- [ ] UT023 [P] Test database connection failures in tests/unit/test_error_handling.py
- [ ] UT024 [P] Test rate limiting scenarios in tests/unit/test_rate_limiting.py
- [ ] UT025 [P] Test concurrent user operations in tests/unit/test_concurrency.py

## Phase UT.6: Performance & Load Tests
- [ ] UT026 [P] Performance test user creation (<50ms) in tests/performance/test_user_performance.py
- [ ] UT027 [P] Memory usage test for large datasets in tests/performance/test_memory_usage.py
- [ ] UT028 [P] Concurrent user load test (100 users) in tests/performance/test_load.py

## Phase UT.7: Validation & Quality Assurance
- [ ] UT029 [P] Verify test coverage >= 85%
- [ ] UT030 [P] Run mutation testing for critical paths
- [ ] UT031 [P] Validate test execution time < 30 seconds
- [ ] UT032 [P] Check for flaky tests (run 10x each)
- [ ] UT033 [P] Generate test documentation and reports
- [ ] UT034 [P] Validate CI/CD pipeline test integration

## Dependencies
- Mocks (UT006-UT009) before unit tests (UT010-UT016)
- Unit tests before integration tests (UT017-UT020)
- Basic tests before edge cases (UT021-UT025)
- All tests before validation (UT029-UT034)

## Parallel Execution Examples
```
# Launch mock creation together:
Task: "Mock UserService in tests/mocks/mock_user_service.py"
Task: "Mock DatabaseConnection in tests/mocks/mock_database.py"
Task: "Mock ExternalAPI in tests/mocks/mock_external_api.py"

# Launch unit tests together (after mocks ready):
Task: "Test User.validate_email() in tests/unit/test_user_validation.py"
Task: "Test User.hash_password() in tests/unit/test_user_security.py"
Task: "Test UserService.create_user() in tests/unit/test_user_service.py"
```

## Test Quality Standards
- [ ] Each test follows AAA pattern (Arrange, Act, Assert)
- [ ] Test names clearly describe the behavior being tested
- [ ] Each test is independent and can run in isolation
- [ ] Mock usage is minimal and realistic
- [ ] Test data is representative and edge cases are covered
- [ ] No flaky tests (deterministic execution)
- [ ] Proper setup and teardown for each test

## Coverage Requirements
- **Unit Test Coverage**: >= 85% line coverage
- **Critical Path Coverage**: 100% coverage for security and data integrity functions
- **Edge Case Coverage**: >= 70% coverage for error handling paths
- **Integration Coverage**: All major component interactions tested

## Performance Targets
- **Test Suite Execution**: Complete test suite runs in < 30 seconds
- **Individual Tests**: Each unit test completes in < 100ms
- **Setup/Teardown**: Test environment setup < 5 seconds
- **CI/CD Integration**: Test feedback within 2 minutes of commit

## Task Generation Rules

### Mock Tasks
- Each external dependency → mock implementation task [P]
- Each data source → test data fixture task [P]
- Database connections → database mock/test double [P]
- API integrations → API response mocking [P]

### Unit Test Tasks
- Each public method → individual test task [P]
- Each class → test class with multiple test methods [P]
- Each validation rule → validation test task [P]
- Each error condition → error handling test task [P]

### Integration Test Tasks
- Each user workflow → integration test scenario
- Each component interaction → integration test
- Each data flow → end-to-end test scenario
- Each external integration → integration test with real/mock services

### Quality Tasks
- Coverage analysis → automated coverage reporting [P]
- Performance testing → automated performance validation [P]
- Security testing → security-focused test scenarios [P]
- Documentation → test documentation generation [P]

## Notes
- [P] tasks = different files, no dependencies, can run in parallel
- Verify mocks work correctly before writing tests that use them
- Commit after each completed task
- Avoid: vague test descriptions, overlapping test files, brittle tests
- Focus on behavior testing, not implementation details
- Use descriptive test names that serve as documentation

## Common Anti-Patterns to Avoid
- Testing private methods directly
- Writing tests that depend on specific execution order
- Creating overly complex test setups
- Using real external services in unit tests
- Writing tests that test the framework instead of your code
- Ignoring edge cases and error conditions

---

**Generated from test specification**: [link to test-spec.md]
**Test implementation plan**: [link to test-plan.md]
