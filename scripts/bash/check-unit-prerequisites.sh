#!/usr/bin/env bash

# Consolidated prerequisite checking script for unit tests
#
# This script provides unified prerequisite checking for Spec-Driven Unit Testing workflow.
#
# Usage: ./check-unit-prerequisites.sh [OPTIONS]
#
# OPTIONS:
#   --json              Output in JSON format
#   --require-tasks     Require test-tasks.md to exist (for implementation phase)
#   --include-tasks     Include test-tasks.md in AVAILABLE_DOCS list
#   --paths-only        Only output path variables (no validation)
#   --help, -h          Show help message
#
# OUTPUTS:
#   JSON mode: {"TEST_DIR":"...", "AVAILABLE_DOCS":["..."]}
#   Text mode: TEST_DIR:... \n AVAILABLE_DOCS: \n ✓/✗ file.md
#   Paths only: REPO_ROOT: ... \n BRANCH: ... \n TEST_DIR: ... etc.

set -e

# Parse command line arguments
JSON_MODE=false
REQUIRE_TASKS=false
INCLUDE_TASKS=false
PATHS_ONLY=false

for arg in "$@"; do
    case "$arg" in
        --json)
            JSON_MODE=true
            ;;
        --require-tasks)
            REQUIRE_TASKS=true
            ;;
        --include-tasks)
            INCLUDE_TASKS=true
            ;;
        --paths-only)
            PATHS_ONLY=true
            ;;
        --help|-h)
            cat << 'EOF'
Usage: check-unit-prerequisites.sh [OPTIONS]

Consolidated prerequisite checking for Spec-Driven Unit Testing workflow.

OPTIONS:
  --json              Output in JSON format
  --require-tasks     Require test-tasks.md to exist (for implementation phase)
  --include-tasks     Include test-tasks.md in AVAILABLE_DOCS list
  --paths-only        Only output path variables (no prerequisite validation)
  --help, -h          Show this help message

EXAMPLES:
  # Check unit test prerequisites (test-plan.md required)
  ./check-unit-prerequisites.sh --json
  
  # Check test implementation prerequisites (test-plan.md + test-tasks.md required)
  ./check-unit-prerequisites.sh --json --require-tasks --include-tasks
  
  # Get test paths only (no validation)
  ./check-unit-prerequisites.sh --paths-only
  
EOF
            exit 0
            ;;
        *)
            echo "ERROR: Unknown option '$arg'. Use --help for usage information." >&2
            exit 1
            ;;
    esac
done

# Function to find the repository root
find_repo_root() {
    local dir="$1"
    while [ "$dir" != "/" ]; do
        if [ -d "$dir/.git" ] || [ -d "$dir/.specify" ]; then
            echo "$dir"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

# Get script directory and resolve repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if git rev-parse --show-toplevel >/dev/null 2>&1; then
    REPO_ROOT=$(git rev-parse --show-toplevel)
    HAS_GIT=true
else
    REPO_ROOT="$(find_repo_root "$SCRIPT_DIR")"
    if [ -z "$REPO_ROOT" ]; then
        echo "Error: Could not determine repository root. Please run this script from within the repository." >&2
        exit 1
    fi
    HAS_GIT=false
fi

# Get current branch and validate unit test branch
if [ "$HAS_GIT" = true ]; then
    CURRENT_BRANCH=$(git branch --show-current)
    if [ -z "$CURRENT_BRANCH" ]; then
        echo "Error: Not on a git branch" >&2
        exit 1
    fi
    
    if [[ ! "$CURRENT_BRANCH" =~ ^[0-9]{3}-unit- ]]; then
        echo "Error: Not on a unit test branch (expected pattern: ###-unit-*)" >&2
        echo "Current branch: $CURRENT_BRANCH" >&2
        exit 1
    fi
else
    CURRENT_BRANCH="no-git-branch"
fi

# Define paths for unit tests
TESTS_DIR="$REPO_ROOT/tests"
TEST_DIR="$TESTS_DIR/$CURRENT_BRANCH"
TEST_SPEC_FILE="$TEST_DIR/test-spec.md"
TEST_PLAN="$TEST_DIR/test-plan.md"
TEST_TASKS="$TEST_DIR/test-tasks.md"
TEST_STRATEGY="$TEST_DIR/test-strategy.md"
TEST_DATA="$TEST_DIR/test-data.md"
TEST_SETUP="$TEST_DIR/test-setup.md"
MOCKS_DIR="$TEST_DIR/mocks"

# Function to check file existence
check_file() { [[ -f "$1" ]] && echo "  ✓ $2" || echo "  ✗ $2"; }
check_dir() { [[ -d "$1" && -n $(ls -A "$1" 2>/dev/null) ]] && echo "  ✓ $2" || echo "  ✗ $2"; }

# If paths-only mode, output paths and exit
if $PATHS_ONLY; then
    if $JSON_MODE; then
        # Minimal JSON paths payload (no validation performed)
        printf '{"REPO_ROOT":"%s","BRANCH":"%s","TEST_DIR":"%s","TEST_SPEC_FILE":"%s","TEST_PLAN":"%s","TEST_TASKS":"%s"}\n' \
            "$REPO_ROOT" "$CURRENT_BRANCH" "$TEST_DIR" "$TEST_SPEC_FILE" "$TEST_PLAN" "$TEST_TASKS"
    else
        echo "REPO_ROOT: $REPO_ROOT"
        echo "BRANCH: $CURRENT_BRANCH"
        echo "TEST_DIR: $TEST_DIR"
        echo "TEST_SPEC_FILE: $TEST_SPEC_FILE"
        echo "TEST_PLAN: $TEST_PLAN"
        echo "TEST_TASKS: $TEST_TASKS"
    fi
    exit 0
fi

# Validate required directories and files
if [[ ! -d "$TEST_DIR" ]]; then
    echo "ERROR: Test directory not found: $TEST_DIR" >&2
    echo "Run /specify-unit first to create the test structure." >&2
    exit 1
fi

if [[ ! -f "$TEST_PLAN" ]]; then
    echo "ERROR: test-plan.md not found in $TEST_DIR" >&2
    echo "Run /plan-unit first to create the test implementation plan." >&2
    exit 1
fi

# Check for test-tasks.md if required
if $REQUIRE_TASKS && [[ ! -f "$TEST_TASKS" ]]; then
    echo "ERROR: test-tasks.md not found in $TEST_DIR" >&2
    echo "Run /tasks-unit first to create the test task list." >&2
    exit 1
fi

# Build list of available documents
docs=()

# Always check these optional docs
[[ -f "$TEST_STRATEGY" ]] && docs+=("test-strategy.md")
[[ -f "$TEST_DATA" ]] && docs+=("test-data.md")
[[ -f "$TEST_SETUP" ]] && docs+=("test-setup.md")

# Check mocks directory (only if it exists and has files)
if [[ -d "$MOCKS_DIR" ]] && [[ -n "$(ls -A "$MOCKS_DIR" 2>/dev/null)" ]]; then
    docs+=("mocks/")
fi

# Include test-tasks.md if requested and it exists
if $INCLUDE_TASKS && [[ -f "$TEST_TASKS" ]]; then
    docs+=("test-tasks.md")
fi

# Output results
if $JSON_MODE; then
    # Build JSON array of documents
    if [[ ${#docs[@]} -eq 0 ]]; then
        json_docs="[]"
    else
        json_docs=$(printf '"%s",' "${docs[@]}")
        json_docs="[${json_docs%,}]"
    fi
    
    printf '{"TEST_DIR":"%s","AVAILABLE_DOCS":%s}\n' "$TEST_DIR" "$json_docs"
else
    # Text output
    echo "TEST_DIR:$TEST_DIR"
    echo "AVAILABLE_DOCS:"
    
    # Show status of each potential document
    check_file "$TEST_STRATEGY" "test-strategy.md"
    check_file "$TEST_DATA" "test-data.md"
    check_file "$TEST_SETUP" "test-setup.md"
    check_dir "$MOCKS_DIR" "mocks/"
    
    if $INCLUDE_TASKS; then
        check_file "$TEST_TASKS" "test-tasks.md"
    fi
fi
