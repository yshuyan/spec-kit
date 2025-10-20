#!/usr/bin/env bash

set -e

# Parse command line arguments
JSON_MODE=false
ARGS=()

for arg in "$@"; do
    case "$arg" in
        --json) 
            JSON_MODE=true 
            ;;
        --help|-h) 
            echo "Usage: $0 [--json]"
            echo "  --json    Output results in JSON format"
            echo "  --help    Show this help message"
            exit 0 
            ;;
        *) 
            ARGS+=("$arg") 
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

# Get current branch
if [ "$HAS_GIT" = true ]; then
    CURRENT_BRANCH=$(git branch --show-current)
    if [ -z "$CURRENT_BRANCH" ]; then
        echo "Error: Not on a git branch" >&2
        exit 1
    fi
else
    CURRENT_BRANCH="no-git-branch"
fi

# Check if we're on a proper unit test branch (only for git repos)
if [ "$HAS_GIT" = true ]; then
    if [[ ! "$CURRENT_BRANCH" =~ ^[0-9]{3}-unit- ]]; then
        echo "Error: Not on a unit test branch (expected pattern: ###-unit-*)" >&2
        echo "Current branch: $CURRENT_BRANCH" >&2
        exit 1
    fi
fi

# Define paths
TESTS_DIR="$REPO_ROOT/tests"
TEST_DIR="$TESTS_DIR/$CURRENT_BRANCH"
TEST_SPEC_FILE="$TEST_DIR/test-spec.md"
TEST_PLAN="$TEST_DIR/test-plan.md"

# Check if test spec exists
if [ ! -f "$TEST_SPEC_FILE" ]; then
    echo "Error: Test specification not found at $TEST_SPEC_FILE" >&2
    echo "Please run 'specify-unit' first to create the test specification" >&2
    exit 1
fi

# Ensure the test directory exists
mkdir -p "$TEST_DIR"

# Copy unit test plan template if it exists
TEMPLATE="$REPO_ROOT/.specify/templates/unit-test-plan-template.md"
if [[ -f "$TEMPLATE" ]]; then
    cp "$TEMPLATE" "$TEST_PLAN"
    if ! $JSON_MODE; then
        echo "Copied unit test plan template to $TEST_PLAN"
    fi
else
    if ! $JSON_MODE; then
        echo "Warning: Unit test plan template not found at $TEMPLATE"
    fi
    # Create a basic test plan file if template doesn't exist
    touch "$TEST_PLAN"
fi

# Set the SPECIFY_UNIT_TEST environment variable
export SPECIFY_UNIT_TEST="$CURRENT_BRANCH"

# Output results
if $JSON_MODE; then
    printf '{"TEST_SPEC_FILE":"%s","TEST_PLAN":"%s","TESTS_DIR":"%s","BRANCH":"%s","HAS_GIT":"%s"}\n' \
        "$TEST_SPEC_FILE" "$TEST_PLAN" "$TEST_DIR" "$CURRENT_BRANCH" "$HAS_GIT"
else
    echo "TEST_SPEC_FILE: $TEST_SPEC_FILE"
    echo "TEST_PLAN: $TEST_PLAN" 
    echo "TESTS_DIR: $TEST_DIR"
    echo "BRANCH: $CURRENT_BRANCH"
    echo "HAS_GIT: $HAS_GIT"
    echo "SPECIFY_UNIT_TEST environment variable set to: $CURRENT_BRANCH"
fi
