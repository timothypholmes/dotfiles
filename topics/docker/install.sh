#!/usr/bin/env bash

# Docker topic installer

# Install Docker via Homebrew
if command -v brew &> /dev/null; then
    echo "Installing Docker..."
    brew install --cask docker || echo "Docker already installed"
    brew install docker-compose || echo "Docker Compose already installed"
else
    echo "Please install Docker Desktop manually from https://www.docker.com/products/docker-desktop"
fi

echo "Docker setup complete!"
echo "Make sure to start Docker Desktop if it's not already running"