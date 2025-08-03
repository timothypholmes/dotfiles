#!/usr/bin/env bash

# NPM topic installer

# Install Node.js and npm if not already installed
if ! command -v node &> /dev/null; then
    echo "Installing Node.js and npm..."
    if command -v brew &> /dev/null; then
        brew install node
    else
        echo "Please install Node.js manually from https://nodejs.org/"
    fi
else
    echo "Node.js and npm already installed"
fi

# Install global packages
echo "Installing global npm packages..."
npm install -g npm@latest
npm install -g yarn
npm install -g nodemon
npm install -g http-server
npm install -g json
npm install -g prettier
npm install -g eslint

echo "NPM setup complete!"