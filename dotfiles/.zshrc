export PATH="$HOME/bin:/usr/local/bin:$PATH"

# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme to load
ZSH_THEME="common"

# Set zsh autocomplete cache directory to somewhere other than $HOME
export ZSH_COMPDUMP="$ZSH/cache/.zcompdump-$HOST"

# Hyphen-insensitive completion. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Auto-update behavior
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# How often to auto-update (in days).
zstyle ':omz:update' frequency 14

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Command history settings
HIST_STAMPS="mm/dd/yyyy"
HISTFILE="$HOME/.histfile"
HISTSIZE=1000
SAVEHIST=10000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt nosharehistory

# Extend shell functionality
setopt autocd extendedglob nomatch notify
unsetopt beep
autoload -U +X bashcompinit && bashcompinit

# Show hidden files in autocomplete
setopt globdots

# Vim key bindings for command editing
bindkey -v

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins+=(git)
plugins+=(fzf)
if type docker &> /dev/null; then plugins+=(docker); fi
#plugins+=(zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

# File viewers and editors
export VISUAL="nvim"
export EDITOR="nvim"
export BROWSER="sensible-browser"

if uname -a | grep -q -i microsoft; then
	export BROWSER="wslview"
	export DISPLAY=$(ip route list default | awk '{print $3}'):0
	export LIBGL_ALWAYS_INDIRECT=1
fi

# Explicit manpath instead of it being determined
export MANPATH="/usr/local/man:$MANPATH"

# Manually set language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
else
  export EDITOR="nvim"
fi

# Change the current working directory to the last visited one after ranger quits.
ranger_cd() {
	temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
	\ranger --choosedir="$temp_file" -- "${@:-$PWD}"

	if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
		cd -- "$chosen_dir"
	fi
	
	rm -f -- "$temp_file"
}

# fzf installation directory
export FZF_BASE="$HOME/.fzf"

# fzf uses ripgrep instead
export FZF_DEFAULT_COMMAND="rg --hidden --follow --files --glob \"!{.git,node_modules}\""
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

# fzf format search top-to-bottom to not move cursor position
export FZF_CTRL_R_OPTS="--reverse"

# fzf Ctrl+T file preview
export FZF_CTRL_T_OPTS="--reverse --preview 'bat --color=always --style=header,grid --line-range :300 {}'"

# fzf search by file name with Ctrl+P instead of Ctrl+T
bindkey -r '^T'
bindkey '^P' fzf-file-widget

# Set GPG TTY to the current shell process
export GPG_TTY="$(tty)"

# Docker host socket
export DOCKER_HOST="unix:///var/run/docker.sock"

# Local bin path
export PATH="$HOME/.local/bin:$PATH"

# Golang bin path
export PATH="$PATH:/usr/local/go/bin"

# CTRL + Backspace, CTRL + Delete
bindkey '^H' backward-kill-word
bindkey '5~' kill-word

# Disable cursor blinking
echo -ne "\e[2 q"

# Remove current directory in autocomplete suggestions
zstyle ':completion:*:(cd|mv|cp):*' ignore-parents parent pwd

# Hide current directory in autocomplete
zstyle ':completion:*:(cd|mv|cp):*' ignore-parents parent pwd

# Auto-load local AWS config
export AWS_SDK_LOAD_CONFIG=true

# Immedately insert the first option from the zsh autocomplete options
setopt menu_complete

# Do not prompt before using rm *
setopt rmstarsilent

# Autocompletion for pnpm
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

# Local environment variables
[[ -f ~/.localrc ]] && . ~/.localrc || true

# Fuzzy completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Auto-launch into tmux session
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
	exec tmux
fi

# add .NET Core tools to PATH
export PATH="$PATH:/home/matt/.dotnet/tools"

# Angular CLI autocompletion
if command -v ng &> /dev/null; then
	source <(ng completion script)
fi

# Terraform CLI autocompletion
complete -o nospace -C /usr/bin/terraform terraform

# Disable cowsay in Ansible
export ANSIBLE_NOCOWS=1

# Locale settings for Perl
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# tj/n is doing its best malware impression and refuses to remove its own env vars after uninstall
unset N_PREFIX

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
