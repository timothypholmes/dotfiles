#!/usr/bin/env bash

# Wget topic installer

# Install wget if not already installed
if ! command -v wget &> /dev/null; then
    echo "Installing wget..."
    if command -v brew &> /dev/null; then
        brew install wget
    else
        echo "Please install wget manually"
    fi
else
    echo "Wget already installed"
fi

echo "Wget setup complete!"