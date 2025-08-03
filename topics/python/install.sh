#!/usr/bin/env bash

# Python topic installer

# Install Python packages via Homebrew
if command -v brew &> /dev/null; then
    echo "Installing Python tools..."
    brew install python3 || echo "Python3 already installed"
    brew install pipenv || echo "Pipenv already installed"
    
    # Install common Python packages
    pip3 install --user --upgrade pip
    pip3 install --user virtualenv
    pip3 install --user black
    pip3 install --user flake8
    pip3 install --user autopep8
    pip3 install --user jupyter
    pip3 install --user ipython
    pip3 install --user requests
    pip3 install --user pandas
    pip3 install --user numpy
else
    echo "Please install Homebrew first"
fi

echo "Python setup complete!"