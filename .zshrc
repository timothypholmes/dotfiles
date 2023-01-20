case "$OSTYPE" in
  solaris*) OS="Solaris" ;;
  darwin*)  OS="Darwin ";; 
  linux*)   OS="Linux  " ;;
  bsd*)     OS="BSD    " ;;
  *)        OS="unknown: $OSTYPE" ;;
esac


# welcome message
echo  " "
echo  "               ${OS:0:1}      │              "
echo  "               ${OS:1:1}      │ Hello, $USER "
echo  "               ${OS:2:1}      │ Welcome back."
echo  "               ${OS:3:1}      │              "
echo  "               ${OS:4:1}      │             " 
echo  "               ${OS:5:1}      │              "
echo  "               ${OS:6:1}      │              "
echo  "            〈   〉  │                      "
echo  " "

~/.scripts/confetti_shortcut.sh

# export
export ZSH="/Users/timholmes/.oh-my-zsh"
export PATH=/usr/local/share/npm/bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH=/opt/homebrew/bin:$PATH
eval $(thefuck --alias)
source $ZSH/oh-my-zsh.sh
ZSH_THEME="spaceship"

plugins=(
    zsh-autosuggestions
    git
)

alias icloud="~/Library/Mobile\ Documents/com~apple~CloudDocs/"

# general
alias v="vim ~/.vimrc"
alias c="clear"
alias start_page="cd ~/Documents/development/startup-page && serve -s build -p 8000"

# git
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gb="git branch"
alias gco="git checkout"
alias gp="git push"

# python
alias pip="python3 -m pip install"
alias py="python3"

# lsd (lsdeluxe)
alias ls="lsd"
alias la="ls -a"
alias lls="ls -la"
alias lt="ls -tree"

alias brew="arch -arm64 brew"

# Vscode
# alias code="open -a Visual\ Studio\ Code"
# Do the following instead:
# 1) in VSCode press 'Command' + 'Shift' + 'P
# 2) type in 'shell'

# Other
alias cat="bat"
alias dog="cat"
alias reload="source ~/.zshrc"
alias myip="curl http://ipecho.net/plain; echo"
alias hs='history | grep'

# Time it
TIMEFMT=$'\n================\nCPU\t%P\nuser\t%*U\nsystem\t%*S\ntotal\t%*E'

function set_wallpaper() {
    cd ~/Pictures/wallpapers
    ls |sort -R |tail -1 |while read file; do
    osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$PWD/$file\""
    done
    cd -
}
function list_large_git_files() {
    git rev-list --objects --all |
    git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' |
    sed -n 's/^blob //p' |
    sort --numeric-sort --key=2 |
    cut -c 1-12,41- |
    $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
}

eval "$(starship init zsh)"
export PATH="/opt/homebrew/opt/python@3.8/bin:$PATH"
