# 修复 specify-unit 模板文件缺失问题

## 问题描述

在执行 `/specify-unit` 命令时，如果遇到以下错误：

```
Error reading file: ~/GolandProjects/ad-matrix/.specify/templates/unit-test-template.md
```

这是因为项目初始化时缺少模板文件。

## 临时解决方案

### 方法 1: 手动复制模板文件（推荐）

从 spec-kit 源码复制模板到你的项目：

```bash
# 导航到你的项目目录
cd /Users/tu/GolandProjects/ad-matrix

# 创建模板目录（如果不存在）
mkdir -p .specify/templates

# 从 spec-kit 复制所有模板
cp /Users/tu/PycharmProjects/spec-kit/templates/*.md .specify/templates/
```

### 方法 2: 使用新的打包脚本重新初始化

如果你还没有开始编写代码，可以删除项目并使用新的 release 包重新初始化：

```bash
# 1. 先创建新的 release 包
cd /Users/tu/PycharmProjects/spec-kit
./create-release.sh your-github-username

# 2. 重新初始化项目
cd /Users/tu/GolandProjects
rm -rf ad-matrix
specify init ad-matrix --ai claude --repo your-username/spec-kit
```

## 长期解决方案

我已经创建了完整的打包和发布脚本：

### 新增文件

1. **`.github/workflows/scripts/create-release-packages.sh`**
   - 为所有 AI agents 创建 release 包
   - 包含所有模板文件（包括 unit-test-template.md）
   - 支持 22 个组合（11 agents × 2 script types）

2. **`.github/workflows/release.yml`**
   - GitHub Actions 自动化发布工作流
   - 当推送 tag 时自动创建 release

3. **更新 `create-release.sh`**
   - 自动检测并运行打包脚本
   - 交互式确认流程

### 使用新脚本

```bash
# 1. 创建 release 包
cd /Users/tu/PycharmProjects/spec-kit
/bin/bash .github/workflows/scripts/create-release-packages.sh v1.0.1

# 2. 验证包内容
unzip -l .genreleases/spec-kit-template-claude-sh-v1.0.1.zip | grep template

# 3. 创建 GitHub release
./create-release.sh your-github-username
```

### 包含的模板文件

每个 release 包现在都包含以下模板：

- ✅ `spec-template.md` - 功能规范模板
- ✅ `plan-template.md` - 实施计划模板
- ✅ `tasks-template.md` - 任务列表模板
- ✅ `unit-test-template.md` - **单元测试规范模板** ⭐
- ✅ `unit-test-plan-template.md` - 单元测试计划模板
- ✅ `unit-tasks-template.md` - 单元测试任务模板
- ✅ `agent-file-template.md` - Agent 上下文模板

### 目录结构

新的 release 包结构：

```
spec-kit-<agent>-<script-type>/
├── .specify/
│   ├── templates/          # ⭐ 所有模板文件
│   │   ├── unit-test-template.md
│   │   ├── unit-test-plan-template.md
│   │   └── ...
│   ├── specs/
│   ├── plans/
│   └── tasks/
├── scripts/
│   └── bash/ 或 powershell/
├── tests/
├── memory/
│   └── constitution.md
└── .<agent>/               # agent 特定目录
    ├── commands/ 或 workflows/
    └── rules/
```

## 验证修复

运行以下命令验证模板文件已正确安装：

```bash
# 检查模板文件
ls -la .specify/templates/

# 应该看到：
# unit-test-template.md
# unit-test-plan-template.md
# unit-tasks-template.md
# spec-template.md
# plan-template.md
# tasks-template.md
# agent-file-template.md
```

## 下次更新时

当你推送新的 tag 到 GitHub 时，GitHub Actions 会自动：

1. 运行 `create-release-packages.sh` 创建所有包
2. 创建 GitHub Release
3. 上传所有包到 Release

```bash
# 推送 tag 触发自动发布
git tag v1.0.2
git push origin v1.0.2
```

---

**相关文件：**
- 打包脚本: `.github/workflows/scripts/create-release-packages.sh`
- GitHub Actions: `.github/workflows/release.yml`
- 发布脚本: `create-release.sh`
- 模板源码: `templates/`

