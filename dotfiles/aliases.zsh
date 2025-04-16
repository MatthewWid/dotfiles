# Default editor and file viewer
EDITOR="${EDITOR:-neovim}"
VISUAL="${VISUAL:-neovim}"

# Configuration file editing
alias za="$EDITOR $ZSH_CUSTOM/aliases.zsh"
alias zrc="$EDITOR ~/.zshrc"
alias omzc="$EDITOR ~/.oh-my-zsh"
alias tcf="$EDITOR ~/.tmux.conf"
alias gig="$EDITOR ~/.gitignore-global"
alias lrc="$EDITOR ~/.localrc"
alias ccs="$EDITOR ~/.config/nvim/coc-settings.json"
alias vrc="$EDITOR ~/.config/nvim/init.vim"
alias rcc="$EDITOR ~/.config/ranger/rc.conf"
alias ric="$EDITOR ~/.config/ranger/rifle.conf"

# Command modification
alias lls="\ls -F --color -h $*" 
alias ls="lls -A"
alias lsl="ls -l --time-style=long-iso"
alias l="ls"
cd() { builtin cd "$@" && ls; }
alias ..="cd \"..\""
alias cd..=".."
alias tre="tree -I \"node_modules|build*\""
alias diff="git diff --no-index --"
alias sh="bash"
alias grep="grep --color=auto"
alias fgrep="grep -F"
alias egrep="grep -E"
alias cp="cp -r"

# Command shortcuts
alias nv="$(which n)"
alias n="node"
alias v="$EDITOR"
alias v.="v ."
t() { mkdir -p "$(dirname "$1")" && touch "$1"; }
alias d="mkdir -p"
dcd() { d $* && cd "${@:$#}"; }
alias cd-="cd -"
alias r="rm -rf"
alias re="ranger_cd"
alias li="lorem-ipsum"
alias sha="sha256sum"
alias gpp="g++"
alias wgpp="x86_64-w64-mingw32-g++"
alias findlink="readlink -f"
alias findalias="alias"
alias open="npm_config_yes=true npx open-cli"
alias chm="chmod"
alias cho="chown"
alias tsxw="clear && tsx watch"
alias gpt="chatgpt"
alias cah="bat"
alias tf="terraform"
alias red="redis-cli"

# New commands
alias cls="printf \"\033c\""
alias size="du -bsh"
alias bytes="wc -c"
alias proc="ps aux | grep"
alias e.="explorer.exe ."
alias tsf="tmux source-file ~/.tmux.conf"
alias genfile="xfs_mkfile $1 $2"
alias qr="qrencode -t ANSI256 -r /dev/stdin -o /dev/stdout"
alias xargsp="xargs -n 1 -I {}"
alias grepc="rg --with-filename --no-heading"
alias serve="http-server"
htmlqp() { htmlq -p $@ | tail -n +2 | bat -l html -p; }
port() { sudo ss -lptn 'sport = :$1'; }
brow() { if [[ $1 =~ ^http:\/\/ ]]; then $BROWSER "$1"; else $BROWSER "http://$1"; fi; }
vid2u() { find ~/.config/nvim/plugged -exec dos2unix {} \;; }
bman() { man bash | less -p "^       $1 "; }
bundle() { curl -s https://bundlephobia.com/api/size?package=$1 | jq ".gzip" | numfmt --to iec; }
ren() { mv $1 "$(dirname $(readlink -f $1))/$2"; }
colours() { for i in {0..255}; do printf "\x1b[38;5;${i}mcolour${i}\n"; done }
tomp4() { ffmpeg -i "$1" -codec copy -strict experimental "$(echo \"$1\" | cut -f 1 -d '.').mp4"; }
tomp3() { ffmpeg -i "$1" -q:a 0 "$(echo \"$1\" | cut -f 1 -d '.').mp3"; }
ips() { ip -br a; }
vjson() { v "$(cat /dev/urandom | LC_ALL=C tr -dc a-zA-Z0-9 | head -c 12; echo '').ignore.json"; }
gitupdateall() { find . -type d -depth 1 -exec git --git-dir={}/.git --work-tree=$PWD/{} pull origin master \;; }
encode() { printf %s "$1" | jq -s -R -r @uri; }
awscheck() { aws sts get-caller-identity; }
delzone() { find . -name '*:Zone.Identifier' -delete; }
uncorrupt() { mv "$1" "$1.bad"; strings "$1.bad" > "$1"; }

# Dotfiles
getnodeignore() { wget --quiet -O .gitignore https://github.com/MatthewWid/dotfiles/raw/refs/heads/master/dotfiles/Node.gitignore; }
gettsconfig() { wget --quiet -O tsconfig.json https://github.com/MatthewWid/dotfiles/raw/refs/heads/master/dotfiles/tsconfig.json }

# Git
alias gint="git init"
gclo() { git clone "$@"; cd "$(basename "$1" .git)"; }
alias gl="git log --pretty=format:'%C(yellow)%h %Cblue%ad %Cgreen%d %Creset%s' --date=relative"
alias gla="gl --all --graph"
alias gll="git log"
alias glla="git log --all"
alias gs="git status"
alias gsi="git status --ignored"
alias gp="git push"
alias gpf="git push --force"
alias gpu="git pull"
alias ga="git add"
alias ga.="git add -A"
alias gap="git add --patch"
alias gd="git diff"
alias gdc="git diff --cached"
# See diff of a commit (HEAD by default)
gdic() { git diff-tree --color=always -p ${1:-HEAD} ${2:-$(git rev-parse --show-toplevel)} | less -R; }
# See status (files changed) of a commit (HEAD by default)
gsic() { git diff-tree -r --no-commit-id --name-status ${1:-HEAD}; }
alias gdicm="gdic master..HEAD"
alias gdcm="git diff-tree --no-commit-id --name-status -r"
alias gcm="git commit -m"
alias gcmnv="git commit --no-verify -m"
alias gacm="git commit -a -m"
alias gacmnv="git commit --no-verify -a -m"
alias gcnm="git commit --allow-empty-message -m \"\""
alias gcnmnv="git commit --no-verify --allow-empty-message -m \"\""
alias gacnm="git commit -a --allow-empty-message -m \"\""
alias gacnmnv="git commit --no-verify -a --allow-empty-message -m \"\""
alias gca="git commit --amend"
alias gcanv="git commit --no-verify --amend"
alias grh="git reset HEAD~"
alias gre="git restore"
alias gre.="git restore ."
alias grec="git restore --staged"
alias grec.="git restore --staged ."
alias grecp="git restore --staged --patch"
alias grecp.="git restore --staged --patch ."
alias gr="git remote"
alias grv="git remote --verbose"
alias gb="git branch"
alias gba="git branch -a"
alias gbl="git branch --list -vv -a"
alias gbd="git branch -d"
alias gbm="git branch -m"
gdefb() { git branch -r | grep "HEAD -> " | xargs | cut -d " " -f 3 | cut -d "/" -f 2; }
alias gc="git checkout"
alias gcb="git checkout -b"
alias gcbm="git checkout -b $1 master"
alias gi="git init"
alias gf="git fetch"
alias gfp="git fetch -p"
gfpd() { git fetch --prune | git branch -v | grep "\[gone\]" | awk '{print $1}' | xargs git branch -d; }
alias gfm="git fetch origin master:master"
alias gsm="git submodule"
alias gsmu="git submodule update --init --recursive"
alias gst="git stash"
alias gstp="git stash pop"
alias gstl="git stash list"
alias gt="git tag"
alias gtl="git tag --list -n99 --sort=-v:refname"
alias gm="git merge"
alias grb="git rebase"
alias grbc="git rebase --continue"
alias grba="git rebase --abort"
alias grbi="git rebase --interactive"
alias grbim="git rebase --interactive master"
alias grl="git reflog --date=relative"

# npm
alias nint="npm init -y"
alias nins="npm install"
alias na="npm install --save"
alias nad="npm install --save-dev"
alias nu="npm uninstall"
alias nga="npm install -g"
alias ngu="npm uninstall -g"
alias ngau="NPM_CHECK_INSTALLER=npm npx npm-check --global --update-all"
alias nr="npm run"
alias nd="npm run dev"
alias ns="npm run start"
alias nb="npm run build"
alias nbw="npm run build:watch"
alias np="npm run prod"
alias nt="npm run test"
alias ndoc="npm run doc"

# pnpm
alias pnint="pnpm init"
alias pnins="pnpm install"
alias pna="pnpm add"
alias pnfa="pnpm add --filter"
alias pnar="pna -r"
alias pnad="pnpm add -D"
alias pnfad="pnpm add -D --filter"
alias pnadr="pnad -r"
alias pnap="pnpm add --save-peer"
alias pnu="pnpm remove"
alias pnfu="pnpm remove --filter"
alias pnur="pnu -r"
alias pnga="pnpm add --global"
alias pngu="pnpm remove --global"
alias pnr="pnpm run"
alias pnfr="pnpm run --filter"
alias pnrr="pnr --recursive run"
alias pnd="pnpm run dev"
alias pns="pnpm run start"
alias pnsw="clear && pnpm run start:watch"
alias pnb="pnpm run build"
alias pnbw="pnpm run build:watch"
alias pnt="pnpm run test"
alias pnl="pnpm run lint"
alias pnf="pnpm run format"
alias pne="pnpm exec"
alias pnx="pnpm dlx"
pnpg() { pnpm pkg get $* | jq; }
pnps() { pnpm pkg set "$1=$2"; }
alias pnpd="pnpm pkg delete"
alias pnc="pnpm create"
alias pnpk="pnpm pkg"
alias pnab="pnpm approve-builds"

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
alias curl="curl -L"
alias cu="curl -s"
alias cug="curl --request GET $1"
alias cup="curl --request POST $1 --data '$2'"

# tmux
alias tm="tmux"
alias tmls="tmux ls"
tmn() { tmux new-session -s $1 -d; tmux switch-client -t $1; }
alias tmal="tmux attach-session"
alias tmal.="tmux attach-session -c $(pwd)"
alias tman="tmux attach-session -t $1"
alias tmr="tmux rename-session $1"
alias tmrn="tmux rename-session -t $1 $2"
alias tmk="tmux kill-session"
alias tmkl="tmk"
tmkn() { tmux kill-session -t $1; }
alias tmka="tmux kill-server"
alias tmkab="tmux kill-session -a -t $1"
alias mux="tmuxinator"

# Docker
alias doc="docker-compose"
alias docu="docker-compose up -d"
alias docul="docu && docker-compose logs -f"
alias docd="docker-compose down"

# tar
alias tarx="tar -xzvf"
tarc() { tar -czvf "$1.tar.gz" $1 }

# youtube-dl
alias ytdl="yt-dlp"
alias ytdlb="ytdl -f bv+ba"
alias ytdla="ytdl -x"

# WSL
wsldns() { cat /etc/resolv.conf | grep "nameserver" | cut -d " " -f 2; }
wslip() { ip addr show eth0 | grep --colour=never -oP '(?<=inet\s)\d+(\.\d+){3}'; }
wslhome() { builtin cd $(wslpath "$(wslvar USERPROFILE)"); }
wsldown() { powershell.exe -Command "wsl --shutdown"; }

# Powershell
alias pss="powershell.exe"
alias psf="powershell.exe -ExecutionPolicy bypass -File $1"
alias psc="powershell.exe -Command \"$*\""

# Python
alias python="python3"
alias py="python"
alias pip="pip3"
alias wpy="psc py"
alias wpip="psc py -m pip"
venv() { python3 -m venv ${1:-venv} ${@:2}; }
vact() { source ${1:-venv}/bin/activate; }
