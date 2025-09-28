# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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