#!/usr/bin/env bash

# Tmux topic installer

# Install tmux if not already installed
if ! command -v tmux &> /dev/null; then
    echo "Installing tmux..."
    if command -v brew &> /dev/null; then
        brew install tmux
    else
        echo "Please install tmux manually"
    fi
else
    echo "Tmux already installed"
fi

echo "Tmux setup complete!"