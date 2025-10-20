---
description: Execute the unit test implementation by processing and executing all test tasks defined in test-tasks.md
scripts:
  sh: scripts/bash/check-unit-prerequisites.sh --json --require-tasks --include-tasks
  ps: scripts/powershell/check-unit-prerequisites.ps1 -Json -RequireTasks -IncludeTasks
---

**IMPORTANT: Generate all documentation in Chinese (简体中文). All sections, descriptions, and content should be written in Chinese.**

The user input can be provided directly by the agent or as a command argument - you **MUST** consider it before proceeding with the prompt (if not empty).

User input:

$ARGUMENTS

1. Run `{SCRIPT}` from repo root and parse TEST_DIR and AVAILABLE_DOCS list. All paths must be absolute.

2. Load and analyze the test implementation context:
   - **REQUIRED**: Read test-tasks.md for the complete test task list and execution plan
   - **REQUIRED**: Read test-plan.md for testing strategy, framework, and target components
   - **IF EXISTS**: Read test-strategy.md for detailed testing approach
   - **IF EXISTS**: Read test-data.md for test data requirements
   - **IF EXISTS**: Read test-setup.md for test environment configuration
   - **IF EXISTS**: Read mocks/ for mock object specifications

3. Parse test-tasks.md structure and extract:
   - **Test task phases**: Setup, Mocks, Unit Tests, Integration, Edge Cases, Performance, Validation
   - **Test task dependencies**: Sequential vs parallel execution rules
   - **Test task details**: ID, description, test file paths, parallel markers [P]
   - **Execution flow**: Order and dependency requirements

4. Execute test implementation following the test task plan:
   - **Phase-by-phase execution**: Complete each test phase before moving to the next
   - **Respect dependencies**: Run sequential tasks in order, parallel tasks [P] can run together  
   - **Follow TDD approach**: Create failing tests first, then make them pass
   - **File-based coordination**: Tasks affecting the same test files must run sequentially
   - **Validation checkpoints**: Verify each phase completion before proceeding

5. Test implementation execution rules:
   - **Setup first**: Initialize test framework, dependencies, test environment configuration
   - **Mocks before tests**: Implement all mock objects and test doubles before unit tests
   - **Unit tests development**: Implement individual component tests with proper isolation
   - **Integration testing**: Component interaction and workflow testing
   - **Edge case coverage**: Boundary conditions, error scenarios, and exceptional cases
   - **Performance validation**: Test execution speed, memory usage, and load testing
   - **Quality validation**: Coverage analysis, flaky test detection, CI integration

6. Progress tracking and error handling:
   - Report progress after each completed test task
   - Halt execution if any non-parallel test task fails
   - For parallel tasks [P], continue with successful tasks, report failed ones
   - Provide clear error messages with test failure details for debugging
   - Suggest next steps if test implementation cannot proceed
   - **IMPORTANT** For completed tasks, make sure to mark the task off as [X] in the test-tasks file.

7. Test quality validation:
   - Run test suite after implementation to ensure all tests pass
   - Verify test coverage meets requirements (typically 85%+ for unit tests)
   - Check for flaky tests by running the suite multiple times
   - Validate test execution time meets performance targets
   - Confirm CI/CD integration works correctly

8. Completion validation:
   - Verify all required test tasks are completed
   - Check that implemented tests cover the original test specification requirements
   - Validate that test suite passes consistently and meets quality standards
   - Confirm the test implementation follows the technical test plan
   - Report final status with summary of completed test work and quality metrics

Note: This command assumes a complete test task breakdown exists in test-tasks.md. If test tasks are incomplete or missing, suggest running `/tasks-unit` first to regenerate the test task list.
