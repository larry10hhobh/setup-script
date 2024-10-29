#!/bin/bash

# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 打印带颜色的信息
info() {
    echo -e "${GREEN}[INFO] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[WARN] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

# 检查命令是否执行成功
check_success() {
    if [ $? -eq 0 ]; then
        info "$1 成功"
    else
        error "$1 失败"
        exit 1
    fi
}

# 检查是否已安装
is_installed() {
    command -v "$1" >/dev/null 2>&1
}

# 获取用户信息
get_user_info() {
    read -p "请输入你的 Git 用户名: " GIT_USERNAME
    read -p "请输入你的 Git 邮箱: " GIT_EMAIL
    
    # 确认信息
    echo -e "\n以下是你的信息:"
    echo "Git 用户名: $GIT_USERNAME"
    echo "Git 邮箱: $GIT_EMAIL"
    
    read -p "确认信息正确吗? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        get_user_info
    fi
}

# 安装 Xcode Command Line Tools
install_xcode_tools() {
    info "检查 Xcode Command Line Tools..."
    if xcode-select -p &>/dev/null; then
        info "Xcode Command Line Tools 已安装"
    else
        info "安装 Xcode Command Line Tools..."
        xcode-select --install
        check_success "Xcode Command Line Tools 安装"
    fi
}

# 安装 Homebrew
install_homebrew() {
    if is_installed brew; then
        info "Homebrew 已安装"
    else
        info "安装 Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        check_success "Homebrew 安装"

        # 配置 Homebrew 环境变量
        if [[ $(uname -m) == 'arm64' ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
}

# 安装和配置 Zsh
install_zsh() {
    if is_installed zsh; then
        info "Zsh 已安装"
    else
        info "安装 Zsh..."
        brew install zsh
        check_success "Zsh 安装"
    fi

    # 设置 Zsh 为默认 Shell
    if [[ $SHELL != *"zsh"* ]]; then
        info "设置 Zsh 为默认 Shell..."
        sudo sh -c 'echo $(which zsh) >> /etc/shells'
        chsh -s $(which zsh)
        check_success "Zsh 设置"
    fi
}

# 安装 Oh My Zsh
install_oh_my_zsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        info "Oh My Zsh 已安装"
    else
        info "安装 Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        check_success "Oh My Zsh 安装"
    fi
}

# 安装 Zsh 插件
install_zsh_plugins() {
    info "安装 Zsh 插件..."
    
    # 创建插件目录
    ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
    
    # 安装 fast-syntax-highlighting
    if [ ! -d "${ZSH_CUSTOM}/plugins/fast-syntax-highlighting" ]; then
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ${ZSH_CUSTOM}/plugins/fast-syntax-highlighting
    fi
    
    # 安装 zsh-autosuggestions
    if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
    fi
    
    # 安装 zsh-completions
    if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-completions" ]; then
        git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM}/plugins/zsh-completions
    fi
    
    check_success "Zsh 插件安装"
}

# 配置 Zsh
configure_zsh() {
    info "配置 Zsh..."
    
    # 备份现有配置
    if [ -f ~/.zshrc ]; then
        cp ~/.zshrc ~/.zshrc.backup
    fi
    
    # 创建新的配置文件
    cat > ~/.zshrc << 'EOL'
# Path configuration
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Performance options
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
COMPLETION_WAITING_DOTS="true"

# History configuration
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Plugin configuration
plugins=(
    git
    node
    npm
    vscode
    colored-man-pages
    brew
    macos
    fast-syntax-highlighting
    zsh-autosuggestions
    zsh-completions
    docker
    docker-compose
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Load completions
autoload -Uz compinit && compinit -i
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Useful aliases
alias zshconfig="code ~/.zshrc"
alias update='brew update && brew upgrade && brew cleanup'
alias ls='ls -G'
alias ll='ls -lah'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias gst='git status'
alias gco='git checkout'
alias gcm='git commit -m'
alias gaa='git add .'
alias gl='git log --graph --oneline'

# Environment variables
export EDITOR='code'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOL

    check_success "Zsh 配置"
}

# 安装 Git
install_git() {
    info "安装并配置 Git..."
    brew install git
    
    # 配置 Git
    git config --global user.name "$GIT_USERNAME"
    git config --global user.email "$GIT_EMAIL"
    git config --global init.defaultBranch main
    git config --global core.editor "code --wait"
    
    check_success "Git 安装和配置"
}

# 安装 nvm 和 Node.js
install_node() {
    info "安装 nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    
    # 加载 nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # 安装最新的 LTS 版本
    info "安装 Node.js LTS 版本..."
    nvm install --lts
    nvm use --lts
    nvm alias default 'lts/*'
    
    check_success "Node.js 安装"
}

# 安装开发工具
install_dev_tools() {
    info "安装开发工具..."
    
    # 安装 VS Code
    brew install --cask visual-studio-code
    
    # 安装 Chrome
    brew install --cask google-chrome
    
    # 安装 Docker
    brew install --cask docker
    
    # 安装其他工具
    brew install tree wget tldr jq
    
    # 安装全局 npm 包
    npm install -g pnpm yarn typescript @vue/cli serve http-server
    
    check_success "开发工具安装"
}

# 主函数
main() {
    echo "欢迎使用 macOS 开发环境一键安装脚本"
    echo "本脚本将安装并配置常用的开发工具"
    echo "-----------------------------------"
    
    # 获取用户信息
    get_user_info
    
    # 开始安装
    install_xcode_tools
    install_homebrew
    install_zsh
    install_oh_my_zsh
    install_zsh_plugins
    configure_zsh
    install_git
    install_node

    # 询问用户是否安装开发工具
    read -p "是否要安装开发工具? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_dev_tools
    else
        info "跳过开发工具安装"
    fi
    
    info "安装完成！请重启终端以应用更改。"
}

# 执行主函数
main
