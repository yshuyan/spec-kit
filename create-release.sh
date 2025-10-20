#!/bin/bash

# 创建 GitHub Release 并上传所有 zip 文件
# 使用方法: ./create-release.sh your-github-username

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}======================================${NC}"
echo -e "${CYAN}  创建 GitHub Release v1.0.1${NC}"
echo -e "${CYAN}======================================${NC}"
echo ""

# 检查参数
if [ -z "$1" ]; then
    echo -e "${RED}错误: 请提供你的 GitHub 用户名${NC}"
    echo ""
    echo "使用方法: $0 your-github-username"
    exit 1
fi

GITHUB_USER="$1"
VERSION="v1.0.1"

echo -e "${YELLOW}GitHub 用户名: $GITHUB_USER${NC}"
echo -e "${YELLOW}版本: $VERSION${NC}"
echo ""

# 检查 release 包是否存在
if [ ! -d ".genreleases" ]; then
    echo -e "${RED}错误: .genreleases 目录不存在${NC}"
    echo -e "${YELLOW}提示: 先运行打包脚本${NC}"
    echo "  /bin/bash .github/workflows/scripts/create-release-packages.sh $VERSION"
    echo ""
    read -p "是否现在运行打包脚本？(y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${CYAN}运行打包脚本...${NC}"
        # Ensure source scripts have execute permissions before packaging
        chmod +x scripts/bash/*.sh 2>/dev/null || true
        /bin/bash .github/workflows/scripts/create-release-packages.sh "$VERSION"
        echo ""
    else
        exit 1
    fi
fi

ZIP_COUNT=$(ls .genreleases/*.zip 2>/dev/null | wc -l)
if [ "$ZIP_COUNT" -eq 0 ]; then
    echo -e "${RED}错误: .genreleases 目录中没有 zip 文件${NC}"
    exit 1
fi

echo -e "${GREEN}✓ 找到 $ZIP_COUNT 个 release 包${NC}"
echo ""

# 检查是否已登录 GitHub CLI
if ! gh auth status >/dev/null 2>&1; then
    echo -e "${YELLOW}需要登录 GitHub CLI${NC}"
    gh auth login
fi

echo ""
read -p "确认创建 Release 并上传所有包？(y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}已取消${NC}"
    exit 1
fi

echo ""
echo -e "${CYAN}创建 Release ${VERSION}...${NC}"

# 创建 release notes
cat > /tmp/release-notes.md << 'EOF'
## 🎉 新功能

### Unit Testing 支持 ⭐
- ✅ 完整的 Unit Testing 工作流
- ✅ `/specify-unit` - 创建测试规范
- ✅ `/plan-unit` - 创建测试计划
- ✅ `/tasks-unit` - 生成测试任务
- ✅ `/implement-unit` - 执行测试实施

### CLI 增强
- ✅ 支持自定义 GitHub 仓库（`--repo` 参数）
- ✅ `specify unit` 子命令
- ✅ 环境变量支持（`SPECIFY_REPO`）

### 支持的测试框架
- Python: pytest, unittest
- JavaScript/TypeScript: Jest, Mocha, Vitest
- Java: JUnit, TestNG
- Go: testing package
- Swift: XCTest
- 更多...

## 📦 包含的 AI Agents

所有主流 AI 编码助手都已支持：

- 🤖 Claude Code
- 🤖 GitHub Copilot
- 🤖 Cursor
- 🤖 Gemini CLI
- 🤖 Qwen Code
- 🤖 opencode
- 🤖 Windsurf
- 🤖 Codex
- 🤖 Kilo Code
- 🤖 Auggie
- 🤖 Roo Code

每个 agent 都有 Bash 和 PowerShell 两个版本。

## 🚀 使用方法

### 从你的仓库初始化项目

```bash
# 方式 1: 使用 --repo 参数
specify init my-project --ai claude --repo $GITHUB_USER/spec-kit

# 方式 2: 使用环境变量
export SPECIFY_REPO="$GITHUB_USER/spec-kit"
specify init my-project --ai claude
```

### 使用 Unit Testing

```bash
cd my-project
git init
git add .
git commit -m "Initial commit"

# 创建测试规范
claude /specify-unit test user authentication

# 创建测试计划
claude /plan-unit

# 生成测试任务
claude /tasks-unit

# 执行测试实施
claude /implement-unit
```

## 📚 文档

- [Unit Testing 完整指南](./UNIT-TESTING-完善总结.md)
- [从自己的 GitHub 使用](./从自己GitHub使用Spec-Kit.md)
- [添加到现有项目](./如何添加unit-testing到现有项目.md)

---

**完整版本**: v1.0.1
**发布日期**: $(date +%Y-%m-%d)
EOF

# 创建 release
echo -e "${CYAN}上传 Release 包...${NC}"

gh release create "$VERSION" \
  --repo "$GITHUB_USER/spec-kit" \
  --title "Spec Kit Templates - 1.0.1" \
  --notes-file /tmp/release-notes.md \
  .genreleases/*.zip

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}======================================${NC}"
    echo -e "${GREEN}  ✓ Release 创建成功！${NC}"
    echo -e "${GREEN}======================================${NC}"
    echo ""
    echo -e "${CYAN}查看 Release:${NC}"
    echo -e "  ${YELLOW}https://github.com/$GITHUB_USER/spec-kit/releases${NC}"
    echo ""
    echo -e "${CYAN}测试使用:${NC}"
    echo -e "  ${YELLOW}specify init test-project --ai claude --repo $GITHUB_USER/spec-kit${NC}"
    echo ""
else
    echo -e "${RED}✗ Release 创建失败${NC}"
    echo -e "${YELLOW}可能的原因:${NC}"
    echo "  1. Release v1.0.1 已存在"
    echo "  2. 没有推送权限"
    echo "  3. 仓库不存在"
    exit 1
fi

# 清理
rm -f /tmp/release-notes.md

