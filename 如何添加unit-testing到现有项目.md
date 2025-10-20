# 如何为现有项目添加 Unit Testing 支持

## 问题说明

当你使用 `specify init` 初始化项目时，下载的是 GitHub release 中的模板。如果该 release 是在添加 unit testing 功能之前发布的，那么生成的项目中就不会包含 unit testing 相关的命令。

你的 `score_unit/.claude/commands/` 目录中只有：
```
speckit.analyze.md
speckit.checklist.md
speckit.clarify.md
speckit.constitution.md
speckit.implement.md
speckit.plan.md
speckit.specify.md
speckit.tasks.md
```

缺少：
- `speckit.specify-unit.md`
- `speckit.plan-unit.md`
- `speckit.tasks-unit.md`
- `speckit.implement-unit.md`

## 解决方案 1：手动添加命令文件（快速测试）

从 spec-kit 项目复制 unit testing 命令到你的项目：

```bash
# 进入你的项目目录
cd /Users/tu/ad-matrix/score_unit

# 复制 unit testing 命令文件
cp /Users/tu/PycharmProjects/spec-kit/.claude/commands/specify-unit.md .claude/commands/speckit.specify-unit.md
cp /Users/tu/PycharmProjects/spec-kit/.claude/commands/plan-unit.md .claude/commands/speckit.plan-unit.md
cp /Users/tu/PycharmProjects/spec-kit/.claude/commands/tasks-unit.md .claude/commands/speckit.tasks-unit.md
cp /Users/tu/PycharmProjects/spec-kit/.claude/commands/implement-unit.md .claude/commands/speckit.implement-unit.md

# 验证文件已复制
ls -la .claude/commands/ | grep unit
```

### 需要的模板文件

还需要确保项目中有 unit testing 的模板文件：

```bash
# 检查是否存在 .specify/templates 目录
ls -la .specify/templates/

# 如果不存在 unit testing 模板，从 spec-kit 复制
cp /Users/tu/PycharmProjects/spec-kit/templates/unit-test-template.md .specify/templates/
cp /Users/tu/PycharmProjects/spec-kit/templates/unit-test-plan-template.md .specify/templates/
cp /Users/tu/PycharmProjects/spec-kit/templates/unit-tasks-template.md .specify/templates/
```

### 需要的脚本文件

确保有 unit testing 脚本：

```bash
# 检查脚本目录
ls -la .specify/scripts/bash/ | grep unit

# 如果不存在，从 spec-kit 复制
cp /Users/tu/PycharmProjects/spec-kit/scripts/bash/create-unit-test.sh .specify/scripts/bash/
cp /Users/tu/PycharmProjects/spec-kit/scripts/bash/setup-unit-plan.sh .specify/scripts/bash/
cp /Users/tu/PycharmProjects/spec-kit/scripts/bash/check-unit-prerequisites.sh .specify/scripts/bash/

# 确保脚本可执行
chmod +x .specify/scripts/bash/*unit*.sh
```

## 解决方案 2：等待下一个 Release（推荐）

下次 spec-kit 发布新版本时，新的 release 会自动包含所有 unit testing 命令。届时：

1. 删除旧项目或在新目录初始化
2. 运行 `specify init your-project --ai claude`
3. 新项目会自动包含所有 unit testing 命令

## 解决方案 3：创建本地测试 Release

在发布前本地测试，可以手动创建 release 包：

```bash
cd /Users/tu/PycharmProjects/spec-kit

# 运行 release 打包脚本
.github/workflows/scripts/create-release-packages.sh v1.0.1

# 解压生成的包到测试目录
cd .genreleases
unzip spec-kit-template-claude-sh-v1.0.1.zip -d test-project

# 查看生成的命令
ls -la test-project/.claude/commands/
```

## 验证 Unit Testing 可用

添加文件后，验证 unit testing 命令是否可用：

```bash
cd /Users/tu/ad-matrix/score_unit

# 使用 Claude Code CLI 测试
claude /speckit.specify-unit test user authentication

# 或使用 specify CLI（如果项目在 git 中）
cd /Users/tu/ad-matrix/score_unit
specify unit init "test user authentication"
```

## 完整的 Unit Testing 工作流程

添加支持后，你可以使用完整的工作流程：

### 1. 创建测试规范
```bash
/speckit.specify-unit test user authentication with edge cases
```

### 2. 创建测试计划
```bash
/speckit.plan-unit
```

### 3. 生成测试任务
```bash
/speckit.tasks-unit
```

### 4. 实施测试
```bash
/speckit.implement-unit
```

## 预期的命令前缀

根据你的项目配置，命令前缀可能是：
- Claude Code: `/speckit.specify-unit` (有 speckit 前缀)
- 或者: `/specify-unit` (无前缀，取决于配置)

检查你的 `.claude/commands/` 中的文件名来确定正确的前缀。

## 目录结构

成功添加 unit testing 支持后，你的项目结构应该是：

```
score_unit/
├── .claude/
│   └── commands/
│       ├── speckit.specify-unit.md      ← 新增
│       ├── speckit.plan-unit.md         ← 新增
│       ├── speckit.tasks-unit.md        ← 新增
│       ├── speckit.implement-unit.md    ← 新增
│       └── ... (其他现有命令)
├── .specify/
│   ├── scripts/
│   │   └── bash/
│   │       ├── create-unit-test.sh      ← 新增
│   │       ├── setup-unit-plan.sh       ← 新增
│   │       └── check-unit-prerequisites.sh ← 新增
│   └── templates/
│       ├── unit-test-template.md        ← 新增
│       ├── unit-test-plan-template.md   ← 新增
│       └── unit-tasks-template.md       ← 新增
└── tests/                               ← 运行 specify-unit 后创建
    └── 001-unit-test-user-auth/
        ├── test-spec.md
        ├── test-plan.md
        └── test-tasks.md
```

## 总结

- **现在就测试**: 使用方案 1 手动添加文件
- **生产使用**: 等待 spec-kit 发布新版本，然后用新模板初始化项目
- **验证**: 确保命令文件、模板文件和脚本文件都已添加
- **测试**: 运行 `/speckit.specify-unit` 验证功能正常

---

**注意**: 文件名中的 `speckit.` 前缀是你的项目配置决定的。确保新添加的文件名与现有命令文件的命名模式一致。

