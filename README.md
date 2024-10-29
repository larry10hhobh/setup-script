# macOS 前端开发环境自动配置脚本

一键安装配置 macOS 前端开发环境的脚本，快速搭建统一、高效的开发环境。

## ✨ 功能特性

- 🚀 自动安装必要的开发工具
- 🛠 配置 Zsh 和常用插件
- 📦 安装和配置 Node.js 环境
- 🔧 自动配置 Git 环境
- 💻 安装必要的开发软件
- ⚡️ 优化终端体验
- 🎨 美化命令行界面
- 🔍 智能提示和自动补全

## 📋 安装内容

### 基础工具
- [x] Xcode Command Line Tools
- [x] Homebrew
- [x] Git
- [x] Zsh & Oh My Zsh
- [x] Node.js (通过 nvm)

### Zsh 插件
- [x] fast-syntax-highlighting
- [x] zsh-autosuggestions
- [x] zsh-completions

### 开发工具
- [x] Visual Studio Code
- [x] Google Chrome
- [x] Docker
- [x] Tree
- [x] Wget
- [x] TLDR
- [x] JQ

### Node.js 工具
- [x] pnpm
- [x] yarn
- [x] typescript
- [x] @vue/cli
- [x] serve
- [x] http-server

## 🚀 快速开始

### 安装prerequisites

确保你的 macOS 系统已更新到最新版本。

### 下载安装

1. 克隆仓库：
```bash
git clone https://github.com/你的用户名/macos-dev-setup.git
```

2. 进入目录：
```bash
cd macos-dev-setup
```

3. 添加执行权限：
```bash
chmod +x install.sh
```

4. 运行脚本：
```bash
./install.sh
```

### 手动下载安装

如果你不想克隆整个仓库，可以直接下载脚本：

```bash
curl -o install.sh https://raw.githubusercontent.com/你的用户名/macos-dev-setup/main/install.sh
chmod +x install.sh
./install.sh
```

## ⚙️ 配置说明

### Zsh 配置

脚本会自动配置以下内容：

- Oh My Zsh 主题设置为 `robbyrussell`
- 历史记录优化
- 智能补全
- Git 集成
- 实用别名

### Git 配置

脚本会要求输入以下信息：
- Git 用户名
- Git 邮箱

这些信息将被用于配置全局 Git 设置。

### Node.js 配置

- 通过 nvm 安装最新的 LTS 版本
- 配置 npm 全局包
- 设置 npm 镜像（可选）

## 🔧 自定义配置

### 修改 Zsh 主题

1. 编辑 `~/.zshrc` 文件
2. 修改 `ZSH_THEME` 的值
3. 常用主题推荐：
   - robbyrussell（默认）
   - agnoster
   - powerlevel10k

### 添加自定义插件

1. 编辑 `~/.zshrc` 文件
2. 在 plugins 数组中添加插件名称
3. 重新加载配置：`source ~/.zshrc`

### 自定义别名

在 `~/.zshrc` 文件末尾添加：

```bash
# 自定义别名
alias my-alias="your-command"
```

## 📝 常见问题

### 安装失败？

1. 确保有足够的磁盘空间
2. 检查网络连接
3. 确保有管理员权限
4. 查看详细错误日志

### 权限问题？

运行以下命令：

```bash
sudo chown -R $(whoami) /usr/local/lib/node_modules
sudo chown -R $(whoami) ~/.oh-my-zsh
```

### Homebrew 安装很慢？

可以考虑使用镜像源：

```bash
export HOMEBREW_BREW_GIT_REMOTE="..."  # 设置 brew git 源
export HOMEBREW_CORE_GIT_REMOTE="..."  # 设置 brew-core git 源
```

### Oh My Zsh 安装失败？

1. 确保 Git 已正确安装
2. 检查网络连接
3. 尝试手动安装：
```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## 🤝 贡献指南

1. Fork 本仓库
2. 创建特性分支：`git checkout -b my-new-feature`
3. 提交改动：`git commit -am 'Add some feature'`
4. 推送分支：`git push origin my-new-feature`
5. 提交 Pull Request

## 📄 协议

本项目基于 MIT 协议开源，详情请参阅 [LICENSE](LICENSE) 文件。

## 🎉 致谢

- [Homebrew](https://brew.sh/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Node Version Manager](https://github.com/nvm-sh/nvm)
- 所有贡献者和用户

## 💡 问题反馈

如果你发现任何问题或有改进建议，请：

1. 查看 [Issues](https://github.com/zhen-ke/macos-dev-setup/issues) 是否已有相关问题
2. 创建新的 Issue 描述你的问题或建议
3. 提供详细的环境信息和复现步骤
