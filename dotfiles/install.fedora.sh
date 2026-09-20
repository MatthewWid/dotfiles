#!/bin/bash

# ---------------------------------------------------------------------------
# Dotfile and fresh machine setup by Matt W. (Fedora port)
# ---------------------------------------------------------------------------

sudo -v

echo "=== Dotfile and fresh machine setup by Matt W. (Fedora port) ==="
echo -e "\
	Warning!\n \
	This script will update packages and overwrite your dotfiles, configuration files, and more.\n \
	Make a backup before running!"

read -p "Are you sure you want to continue? (y/n) " REPLY
if ! [[ $REPLY =~ ^[Yy] ]]; then
	exit 0
fi

# --- Helpers ---------------------------------------------------------------

ask_yn() {
	local prompt="$1" reply
	read -p "$prompt (y/n) " reply
	[[ $reply =~ ^[Yy] ]]
}

# Runs a section function; refreshes sudo first, logs+continues on failure
# instead of aborting the script.
run_section() {
	local desc="$1"; shift
	local func="$1"; shift
	sudo -v
	echo
	echo "== $desc =="
	if "$func" "$@"; then
		:
	else
		echo "!! '$desc' hit an error - continuing with the rest of the script. !!" >&2
	fi
}

# Install a whole package list as one dnf transaction. --skip-unavailable
# skips any package name dnf can't find instead of failing the transaction;
# --skip-broken does the same for dependency conflicts. dnf downloads the
# packages over several connections at once on its own, so this is as
# parallel (and as safe) as dnf installs get. Requires dnf5 (Fedora 41+,
# which is what's current) - config-manager syntax elsewhere in this script
# already assumes dnf5 too.
dnf_install_all() {
	echo "  -> dnf install ${*}"
	sudo dnf -y install --skip-unavailable --skip-broken "$@" \
		|| echo "  !! One or more packages in that batch failed - see above for which, continuing..." >&2
}

# Run one shell command per item in the background, wait for them all, and
# report (without aborting) any that failed. Safe for npm/pipx, whose caches
# handle concurrent access; NOT used for dnf (rpmdb lock) or dotnet tool
# (shared manifest file) - see the header comment.
run_parallel() {
	local -a pids=() cmds=("$@")
	local i
	for i in "${!cmds[@]}"; do
		( eval "${cmds[$i]}" ) &
		pids[i]=$!
	done
	for i in "${!cmds[@]}"; do
		wait "${pids[$i]}" || echo "  !! failed: ${cmds[$i]}" >&2
	done
}

npm_install_each() {
	local pkg cmds=()
	for pkg in "$@"; do
		cmds+=("echo '  -> npm install -g $pkg'; npm install -g '$pkg'")
	done
	run_parallel "${cmds[@]}"
}

pipx_install_each() {
	local pkg cmds=()
	for pkg in "$@"; do
		cmds+=("echo '  -> pipx install $pkg'; pipx install '$pkg'")
	done
	run_parallel "${cmds[@]}"
}

# Deliberately sequential - see header comment.
dotnet_tool_install_each() {
	local tool
	for tool in "$@"; do
		echo "  -> dotnet tool install --global $tool"
		dotnet tool install --global "$tool" || echo "  !! dotnet tool: '$tool' failed to install, skipping..." >&2
	done
}

is_wsl() {
	grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null || [[ -n "${WSL_DISTRO_NAME:-}" ]]
}

# --- Up-front optional choices ----------------------------------------------

DO_BASE_PACKAGES=false; DO_ZSH=false; DO_NODE=false; DO_PYTHON=false
DO_DOTNET_TOOLS=false; DO_GOLANG=false; DO_NVIM_PLUGINS=false; DO_RUST=false
DO_TMUX_PLUGINS=false; DO_FZF=false; DO_EXTRA_CLI=false
DO_FONTS=false; DO_CHATGPT=false; DO_SSH=false; DO_DOCKER=false

echo
echo "Every group of installs below can be skipped - answer now, the rest of the"
echo "script runs unattended after this."
echo
if ask_yn "Install everything below with its defaults? (fastest - answer 'n' to pick individually)"; then
	DO_BASE_PACKAGES=true; DO_ZSH=true; DO_NODE=true; DO_PYTHON=true
	DO_DOTNET_TOOLS=true; DO_GOLANG=true; DO_NVIM_PLUGINS=true; DO_RUST=true
	DO_TMUX_PLUGINS=true; DO_FZF=true; DO_EXTRA_CLI=true
else
	ask_yn "Install the main package list (dev tools, CLI utilities, etc. via dnf)?" && DO_BASE_PACKAGES=true
	ask_yn "Install Oh My Zsh (theme + plugins)?" && DO_ZSH=true
	ask_yn "Install Node.js, npm and the global npm packages?" && DO_NODE=true
	ask_yn "Install Python global tools via pipx (autopep8, pyinstaller, poetry)?" && DO_PYTHON=true
	ask_yn "Install .NET global tools (csharp-ls, csharprepl, csharpier)?" && DO_DOTNET_TOOLS=true
	ask_yn "Install Golang?" && DO_GOLANG=true
	ask_yn "Sync NeoVim plugins (lazy.nvim)?" && DO_NVIM_PLUGINS=true
	ask_yn "Install Rust (via rustup)?" && DO_RUST=true
	ask_yn "Install the tmux plugin manager (tpm)?" && DO_TMUX_PLUGINS=true
	ask_yn "Install fzf?" && DO_FZF=true
	ask_yn "Install extra CLI tools (htmlq, yq)?" && DO_EXTRA_CLI=true
fi

echo
echo "A few separate, more invasive bits - always asked individually:"
ask_yn "Install Microsoft core fonts?" && DO_FONTS=true
ask_yn "Install the ChatGPT CLI?" && DO_CHATGPT=true
ask_yn "Generate a new SSH key (~/.ssh/id_ed25519)?" && DO_SSH=true
ask_yn "Install Docker (native Engine on Linux or inside WSL)?" && DO_DOCKER=true

# --- Section: repos ----------------------------------------------------------
# Fedora has no PPAs. dnf-plugins-core gives us `dnf config-manager`, RPM
# Fusion covers what "multiverse" covered on Ubuntu (codecs, extra fonts,
# etc.), and COPR replaces the neovim/wslu PPAs. dotnet SDKs ship directly in
# Fedora's own repos, so there's no "backports" repo needed for that one.

section_enable_repos() {
	sudo dnf -y install dnf-plugins-core || return 1
	sudo dnf -y install \
		"https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
		"https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm" \
		|| echo "  !! Could not add RPM Fusion, continuing without it..." >&2
	# Only relevant if this is actually Fedora Remix for WSL - harmless otherwise.
	sudo dnf -y copr enable wslutilities/wslu || echo "  !! Could not enable wslu COPR, continuing..." >&2
	# Optional: uncomment for a bleeding-edge Neovim build instead of Fedora's stable package.
	# sudo dnf -y copr enable agriffis/neovim-nightly
}

# --- Section: update packages -----------------------------------------------

section_update_packages() {
	sudo dnf -y upgrade --refresh || echo "  !! dnf upgrade reported an error, continuing..." >&2
	sudo dnf -y autoremove || true
	sudo dnf clean all || true
}

# --- Section: install packages ----------------------------------------------
# Notes on renamed/replaced packages vs. the Ubuntu list:
#   neofetch          -> fastfetch (neofetch is dead upstream and dropped from Fedora)
#   silversearcher-ag -> the_silver_searcher
#   sqlite3           -> sqlite (still provides the `sqlite3` binary)
#   vim               -> vim-enhanced (plain "vim" is a minimal build on Fedora)
#   g++-14            -> gcc-c++ (Fedora tracks a current gcc already; no versioned package needed)
#   apache2-utils     -> httpd-tools
#   dnsutils          -> bind-utils
#   redis-tools       -> redis (bundles redis-cli)
#   tshark            -> wireshark-cli
#   python3-venv      -> dropped; the venv module ships inside Fedora's python3 package
#   keynav            -> not in Fedora/RPM Fusion at all, only via a third-party COPR - see below

DNF_PACKAGES=(
	coreutils curl wget tree tmux tcpdump tar zip vim-enhanced nmap fastfetch
	source-highlight less jq ca-certificates dos2unix net-tools figlet cowsay
	xclip git bash-completion xdg-utils the_silver_searcher python3 python3-pip
	pipx wslu ranger ffmpeg sqlite neovim bat xsel make cmake ninja-build
	gcc-c++ gdb shadow-utils xfsprogs cloc httpd-tools zsh qrencode httrack
	wireshark-cli trash-cli dotnet-sdk-9.0 htop bind-utils redis ripgrep
)

section_install_packages() {
	dnf_install_all "${DNF_PACKAGES[@]}"
	echo "  (keynav isn't packaged for Fedora/RPM Fusion - only via the third-party"
	echo "  dhalucario/keynav COPR. Uncomment the two lines below in the script if you want it.)"
	# sudo dnf -y copr enable dhalucario/keynav
	# dnf_install_all keynav
}

# --- Section (optional): Microsoft fonts ------------------------------------
# Fedora/RPM Fusion don't ship these; they come from the community
# mscorefonts2 project on SourceForge.

section_install_msfonts() {
	dnf_install_all cabextract xorg-x11-font-utils
	sudo rpm -i --replacepkgs https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm \
		|| echo "  !! Microsoft fonts install failed, continuing..." >&2
	sudo fc-cache -f || true
}

# --- Section: Oh My Zsh + theme + plugins -----------------------------------

section_ohmyzsh() {
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
		|| echo "  !! Oh My Zsh install failed, continuing..." >&2
}

section_zsh_theme() {
	zsh -i -c "wget -O \$ZSH_CUSTOM/themes/common.zsh-theme https://raw.githubusercontent.com/jackharrisonsherlock/common/master/common.zsh-theme" \
		|| echo "  !! zsh theme download failed, continuing..." >&2
}

section_zsh_plugins() {
	zsh -i -c "git clone https://github.com/jeffreytse/zsh-vi-mode \$ZSH_CUSTOM/plugins/zsh-vi-mode" \
		|| echo "  !! zsh-vi-mode clone failed, continuing..." >&2
}

# --- Section: Node, package managers and global packages --------------------

NPM_PACKAGES=(
	npm@latest pnpm yarn tsx open-cli markserv lorem-ipsum @angular/cli
	graphql-language-service-cli typescript-language-server http-server
	@agentclientprotocol/claude-agent-acp
)

section_node() {
	curl -fsSL https://fnm.vercel.app/install | bash \
		|| { echo "  !! fnm install failed, aborting Node section..." >&2; return 1; }
	export PATH="$HOME/.local/share/fnm:$PATH"
	eval "$(fnm env --use-on-cd --shell bash)"
	fnm install --lts || echo "  !! fnm install --lts failed, continuing..." >&2
	npm_install_each "${NPM_PACKAGES[@]}"
}

# --- Section: Python global packages -----------------------------------------

PIPX_PACKAGES=(autopep8 pyinstaller poetry)

section_python() {
	pipx_install_each "${PIPX_PACKAGES[@]}"
}

# --- Section: .NET global tools ----------------------------------------------

DOTNET_TOOLS=(csharp-ls csharprepl csharpier)

section_dotnet() {
	dotnet_tool_install_each "${DOTNET_TOOLS[@]}"
}

# --- Section: Golang ----------------------------------------------------------

section_golang() {
	wget https://go.dev/dl/go1.24.2.linux-amd64.tar.gz \
		|| { echo "  !! Go download failed, aborting Go section..." >&2; return 1; }
	sudo tar -C /usr/local -xzf go1.24.2.linux-amd64.tar.gz || echo "  !! Go extract failed, continuing..." >&2
	rm -f go1.24.2.linux-amd64.tar.gz
}

# --- Section: NeoVim plugins ---------------------------------------------------
# (lazy.nvim self-bootstraps from init.lua on first launch)

section_neovim_plugins() {
	DISPLAY= python3 -m pip install --user --upgrade pynvim || echo "  !! pynvim install failed, continuing..." >&2
	nvim --headless "+Lazy! sync" +qa || echo "  !! Neovim plugin sync failed, continuing..." >&2
}

# --- Section: Rust --------------------------------------------------------------

section_rust() {
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
		|| { echo "  !! rustup install failed, aborting Rust section..." >&2; return 1; }
	source "$HOME/.cargo/env"
}

# --- Section: tmux plugin manager -------------------------------------------

section_tmux_plugins() {
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
		|| { echo "  !! tpm clone failed, aborting tmux plugin section..." >&2; return 1; }
	tmux source ~/.tmux.conf || echo "  !! tmux source failed (no session/config?), continuing..." >&2
	~/.tmux/plugins/tpm/bin/install_plugins || echo "  !! tmux plugin install failed, continuing..." >&2
}

# --- Section: fzf ------------------------------------------------------------

section_fzf() {
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
		|| { echo "  !! fzf clone failed, aborting fzf section..." >&2; return 1; }
	~/.fzf/install --all || echo "  !! fzf install script failed, continuing..." >&2
}

# --- Section (optional): ChatGPT CLI ----------------------------------------

section_chatgpt_cli() {
	curl -L -o chatgpt https://github.com/kardolus/chatgpt-cli/releases/latest/download/chatgpt-linux-amd64 \
		&& chmod +x chatgpt \
		&& sudo mv chatgpt /usr/local/bin/ \
		|| echo "  !! ChatGPT CLI install failed, continuing..." >&2
}

# --- Section: htmlq / yq ------------------------------------------------------

section_htmlq() {
	cargo install htmlq || echo "  !! htmlq (cargo) install failed, continuing..." >&2
}

section_yq() {
	wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq \
		&& sudo chmod +x /usr/bin/yq \
		|| echo "  !! yq install failed, continuing..." >&2
}

# --- Section: locale ----------------------------------------------------------
# Fedora doesn't have locale-gen/dpkg-reconfigure; install the langpack and
# set the locale with localectl instead.

section_locale() {
	dnf_install_all glibc-langpack-en
	sudo localectl set-locale LANG=en_US.UTF-8 || echo "  !! localectl set-locale failed, continuing..." >&2
}

# --- Section (optional): Docker ----------------------------------------------
# Works whether this is native Fedora or Fedora running under WSL:
#   - If `docker` already works (e.g. Docker Desktop's WSL integration is
#     already wired up), it's left alone.
#   - Otherwise Docker Engine (docker-ce) is installed from Docker's official
#     Fedora repo.
#   - If systemd is running (native Fedora, or WSL with systemd turned on),
#     the docker service is enabled via systemctl.
#   - If there's no systemd (typical under WSL unless enabled), dockerd is
#     started directly instead, with a tip on how to get systemd going.

section_docker() {
	if command -v docker &> /dev/null; then
		echo "  docker is already available ($(docker --version 2>/dev/null)) - skipping install."
	else
		if is_wsl; then
			echo "  WSL detected. If you already use Docker Desktop, enabling this distro under"
			echo "  Docker Desktop > Settings > Resources > WSL Integration is the simplest option."
			echo "  Continuing to install a native Docker Engine here instead..."
		fi

		echo "  Removing any conflicting Docker/Podman packages..."
		sudo dnf -y remove docker docker-client docker-client-latest docker-common \
			docker-latest docker-latest-logrotate docker-logrotate docker-selinux \
			docker-engine-selinux docker-engine podman-docker 2>/dev/null || true

		dnf_install_all dnf-plugins-core

		echo "  Adding Docker's official repository..."
		( sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo 2>/dev/null \
			|| sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo ) \
			|| { echo "  !! Could not add the Docker repo, aborting Docker section..." >&2; return 1; }

		dnf_install_all docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

		sudo groupadd docker 2>/dev/null
		sudo usermod -aG docker "$USER" || true

		if [ -d /run/systemd/system ]; then
			sudo systemctl enable --now docker || echo "  !! Could not start the docker service, continuing..." >&2
		else
			echo "  No systemd detected (common under WSL unless you've turned it on) - starting dockerd directly."
			sudo sh -c "nohup dockerd > /var/log/dockerd.log 2>&1 &" \
				|| echo "  !! Could not start dockerd directly, continuing..." >&2
			echo "  Tip: add '[boot]' and 'systemd=true' to /etc/wsl.conf, then run 'wsl --shutdown'"
			echo "  from Windows PowerShell, so Docker can start automatically via systemd next time."
		fi

		echo "  Log out and back in (or run 'newgrp docker') for group membership to take effect."
	fi

	if command -v docker &> /dev/null; then
		mkdir -p ~/.oh-my-zsh/completions
		docker completion zsh > ~/.oh-my-zsh/completions/_docker \
			|| echo "  !! docker zsh completions failed, continuing..." >&2
	fi
}

# --- Section (optional): SSH keys ---------------------------------------------

section_ssh_keys() {
	if [ -f ~/.ssh/id_ed25519 ]; then
		echo "  ~/.ssh/id_ed25519 already exists - leaving it alone."
		return 0
	fi
	mkdir -p ~/.ssh
	ssh-keygen -q -N "" -t ed25519 -a 100 -f ~/.ssh/id_ed25519 <<< "n" > /dev/null \
		|| echo "  !! SSH key generation failed, continuing..." >&2
}

# --- Section: dotfiles ---------------------------------------------------------

section_dotfiles() {
	curl -sL https://raw.githubusercontent.com/MatthewWid/dotfiles/refs/heads/master/dotfiles/sync | bash -s -- fetch \
		|| echo "  !! dotfiles fetch failed, continuing..." >&2
	touch ~/.hushlogin
}

section_chsh() {
	chsh -s "$(which zsh)" || echo "  !! chsh failed (already zsh? needs a password prompt?), continuing..." >&2
}

# --- Run everything -------------------------------------------------------------

run_section "Enabling extra repositories" section_enable_repos
run_section "Updating packages" section_update_packages
$DO_BASE_PACKAGES && run_section "Installing packages" section_install_packages
$DO_FONTS && run_section "Installing Microsoft fonts" section_install_msfonts
$DO_ZSH && run_section "Installing Oh My Zsh" section_ohmyzsh
$DO_ZSH && run_section "Installing zsh theme" section_zsh_theme
$DO_ZSH && run_section "Installing Oh My Zsh plugins" section_zsh_plugins
$DO_NODE && run_section "Installing Node and npm globals" section_node
$DO_PYTHON && run_section "Installing Python global packages" section_python
$DO_DOTNET_TOOLS && run_section "Installing .NET global tools" section_dotnet
$DO_GOLANG && run_section "Installing Golang" section_golang
$DO_NVIM_PLUGINS && run_section "Installing NeoVim plugins" section_neovim_plugins
$DO_RUST && run_section "Installing Rust" section_rust
$DO_TMUX_PLUGINS && run_section "Installing tmux plugin manager" section_tmux_plugins
$DO_FZF && run_section "Installing fzf" section_fzf
$DO_CHATGPT && run_section "Installing ChatGPT CLI" section_chatgpt_cli
$DO_EXTRA_CLI && run_section "Installing htmlq" section_htmlq
$DO_EXTRA_CLI && run_section "Installing yq" section_yq
run_section "Configuring locale" section_locale
$DO_DOCKER && run_section "Setting up Docker" section_docker
$DO_SSH && run_section "Generating SSH keys" section_ssh_keys
run_section "Fetching dotfiles and scripts" section_dotfiles
run_section "Setting zsh as default shell" section_chsh

echo
echo "== Done! =="
