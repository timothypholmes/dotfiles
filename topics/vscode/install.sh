#!/usr/bin/env bash

# VSCode topic installer

# Install VSCode extensions if code command is available
if command -v code &> /dev/null; then
    echo "Installing VSCode extensions..."
    
    extensions=(
        "njpwerner.autodocstring"
        "usernamehw.errorlens"
        "tamasfe.even-better-toml"
        "ms-toolsai.jupyter"
        "ms-python.pylint"
        "KevinRose.vsc-python-indent"
        "charliermarsh.ruff"
    )
    
    for extension in "${extensions[@]}"; do
        echo "Installing $extension..."
        code --install-extension "$extension" --force
    done
else
    echo "VSCode command 'code' not found. Install VSCode and add it to PATH to install extensions."
fi

echo "VSCode setup complete!"