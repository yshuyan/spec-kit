# 从自己的 GitHub 仓库使用 Spec-Kit

## ✅ 现在支持三种方式

### 方式 1：命令行参数 `--repo`（推荐）

```bash
specify init my-project --ai claude --repo yourname/your-spec-kit
```

### 方式 2：环境变量 `SPECIFY_REPO`

```bash
export SPECIFY_REPO="yourname/your-spec-kit"
specify init my-project --ai claude
```

### 方式 3：分别设置环境变量

```bash
export SPECIFY_REPO_OWNER="yourname"
export SPECIFY_REPO_NAME="your-spec-kit"
specify init my-project --ai claude
```

## 🚀 完整流程：从零到可用

### 第一步：在 GitHub 创建你的仓库

#### 选项 A：Fork 官方仓库（推荐）

```bash
# 1. 在 GitHub 上 fork github/spec-kit
# 访问: https://github.com/github/spec-kit
# 点击右上角的 Fork 按钮

# 2. Clone 你 fork 的仓库
git clone https://github.com/yourname/spec-kit.git
cd spec-kit

# 3. 添加你的修改（比如自定义模板）
# ...

# 4. 提交修改
git add .
git commit -m "Add custom templates"
git push origin main
```

#### 选项 B：从测试包创建新仓库

```bash
# 1. 在 GitHub 创建新仓库（空仓库）
# 访问: https://github.com/new
# 名称: my-spec-kit
# 不要初始化 README

# 2. 使用测试包内容
cp -r ~/Desktop/spec-kit-with-unit-testing my-spec-kit
cd my-spec-kit

# 3. 初始化并推送
git init
git add .
git commit -m "Initial commit with unit testing support"
git remote add origin https://github.com/yourname/my-spec-kit.git
git branch -M main
git push -u origin main
```

### 第二步：创建 Release

有两种方式创建 release：

#### 方式 A：使用 spec-kit 的打包脚本

```bash
# 如果你 fork 了 spec-kit，使用现有的打包脚本
cd ~/spec-kit  # 你的仓库目录

# 运行打包脚本
/bin/bash .github/workflows/scripts/create-release-packages.sh v1.0.1

# 查看生成的包
ls .genreleases/

# 上传到 GitHub
# 访问: https://github.com/yourname/spec-kit/releases/new
# - Tag: v1.0.1
# - Title: Spec Kit Templates - 1.0.1
# - 上传 .genreleases/ 中的所有 .zip 文件
```

#### 方式 B：手动打包（如果是新仓库）

```bash
cd ~/my-spec-kit

# 创建打包目录
mkdir -p releases

# 打包（以 Claude + Bash 为例）
zip -r releases/spec-kit-template-claude-sh-v1.0.0.zip .claude .specify

# 在 GitHub 创建 release
# 访问: https://github.com/yourname/my-spec-kit/releases/new
# - Tag: v1.0.0
# - Title: Spec Kit Templates - 1.0.0
# - 上传 releases/spec-kit-template-claude-sh-v1.0.0.zip
# - 发布 release
```

### 第三步：使用你的仓库初始化项目

```bash
# 使用 --repo 参数
specify init my-new-project --ai claude --repo yourname/my-spec-kit

# 或设置环境变量（在 ~/.zshrc 或 ~/.bashrc 中）
echo 'export SPECIFY_REPO="yourname/my-spec-kit"' >> ~/.zshrc
source ~/.zshrc

# 以后就可以直接使用
specify init another-project --ai claude
```

## 📋 完整示例

### 示例：创建包含自定义配置的 spec-kit

```bash
# 1. 创建新仓库
mkdir ~/my-custom-spec-kit
cd ~/my-custom-spec-kit

# 2. 复制测试包内容
cp -r ~/Desktop/spec-kit-with-unit-testing/.claude .
cp -r ~/Desktop/spec-kit-with-unit-testing/.specify .

# 3. 自定义（可选）
# 编辑 .specify/templates/ 中的模板
# 修改 .claude/commands/ 中的命令
# 添加自己的脚本

# 4. 提交到 GitHub
git init
git add .
git commit -m "Initial commit with customizations"
git remote add origin https://github.com/yourname/my-custom-spec-kit.git
git branch -M main
git push -u origin main

# 5. 创建 release（手动打包）
mkdir releases
zip -r releases/spec-kit-template-claude-sh-v1.0.0.zip .claude .specify

# 6. 在 GitHub 创建 release
# - 上传 zip 文件
# - Tag: v1.0.0
# - 发布

# 7. 使用
specify init test-project --ai claude --repo yourname/my-custom-spec-kit
```

## 🎯 高级用法

### 为不同团队维护不同的模板

```bash
# 前端团队
export SPECIFY_REPO="yourcompany/spec-kit-frontend"
specify init frontend-project --ai claude

# 后端团队
export SPECIFY_REPO="yourcompany/spec-kit-backend"
specify init backend-project --ai claude

# 移动团队
export SPECIFY_REPO="yourcompany/spec-kit-mobile"
specify init mobile-project --ai claude
```

### 使用私有仓库

```bash
# 设置 GitHub token
export GITHUB_TOKEN="your_github_token"

# 或使用 --github-token 参数
specify init my-project --ai claude \
  --repo yourcompany/private-spec-kit \
  --github-token your_github_token
```

### 本地测试（不发布到 GitHub）

如果只是想测试，可以直接复制：

```bash
# 直接使用测试包
cp -r ~/Desktop/spec-kit-with-unit-testing ~/my-new-project
cd ~/my-new-project
git init
git add .
git commit -m "Initial commit"

# 开始使用
claude /specify-unit test something
```

## 🔧 故障排除

### 问题：找不到 release

```
Error: No matching release asset found
```

**解决方案**：
1. 确认 release 已发布（不是 draft）
2. 确认 zip 文件命名正确：`spec-kit-template-{agent}-{script}-{version}.zip`
3. 示例：`spec-kit-template-claude-sh-v1.0.0.zip`

### 问题：私有仓库访问被拒

```
Error: GitHub API returned 404
```

**解决方案**：
```bash
# 设置 GitHub token
export GITHUB_TOKEN="your_token_with_repo_access"

# 或使用参数
specify init project --repo yourname/private-repo --github-token your_token
```

### 问题：命名不匹配

确保 release 中的 zip 文件遵循命名规范：

```
spec-kit-template-{ai_agent}-{script_type}-{version}.zip

示例：
- spec-kit-template-claude-sh-v1.0.0.zip
- spec-kit-template-cursor-ps-v1.0.0.zip
- spec-kit-template-copilot-sh-v2.0.0.zip
```

## 📊 对比

| 方式 | 优点 | 缺点 | 适用场景 |
|------|------|------|----------|
| **官方仓库** | 简单，自动更新 | 无法自定义 | 个人使用 |
| **Fork 官方** | 可自定义，易更新 | 需要维护 | 团队使用 |
| **独立仓库** | 完全自定义 | 不能合并上游更新 | 企业定制 |
| **本地复制** | 最快速 | 无版本管理 | 临时测试 |

## 💡 最佳实践

1. **团队使用**：Fork 官方仓库，添加团队定制
2. **企业使用**：创建私有仓库，统一模板
3. **个人使用**：直接使用官方仓库或本地测试包
4. **测试新功能**：使用本地测试包验证后再发布

## 🎉 总结

现在你可以：

✅ 从自己的 GitHub 仓库初始化项目
✅ 维护团队专属的 spec-kit 模板
✅ 使用私有仓库保护企业配置
✅ 本地测试包快速验证

选择最适合你的方式开始使用！

