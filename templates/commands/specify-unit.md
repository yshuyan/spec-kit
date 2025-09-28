---
description: Create or update unit test specifications from a natural language test description.
scripts:
  sh: scripts/bash/create-unit-test.sh --json "{ARGS}"
  ps: scripts/powershell/create-unit-test.ps1 -Json "{ARGS}"
---

The user input to you can be provided directly by the agent or as a command argument - you **MUST** consider it before proceeding with the prompt (if not empty).

User input:

$ARGUMENTS

The text the user typed after `/specify-unit` in the triggering message **is** the unit test description. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that unit test description, do this:

1. Run the script `{SCRIPT}` from repo root and parse its JSON output for BRANCH_NAME and TEST_SPEC_FILE. All file paths must be absolute.
   **IMPORTANT** You must only ever run this script once. The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for.
2. Load `templates/unit-test-template.md` to understand required sections.
3. Write the unit test specification to TEST_SPEC_FILE using the template structure, replacing placeholders with concrete details derived from the test description (arguments) while preserving section order and headings.
4. Report completion with branch name, test spec file path, and readiness for test implementation.

Note: The script creates and checks out the new test branch and initializes the test specification file before writing.
