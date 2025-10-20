#!/bin/bash

# 一键安装 Specify 到 ad-matrix 项目
# 从本地 release 包安装，避免 GitHub API 限制

set -e

echo "🚀 安装 Spec-Kit 到 ad-matrix 项目"
echo "===================================="
echo ""

# 项目目录
PROJECT_DIR="/Users/tu/GolandProjects/ad-matrix"
RELEASE_ZIP="/Users/tu/PycharmProjects/spec-kit/.genreleases/spec-kit-template-claude-sh-v1.0.3.zip"
TEMP_DIR="/tmp/spec-kit-install-$$"

# 检查文件
if [ ! -f "$RELEASE_ZIP" ]; then
    echo "❌ 错误: 找不到 release 包"
    echo "   $RELEASE_ZIP"
    exit 1
fi

if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ 错误: 找不到项目目录"
    echo "   $PROJECT_DIR"
    exit 1
fi

echo "📂 项目目录: $PROJECT_DIR"
echo "📦 Release 包: $(basename $RELEASE_ZIP)"
echo ""

# 解压
echo "📋 步骤 1/4: 解压 release 包..."
mkdir -p "$TEMP_DIR"
unzip -q "$RELEASE_ZIP" -d "$TEMP_DIR"
echo "✅ 完成"
echo ""

# 复制文件
echo "📋 步骤 2/4: 复制文件到项目..."
cd "$PROJECT_DIR"

# 备份现有文件（如果存在）
if [ -d ".claude" ] || [ -d "scripts" ]; then
    BACKUP_DIR=".specify-backup-$(date +%Y%m%d-%H%M%S)"
    echo "   备份现有文件到: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    [ -d ".claude" ] && cp -r .claude "$BACKUP_DIR/" 2>/dev/null || true
    [ -d "scripts" ] && cp -r scripts "$BACKUP_DIR/" 2>/dev/null || true
    [ -d ".specify" ] && cp -r .specify "$BACKUP_DIR/" 2>/dev/null || true
fi

# 复制新文件
cp -r "$TEMP_DIR/spec-kit-claude-sh/.claude" .
cp -r "$TEMP_DIR/spec-kit-claude-sh/.specify" .
cp -r "$TEMP_DIR/spec-kit-claude-sh/scripts" .
cp -r "$TEMP_DIR/spec-kit-claude-sh/tests" .
cp -r "$TEMP_DIR/spec-kit-claude-sh/memory" . 2>/dev/null || true

# 复制文档
cp "$TEMP_DIR/spec-kit-claude-sh/README.md" .specify/ 2>/dev/null || true
cp "$TEMP_DIR/spec-kit-claude-sh/UNIT-TESTING.md" . 2>/dev/null || true
cp "$TEMP_DIR/spec-kit-claude-sh/spec-driven.md" . 2>/dev/null || true
cp "$TEMP_DIR/spec-kit-claude-sh/GO-TESTING-GUIDE.md" . 2>/dev/null || true

echo "✅ 完成"
echo ""

# 设置权限
echo "📋 步骤 3/4: 设置脚本权限..."
chmod +x scripts/bash/*.sh 2>/dev/null || true
echo "✅ 完成"
echo ""

# 验证
echo "📋 步骤 4/4: 验证安装..."
ERRORS=0

if [ ! -f "scripts/bash/create-unit-test.sh" ]; then
    echo "❌ 缺少: scripts/bash/create-unit-test.sh"
    ERRORS=$((ERRORS+1))
else
    echo "✅ scripts/bash/create-unit-test.sh"
fi

if [ ! -f ".claude/commands/specify-unit.md" ]; then
    echo "❌ 缺少: .claude/commands/specify-unit.md"
    ERRORS=$((ERRORS+1))
else
    echo "✅ .claude/commands/specify-unit.md"
fi

if [ ! -f ".specify/templates/unit-test-template.md" ]; then
    echo "❌ 缺少: .specify/templates/unit-test-template.md"
    ERRORS=$((ERRORS+1))
else
    echo "✅ .specify/templates/unit-test-template.md"
fi

# 统计模板文件
TEMPLATE_COUNT=$(ls -1 .specify/templates/*.md 2>/dev/null | wc -l)
echo "✅ 共 $TEMPLATE_COUNT 个模板文件"

# 统计命令文件
COMMAND_COUNT=$(ls -1 .claude/commands/*.md 2>/dev/null | wc -l)
echo "✅ 共 $COMMAND_COUNT 个 Claude 命令"

echo ""

# 清理
echo "🧹 清理临时文件..."
rm -rf "$TEMP_DIR"
echo "✅ 完成"
echo ""

if [ $ERRORS -eq 0 ]; then
    echo "════════════════════════════════════"
    echo "  ✅ 安装成功！"
    echo "════════════════════════════════════"
    echo ""
    echo "现在可以使用以下命令："
    echo "  • /specify      - 创建功能规范"
    echo "  • /specify-unit - 创建单元测试规范"
    echo "  • /plan         - 创建实施计划"
    echo "  • /plan-unit    - 创建测试计划"
    echo "  • /tasks        - 生成任务列表"
    echo "  • /tasks-unit   - 生成测试任务"
    echo "  • /implement    - 执行实施"
    echo "  • /implement-unit - 执行测试实施"
    echo ""
    echo "测试命令："
    echo "  cd $PROJECT_DIR"
    echo "  claude /specify-unit 为 score_service.go 创建单元测试"
    echo ""
else
    echo "════════════════════════════════════"
    echo "  ⚠️  安装完成但有 $ERRORS 个错误"
    echo "════════════════════════════════════"
    exit 1
fi

