---
description: "Unit test implementation plan template for test development"
scripts:
  sh: scripts/bash/update-agent-context.sh __AGENT__
  ps: scripts/powershell/update-agent-context.ps1 -AgentType __AGENT__
---

# Unit Test Implementation Plan: [TEST SUITE]

**Branch**: `[###-unit-test-name]` | **Date**: [DATE] | **Test Spec**: [link]
**Input**: Test specification from `/tests/[###-unit-test-name]/test-spec.md`

## Execution Flow (/plan-unit command scope)
```
1. Load test spec from Input path
   → If not found: ERROR "No test spec at {path}"
2. Fill Test Technical Context (scan for NEEDS CLARIFICATION)
   → Detect Test Framework from project structure or context
   → Set Testing Strategy based on target components
3. Fill the Constitution Check section based on testing standards
4. Evaluate Constitution Check section below
   → If testing violations exist: Document in Complexity Tracking
   → If no justification possible: ERROR "Simplify test approach first"
   → Update Progress Tracking: Initial Constitution Check
5. Execute Phase 0 → test-strategy.md
   → If NEEDS CLARIFICATION remain: ERROR "Resolve test unknowns"
6. Execute Phase 1 → mocks/, test-data.md, test-setup.md
7. Re-evaluate Constitution Check section
   → If new violations: Refactor test design, return to Phase 1
   → Update Progress Tracking: Post-Design Constitution Check
8. Plan Phase 2 → Describe test task generation approach (DO NOT create test-tasks.md)
9. STOP - Ready for /test-tasks command
```

**IMPORTANT**: The /plan-unit command STOPS at step 8. Phase 2 is executed by other commands:
- Phase 2: /test-tasks command creates test-tasks.md
- Phase 3: Test implementation execution

## Summary
[Extract from test spec: primary test objectives + testing approach from strategy]

## Test Technical Context
**Testing Framework**: [e.g., Go testing, pytest, Jest, JUnit, XCTest or NEEDS CLARIFICATION]  
**Primary Test Libraries**: [e.g., testify, pytest-mock, testing-library, Mockito or NEEDS CLARIFICATION]  
**Assertion Library**: [e.g., testify/assert, pytest, Chai, AssertJ, XCTAssert or NEEDS CLARIFICATION]  
**Mock Framework**: [e.g., gomock, testify/mock, unittest.mock, Jest mocks, Mockito or NEEDS CLARIFICATION]  
**Test Runner**: [e.g., go test, pytest, npm test, gradle test, xcodebuild test or NEEDS CLARIFICATION]
**Coverage Tool**: [e.g., go test -cover, coverage.py, nyc, JaCoCo, Xcode Coverage or NEEDS CLARIFICATION]  
**CI Integration**: [e.g., GitHub Actions, Jenkins, CircleCI or NEEDS CLARIFICATION]  
**Performance Goals**: [e.g., <5s test suite, 90% coverage, <100ms per test or NEEDS CLARIFICATION]  
**Test Constraints**: [e.g., no external dependencies, deterministic only, thread-safe or NEEDS CLARIFICATION]  
**Test Scope**: [e.g., unit only, integration included, end-to-end or NEEDS CLARIFICATION]

## Constitution Check
*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Testing Standards Compliance**:
- [ ] Tests are isolated and independent
- [ ] No reliance on external services in unit tests
- [ ] Clear test naming conventions followed
- [ ] Proper setup/teardown procedures
- [ ] Deterministic test execution (no flaky tests)

**Code Quality Gates**:
- [ ] Test coverage meets minimum requirements (typically 80%+)
- [ ] Critical paths have 100% coverage
- [ ] Edge cases and error conditions covered
- [ ] Performance tests for critical components
- [ ] Security-sensitive functions tested

**Documentation Requirements**:
- [ ] Test documentation explains complex scenarios
- [ ] Mock usage is justified and documented
- [ ] Test data generation is reproducible
- [ ] CI/CD integration documented

## Test Project Structure

### Test Documentation (this test suite)
```
tests/[###-unit-test]/
├── test-plan.md         # This file (/plan-unit command output)
├── test-strategy.md     # Phase 0 output (/plan-unit command)
├── test-data.md         # Phase 1 output (/plan-unit command)
├── test-setup.md        # Phase 1 output (/plan-unit command)
├── mocks/               # Phase 1 output (/plan-unit command)
└── test-tasks.md        # Phase 2 output (/test-tasks command - NOT created by /plan-unit)
```

### Test Code Structure (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete test layout
  for this test suite. Delete unused options and expand the chosen structure with
  real paths. The delivered plan must not include Option labels.
-->
```
# [REMOVE IF UNUSED] Option 1: Standard unit test structure (DEFAULT)
tests/
├── unit/
│   ├── test_[module].py
│   ├── test_[service].py
│   └── conftest.py
├── integration/
│   └── test_[feature]_integration.py
├── fixtures/
│   ├── data/
│   └── mocks/
└── utils/
    └── test_helpers.py

# [REMOVE IF UNUSED] Option 1b: Go test structure
├── [package]_test.go        # Unit tests alongside source
├── integration_test.go      # Integration tests
├── testdata/               # Test data files
│   ├── fixtures.json
│   └── sample.txt
└── mocks/                  # Generated mocks
    └── mock_[interface].go

# [REMOVE IF UNUSED] Option 2: Module-aligned test structure
src/
├── [module]/
│   ├── __init__.py
│   ├── [component].py
│   └── tests/
│       ├── test_[component].py
│       └── fixtures/
└── tests/
    ├── integration/
    └── e2e/

# [REMOVE IF UNUSED] Option 3: Behavior-driven test structure
tests/
├── behaviors/
│   ├── user_authentication/
│   │   ├── test_login.py
│   │   ├── test_logout.py
│   │   └── fixtures/
│   └── data_processing/
├── mocks/
└── shared/
```

## Phase 0: Test Strategy Research

### Research Tasks
1. **Framework Analysis**: [Evaluate testing frameworks for target language/platform]
2. **Mock Strategy**: [Determine mocking approach for external dependencies]
3. **Test Data Strategy**: [Plan test data generation and management]
4. **CI/CD Integration**: [Research continuous testing pipeline integration]
5. **Performance Testing**: [Identify performance testing requirements]

### Expected Artifacts
- `test-strategy.md`: Comprehensive testing strategy document

### Success Criteria
- Testing approach clearly defined
- Framework selection justified
- Mock strategy documented
- Performance requirements addressed

## Phase 1: Test Design & Setup

### Design Tasks
1. **Mock Objects**: [Design mock interfaces and behaviors]
2. **Test Data Sets**: [Create test data schemas and generators]
3. **Test Setup**: [Design test environment and configuration]
4. **Helper Functions**: [Design reusable test utilities]
5. **Fixture Management**: [Plan test fixture creation and cleanup]

### Expected Artifacts
- `test-data.md`: Test data requirements and generation strategy
- `test-setup.md`: Test environment setup and configuration
- `mocks/`: Mock object designs and specifications

### Success Criteria
- All mock dependencies identified
- Test data generation strategy defined
- Test environment setup documented
- Reusable test components designed

## Phase 2: Test Task Planning (Future /test-tasks command)

### Task Categories
1. **Test Setup**: Framework configuration, test runners, CI integration
2. **Unit Tests**: Individual function/method test implementation
3. **Integration Tests**: Component interaction test implementation
4. **Mock Implementation**: Mock object creation and configuration
5. **Test Data**: Test data generation and fixture creation
6. **Validation**: Coverage analysis, performance testing, quality gates

### Task Dependencies
- Setup tasks must complete before test implementation
- Mock implementation should parallel unit test development
- Integration tests depend on unit test completion
- Validation tasks run after all test implementation

## Quality Assurance

### Test Quality Gates
- [ ] Test coverage >= [X]% (typically 80-90%)
- [ ] Critical path coverage = 100%
- [ ] No flaky tests (deterministic execution)
- [ ] Test execution time < [X] seconds
- [ ] All edge cases covered
- [ ] Error conditions properly tested

### Code Review Checklist
- [ ] Test names clearly describe behavior being tested
- [ ] Tests follow AAA pattern (Arrange, Act, Assert)
- [ ] Mock usage is appropriate and minimal
- [ ] Test data is realistic and representative
- [ ] Setup and teardown are properly handled
- [ ] Tests are independent and can run in any order

### Documentation Standards
- [ ] Complex test logic is commented
- [ ] Mock behavior is documented
- [ ] Test data sources are explained
- [ ] CI/CD integration is documented
- [ ] Troubleshooting guide exists

## Risk Assessment & Mitigation

### Technical Risks
- **Flaky Tests**: [Risk of non-deterministic test failures]
  - *Mitigation*: [Strict isolation, deterministic data, proper timing]
- **Mock Complexity**: [Risk of mocks becoming too complex or unrealistic]
  - *Mitigation*: [Regular mock validation, integration testing]
- **Test Maintenance**: [Risk of tests becoming outdated or brittle]
  - *Mitigation*: [Regular refactoring, clear documentation]

### Process Risks
- **Coverage Gaps**: [Risk of missing critical test scenarios]
  - *Mitigation*: [Systematic requirement mapping, code review]
- **Performance Issues**: [Risk of slow test execution]
  - *Mitigation*: [Performance monitoring, parallel execution]

## Progress Tracking

### Phase Completion Status
- [ ] **Phase 0**: Research completed, strategy documented
- [ ] **Phase 1**: Design completed, all artifacts generated
- [ ] **Phase 2**: Tasks planned (handled by /test-tasks command)

### Artifact Status
- [ ] `test-strategy.md` - Generated and reviewed
- [ ] `test-data.md` - Generated and reviewed
- [ ] `test-setup.md` - Generated and reviewed
- [ ] `mocks/` directory - Created with specifications
- [ ] Test structure - Defined and documented

### Gate Checkpoints
- [ ] **Initial Constitution Check**: Testing standards reviewed
- [ ] **Post-Design Constitution Check**: Design meets standards
- [ ] **Ready for Tasks**: All planning phases complete

---

## Complexity Tracking
*Document any simplifications made during planning*

### Simplified Approaches
[Record any areas where complexity was reduced to meet constitutional requirements]

### Deferred Features
[List any test features deferred to future iterations]

### Trade-off Decisions
[Document key decisions and rationales during planning]

---

**Next Steps**: Run `/test-tasks` to generate detailed implementation tasks based on this plan.
