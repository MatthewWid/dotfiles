source ~/.bashrc

# Git branch autocompletion
if [ -f /usr/share/bash-completion/completions/git ]; then
	. /usr/share/bash-completion/completions/git
fi

# Disable cursor blink
echo -ne "\e[2 q"

# History time format
HISTTIMEFORMAT="%d/%m/%y %T "

# Add ~/bin to path
export PATH="$HOME/bin:$PATH"

# Golang
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH="$PATH:$GOPATH/bin:$GOROOT/bin"

# Yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# User-locally installed bin scripts
export PATH="/home/matt/.local/bin:$PATH"
. "$HOME/.cargo/env"
