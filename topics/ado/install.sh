#!/usr/bin/env bash

# Azure DevOps CLI installer

# Install Azure CLI if not already installed
if ! command -v az &> /dev/null; then
    echo "Installing Azure CLI..."
    if command -v brew &> /dev/null; then
        brew install azure-cli
    else
        echo "Please install Azure CLI manually: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    fi
else
    echo "Azure CLI already installed"
fi

# Install Azure DevOps extension
echo "Installing Azure DevOps extension..."
az extension add --name azure-devops --yes 2>/dev/null || echo "Azure DevOps extension already installed"

echo "ADO setup complete!"
echo "Run 'ado-setup organization project' to configure your defaults"
echo "Run 'ado-login' to authenticate"