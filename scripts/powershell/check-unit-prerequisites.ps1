#!/usr/bin/env pwsh
# Consolidated prerequisite checking script for unit tests
# 
# This script provides unified prerequisite checking for Spec-Driven Unit Testing workflow.

[CmdletBinding()]
param(
    [switch]$Json,
    [switch]$RequireTasks,
    [switch]$IncludeTasks,
    [switch]$PathsOnly,
    [switch]$Help
)
$ErrorActionPreference = 'Stop'

if ($Help) {
    Write-Output @"
Usage: check-unit-prerequisites.ps1 [OPTIONS]

Consolidated prerequisite checking for Spec-Driven Unit Testing workflow.

OPTIONS:
  -Json               Output in JSON format
  -RequireTasks       Require test-tasks.md to exist (for implementation phase)
  -IncludeTasks       Include test-tasks.md in AVAILABLE_DOCS list
  -PathsOnly          Only output path variables (no prerequisite validation)
  -Help               Show this help message

EXAMPLES:
  # Check unit test prerequisites (test-plan.md required)
  ./check-unit-prerequisites.ps1 -Json
  
  # Check test implementation prerequisites (test-plan.md + test-tasks.md required)
  ./check-unit-prerequisites.ps1 -Json -RequireTasks -IncludeTasks
  
  # Get test paths only (no validation)
  ./check-unit-prerequisites.ps1 -PathsOnly
"@
    exit 0
}

# Function to find the repository root
function Find-RepositoryRoot {
    param(
        [string]$StartDir,
        [string[]]$Markers = @('.git', '.specify')
    )
    $current = Resolve-Path $StartDir
    while ($true) {
        foreach ($marker in $Markers) {
            if (Test-Path (Join-Path $current $marker)) {
                return $current
            }
        }
        $parent = Split-Path $current -Parent
        if ($parent -eq $current) {
            # Reached filesystem root without finding markers
            return $null
        }
        $current = $parent
    }
}

# Resolve repository root
$fallbackRoot = (Find-RepositoryRoot -StartDir $PSScriptRoot)
if (-not $fallbackRoot) {
    Write-Error "Error: Could not determine repository root. Please run this script from within the repository."
    exit 1
}

try {
    $repoRoot = git rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -eq 0) {
        $hasGit = $true
    } else {
        throw "Git not available"
    }
} catch {
    $repoRoot = $fallbackRoot
    $hasGit = $false
}

# Get current branch and validate unit test branch
if ($hasGit) {
    $currentBranch = git branch --show-current 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $currentBranch) {
        Write-Error "Error: Not on a git branch"
        exit 1
    }
    
    if ($currentBranch -notmatch '^[0-9]{3}-unit-') {
        Write-Error "Error: Not on a unit test branch (expected pattern: ###-unit-*)`nCurrent branch: $currentBranch"
        exit 1
    }
} else {
    $currentBranch = "no-git-branch"
}

# Define paths for unit tests
$testsDir = Join-Path $repoRoot 'tests'
$testDir = Join-Path $testsDir $currentBranch
$testSpecFile = Join-Path $testDir 'test-spec.md'
$testPlan = Join-Path $testDir 'test-plan.md'
$testTasks = Join-Path $testDir 'test-tasks.md'
$testStrategy = Join-Path $testDir 'test-strategy.md'
$testData = Join-Path $testDir 'test-data.md'
$testSetup = Join-Path $testDir 'test-setup.md'
$mocksDir = Join-Path $testDir 'mocks'

# Function to check file/directory existence
function Test-FileExists { param($Path, $Name) if (Test-Path $Path) { "  ✓ $Name" } else { "  ✗ $Name" } }
function Test-DirExists { param($Path, $Name) if ((Test-Path $Path) -and (Get-ChildItem $Path -ErrorAction SilentlyContinue)) { "  ✓ $Name" } else { "  ✗ $Name" } }

# If paths-only mode, output paths and exit
if ($PathsOnly) {
    if ($Json) {
        # Minimal JSON paths payload (no validation performed)
        $obj = [PSCustomObject]@{ 
            REPO_ROOT = $repoRoot
            BRANCH = $currentBranch
            TEST_DIR = $testDir
            TEST_SPEC_FILE = $testSpecFile
            TEST_PLAN = $testPlan
            TEST_TASKS = $testTasks
        }
        $obj | ConvertTo-Json -Compress
    } else {
        Write-Output "REPO_ROOT: $repoRoot"
        Write-Output "BRANCH: $currentBranch"
        Write-Output "TEST_DIR: $testDir"
        Write-Output "TEST_SPEC_FILE: $testSpecFile"
        Write-Output "TEST_PLAN: $testPlan"
        Write-Output "TEST_TASKS: $testTasks"
    }
    exit 0
}

# Validate required directories and files
if (-not (Test-Path $testDir)) {
    Write-Error "ERROR: Test directory not found: $testDir`nRun /specify-unit first to create the test structure."
    exit 1
}

if (-not (Test-Path $testPlan)) {
    Write-Error "ERROR: test-plan.md not found in $testDir`nRun /plan-unit first to create the test implementation plan."
    exit 1
}

# Check for test-tasks.md if required
if ($RequireTasks -and (-not (Test-Path $testTasks))) {
    Write-Error "ERROR: test-tasks.md not found in $testDir`nRun /tasks-unit first to create the test task list."
    exit 1
}

# Build list of available documents
$docs = @()

# Always check these optional docs
if (Test-Path $testStrategy) { $docs += "test-strategy.md" }
if (Test-Path $testData) { $docs += "test-data.md" }
if (Test-Path $testSetup) { $docs += "test-setup.md" }

# Check mocks directory (only if it exists and has files)
if ((Test-Path $mocksDir) -and (Get-ChildItem $mocksDir -ErrorAction SilentlyContinue)) {
    $docs += "mocks/"
}

# Include test-tasks.md if requested and it exists
if ($IncludeTasks -and (Test-Path $testTasks)) {
    $docs += "test-tasks.md"
}

# Output results
if ($Json) {
    # Build JSON object with documents array
    $obj = [PSCustomObject]@{ 
        TEST_DIR = $testDir
        AVAILABLE_DOCS = $docs
    }
    $obj | ConvertTo-Json -Compress
} else {
    # Text output
    Write-Output "TEST_DIR:$testDir"
    Write-Output "AVAILABLE_DOCS:"
    
    # Show status of each potential document
    Write-Output (Test-FileExists $testStrategy "test-strategy.md")
    Write-Output (Test-FileExists $testData "test-data.md")
    Write-Output (Test-FileExists $testSetup "test-setup.md")
    Write-Output (Test-DirExists $mocksDir "mocks/")
    
    if ($IncludeTasks) {
        Write-Output (Test-FileExists $testTasks "test-tasks.md")
    }
}
