# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.9] - 2025-10-20

### Fixed
- **Chinese Content Generation**: Enhanced specify-unit command to ensure generated content is in Chinese
  - Added explicit instructions to NOT copy template content directly
  - Instructs AI to generate completely new Chinese content
  - Emphasizes replacing ALL placeholders with Chinese descriptions
  - Ensures all sections are written in Chinese

### Changed
- **Content Quality**: Improved guidance for generating Chinese documentation from user input

## [1.0.8] - 2025-10-20

### Fixed
- **Critical Permission Fix**: Use `bash` prefix for all script commands to avoid permission errors
  - Changed from `scripts/bash/xxx.sh` to `bash scripts/bash/xxx.sh`
  - Eliminates "permission denied" errors completely
  - Works regardless of file execution permissions
  - Applies to all workflow commands

### Changed
- **Script Execution**: All commands now explicitly use `bash` or `pwsh` interpreters
- **Reliability**: Scripts will run consistently across all systems

## [1.0.7] - 2025-10-20

### Added
- **Chinese Language Support**: All command files now instruct AI to generate documentation in Chinese (简体中文)
  - Added language instruction to all workflow commands
  - `/specify-unit`, `/plan-unit`, `/tasks-unit`, `/implement-unit` now generate Chinese docs
  - `/specify`, `/plan`, `/tasks`, `/implement` now generate Chinese docs
  - Ensures consistent Chinese output for all generated documentation

### Changed
- **Command Templates**: Enhanced all command templates with explicit Chinese language directive
- **Documentation Quality**: Improved clarity by specifying language at the beginning of each command

## [1.0.6] - 2025-10-20

### Added
- **Version Display**: Show Specify CLI version number when running `specify init`
  - Helps users verify which version they're using
  - Appears after banner, before project setup info

### Note
- Users need to run `specify init --here --force` to update existing projects with fixed scripts
- The permission fix from v1.0.4 only applies to newly initialized projects

## [1.0.5] - 2025-10-20

### Fixed
- **Command File Instructions**: Enhanced `/specify-unit` command template with clearer instructions
  - Added explicit example showing how to pass arguments to the script
  - Claude Code was running script without arguments due to ambiguous instructions
  - Now includes clear example: `scripts/bash/create-unit-test.sh --json "test user authentication"`
  - Fixed template path reference to use `.specify/templates/` instead of `templates/`

### Changed
- **Command Documentation**: Improved clarity on how to execute scripts with user input
- **Error Prevention**: More explicit instructions to prevent "Usage error" when running commands

## [1.0.4] - 2025-10-20

### Fixed
- **Script Permission Detection**: Fixed `ensure_executable_scripts()` to check both `.specify/scripts` and `scripts/` directories
  - Previously only checked `.specify/scripts/`, missing the main `scripts/bash/` directory
  - Now properly sets execute permissions for all bash scripts after extraction
  - Fixes issue where scripts had correct permissions in ZIP but lost them after `specify init`

### Changed
- **Permission Verification**: Added total script count to permission tracking
- **Error Handling**: Improved error reporting with relative paths

## [1.0.3] - 2025-10-20

### Fixed
- **Script Permissions**: Fixed bash scripts missing executable permissions
  - Added automatic `chmod +x` in release packaging script
  - Ensures all bash scripts have execute permissions before and after packaging
  - Prevents "permission denied" errors when running scripts directly
- **Packaging Script**: Enhanced `.github/workflows/scripts/create-release-packages.sh`
  - Now ensures source scripts have execute permissions before copying
  - Double-checks destination scripts also have execute permissions
  - Eliminates permission issues in deployed projects

### Changed
- **Release Process**: Both `create-release.sh` and packaging script now set proper permissions
- **Error Prevention**: Scripts will work correctly even if git doesn't track file permissions

## [1.0.2] - 2025-10-20

### Fixed
- **Unit Test Scripts Template Paths**: Fixed incorrect template paths in unit test scripts
  - `scripts/bash/create-unit-test.sh`: Updated to use `.specify/templates/unit-test-template.md`
  - `scripts/bash/setup-unit-plan.sh`: Updated to use `.specify/templates/unit-test-plan-template.md`
  - `scripts/powershell/create-unit-test.ps1`: Updated to use `.specify/templates/unit-test-template.md`
  - `scripts/powershell/setup-unit-plan.ps1`: Updated to use `.specify/templates/unit-test-plan-template.md`
  - These scripts were incorrectly looking for templates in `templates/` instead of `.specify/templates/`
  - This caused `/specify-unit` command to fail with "Error reading file" for templates

## [1.0.1] - 2025-10-20

### Fixed
- **Template Files Missing**: Fixed critical issue where `specify init` did not copy template files to project's `.specify/templates/` directory
  - This caused `/specify-unit` and other commands to fail when looking for templates
  - Now all 7 template files are properly included in release packages
- **Release Package Script**: Created comprehensive packaging script to generate release packages for all AI agents
  - Supports 11 AI agents: claude, gemini, copilot, cursor, qwen, opencode, codex, windsurf, kilocode, auggie, roo
  - Generates both bash and PowerShell variants (22 packages total)
  - Ensures all template files are included in each package

### Added
- **Automated Packaging**: `.github/workflows/scripts/create-release-packages.sh`
  - Generates release packages for all supported AI agents
  - Properly includes all template files in `.specify/templates/`
  - Creates correct directory structure for each agent
- **GitHub Actions Workflow**: `.github/workflows/release.yml`
  - Automatically creates releases when tags are pushed
  - Uploads all 22 release packages to GitHub releases
- **Quick Fix Tool**: `fix-templates.sh`
  - One-command solution to fix existing projects missing template files
  - Copies all necessary templates from spec-kit to target project
- **Documentation**: 
  - `TEMPLATE-FIX.md` - Comprehensive guide for the template fix
  - `TEMPLATE-FIX-COMPLETION.md` - Technical completion report

### Changed
- **Release Script Enhancement**: `create-release.sh` now checks for packages and offers to run packaging script automatically
- **Package Contents**: All release packages now include:
  - 7 template files (spec, plan, tasks, unit-test, unit-test-plan, unit-tasks, agent-file)
  - Complete directory structure (.specify/, tests/, memory/)
  - Agent-specific command files and rules
  - Cross-platform scripts (bash/powershell)

### Technical Details
- Fixed bash compatibility issue (removed `local -A` for macOS bash 3.x support)
- Improved script path resolution (uses `bash/` and `powershell/` directories correctly)
- Enhanced error handling in packaging script
- Added comprehensive validation and testing

## [1.0.0] - 2025-10-19

### Changed
- Stable release with full unit testing support
- All features from 0.1.0 promoted to stable

## [0.1.0] - 2024-01-15

### Added
- **Unit Testing Framework**: Complete spec-driven unit testing workflow
  - New `specify unit` command group with subcommands:
    - `specify unit init "description"` - Create unit test specifications
    - `specify unit plan` - Generate test implementation plans  
    - `specify unit check` - Verify testing prerequisites
    - `specify unit status` - Show current test workflow status
- **Templates and Scripts**: Full template system for unit testing
  - Unit test specification template (`templates/unit-test-template.md`)
  - Test implementation plan template (`templates/unit-test-plan-template.md`)
  - Test tasks breakdown template (`templates/unit-tasks-template.md`)
  - AI assistant command templates (`templates/commands/specify-unit.md`, `plan-unit.md`, etc.)
- **Cross-Platform Scripts**: Bash and PowerShell support
  - `scripts/bash/create-unit-test.sh` - Create test specifications
  - `scripts/bash/setup-unit-plan.sh` - Setup test plans
  - `scripts/bash/check-unit-prerequisites.sh` - Check prerequisites
  - PowerShell equivalents for Windows support
- **Go Language Support**: Enhanced templates and examples for Go projects
  - Go-specific test patterns (table-driven tests, benchmarks)
  - gomock and testify integration examples
  - Go testing best practices integration
- **Documentation**: Comprehensive guides and examples
  - `GO-TESTING-GUIDE.md` - Complete Go testing integration guide
  - `CLI-INTEGRATION.md` - CLI usage and integration instructions
  - `UNIT-TESTING.md` - Complete unit testing framework documentation

### Changed
- Version bumped from 0.0.17 to 0.1.0 (minor version for new features)
- Enhanced CLI help system to include unit testing commands
- Improved template system with language-specific examples

### Technical Details
- Added typer sub-application for unit testing commands
- Integration with existing script infrastructure
- JSON-based communication between CLI and scripts
- Support for multiple project directory structures
- Git branch management for unit test workflows

## [0.0.17] - 2024-01-14

### Previous Release
- Core Specify CLI functionality
- Project initialization with AI assistant selection
- Template downloading from GitHub releases
- Multi-platform support (Bash/PowerShell)
- Support for Claude Code, Gemini CLI, GitHub Copilot, Cursor, Qwen Code, opencode, Windsurf, and other AI assistants

---

**Migration Notes for v0.1.0:**

If you're upgrading from a previous version:

1. **New Commands Available**: You now have access to `specify unit` commands
2. **Existing Projects**: The new unit testing features work alongside existing Specify projects
3. **No Breaking Changes**: All existing `specify init` and `specify check` commands work exactly as before
4. **New Dependencies**: The same Python dependencies are used, no additional installation required

**For New Users:**

The complete workflow now includes both feature development and unit testing:

```bash
# Feature Development Workflow
specify init my-project --ai claude
specify /specify    # Create feature spec
specify /plan       # Create implementation plan  
specify /tasks      # Generate tasks
specify /implement  # Execute implementation

# Unit Testing Workflow (NEW!)
specify unit init "test user authentication"  # Create test spec
specify /plan-unit     # Plan tests
specify /tasks-unit    # Generate test tasks  
specify /implement-unit # Execute tests
```