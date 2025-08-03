#!/usr/bin/env bash

# The Fuck integration

# Initialize thefuck alias if available
if command -v thefuck >/dev/null 2>&1; then
    # Create config directory if it doesn't exist
    mkdir -p "$HOME/.config/thefuck/rules"
    
    # Initialize thefuck alias
    eval $(thefuck --alias)
    
    # Alternative aliases
    alias oops='fuck'
    alias doh='fuck'
    alias wtf='fuck'
fi