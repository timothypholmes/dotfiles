#!/bin/bash

# deploy.sh
# Script is used to copy changes made to dotfiles and 
# update them in the repo.

cd ~/dotfiles
cp ~/.vimrc .
cp ~/.zshrc .
cp ~/.config/starship.toml .
cp /Users/$USER/Library/Application\ Support/Code/User/settings.json .
cp -r ~/.config/scripts ./scripts


# push code to gh if config change
cd ~/dotfiles
git add .
set +e
git status | grep modified
if [ $? -eq 0 ]
then
    set -e
    git commit -am "Auto Update: $(date)"
    git push
else
    set -e
    echo "No changes since last run: $(date)"
fi
