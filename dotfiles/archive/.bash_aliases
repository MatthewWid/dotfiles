# Expand aliases for the current session, including non-interactive shells
shopt -s expand_aliases

# Configuration editing
alias ba="v ~/.bash_aliases"
alias brc="v ~/.bashrc"
alias bpro="v ~/.bash_profile"
alias irc="v ~/.inputrc"
alias tcf="v ~/.tmux.conf"
alias gig="v ~/.gitignore-global"
alias ccs="v ~/.config/nvim/coc-settings.json"
alias vrc="v ~/.config/nvim/init.vim"

# Command modification
alias lls="\ls -F --color -I \"*.swp\" -h $*" 
alias ls="lls -A"
alias lsl="ls -l"
alias l="ls"
cd() { builtin cd "$@" && ls; }
alias ..="cd \"..\""
alias cd..=".."
alias tre="tree -I \"node_modules|build*\""
alias curl="curl -L"
alias diff="git diff --no-index --"
alias sh="bash"
alias grep="grep --color=auto"
alias fgrep="grep -F"
alias egrep="grep -E"
alias cp="cp -r"

# Command shortcuts
alias nv="$(which n)"
alias n="node"
alias v="nvim"
alias t="touch"
alias d="mkdir -p"
alias r="rm -rf"
alias re="ranger_cd"
alias py="python"
alias li="lorem-ipsum"
alias sha="sha256sum"
alias gpp="g++"
alias wgpp="x86_64-w64-mingw32-g++"
alias python="python3"
alias ytdl="youtube-dl"
alias findlink="readlink -f"
alias findalias="type"

# New commands
alias cls="printf \"\033c\""
alias size="du -bsh"
alias bytes="wc -c"
alias proc="ps aux | grep"
alias e.="browse ."
alias ~="cd ~"
alias tsf="tmux source-file ~/.tmux.conf"
alias genfile="xfs_mkfile $1 $2"
alias port="netstat -tulpn | grep"
alias copy="xsel -b -i"
alias paste="xsel -b -o 2> /dev/null"
alias qr="qrencode -t ANSI256 -r /dev/stdin -o /dev/stdout"
alias xargsp="xargs -n 1 -I {}"
brow() { if [[ $1 =~ ^http:\/\/ ]]; then $BROWSER "$1"; else $BROWSER "http://$1"; fi; }
vid2u() { find ~/.config/nvim/plugged -exec dos2unix {} \;; }
bman() { help $1 | less; }
search() { grep -n -r -i $1 $2; }
bundle() { curl -s https://bundlephobia.com/api/size?package=$1 | jq ".gzip" | numfmt --to iec; }
ren() { mv $1 "$(dirname $(readlink -f $1))/$2"; }
cah() { bat $* ; }
wsldns() { cat /etc/resolv.conf | grep "nameserver" | cut -d " " -f 2; }
wslip() { ip addr show eth0 | grep --colour=never -oP '(?<=inet\s)\d+(\.\d+){3}'; }
colours() { for i in {0..255}; do printf "\x1b[38;5;${i}mcolour${i}\n"; done }
mkvtomp4() { ffmpeg -i "$1" -codec copy -strict experimental "$(echo \"$1\" | cut -f 1 -d '.').mp4"; }
serve() { python -m http.server; }
ips() { ip -br a; }
vpn() { TERM=xterm barracudavpn $*; }
vpnc() { read -s -p "Password: " VPN_PWD && vpn --start --login matthew.widdicombe --serverpwd $VPN_PWD; }
vpnr() { sudo sh -c "echo \"nameserver 192.168.50.10\" > /etc/resolv.conf"; }
vpnd() { vpn --stop; }

# Git
alias gint="git init"
alias gclo="git clone"
alias gl="git log --pretty=format:'%C(yellow)%h %Cblue%ad %Cgreen%d %Creset%s' --date=relative"
alias gla="gl --all --graph"
alias gs="git status"
alias gsi="git status --ignored"
alias gp="git push"
alias gpu="git pull"
alias ga="git add"
alias ga."=git add -A"
alias gd="git diff"
alias gdc="git diff --cached"
gdic() { git diff-tree --color=always -p ${1:-HEAD} ${2:-$(git rev-parse --show-toplevel)} | less -R; }
alias gdcm="git diff-tree --no-commit-id --name-status -r"
alias gcm="git commit -m"
alias gacm="git commit -a -m"
alias gca="git commit --amend"
alias grh="git reset HEAD~"
alias gre="git restore"
alias gre.="git restore ."
alias grec="git restore --staged"
alias gr="git remote"
alias grv="git remote --verbose"
alias gb="git branch"
alias gba="git branch -a"
alias gbl="git branch --list -vv -a"
alias gc="git checkout"
alias gi="git init"
alias gf="git fetch"
alias gsm="git submodule"
alias gsmu="git submodule update --init --recursive"
alias gst="git stash"
alias gstp="git stash pop"
alias gstl="git stash list"
alias gt="git tag"
alias gtl="git tag --list -n99 --sort=-v:refname"
alias gm="git merge"
alias grb="git rebase"
if test -f "/usr/share/bash-completion/completions/git"; then
	source "/usr/share/bash-completion/completions/git"
	__git_complete gp _git_checkout
	__git_complete gpu _git_pull
	__git_complete gb _git_branch
	__git_complete gba _git_branch
	__git_complete gbl _git_branch
	__git_complete gc _git_checkout
	__git_complete gf _git_fetch
	__git_complete gm _git_merge
fi

# npm
alias nint="npm init -y"
alias nins="npm install"
alias na="npm install --save"
alias nad="npm install --save-dev"
alias nu="npm uninstall"
alias nga="npm install -g"
alias ngu="npm uninstall -g"
alias nr="npm run"
alias nd="npm run dev"
alias ns="npm run start"
alias nb="npm run build"
alias nbw="npm run build:watch"
alias np="npm run prod"
alias nt="npm run test"
alias ndoc="npm run doc"

# pnpm
alias pnint="pnpm init -y"
alias pnins="pnpm install"
alias pna="pnpm add"
alias pnad="pnpm add -D"
alias pnu="pnpm remove"
alias pnga="pnpm add --global"
alias pngu="pnpm remove --global"
alias pnr="pnpm run"
alias pnd="pnpm run dev"
alias pns="pnpm run start"
alias pnb="pnpm run build"
alias pnbw="pnpm run build:watch"
alias pnt="pnpm run test"
alias pne="pnpm exec"
alias pnx="pnpx"

# Yarn
alias yint="yarn init -y"
alias yins="yarn install"
alias ya="yarn add"
alias yg="yarn global"
alias yga="yarn global add"
alias ygu="yarn global remove"
alias yad="yarn add -D"
alias yu="yarn remove"
alias yr="yarn run"
alias yd="yarn run dev"
alias ys="yarn run start"
alias yb="yarn run build"
alias ybw="yarn run build:watch"
alias yp="yarn run prod"
alias yt="yarn run test"
alias ydo="yarn run doc"

# curl
alias cu="curl"
alias cug="curl --request GET $1"
alias cup="curl --request POST $1 --data '$2'"

# tmux
alias tm="tmux"
alias tmls="tmux ls"
alias tmn="tmux new-session -s $1"
alias tmal="tmux attach-session"
alias tmal.="tmux attach-session -c $(pwd)"
alias tman="tmux attach-session -t $1"
alias tmr="tmux rename-session $1"
alias tmrn="tmux rename-session -t $1 $2"
alias tmkl="tmux kill-session"
alias tmkn="tmux kill-session -t $1"
alias tmka="tmux kill-server"
alias tmkab="tmux kill-session -a -t $1"

# Powershell
alias psf="powershell.exe -ExecutionPolicy bypass -File $1"
alias psc="powershell.exe -Command \"$*\""
