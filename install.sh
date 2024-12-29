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

# 系统检测
check_system() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        error "本脚本仅支持 macOS 系统"
        exit 1
    fi
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

# 安装 Homebrew
install_homebrew() {
    if brew --version &>/dev/null; then
        info "Homebrew 已安装"
    else
        info "安装 Homebrew..."
        # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        /bin/bash -c "$(curl -fsSL https://gitee.com/ineo6/homebrew-install/raw/master/install.sh)"
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

# 安装 Oh My Zsh 和插件
install_oh_my_zsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        info "Oh My Zsh 已安装"
    else
        info "安装 Oh My Zsh..."
        # sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        sh -c "$(curl -fsSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh)"
        check_success "Oh My Zsh 安装"
    fi

    info "安装 Zsh 插件..."
    ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ${ZSH_CUSTOM}/plugins/fast-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM}/plugins/zsh-completions
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k

    # 设置主题为 powerlevel10k
    sed -i '' 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
    check_success "Zsh 插件安装"
}

# 配置 Zsh
configure_zsh() {
    info "配置 Zsh..."
    cp ~/.zshrc ~/.zshrc.backup 2>/dev/null || true

    cat > ~/.zshrc << 'EOL'
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
DISABLE_AUTO_UPDATE="true"
plugins=(git node npm vscode brew macos fast-syntax-highlighting zsh-autosuggestions zsh-completions docker)
source $ZSH/oh-my-zsh.sh
autoload -Uz compinit && compinit -i
zstyle ':completion:*' menu select
EOL

    check_success "Zsh 配置"
}

# 安装 Git
install_git() {
    info "安装并配置 Git..."
    brew install git
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
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    info "安装 Node.js LTS 版本..."
    nvm install --lts
    nvm alias default 'lts/*'
    check_success "Node.js 安装"
}

# 安装开发工具
install_dev_tools() {
    info "安装开发工具..."
    # brew install --cask visual-studio-code google-chrome docker
    brew install --cask docker
    brew install tree wget tldr jq
    check_success "开发工具安装"
}

# 安装 Go 和 Python（可选）
install_go_python() {
    read -p "是否要安装 Golang 和 Python? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        brew install go python
        check_success "Golang 和 Python 安装"
        echo 'export GOPATH=$HOME/go' >> ~/.zshrc
        echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.zshrc
    fi
}

# 验证安装
validate_install() {
    info "验证安装..."
    for cmd in brew git node; do
        if is_installed $cmd; then
            info "$cmd 验证通过"
        else
            warn "$cmd 验证失败"
        fi
    done
}

# 主函数
main() {
    echo "欢迎使用 macOS 开发环境一键安装脚本"
    echo "-----------------------------------"
    
    # 系统检测
    check_system

    # 获取用户信息
    get_user_info
    
    # 开始安装
    install_homebrew
    install_zsh
    install_oh_my_zsh
    configure_zsh
    install_git
    # install_node
    
    # 安装开发工具和语言环境
    # install_dev_tools
    install_go_python
    
    # 验证安装
    validate_install
    
    info "安装完成！请执行以下命令以加载最新环境配置："
    echo "  source ~/.zshrc"
}

# 执行主函数
main
