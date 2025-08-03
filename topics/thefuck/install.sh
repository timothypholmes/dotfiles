#!/usr/bin/env bash

# The Fuck topic installer

# Install thefuck if not already installed
if ! command -v thefuck &> /dev/null; then
    echo "Installing thefuck..."
    if command -v brew &> /dev/null; then
        brew install thefuck
    else
        echo "Please install thefuck manually: pip3 install thefuck"
    fi
else
    echo "thefuck already installed"
fi

# Create thefuck config directory
mkdir -p "$HOME/.config/thefuck"

# Create basic settings file
if [[ ! -f "$HOME/.config/thefuck/settings.py" ]]; then
    echo "Creating thefuck settings..."
    cat > "$HOME/.config/thefuck/settings.py" << 'EOF'
# The Fuck settings
priority = []
rules = []
exclude_rules = []
wait_command = 3
require_confirmation = True
no_colors = False
debug = False
history_limit = None
alter_history = True
wait_slow_command = 15
slow_commands = ['lein', 'react-native', 'gradle', './gradlew', 'vagrant']
repeat = False
instant_mode = False
num_close_matches = 3
env = {'LC_ALL': 'C', 'LANG': 'C', 'GIT_TRACE': '1'}
EOF
fi

echo "thefuck setup complete!"
echo "Add 'eval \$(thefuck --alias)' to your shell config to enable"