---
description: Execute the unit test implementation planning workflow using the unit test plan template to generate test design artifacts.
---

The user input to you can be provided directly by the agent or as a command argument - you **MUST** consider it before proceeding with the prompt (if not empty).

User input:

$ARGUMENTS

Given the test implementation details provided as an argument, do this:

1. Run `.specify/scripts/bash/setup-unit-plan.sh --json` from the repo root and parse JSON for TEST_SPEC_FILE, TEST_PLAN, TESTS_DIR, BRANCH. All future file paths must be absolute.
   - BEFORE proceeding, inspect TEST_SPEC_FILE for unclear test requirements or missing clarifications. If test scenarios are vague or critical testing approaches are undefined, PAUSE and instruct the user to clarify the test specification first. Only continue if: (a) Test requirements are clear OR (b) an explicit user override is provided.

2. Read and analyze the test specification to understand:
   - The test scenarios and test cases
   - Target components and functions to test
   - Test requirements and acceptance criteria
   - Edge cases and boundary conditions
   - Integration testing needs

3. Read the constitution at `.specify/memory/constitution.md` to understand constitutional requirements for testing.

4. Execute the unit test plan template:
   - Load `.specify/templates/unit-test-plan-template.md` (already copied to TEST_PLAN path)
   - Set Input path to TEST_SPEC_FILE
   - Run the Execution Flow (main) function steps 1-9
   - The template is self-contained and executable
   - Follow error handling and gate checks as specified
   - Let the template guide test artifact generation in $TESTS_DIR:
     * Phase 0 generates test-strategy.md
     * Phase 1 generates test-data.md, mocks/, test-setup.md
     * Phase 2 generates test-tasks.md
   - Incorporate user-provided details from arguments into Test Technical Context: $ARGUMENTS
   - Update Progress Tracking as you complete each phase

5. Verify execution completed:
   - Check Progress Tracking shows all phases complete
   - Ensure all required test artifacts were generated
   - Confirm no ERROR states in execution

6. Report results with branch name, file paths, and generated test artifacts.

Use absolute paths with the repository root for all file operations to avoid path issues.

