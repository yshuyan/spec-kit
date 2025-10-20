# 🚀 发布 Spec-Kit 到你的 GitHub 账号

## ✅ 代码已准备好

你的本地代码已经整理好并提交了。现在需要推送到 GitHub。

## 📝 第一步：在 GitHub 创建新仓库

### 1. 访问 GitHub 创建仓库页面

打开浏览器，访问：**https://github.com/new**

### 2. 填写仓库信息

```
Repository name: spec-kit
Description: Spec-Driven Development toolkit with Unit Testing support
```

**重要设置：**
- ☑️ Public（公开）或 Private（私有） - 根据你的需求
- ⚠️ **不要勾选**以下选项：
  - [ ] Add a README file
  - [ ] Add .gitignore
  - [ ] Choose a license

（因为你本地已经有这些文件了）

### 3. 点击 "Create repository"

## 💻 第二步：推送代码到新仓库

### 手动执行命令

在终端中运行以下命令（**替换 `yourname` 为你的 GitHub 用户名**）：

```bash
cd /Users/tu/PycharmProjects/spec-kit

# 1. 移除旧的 remote
git remote remove origin

# 2. 添加你的新仓库 remote（替换 yourname）
git remote add origin https://github.com/yourname/spec-kit.git

# 3. 推送代码
git push -u origin main
```

## 🎯 第三步：创建 Release（发布模板包）

### 方式 A：使用 GitHub 自动发布（推荐）

你的仓库已经有 GitHub Actions 工作流，会自动打包和发布。

#### 1. 创建 Git Tag

```bash
cd /Users/tu/PycharmProjects/spec-kit

# 创建标签
git tag v1.0.1

# 推送标签
git push origin v1.0.1
```

#### 2. 等待 GitHub Actions 完成

- 访问你的仓库页面
- 点击 "Actions" 标签
- 查看工作流运行状态
- 等待完成（约 5-10 分钟）

#### 3. 检查 Release

- 访问 `https://github.com/yourname/spec-kit/releases`
- 应该看到自动创建的 v1.0.1 release
- 包含所有 agent 的 zip 包

### 方式 B：手动创建 Release

如果你不想使用自动化，可以手动创建：

#### 1. 本地生成 Release 包

```bash
cd /Users/tu/PycharmProjects/spec-kit

# 运行打包脚本
/bin/bash .github/workflows/scripts/create-release-packages.sh v1.0.1

# 查看生成的包
ls -lh .genreleases/
```

#### 2. 在 GitHub 创建 Release

1. 访问：`https://github.com/yourname/spec-kit/releases/new`
2. 填写信息：
   - **Tag version**: `v1.0.1`
   - **Release title**: `Spec Kit Templates - 1.0.1`
   - **Description**: 
     ```
     ## 新功能
     
     - ✅ 完整的 Unit Testing 支持
     - ✅ 支持自定义 GitHub 仓库
     - ✅ CLI 增强（specify unit 命令）
     
     ## 包含的 AI Agents
     
     - Claude Code
     - GitHub Copilot
     - Cursor
     - Gemini CLI
     - Qwen Code
     - opencode
     - Windsurf
     - Codex
     - Kilo Code
     - Auggie
     - Roo Code
     ```

3. **上传文件**：拖拽 `.genreleases/` 目录下的所有 `.zip` 文件

4. 点击 **"Publish release"**

## 🎉 第四步：测试使用

### 测试从你的仓库初始化项目

```bash
# 使用你的仓库初始化新项目
specify init test-project --ai claude --repo yourname/spec-kit

# 或设置环境变量
export SPECIFY_REPO="yourname/spec-kit"
specify init test-project --ai claude
```

### 验证 Unit Testing 功能

```bash
cd test-project
git init
git add .
git commit -m "Initial commit"

# 测试 unit testing 命令
claude /specify-unit test user authentication
```

## 📋 完整命令清单

### 创建仓库后执行：

```bash
cd /Users/tu/PycharmProjects/spec-kit

# 1. 移除旧 remote
git remote remove origin

# 2. 添加新 remote（替换 yourname）
git remote add origin https://github.com/yourname/spec-kit.git

# 3. 推送代码
git push -u origin main

# 4. 创建并推送标签（触发自动发布）
git tag v1.0.1
git push origin v1.0.1

# 5. 等待 GitHub Actions 完成（可选）
# 访问 https://github.com/yourname/spec-kit/actions 查看进度
```

## 🔍 验证清单

发布完成后，检查：

- [ ] 代码已推送到 GitHub
- [ ] Release v1.0.1 已创建
- [ ] Release 包含所有 agent 的 zip 文件
- [ ] 可以使用 `specify init --repo yourname/spec-kit` 初始化项目
- [ ] 初始化的项目包含 unit testing 命令

## ⚠️ 常见问题

### Q: 推送代码时提示权限错误

**A**: 需要配置 GitHub 认证

```bash
# 使用 GitHub CLI（推荐）
gh auth login

# 或使用 Personal Access Token
# 1. 访问 https://github.com/settings/tokens
# 2. 生成新 token（repo 权限）
# 3. 使用 token 作为密码
```

### Q: GitHub Actions 执行失败

**A**: 检查工作流权限

1. 访问仓库 Settings → Actions → General
2. 找到 "Workflow permissions"
3. 选择 "Read and write permissions"
4. 保存并重新运行工作流

### Q: 如何更新已发布的版本？

**A**: 创建新的 tag 和 release

```bash
# 修改代码后
git add .
git commit -m "Update description"
git push

# 创建新版本
git tag v1.0.2
git push origin v1.0.2
```

## 🎯 下一步

发布成功后，你可以：

1. **分享给团队**: 团队成员使用 `specify init --repo yourname/spec-kit`
2. **自定义模板**: 修改 `.claude/commands/` 和 `.specify/templates/`
3. **维护版本**: 定期创建新的 release
4. **文档**: 更新 README.md 添加使用说明

## 📚 相关文档

- `从自己GitHub使用Spec-Kit.md` - 详细使用指南
- `UNIT-TESTING-完善总结.md` - Unit Testing 功能说明
- `如何添加unit-testing到现有项目.md` - 迁移指南

---

**需要帮助？** 如果遇到问题，请检查：
1. GitHub 用户名是否正确
2. 仓库权限设置
3. GitHub Actions 执行日志

