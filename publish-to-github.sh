#!/bin/bash

# 发布 Spec-Kit 到你的 GitHub 账号
# 使用方法: ./publish-to-github.sh your-github-username

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}======================================${NC}"
echo -e "${CYAN}  发布 Spec-Kit 到你的 GitHub 账号${NC}"
echo -e "${CYAN}======================================${NC}"
echo ""

# 检查参数
if [ -z "$1" ]; then
    echo -e "${RED}错误: 请提供你的 GitHub 用户名${NC}"
    echo ""
    echo "使用方法: $0 your-github-username"
    echo ""
    echo "示例: $0 johnsmith"
    exit 1
fi

GITHUB_USER="$1"
REPO_URL="https://github.com/$GITHUB_USER/spec-kit.git"

echo -e "${YELLOW}GitHub 用户名: $GITHUB_USER${NC}"
echo -e "${YELLOW}仓库地址: $REPO_URL${NC}"
echo ""

# 确认
read -p "确认继续？(y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}已取消${NC}"
    exit 1
fi

echo ""
echo -e "${CYAN}步骤 1/5: 移除旧的 remote...${NC}"
git remote remove origin 2>/dev/null || echo "没有旧的 origin，跳过"

echo -e "${GREEN}✓ 完成${NC}"
echo ""

echo -e "${CYAN}步骤 2/5: 添加新的 remote...${NC}"
git remote add origin "$REPO_URL"
echo -e "${GREEN}✓ 完成${NC}"
echo ""

echo -e "${CYAN}步骤 3/5: 推送代码到 main 分支...${NC}"
git push -u origin main

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ 代码推送成功${NC}"
else
    echo -e "${RED}✗ 推送失败${NC}"
    echo -e "${YELLOW}提示：${NC}"
    echo "  1. 确保已在 GitHub 创建 spec-kit 仓库"
    echo "  2. 确保有推送权限（可能需要 gh auth login）"
    exit 1
fi

echo ""
echo -e "${CYAN}步骤 4/5: 创建 v1.0.1 标签...${NC}"
git tag v1.0.1 2>/dev/null || echo "标签已存在"
echo -e "${GREEN}✓ 完成${NC}"
echo ""

echo -e "${CYAN}步骤 5/5: 推送标签（将触发自动发布）...${NC}"
git push origin v1.0.1

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ 标签推送成功${NC}"
else
    echo -e "${YELLOW}⚠ 标签推送失败（可能已存在）${NC}"
fi

echo ""
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  ✓ 发布完成！${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""
echo -e "${CYAN}下一步：${NC}"
echo ""
echo "1. 检查 GitHub Actions 运行状态："
echo -e "   ${YELLOW}https://github.com/$GITHUB_USER/spec-kit/actions${NC}"
echo ""
echo "2. 等待 Actions 完成后，查看 Release："
echo -e "   ${YELLOW}https://github.com/$GITHUB_USER/spec-kit/releases${NC}"
echo ""
echo "3. 测试使用你的仓库："
echo -e "   ${YELLOW}specify init test-project --ai claude --repo $GITHUB_USER/spec-kit${NC}"
echo ""
echo -e "${CYAN}或者设置环境变量：${NC}"
echo -e "   ${YELLOW}export SPECIFY_REPO=\"$GITHUB_USER/spec-kit\"${NC}"
echo -e "   ${YELLOW}specify init test-project --ai claude${NC}"
echo ""

