# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Prevent history duplicates or lines starting with a ' '
HISTCONTROL=ignoreboth

# Append to the history file instead of overwriting
shopt -s histappend

# Huge history size
HISTSIZE=100000
HISTFILESIZE=100000

# Include dot files in globs
shopt -s dotglob

# Re-set LINES and COLUMNS variables after every command
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Enable colour prompt
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >& /dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

# Programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Press tab twice to auto-complete files and directories
[ -f ~/.config/tabtab/bash/__tabtab.bash ] && . ~/.config/tabtab/bash/__tabtab.bash || true

# Aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

summary() { echo -e "$(whoami) | $(date "+%I:%M%p") | $(pwd)\n"; }

# Prompt
# https://scriptim.github.io/bash-prompt-generator/
make_prompt() {
	PS1=''

	# Current Directory Name
	PS1+='\[\e[0;38;5;255m\]\W\[\e[0;38;5;248m\]'

	# Git Branch
	PS1+='$(git branch 2>/dev/null | grep '"'"'^*'"'"'| colrm 1 1) '

	# Exit Status
	# PS1+='\[\e[0;38;5;215m\]$?\[\e[0m\] '

	# Prompt Character
	PS1+='\[\033[01;34m\]λ\[\033[00m\] '

	# Trim prompt directory length
	PROMPT_DIRTRIM=3
}

make_prompt

# Set file viewers and editors
export VISUAL="nvim"
export EDITOR="nvim"
export BROWSER="sensible-browser"
if grep -q -i microsoft /proc/version; then
	export BROWSER="wslview"
	export DISPLAY=$(route.exe print | grep 0.0.0.0 | head -1 | awk '{print $4}'):0.0
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

# Set base path for n node version manager
#export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

# Monokai `bat` theme
export BAT_THEME="base16"

# fzf bash and tmux integration
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# fzf uses ripgrep instead
export FZF_DEFAULT_COMMAND="rg --hidden --follow --glob \"!.git/*\" --files"

# fzf format search top-to-bottom to not move cursor position
export FZF_CTRL_R_OPTS="--reverse"

# fzf Ctrl+T file preview
export FZF_CTRL_T_OPTS="--reverse --preview 'bat --color=always --style=header,grid --line-range :300 {}'"

# Python configuration file
export PYTHONSTARTUP=~/.pythonrc

# Set GPG TTY to the current shell process
export GPG_TTY="$(tty)"

# Start D-Bus for graphical applications
# /etc/init.d/dbus start &> /dev/null

# Docker host socket
#export DOCKER_HOST=unix:///run/user/1000/docker.sock
export DOCKER_HOST=unix:///var/run/docker.sock

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
. "$HOME/.cargo/env"
export LD_LIBRARY_PATH=/usr/lib/wsl/lib:$LD_LIBRARY_PATH

complete -C /usr/bin/terraform terraform
