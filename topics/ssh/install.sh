#!/usr/bin/env bash

# SSH topic installer

# Create .ssh directory if it doesn't exist
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Set proper permissions for SSH config
if [ -f ~/.ssh/config ]; then
    chmod 600 ~/.ssh/config
fi

echo "SSH setup complete!"
echo "Make sure to generate SSH keys if needed: ssh-keygen -t rsa -b 4096 -C 'your_email@example.com'"