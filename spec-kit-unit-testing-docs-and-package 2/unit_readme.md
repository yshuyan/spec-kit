<div align="center">
    <img src="./media/logo_small.webp"/>
    <h1>🌱 Spec Kit: Unit Testing</h1>
    <h3><em>Build high-quality unit tests faster.</em></h3>
</div>

<p align="center">
    <strong>A complete spec-driven unit testing framework that extends the Spec-Kit methodology to comprehensive test development.</strong>
</p>

---

## 📋 Table of Contents

- [🤔 What is Spec-Driven Unit Testing?](#-what-is-spec-driven-unit-testing)
- [⚡ Get started](#-get-started)
- [🤖 Supported AI Agents](#-supported-ai-agents)
- [🔧 CLI Reference](#-cli-reference)
- [📚 Core philosophy](#-core-philosophy)
- [🎯 Key Features](#-key-features)
- [📖 Learn more](#-learn-more)

## 🤔 What is Spec-Driven Unit Testing?

Spec-Driven Unit Testing applies the same structured, intent-driven principles of Spec-Driven Development to the process of creating unit tests. Instead of writing test code directly, you start by creating a high-level specification of what needs to be tested. This specification is then used to generate a detailed test plan, actionable tasks, and finally, the complete test suite.

This approach ensures that your tests are comprehensive, well-documented, and directly aligned with your feature's requirements.

## ⚡ Get started

Before you begin, install the Specify CLI directly from the provided wheel package.

### 1. Install Specify CLI from the wheel

Locate the packaged wheel file (for example, `specify_cli_yshuyan-1.0-py3-none-any.whl`) and install it with `pip`:

```bash
pip install specify_cli_yshuyan-1.0-py3-none-any.whl
```

> Replace the path if you stored the wheel elsewhere.

### 2. Specify the tests

Use the `/specify-unit` command to describe the component or behavior you want to test. Focus on the **what** and **why**, not the implementation details of the tests.

```bash
/specify-unit test user authentication with edge cases and security validation
```

This will create a new test branch and a `test-spec.md` file under the `tests/` directory.

### 3. Create a technical test plan

Use the `/plan-unit` command to generate a detailed technical plan for your tests. This includes selecting testing frameworks, designing mocks, and defining test data.

```bash
/plan-unit
```

### 4. Break down into tasks

Use `/tasks-unit` to create an actionable list of tasks from your test plan.

```bash
/tasks-unit
```

### 5. Execute test implementation

Use `/implement-unit` to execute all the testing tasks and build your test suite.

```bash
/implement-unit
```

## 🤖 Supported AI Agents

All AI agents supported by the main Spec Kit workflow are also supported for the unit testing workflow, including:

- Claude Code
- GitHub Copilot
- Gemini CLI
- Cursor
- Qwen Code
- opencode
- Windsurf
- And more...

## 🔧 CLI Reference

The unit testing workflow introduces a new set of slash commands that mirror the main development commands.

| Command           | Description                                                           |
|-------------------|-----------------------------------------------------------------------|
| `/specify-unit`   | Define what you want to test (requirements and scenarios)             |
| `/plan-unit`      | Create a technical test implementation plan with your chosen frameworks |
| `/tasks-unit`     | Generate actionable task lists for test implementation                |
| `/implement-unit` | Execute all tasks to build the test suite according to the plan       |

## 📚 Core philosophy

- **Intent-driven testing**: Define the *what* and *why* of your tests before the *how*.
- **Structured process**: Follow a multi-step refinement process for creating robust tests.
- **Framework-agnostic**: Works with popular testing frameworks like `pytest`, `Jest`, `JUnit`, `XCTest`, and more.
- **Comprehensive planning**: Goes beyond just writing test cases to include test strategy, data management, and mocking.

## 🎯 Key Features

### Comprehensive Test Planning
- **Test Strategy Design**: Framework selection, mocking approach, data management.
- **Quality Standards**: Coverage targets, performance requirements, CI integration.
- **Risk Assessment**: Identify potential testing challenges and mitigation strategies.

### Technical Excellence  
- **Framework Agnostic**: Works with pytest, Jest, JUnit, XCTest, and others.
- **Mock Management**: Systematic approach to creating and managing test doubles.
- **Test Data**: Structured approach to test data generation and management.

### Quality Assurance
- **Coverage Requirements**: Automated coverage tracking and validation.
- **Performance Testing**: Built-in performance test scenarios.
- **Flaky Test Detection**: Tools to identify and eliminate non-deterministic tests.

## 📖 Learn more

- **[Complete Spec-Driven Unit Testing Methodology](./UNIT-TESTING.md)** - Deep dive into the full process.

