# Specify CLI 版本更新 - v1.0.1

## 更新内容

### ✅ 版本号更新

- **之前版本**: 1.0
- **新版本**: 1.0.1
- **更新日期**: 2025-10-20

### ✅ 更新的文件

1. **`pyproject.toml`**
   ```toml
   version = "1.0.1"
   ```

2. **`CHANGELOG.md`**
   - 添加了完整的 1.0.1 版本变更日志
   - 包含修复、新增、变更和技术细节

3. **构建产物**
   - `dist/specify_cli_yshuyan-1.0.1-py3-none-any.whl` (17K)
   - `dist/specify_cli_yshuyan-1.0.1.tar.gz` (2.3M)

### ✅ 安装验证

```bash
# 构建成功
Successfully built specify_cli_yshuyan-1.0.1.tar.gz and specify_cli_yshuyan-1.0.1-py3-none-any.whl

# 安装成功
Successfully installed specify-cli-yshuyan-1.0.1

# 验证版本
Version: 1.0.1
Location: /Library/Frameworks/Python.framework/Versions/3.12/lib/python3.12/site-packages
```

## 主要变更

### 🐛 修复的问题

1. **模板文件缺失** ⭐
   - 修复了 `specify init` 不复制模板文件的问题
   - 现在所有 7 个模板文件都会正确包含在 release 包中
   - 解决了 `/specify-unit` 和其他命令找不到模板的错误

2. **打包脚本问题**
   - 创建了完整的打包脚本支持所有 AI agents
   - 支持 11 个 agents × 2 种脚本类型 = 22 个包
   - 修复了 bash 兼容性问题（macOS bash 3.x）

### 🆕 新增功能

1. **自动化打包系统**
   - `.github/workflows/scripts/create-release-packages.sh`
   - 自动生成所有 agent 的 release 包
   - 确保模板文件完整

2. **GitHub Actions 工作流**
   - `.github/workflows/release.yml`
   - 推送 tag 自动创建 release
   - 自动上传所有包

3. **快速修复工具**
   - `fix-templates.sh`
   - 一键修复现有项目的模板缺失问题

4. **完整文档**
   - `TEMPLATE-FIX.md` - 使用指南
   - `TEMPLATE-FIX-COMPLETION.md` - 技术报告

## 使用新版本

### 方式 1: 从本地安装

```bash
cd /Users/tu/PycharmProjects/spec-kit
python3 -m pip install --upgrade dist/specify_cli_yshuyan-1.0.1-py3-none-any.whl
```

### 方式 2: 从 PyPI 安装（如果已发布）

```bash
pip install --upgrade specify-cli-yshuyan
```

### 方式 3: 使用 uv

```bash
uv tool install --upgrade specify-cli-yshuyan
```

## 发布到 GitHub

```bash
# 1. 创建 release 包
/bin/bash .github/workflows/scripts/create-release-packages.sh v1.0.1

# 2. 验证包内容
ls -lh .genreleases/

# 3. 发布到 GitHub
./create-release.sh your-github-username

# 或使用自动化方式
git add .
git commit -m "chore: bump version to 1.0.1"
git tag v1.0.1
git push origin main
git push origin v1.0.1
```

## 发布到 PyPI（可选）

```bash
# 安装 twine
pip install twine

# 上传到 PyPI
python3 -m twine upload dist/specify_cli_yshuyan-1.0.1*

# 或上传到 TestPyPI（测试）
python3 -m twine upload --repository testpypi dist/specify_cli_yshuyan-1.0.1*
```

## 验证更新

### 检查版本

```bash
python3 -m pip show specify-cli-yshuyan
```

### 测试功能

```bash
# 测试 init 命令
specify init test-project --ai claude

# 验证模板文件
ls -la test-project/.specify/templates/

# 应该看到：
# agent-file-template.md
# plan-template.md
# spec-template.md
# tasks-template.md
# unit-tasks-template.md
# unit-test-plan-template.md
# unit-test-template.md ⭐
```

## 影响范围

### 对现有用户

如果用户已经使用旧版本初始化了项目，可以使用快速修复脚本：

```bash
./fix-templates.sh /path/to/their/project
```

### 对新用户

使用新版本初始化的项目将自动包含所有模板文件，不会遇到模板缺失问题。

## 回滚方案

如果需要回滚到之前版本：

```bash
pip install specify-cli-yshuyan==1.0
```

## 下一步

- [ ] 推送到 GitHub
- [ ] 创建 GitHub Release (v1.0.1)
- [ ] 发布到 PyPI（可选）
- [ ] 通知用户更新
- [ ] 更新文档网站（如果有）

---

**版本**: 1.0.1  
**发布日期**: 2025-10-20  
**状态**: ✅ 构建成功，安装验证通过  
**测试**: ✅ 本地测试通过

