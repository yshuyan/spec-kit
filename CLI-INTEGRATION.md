# CLI集成指南：添加单元测试功能

我已经为您的Specify CLI添加了完整的单元测试功能。以下是完整的集成指南和使用方法。

## 🔄 已完成的集成

### 1. 新增的CLI命令

我已经在`src/specify_cli/__init__.py`中添加了以下单元测试命令：

```bash
specify unit init "test description"    # 创建单元测试规范
specify unit plan                       # 制定测试实现计划
specify unit check                      # 检查测试先决条件
specify unit status                     # 显示当前测试状态
```

### 2. 版本更新

- 已将版本从`0.0.17`升级到`0.1.0`，表示新的功能版本

## 🚀 如何安装和使用

### 步骤1：安装依赖

确保您的环境中安装了所需的Python依赖：

```bash
cd /Users/tu/PycharmProjects/spec-kit

# 方式1：使用pip安装依赖
pip3 install typer rich httpx platformdirs readchar truststore

# 方式2：使用uv（如果已安装）
uv sync

# 方式3：安装为可编辑包
pip3 install -e .
```

### 步骤2：测试CLI功能

```bash
# 测试主命令帮助
python3 -m specify_cli --help

# 测试单元测试子命令
python3 -m specify_cli unit --help

# 或者，如果已安装为包
specify --help
specify unit --help
```

## 📋 完整的使用示例

### 创建项目并添加单元测试

```bash
# 1. 创建新的Specify项目
specify init my-go-project --ai claude

# 2. 进入项目目录
cd my-go-project

# 3. 创建单元测试规范
specify unit init "test user authentication with password validation"

# 输出示例：
# ✓ Unit test specification created:
#   Branch: 001-unit-test-user-authentication
#   Spec file: /path/to/tests/001-unit-test-user-authentication/test-spec.md
#   Test number: 001
#
# Next steps:
# 1. /plan-unit - Plan the test implementation
# 2. /tasks-unit - Break down into tasks
# 3. /implement-unit - Execute the tests

# 4. 制定测试实现计划
specify unit plan

# 输出示例：
# ✓ Test implementation plan created:
#   Branch: 001-unit-test-user-authentication
#   Plan file: /path/to/tests/001-unit-test-user-authentication/test-plan.md

# 5. 检查测试状态
specify unit status

# 输出示例：
# ✓ On unit test branch: 001-unit-test-user-authentication
#
# Available test documents:
#   - test-spec.md ✓
#   - test-plan.md ✓
#
# Test directory: /path/to/tests/001-unit-test-user-authentication

# 6. 检查测试先决条件
specify unit check

# 输出示例：
# TEST_DIR:/path/to/tests/001-unit-test-user-authentication
# AVAILABLE_DOCS:
#   ✓ test-strategy.md
#   ✓ test-data.md
#   ✗ test-setup.md
#   ✓ mocks/
#
# Unit testing prerequisites satisfied!
```

### Go项目示例

```bash
# 创建Go项目
mkdir my-go-api && cd my-go-api
specify init . --ai claude

# 创建Go HTTP handler测试
specify unit init "test HTTP handler with JSON parsing and error responses"

# 创建数据库服务测试
specify unit init "test database connection with transaction handling"

# 创建用户验证测试  
specify unit init "test user validation functions with email format checking"

# 查看当前测试状态
specify unit status
```

## 🎯 新命令详细说明

### `specify unit init`

**功能**：创建新的单元测试规范

**语法**：
```bash
specify unit init "test description" [--dir PROJECT_DIR]
```

**参数**：
- `test_description`：必需参数，描述要测试的内容
- `--dir`：可选参数，指定项目目录（默认为当前目录）

**示例**：
```bash
specify unit init "test user registration with email validation"
specify unit init "test API endpoint authentication" --dir ~/my-project
specify unit init "test Go HTTP middleware with rate limiting"
```

### `specify unit plan`

**功能**：为当前测试规范创建实现计划

**语法**：
```bash
specify unit plan [--dir PROJECT_DIR]
```

**功能**：
- 分析测试规范文件
- 生成测试技术上下文和策略
- 创建测试实现计划文档

### `specify unit check`

**功能**：检查单元测试工作流的先决条件

**语法**：
```bash
specify unit check [--dir PROJECT_DIR] [--require-tasks]
```

**参数**：
- `--require-tasks`：要求test-tasks.md文件存在
- `--dir`：指定项目目录

### `specify unit status`

**功能**：显示当前单元测试工作流状态

**语法**：
```bash
specify unit status [--dir PROJECT_DIR]
```

**输出信息**：
- 当前Git分支状态
- 可用的测试文档
- 测试目录位置

## 🔧 高级用法

### 多项目管理

```bash
# 在不同项目中创建测试
specify unit init "test API endpoints" --dir ~/project-a
specify unit init "test database models" --dir ~/project-b  
specify unit init "test user authentication" --dir ~/project-c

# 检查不同项目的状态
specify unit status --dir ~/project-a
specify unit status --dir ~/project-b
specify unit status --dir ~/project-c
```

### 批量操作

```bash
#!/bin/bash
# 批量创建多个测试规范

PROJECTS=("user-service" "payment-service" "notification-service")
TESTS=("API endpoints" "database operations" "business logic")

for project in "${PROJECTS[@]}"; do
    for test in "${TESTS[@]}"; do
        specify unit init "test $test" --dir ~/workspace/$project
    done
done
```

### 集成到CI/CD

```yaml
# .github/workflows/unit-tests.yml
name: Unit Test Workflow

on: [push, pull_request]

jobs:
  check-tests:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Install Specify CLI
      run: |
        pip install specify-cli
        
    - name: Check unit test prerequisites  
      run: |
        specify unit check --require-tasks
        
    - name: Display test status
      run: |
        specify unit status
```

## 🔗 与AI助手的集成

新的CLI命令与AI助手完美集成：

### Claude Code
```bash
# 在Claude中使用
/specify-unit test user authentication with security validation
/plan-unit
/tasks-unit  
/implement-unit
```

### 其他AI助手
所有支持的AI助手都可以使用相同的命令：
- Cursor：`/specify-unit`, `/plan-unit`, `/tasks-unit`, `/implement-unit`
- GitHub Copilot：在Chat中使用相同命令
- Gemini CLI：`/specify-unit`, `/plan-unit`, `/tasks-unit`, `/implement-unit`

## 📊 项目结构

新的CLI功能会在您的项目中创建以下结构：

```
your-project/
├── scripts/
│   ├── bash/
│   │   ├── create-unit-test.sh          # CLI调用的脚本
│   │   ├── setup-unit-plan.sh           # CLI调用的脚本  
│   │   └── check-unit-prerequisites.sh  # CLI调用的脚本
│   └── powershell/
│       ├── create-unit-test.ps1
│       ├── setup-unit-plan.ps1
│       └── check-unit-prerequisites.ps1
├── templates/
│   ├── commands/
│   │   ├── specify-unit.md              # AI助手命令
│   │   ├── plan-unit.md                 # AI助手命令
│   │   ├── tasks-unit.md                # AI助手命令
│   │   └── implement-unit.md            # AI助手命令
│   ├── unit-test-template.md            # 测试规范模板
│   ├── unit-test-plan-template.md       # 测试计划模板
│   └── unit-tasks-template.md           # 测试任务模板
└── tests/                               # CLI创建的测试目录
    └── ###-unit-test-name/
        ├── test-spec.md
        ├── test-plan.md
        └── test-tasks.md
```

## 🐛 故障排除

### 常见问题

1. **`No module named 'typer'`错误**
   ```bash
   pip3 install typer rich httpx platformdirs readchar truststore
   ```

2. **脚本不存在错误**
   ```bash
   # 确保在Specify项目目录中运行
   # 确保scripts/目录存在相应的脚本文件
   ```

3. **权限错误**
   ```bash
   chmod +x scripts/bash/*.sh
   ```

### 验证安装

```bash
# 检查CLI是否正常工作
specify --help

# 检查单元测试功能
specify unit --help

# 检查依赖脚本
ls -la scripts/bash/create-unit-test.sh
ls -la scripts/bash/setup-unit-plan.sh
ls -la scripts/bash/check-unit-prerequisites.sh
```

## 🎉 完成！

您现在拥有了一个完整的CLI集成单元测试工具链！

### 主要功能
- ✅ 命令行接口集成
- ✅ 跨平台支持（Bash + PowerShell）
- ✅ AI助手集成  
- ✅ Go项目优化支持
- ✅ 完整的4阶段工作流程
- ✅ 状态管理和进度跟踪

### 下一步
1. **安装依赖**：`pip3 install -e .`
2. **测试命令**：`specify unit --help`
3. **创建测试**：`specify unit init "your test description"`
4. **开始使用**：享受spec驱动的单元测试开发！

您的CLI现在支持完整的单元测试开发工作流程了！🚀
