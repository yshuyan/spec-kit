#!/usr/bin/env pwsh
# Create a new unit test specification
[CmdletBinding()]
param(
    [switch]$Json,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$TestDescription
)
$ErrorActionPreference = 'Stop'

if (-not $TestDescription -or $TestDescription.Count -eq 0) {
    Write-Error "Usage: ./create-unit-test.ps1 [-Json] <test description>"
    exit 1
}
$testDesc = ($TestDescription -join ' ').Trim()

# Resolve repository root. Prefer git information when available, but fall back
# to searching for repository markers so the workflow still functions in repositories that
# were initialised with --no-git.
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

Set-Location $repoRoot

$testsDir = Join-Path $repoRoot 'tests'
New-Item -ItemType Directory -Path $testsDir -Force | Out-Null

$highest = 0
if (Test-Path $testsDir) {
    Get-ChildItem -Path $testsDir -Directory | ForEach-Object {
        if ($_.Name -match '^(\d{3})') {
            $num = [int]$matches[1]
            if ($num -gt $highest) { $highest = $num }
        }
    }
}
$next = $highest + 1
$testNum = ('{0:000}' -f $next)

$branchName = $testDesc.ToLower() -replace '[^a-z0-9]', '-' -replace '-{2,}', '-' -replace '^-', '' -replace '-$', ''
$words = ($branchName -split '-') | Where-Object { $_ } | Select-Object -First 3
$branchName = "$testNum-unit-$([string]::Join('-', $words))"

if ($hasGit) {
    try {
        git checkout -b $branchName | Out-Null
    } catch {
        Write-Warning "Failed to create git branch: $branchName"
    }
} else {
    Write-Warning "[specify-unit] Warning: Git repository not detected; skipped branch creation for $branchName"
}

$testDir = Join-Path $testsDir $branchName
New-Item -ItemType Directory -Path $testDir -Force | Out-Null

$template = Join-Path $repoRoot '.specify/templates/unit-test-template.md'
$testSpecFile = Join-Path $testDir 'test-spec.md'
if (Test-Path $template) { 
    Copy-Item $template $testSpecFile -Force 
} else { 
    New-Item -ItemType File -Path $testSpecFile | Out-Null 
}

# Set the SPECIFY_UNIT_TEST environment variable for the current session
$env:SPECIFY_UNIT_TEST = $branchName

if ($Json) {
    $obj = [PSCustomObject]@{ 
        BRANCH_NAME = $branchName
        TEST_SPEC_FILE = $testSpecFile
        TEST_NUM = $testNum
        HAS_GIT = $hasGit
    }
    $obj | ConvertTo-Json -Compress
} else {
    Write-Output "BRANCH_NAME: $branchName"
    Write-Output "TEST_SPEC_FILE: $testSpecFile"
    Write-Output "TEST_NUM: $testNum"
    Write-Output "HAS_GIT: $hasGit"
    Write-Output "SPECIFY_UNIT_TEST environment variable set to: $branchName"
}
