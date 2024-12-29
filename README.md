# mac 开发环境自动配置脚本

一键安装配置 mac 开发环境的脚本，快速搭建统一、高效的开发环境。

## ✨ 功能特性

- 🚀 自动安装必要的开发工具
- 🛠 配置 Zsh 和常用插件
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

## 🚀 快速开始

### 安装prerequisites

确保你的 macOS 系统已更新到最新版本。

### 下载安装

1. 克隆仓库：
```bash
git clone xxx
```

2. 进入目录：
```bash
cd setup-script
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
curl -o install.sh https://raw.githubusercontent.com/xxx/main/install.sh
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
