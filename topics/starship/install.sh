#!/usr/bin/env bash

# Starship topic installer

# Install starship if not already installed
if ! command -v starship &> /dev/null; then
    echo "Installing Starship prompt..."
    if command -v brew &> /dev/null; then
        brew install starship
    else
        curl -sS https://starship.rs/install.sh | sh
    fi
else
    echo "Starship already installed"
fi

echo "Starship setup complete!"