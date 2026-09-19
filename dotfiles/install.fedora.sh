#!/bin/bash

# Utility function to catch errors and prevent the script from halting
try() {
    "$@" || echo " -> [Warning] Command failed: $*"
}

sudo -v
# Keep sudo alive in the background
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "=== Dotfile and fresh machine setup by Matt W. (Fedora port) ==="
echo -e "\tWarning!\n\tThis script will update packages and overwrite your dotfiles, configuration files, SSH keys and more.\n\tMake a backup before running!"

read -p "Are you sure you want to continue? (y/n) " -n 1 -r REPLY_MAIN; echo
if [[ ! $REPLY_MAIN =~ ^[Yy]$ ]]; then
    exit 0
fi

# Upfront Options
read -p "Install Docker (Supports native Linux & WSL2)? (y/n) " -n 1 -r REPLY_DOCKER; echo
read -p "Install Microsoft core fonts? (y/n) " -n 1 -r REPLY_FONTS; echo
read -p "Install ChatGPT CLI? (y/n) " -n 1 -r REPLY_CHATGPT; echo
read -p "Generate SSH Keys? (y/n) " -n 1 -r REPLY_SSH; echo

echo "== Enabling extra repositories =="
try sudo dnf -y install dnf-plugins-core
try sudo dnf -y install \
    "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
try sudo dnf -y copr enable wslutilities/wslu

echo "== Updating packages =="
try sudo dnf -y upgrade --refresh
try sudo dnf -y autoremove
try sudo dnf clean all

echo "== Installing new packages =="
# Arrays are used to loop through package managers so one broken package doesn't fail the entire transaction
DNF_PACKAGES=(
    coreutils curl wget tree tmux tcpdump tar zip vim-enhanced nmap fastfetch
    source-highlight less jq ca-certificates dos2unix net-tools figlet cowsay
    xclip git bash-completion xdg-utils the_silver_searcher python3 python3-pip
    pipx wslu ranger ffmpeg sqlite neovim bat xsel make cmake ninja-build gcc-c++
    gdb shadow-utils xfsprogs cloc httpd-tools zsh qrencode httrack wireshark-cli
    trash-cli dotnet-sdk-9.0 htop bind-utils redis ripgrep cabextract xorg-x11-font-utils
)

for pkg in "${DNF_PACKAGES[@]}"; do
    sudo dnf -y install "$pkg" || echo " -> [Warning] Failed to install $pkg via DNF. Continuing..."
done

# Install Oh My Zsh
try sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
try zsh -i -c "wget -O \$ZSH_CUSTOM/themes/common.zsh-theme https://raw.githubusercontent.com/jackharrisonsherlock/common/master/common.zsh-theme"
try zsh -i -c "git clone https://github.com/jeffreytse/zsh-vi-mode \$ZSH_CUSTOM/plugins/zsh-vi-mode"

echo "== Installing Node and other package managers =="
try curl -fsSL https://fnm.vercel.app/install | bash
export PATH="$HOME/.local/share/fnm:$PATH"

if command -v fnm &> /dev/null; then
    eval "$(fnm env --use-on-cd --shell bash)"
    try fnm install --lts
    NPM_PACKAGES=(
        npm@latest pnpm yarn tsx open-cli markserv lorem-ipsum @angular/cli
        graphql-language-service-cli typescript-language-server http-server
        @agentclientprotocol/claude-agent-acp
    )
    for pkg in "${NPM_PACKAGES[@]}"; do
        try npm install -g "$pkg"
    done
fi

echo "== Installing Python and global packages =="
PIPX_PACKAGES=(autopep8 pyinstaller poetry)
for pkg in "${PIPX_PACKAGES[@]}"; do
    try pipx install "$pkg"
done

echo "== Installing .NET and global packages =="
DOTNET_TOOLS=(csharp-ls csharprepl csharpier)
for tool in "${DOTNET_TOOLS[@]}"; do
    try dotnet tool install --global "$tool"
done

echo "== Installing Golang =="
if try wget https://go.dev/dl/go1.24.2.linux-amd64.tar.gz; then
    try sudo tar -C /usr/local -xzf go1.24.2.linux-amd64.tar.gz
    try rm go1.24.2.linux-amd64.tar.gz
fi

echo "== Installing NeoVim plugins =="
try python3 -v -m pip install --user --upgrade pynvim
try nvim --headless "+Lazy! sync" +qa

echo "== Installing Rust =="
try curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

echo "== Installing tmux plugin manager =="
try git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
try tmux source ~/.tmux.conf
try ~/.tmux/plugins/tpm/bin/install_plugins

echo "== Installing fzf =="
if try git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; then
    try ~/.fzf/install --all
fi

# Optional: ChatGPT CLI
if [[ $REPLY_CHATGPT =~ ^[Yy]$ ]]; then
    echo "== Installing ChatGPT CLI =="
    if try curl -L -o chatgpt https://github.com/kardolus/chatgpt-cli/releases/latest/download/chatgpt-linux-amd64; then
        try chmod +x chatgpt
        try sudo mv chatgpt /usr/local/bin/
    fi
fi

# Rust/Cargo packages
try cargo install htmlq

echo "== Installing yq =="
if try wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O yq_temp; then
    try sudo mv yq_temp /usr/bin/yq
    try sudo chmod +x /usr/bin/yq
fi

# Optional: Microsoft core fonts
if [[ $REPLY_FONTS =~ ^[Yy]$ ]]; then
    echo "== Installing Microsoft fonts =="
    try sudo rpm -i --replacepkgs https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
    try sudo fc-cache -f
fi

echo "== Configuring locale =="
try sudo dnf -y install glibc-langpack-en
try sudo localectl set-locale LANG=en_US.UTF-8

# Optional: Docker
if [[ $REPLY_DOCKER =~ ^[Yy]$ ]]; then
    echo "== Installing Docker =="
    try sudo dnf -y install dnf-plugins-core
    try sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

    DOCKER_PACKAGES=(docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin)
    for pkg in "${DOCKER_PACKAGES[@]}"; do
        try sudo dnf -y install "$pkg"
    done

    # Enable systemd service if available (Works on native Linux and modern WSL with systemd enabled)
    if command -v systemctl &> /dev/null && systemctl | grep -q '\-\.mount'; then
        try sudo systemctl enable --now docker
    else
        echo " -> [Info] Systemd not detected (likely older WSL). Start the Docker daemon manually or use Docker Desktop."
    fi

    try sudo usermod -aG docker "$USER"

    if command -v docker &> /dev/null; then
        mkdir -p ~/.oh-my-zsh/completions
        try docker completion zsh > ~/.oh-my-zsh/completions/_docker
    fi
fi

# Optional: SSH Keys
if [[ $REPLY_SSH =~ ^[Yy]$ ]]; then
    echo "== Generating SSH keys =="
    # Only generate if an SSH key does NOT already exist to prevent overwrites
    if ls ~/.ssh/id_* 1> /dev/null 2>&1; then
        echo " -> [Info] An SSH key already exists in ~/.ssh. Skipping generation to prevent accidental overwriting."
    else
        try ssh-keygen -q -N "" -t ed25519 -a 100 -f ~/.ssh/id_ed25519
    fi
fi

echo "== Fetching dotfiles and scripts =="
curl -sL https://raw.githubusercontent.com/MatthewWid/dotfiles/refs/heads/master/dotfiles/sync | bash -s -- fetch || echo " -> [Warning] Dotfile sync failed."
try touch ~/.hushlogin

try chsh -s "$(which zsh)"

echo "== Done! =="
