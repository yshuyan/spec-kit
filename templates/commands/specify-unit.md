---
description: Create or update unit test specifications from a natural language test description.
scripts:
  sh: bash scripts/bash/create-unit-test.sh --json "$ARGUMENTS"
  ps: pwsh scripts/powershell/create-unit-test.ps1 -Json "$ARGUMENTS"
---

**IMPORTANT: Generate all documentation in Chinese (简体中文). All sections, descriptions, and content should be written in Chinese.**

The user input to you can be provided directly by the agent or as a command argument - you **MUST** consider it before proceeding with the prompt (if not empty).

User input:

$ARGUMENTS

The text the user typed after `/specify-unit` in the triggering message **is** the unit test description. Assume you always have it available in this conversation even if `$ARGUMENTS` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that unit test description, do this:

1. **Run the script with bash explicitly**: Execute `bash scripts/bash/create-unit-test.sh --json "<test_description>"` from repo root where `<test_description>` is what the user typed after /specify-unit. Parse the JSON output for BRANCH_NAME and TEST_SPEC_FILE. All file paths must be absolute.
   **IMPORTANT**: You must pass the test description as an argument to the script. 
   **Example**: If user said "test user authentication", run: `bash scripts/bash/create-unit-test.sh --json "test user authentication"`
   
2. Load `.specify/templates/unit-test-template.md` to understand required sections.

3. **Write the unit test specification in Chinese (中文)** to TEST_SPEC_FILE using the template structure, replacing placeholders with concrete details derived from the test description (arguments) while preserving section order and headings. All content should be in Chinese.

4. Report completion with branch name, test spec file path, and readiness for test implementation.

Note: The script creates and checks out the new test branch and initializes the test specification file before writing.
