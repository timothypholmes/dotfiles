#!/usr/bin/env bash

# Vim topic installer

# Install Vundle if not already installed
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
    echo "Installing Vundle..."
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

# Install vim plugins
echo "Installing vim plugins..."
vim +PluginInstall +qall

echo "Vim setup complete!"