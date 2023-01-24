source $ZSH/oh-my-zsh.sh

ZSH_THEME="spaceship"

plugins=(
    zsh-autosuggestions
    git
)

# import configs
. ~/.config/scripts/.general_config.sh
if grep -qi microsoft /proc/version; then
    . ~/.config/scripts/.wsl_config.sh
fi
if [[ $OSTYPE == 'darwin'* ]]; then
    . ~/.config/scripts/.mac_config.sh
fi
. ~/.config/scripts/.git_config.sh

alias icloud="~/Library/Mobile\ Documents/com~apple~CloudDocs/"

# general
alias v="vim ~/.vimrc"
alias z="vim ~/.zshrc"
alias s="vim ~/.config/scripts"
alias c="clear"
alias reload="source ~/.zshrc"
alias myip="curl http://ipecho.net/plain; echo"
alias hs="history | grep"

# python
alias pip="python3 -m pip install"
alias py="python3"

# Vscode
# alias code="open -a Visual\ Studio\ Code"
# Do the following instead:
# 1) in VSCode press 'Command' + 'Shift' + 'P
# 2) type in 'shell'

eval "$(starship init zsh)"
eval $(thefuck --alias)

# export
export HISTFILESIZE=1000000000
export HISTSIZE=1000000

export ZSH="/Users/timholmes/.oh-my-zsh"
export PATH=/usr/local/share/npm/bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH=/opt/homebrew/bin:$PATH
export PATH=~/anaconda3/bin:$PATH
export PATH="/opt/homebrew/opt/python@3.8/bin:$PATH"
export PATH=/home/tim/bin:$PATH
export PATH=:$PATH

