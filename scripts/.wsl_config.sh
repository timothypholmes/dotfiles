#!/usr/bin/env bash

echo "Ubuntu on Windows"

# general alias
alias open="wslview" # WLS2 command only
alias code="code --remote wsl+Ubuntu"
alias install="sudo apt-get update && sudo apt-get install"

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

function run_pipeline() {

    echo "running pipeline env: $1"

    if [[ `current_repository` == *"sdge-it-wingspln-python"* ]]; then
        name="sdge-it-wingspln-python"
    elif [[ `current_repository` == *"sdge-it-wmp-analytics-dataops"* ]]; then
        name="sdge-it-wmp-analytics-dataops"
    elif [[ `current_repository` == *"sdge-it-wmp-analytics-mlmodels"* ]]; then
        name="sdge-it-wmp-analytics-mlmodels"
    else
        echo "repo does not match any pipelines"
        exit 1
    fi

    echo "pipeline: $name"
   
    if [[ $1 == "dev" ]]; then
        az pipelines run --name $name --branch `current_branch` --parameters 'Environments=- env: dev'  --output table --open
    elif [[ $1 == "qa" ]]; then
        az pipelines run --name $name --branch `current_branch` --parameters 'Environments=- env: qa' 'MakeQAGo=true' --output table --open
    else
        echo "no enviorment selected"
        exit 1
    fi
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
