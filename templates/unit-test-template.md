# Unit Test Specification: [TEST SUITE NAME]

**Test Branch**: `[###-unit-test-name]`  
**Created**: [DATE]  
**Status**: Draft  
**Input**: User description: "$ARGUMENTS"

## Execution Flow (main)
```
1. Parse user test description from Input
   → If empty: ERROR "No test description provided"
2. Extract key testing concepts from description
   → Identify: target functions/classes, test scenarios, edge cases, expected behaviors
3. For each unclear aspect:
   → Mark with [NEEDS CLARIFICATION: specific question]
4. Fill Test Scenarios & Cases section
   → If no clear test cases: ERROR "Cannot determine test scenarios"
5. Generate Test Requirements
   → Each test case must be specific and verifiable
   → Mark ambiguous test requirements
6. Identify Target Components (functions, classes, modules to test)
7. Run Review Checklist
   → If any [NEEDS CLARIFICATION]: WARN "Test spec has uncertainties"
   → If implementation details found: ERROR "Focus on behavior, not implementation"
8. Return: SUCCESS (test spec ready for implementation)
```

---

## ⚡ Quick Guidelines
- ✅ Focus on WHAT behavior to test and WHY it matters
- ❌ Avoid HOW to implement tests (no specific test frameworks, mock details)
- 🧪 Written for developers who will implement the tests

### Section Requirements
- **Mandatory sections**: Must be completed for every test suite
- **Optional sections**: Include only when relevant to the testing scenario
- When a section doesn't apply, remove it entirely (don't leave as "N/A")

### For AI Generation
When creating this test spec from a user prompt:
1. **Mark all ambiguities**: Use [NEEDS CLARIFICATION: specific question] for any assumption you'd need to make
2. **Don't guess**: If the prompt doesn't specify something (e.g., "test user login" without auth method), mark it
3. **Think like a tester**: Every vague requirement should fail the "testable and specific" checklist item
4. **Common underspecified areas**:
   - Input validation boundaries
   - Error conditions and expected responses
   - State changes and side effects
   - Performance expectations
   - Integration dependencies
   - Data persistence behaviors

---

## Test Scenarios & Cases *(mandatory)*

### Primary Test Scenarios
[Describe the main testing objectives in plain language]

### Test Cases
1. **Given** [initial conditions], **When** [action/input], **Then** [expected result/behavior]
2. **Given** [initial conditions], **When** [action/input], **Then** [expected result/behavior]
3. **Given** [error condition], **When** [trigger], **Then** [expected error handling]

### Edge Cases & Boundary Tests
- What happens when [boundary condition]?
- How does system handle [invalid input]?
- What occurs when [resource constraints]?

### Integration Test Cases *(if applicable)*
- How does the component interact with [dependency]?
- What happens when [external service] fails?

## Test Requirements *(mandatory)*

### Functional Test Requirements
- **TR-001**: Test MUST verify [specific behavior, e.g., "user authentication with valid credentials"]
- **TR-002**: Test MUST validate [input handling, e.g., "email format validation"]  
- **TR-003**: Test MUST confirm [state change, e.g., "user session creation"]
- **TR-004**: Test MUST check [data persistence, e.g., "user preferences storage"]
- **TR-005**: Test MUST ensure [error handling, e.g., "invalid login attempt logging"]

*Example of marking unclear requirements:*
- **TR-006**: Test MUST verify user authentication via [NEEDS CLARIFICATION: auth method not specified - email/password, SSO, OAuth?]
- **TR-007**: Test MUST validate data retention for [NEEDS CLARIFICATION: retention period not specified]

### Target Components *(mandatory)*
- **[Function/Class 1]**: [What it does, key behaviors to test]
- **[Function/Class 2]**: [What it does, interactions with other components]
- **[Module/Service]**: [Core functionality, integration points]

### Test Data Requirements *(include if tests need specific data)*
- **[Data Set 1]**: [What data is needed, why it's important for testing]
- **[Data Set 2]**: [Test data scenarios, valid/invalid cases]

### Mock/Stub Requirements *(include if external dependencies exist)*
- **[External Service]**: [What needs to be mocked, expected interactions]
- **[Database/API]**: [Mock behavior, success/failure scenarios]

---

## Performance & Quality Expectations *(optional)*

### Performance Criteria
- Test execution time should be under [X] seconds
- Memory usage should not exceed [X] MB
- Test suite should complete within [X] minutes

### Coverage Requirements
- Code coverage target: [X]%
- Critical path coverage: 100%
- Error path coverage: [X]%

### Quality Standards
- All tests must be deterministic (no flaky tests)
- Tests must be independent (no execution order dependencies)
- Clear, descriptive test names and assertions

---

## Review & Acceptance Checklist
*GATE: Automated checks run during main() execution*

### Test Quality
- [ ] No implementation details (specific frameworks, mock libraries)
- [ ] Focused on behavior verification and quality assurance
- [ ] Written for developers implementing tests
- [ ] All mandatory sections completed

### Test Completeness
- [ ] No [NEEDS CLARIFICATION] markers remain
- [ ] Test cases are specific and verifiable
- [ ] Success criteria are measurable
- [ ] Test scope is clearly bounded
- [ ] Dependencies and test data identified

### Coverage Assessment
- [ ] Happy path scenarios covered
- [ ] Error conditions and edge cases included
- [ ] Integration points identified
- [ ] Performance expectations defined (if applicable)

---

## Execution Status
*Updated by main() during processing*

- [ ] Test description parsed
- [ ] Key testing concepts extracted
- [ ] Ambiguities marked
- [ ] Test scenarios defined
- [ ] Test requirements generated
- [ ] Target components identified
- [ ] Review checklist passed

---
