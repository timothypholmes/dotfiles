# Fig pre block. Keep at the top of this file.
. "$HOME/.fig/shell/zshrc.pre.zsh"

# welcome message
echo  "                  │              "
echo  "         〈 〉   │ Hello, $USER "
echo  "         Darwin   │ Welcome back."
echo  "                  │             "



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

function setup {
	echo "Which enviorment would you like to start: "
	echo "------------------------------------------"
	echo "                                          "
	echo "d) documents                              "
	echo "t) thesis                                 "
    echo "dv) development                            "
	echo "                                          "
	echo "e) exit                                   "

	echo "input option: " 
	read env 

	if [ "$env" = "d" ]; then
		code -n "~/Documents" 
		
	elif [ "$env" = "t" ]; then
		code "/Users/timholmes/Library/Mobile Documents/com~apple~CloudDocs/thesis" 

	elif [ "$env" = "dv" ]; then
		code "~/Documents/development" 

	elif [ "$env" = "e" ]; then
		return

	fi
}

function generate_password() {
    LC_ALL=C tr -dc "[:alnum:]" < /dev/urandom | head -c 20 | pbcopy
}

alias setup="setup"
alias genpass="genpass"
alias promanage="ssh pmuser1@10.20.30.246"

eval "$(starship init zsh)"
export PATH="/opt/homebrew/opt/python@3.8/bin:$PATH"

# Fig post block. Keep at the bottom of this file.
. "$HOME/.fig/shell/zshrc.post.zsh"
