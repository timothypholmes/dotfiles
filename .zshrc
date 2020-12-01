# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/timholmes/.oh-my-zsh"
export PATH=/usr/local/share/npm/bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="common"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# ----- colorls
#source $(dirname $(gem which colorls))/tab_complete.sh

#alias ls="colorls -A"           # short, multi-line
#alias ll="colorls -1A"          # list, 1 per line
#alias ld="ll"                   # ^^^, NOTE: Trying to move to this for alternate hand commands
#alias la="colorls -lA"          # list w/ info
plugins=(
zsh-autosuggestions
)

alias icloud="~/Library/Mobile\ Documents/com~apple~CloudDocs/"

# GIT
alias gs="git status"
alias gs="git add"
alias gb="git branch"

alias gco="git checkout"
alias gp="git push"

# Python
alias pip="python3 -m pip"

# Vscode
alias code="open -a Visual\ Studio\ Code"

# matlab

# Other
alias dog="cat"
alias zshreload="source ~/.zshrc"


function setup {
	echo "Which enviorment would you like to start: "
	echo "------------------------------------------"
	echo "                                          "
	echo "d) Development                            "
	echo "t) Thesis                                 "
	echo "p) PHY-442                                "
	echo "c) CSC-407                                "
	echo "                                          "
	echo "e) Exit                                   "

	echo "input option: " 
	read env 

	if [ "$env" = "d" ]; then
		code "~/Documents" 
		
	elif [ "$env" = "t" ]; then
		code "/Users/timholmes/Library/Mobile Documents/com~apple~CloudDocs/thesis" 

	elif [ "$env" = "p" ]; then
		code "/Users/timholmes/Library/Mobile Documents/com~apple~CloudDocs/PHY-442" 

	elif [ "$env" = "c" ]; then
		code "/Users/timholmes/Library/Mobile Documents/com~apple~CloudDocs/CSC-407"  

	elif [ "$env" = "e" ]; then
		exit

	fi
}


alias setup="setup"
