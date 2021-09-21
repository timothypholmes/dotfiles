# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# export
export ZSH="/Users/timholmes/.oh-my-zsh"
export PATH=/usr/local/share/npm/bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH=/opt/homebrew/bin:$PATH
eval $(thefuck --alias)
source $ZSH/oh-my-zsh.sh
ZSH_THEME="spaceship"
#source $ZSH/oh-my-zsh.sh

# ----- colorls
#source $(dirname $(gem which colorls))/tab_complete.sh

#alias ls="colorls -A"           # short, multi-line
#alias ll="colorls -1A"          # list, 1 per line
#alias ld="ll"                   # ^^^, NOTE: Trying to move to this for alternate hand commands
#alias la="colorls -lA"          # list w/ info
plugins=(
    zsh-autosuggestions
    git
)

alias icloud="~/Library/Mobile\ Documents/com~apple~CloudDocs/"

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

# Vscode
# alias code="open -a Visual\ Studio\ Code"
# Do the following instead:
# 1) in VSCode press 'Command' + 'Shift' + 'P
# 2) type in 'shell'
#alias code="code-insiders"

# matlab

# Other
alias dog="cat"
alias reload="source ~/.zshrc"

# Time it
TIMEFMT=$'\n================\nCPU\t%P\nuser\t%*U\nsystem\t%*S\ntotal\t%*E'

function setup {
	echo "Which enviorment would you like to start: "
	echo "------------------------------------------"
	echo "                                          "
	echo "d) development                            "
	echo "t) thesis                                 "
	echo "p) phy-420                                "
	echo "c) phy-                                   "
	echo "                                          "
	echo "e) exit                                   "

	echo "input option: " 
	read env 

	if [ "$env" = "d" ]; then
		code -n "~/Documents" 
		
	elif [ "$env" = "t" ]; then
		code "/Users/timholmes/Library/Mobile Documents/com~apple~CloudDocs/thesis" 

	elif [ "$env" = "p" ]; then
		code "/Users/timholmes/Library/Mobile Documents/com~apple~CloudDocs/PHY-442" 

	elif [ "$env" = "c" ]; then
		code "/Users/timholmes/Library/Mobile Documents/com~apple~CloudDocs/CSC-407"  

	elif [ "$env" = "e" ]; then
		#exit
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

