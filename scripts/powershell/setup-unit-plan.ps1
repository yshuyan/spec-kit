#!/usr/bin/env pwsh
# Setup unit test implementation plan
[CmdletBinding()]
param(
    [switch]$Json
)
$ErrorActionPreference = 'Stop'

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

# Get current branch
if ($hasGit) {
    $currentBranch = git branch --show-current 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $currentBranch) {
        Write-Error "Error: Not on a git branch"
        exit 1
    }
} else {
    $currentBranch = "no-git-branch"
}

# Check if we're on a proper unit test branch (only for git repos)
if ($hasGit) {
    if ($currentBranch -notmatch '^[0-9]{3}-unit-') {
        Write-Error "Error: Not on a unit test branch (expected pattern: ###-unit-*)`nCurrent branch: $currentBranch"
        exit 1
    }
}

# Define paths
$testsDir = Join-Path $repoRoot 'tests'
$testDir = Join-Path $testsDir $currentBranch
$testSpecFile = Join-Path $testDir 'test-spec.md'
$testPlan = Join-Path $testDir 'test-plan.md'

# Check if test spec exists
if (-not (Test-Path $testSpecFile)) {
    Write-Error "Error: Test specification not found at $testSpecFile`nPlease run 'specify-unit' first to create the test specification"
    exit 1
}

# Ensure the test directory exists
New-Item -ItemType Directory -Path $testDir -Force | Out-Null

# Copy unit test plan template if it exists
$template = Join-Path $repoRoot '.specify/templates/unit-test-plan-template.md'
if (Test-Path $template) { 
    Copy-Item $template $testPlan -Force 
    if (-not $Json) {
        Write-Output "Copied unit test plan template to $testPlan"
    }
} else { 
    if (-not $Json) {
        Write-Warning "Warning: Unit test plan template not found at $template"
    }
    # Create a basic test plan file if template doesn't exist
    New-Item -ItemType File -Path $testPlan | Out-Null 
}

# Set the SPECIFY_UNIT_TEST environment variable
$env:SPECIFY_UNIT_TEST = $currentBranch

# Output results
if ($Json) {
    $obj = [PSCustomObject]@{ 
        TEST_SPEC_FILE = $testSpecFile
        TEST_PLAN = $testPlan
        TESTS_DIR = $testDir
        BRANCH = $currentBranch
        HAS_GIT = $hasGit
    }
    $obj | ConvertTo-Json -Compress
} else {
    Write-Output "TEST_SPEC_FILE: $testSpecFile"
    Write-Output "TEST_PLAN: $testPlan"
    Write-Output "TESTS_DIR: $testDir"
    Write-Output "BRANCH: $currentBranch"
    Write-Output "HAS_GIT: $hasGit"
    Write-Output "SPECIFY_UNIT_TEST environment variable set to: $currentBranch"
}
