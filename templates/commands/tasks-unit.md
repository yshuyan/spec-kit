---
description: Generate an actionable, dependency-ordered test-tasks.md for the unit test suite based on available test design artifacts.
scripts:
  sh: scripts/bash/check-unit-prerequisites.sh --json
  ps: scripts/powershell/check-unit-prerequisites.ps1 -Json
---

**IMPORTANT: Generate all documentation in Chinese (简体中文). All sections, descriptions, and content should be written in Chinese.**

The user input to you can be provided directly by the agent or as a command argument - you **MUST** consider it before proceeding with the prompt (if not empty).

User input:

$ARGUMENTS

1. Run `{SCRIPT}` from repo root and parse TEST_DIR and AVAILABLE_DOCS list. All paths must be absolute.
2. Load and analyze available test design documents:
   - Always read test-plan.md for testing strategy and framework
   - IF EXISTS: Read test-strategy.md for testing approach
   - IF EXISTS: Read test-data.md for test data requirements
   - IF EXISTS: Read test-setup.md for test environment setup
   - IF EXISTS: Read mocks/ for mock object specifications

   Note: Not all test suites have all documents. For example:
   - Simple unit tests might not need complex mocks/
   - Basic tests might not require test-data.md
   - Generate tasks based on what's available

3. Generate test tasks following the template:
   - Use `/templates/unit-tasks-template.md` as the base
   - Replace example tasks with actual test tasks based on:
     * **Setup tasks**: Test framework setup, dependencies, configuration
     * **Mock tasks [P]**: One per mock object or external dependency
     * **Unit test tasks [P]**: One per function/class/module to test
     * **Integration test tasks**: Component interaction testing
     * **Validation tasks [P]**: Coverage analysis, performance testing, CI integration

4. Test task generation rules:
   - Each target component → unit test task marked [P]
   - Each mock specification → mock implementation task marked [P]
   - Each integration scenario → integration test (not parallel if shared dependencies)
   - Each test data set → test data generation task marked [P]
   - Different test files = can be parallel [P]
   - Same test file = sequential (no [P])

5. Order tasks by dependencies:
   - Setup before everything
   - Mocks before tests that use them
   - Unit tests before integration tests
   - Core tests before edge case tests
   - Everything before validation

6. Include parallel execution examples:
   - Group [P] tasks that can run together
   - Show actual Task agent commands

7. Create TEST_DIR/test-tasks.md with:
   - Correct test suite name from test plan
   - Numbered tasks (UT001, UT002, etc.)
   - Clear file paths for each test task
   - Dependency notes
   - Parallel execution guidance

Context for test task generation: {ARGS}

The test-tasks.md should be immediately executable - each task must be specific enough that an LLM can complete it without additional context.
