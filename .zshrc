source $ZSH/oh-my-zsh.sh

ZSH_THEME="spaceship"

plugins=(
    zsh-autosuggestions
    git
    dirhistory
    zsh-syntax-highlighting
    web-search
    you-should-use
    zsh-bat
    copyfile
)

# import configs
. ~/dotfiles/scripts/.general_config.sh
. ~/dotfiles/scripts/.git_config.sh
. ~/dotfiles/scripts/.python_config.sh
if [[ -f "~/dotfiles/scripts/.project_config.sh" ]]; then
    . ~/dotfiles/scripts/.project_config.sh
fi

# configs by os type
if grep -qi microsoft /proc/version; then
    . ~/dotfiles/scripts/.wsl_config.sh
fi
if [[ $OSTYPE == 'darwin'* ]]; then
    . ~/dotfiles/scripts/.mac_config.sh
fi
if [[ $OSTYPE == 'linux'* ]]; then
    . ~/dotfiles/scripts/.linux_config.sh
fi

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

export ZSH="$HOME/.oh-my-zsh"
export PATH=/usr/local/share/npm/bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH=/opt/homebrew/bin:$PATH
export PATH=~/anaconda3/bin:$PATH
export PATH="/opt/homebrew/opt/python@3.8/bin:$PATH"
export PATH=$HOME/bin:$PATH
export PATH=:$PATH

export PATH=$HOME/bin:$PATH
export PATH=:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
