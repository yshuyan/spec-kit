#!/bin/bash

# 快速修复：复制模板文件到用户项目
# 使用方法: ./fix-templates.sh /path/to/your/project

set -e

TARGET_PROJECT="${1:-.}"

echo "修复 Spec-Kit 模板文件缺失问题"
echo "================================"
echo ""

if [ ! -d "$TARGET_PROJECT" ]; then
    echo "❌ 错误: 目录不存在: $TARGET_PROJECT"
    exit 1
fi

SPEC_KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_SRC="$SPEC_KIT_ROOT/templates"
TEMPLATES_DEST="$TARGET_PROJECT/.specify/templates"

if [ ! -d "$TEMPLATES_SRC" ]; then
    echo "❌ 错误: 找不到模板源目录: $TEMPLATES_SRC"
    exit 1
fi

echo "📂 目标项目: $TARGET_PROJECT"
echo "📁 源模板目录: $TEMPLATES_SRC"
echo "📁 目标模板目录: $TEMPLATES_DEST"
echo ""

# 创建目标目录
mkdir -p "$TEMPLATES_DEST"

# 复制模板文件
echo "📋 复制模板文件..."
cp -v "$TEMPLATES_SRC"/*.md "$TEMPLATES_DEST/" 2>/dev/null || {
    echo "⚠️  警告: 没有找到 .md 文件"
}

echo ""
echo "✅ 完成！已复制以下模板文件："
echo ""
ls -1 "$TEMPLATES_DEST"/*.md 2>/dev/null | while read file; do
    echo "  ✓ $(basename "$file")"
done

echo ""
echo "🎉 现在可以使用 /specify-unit 命令了！"
echo ""

