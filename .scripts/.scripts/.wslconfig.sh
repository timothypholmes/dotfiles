#!/usr/bin/env bash

echo "Ubuntu on Windows"

# starting dir
cd /mnt/c/Users/timh/projects

# general alias
alias open="wslview" # WLS2 command only
alias code="code --remote wsl+Ubuntu"
alias install="sudo apt-get update && sudo apt-get install"

# alias paths
alias icloud="cd /mnt/c/Users/timh/iCloudDrive"
alias logic="cd /mnt/c/Users/timh/OneDrive\ -\ Logic20\ 20\ Inc/Documents/logic"
alias sempra="cd /mnt/c/Users/timh/OneDrive\ -\ Logic20\ 20\ Inc/Documents/sempra"
alias pln="cd /mnt/c/Users/timh/projects/sdge-it-wingspln-python"
alias dataops="cd /mnt/c/Users/timh/projects/sdge-it-wmp-analytics-dataops"

function build_page {
    cd /mnt/c/Users/timh/projects/startup-page && npm run build && cd -
}   
    
function start_page {
    cd /mnt/c/Users/timh/projects/startup-page && serve -s dist -p 8000 && cd -
}  

function setup_github_ssh_key {
    echo "Setting up Git"
    ssh-keygen -t rsa -b 4096 -C "myemail@domain.com"
    echo "new SSH key generated"
    ssh-agent
    ssh-add ~/.ssh/$1
    cat ~/.ssh/$1.pub | clip.exe
    cmd.exe /C start https://github.com/settings/ssh/new
    echo "Your new ssh key was added to your clipboard, add it to GitHub (and consider turning on SSO)"
    echo "Press any key when your key was added to GitHub"
    while true; do
        read -t 3 -n 1
        if [ $? = 0 ] ; then
            break;
        else
            echo "waiting for the keypress"
        fi
    done
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/tim/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/tim/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/tim/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/tim/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
