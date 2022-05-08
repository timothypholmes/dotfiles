cd ~/dotfiles
cp ~/.vimrc .
cp ~/.zshrc .
cp ~/.config/starship.toml .
cp /Users/$USER/Library/Application\ Support/Code/User/settings.json .



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
