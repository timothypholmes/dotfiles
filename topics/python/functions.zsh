#!/usr/bin/env bash

# Python functions and aliases

# Create virtual environment
function mkvenv() {
    local name=${1:-venv}
    python3 -m venv "$name"
    echo "Virtual environment '$name' created"
    echo "Activate with: source $name/bin/activate"
}

# Activate virtual environment
function activate() {
    local venv_name=${1:-venv}
    if [ -f "$venv_name/bin/activate" ]; then
        source "$venv_name/bin/activate"
        echo "Activated virtual environment: $venv_name"
    elif [ -f "venv/bin/activate" ]; then
        source venv/bin/activate
        echo "Activated virtual environment: venv"
    else
        echo "No virtual environment found"
    fi
}

# Install requirements
function pip-install-requirements() {
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
    elif [ -f "requirements-dev.txt" ]; then
        pip install -r requirements-dev.txt
    else
        echo "No requirements.txt found"
    fi
}

# Create requirements file
function pip-freeze-requirements() {
    pip freeze > requirements.txt
    echo "Requirements saved to requirements.txt"
}

# Python aliases
alias py="python3"
alias pip="pip3"
alias serve="python3 -m http.server"
alias json="python3 -m json.tool"
alias pep8="python3 -m autopep8"
alias pipr="pip-install-requirements"
alias pipf="pip-freeze-requirements"

# Jupyter aliases
alias jn="jupyter notebook"
alias jl="jupyter lab"