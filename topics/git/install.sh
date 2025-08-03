#!/usr/bin/env bash

# Git topic installer

# Install git if not already installed
if ! command -v git &> /dev/null; then
    echo "Installing git..."
    if command -v brew &> /dev/null; then
        brew install git
    else
        echo "Please install git manually"
    fi
else
    echo "Git already installed"
fi

echo "Git setup complete!"
echo "Note: Personal git config should go in ~/.gitconfig.local"