#!/usr/bin/env bash

# Dotfiles startup configuration

# Show welcome message on new terminal sessions
function dotfiles_welcome() {
    # Only show welcome in interactive shells and if not already shown in this session
    if [[ $- == *i* ]] && [[ -z "$DOTFILES_WELCOME_SHOWN" ]]; then
        export DOTFILES_WELCOME_SHOWN=1
        
        # Clear any partial prompt and add some space
        echo
        
        # Colorful welcome banner
        echo -e "\033[0;36m"
        echo "    ╔════════════════════════════════════════╗"
        echo "    ║          🚀 Welcome Back! 🚀          ║"
        echo "    ╚════════════════════════════════════════╝"
        echo -e "\033[0m"
        
        # Commands section
        echo -e "\033[1;37m💡 Quick Commands:\033[0m"
        echo -e "   \033[1;36mdotfiles\033[0m      - Full command center dashboard"
        echo -e "   \033[1;36mdotfiles help\033[0m - Quick help menu"
        echo -e "   \033[1;36mawsup\033[0m         - Update AWS credentials from clipboard"
        echo -e "   \033[1;36mado-run dev\033[0m   - Run Azure DevOps pipeline"
        echo
        
        # Show current context if available
        local context_shown=false
        
        if [[ -n "$AWS_PROFILE" ]]; then
            echo -e "\033[0;33m🔐 AWS Profile: $AWS_PROFILE\033[0m"
            context_shown=true
        fi
        
        if git rev-parse --git-dir >/dev/null 2>&1; then
            local repo=$(basename "$(git rev-parse --show-toplevel)" 2>/dev/null)
            local branch=$(git branch --show-current 2>/dev/null)
            if [[ -n "$repo" && -n "$branch" ]]; then
                echo -e "\033[0;32m📂 Git: $repo ($branch)\033[0m"
                context_shown=true
            fi
        fi
        
        if [[ "$context_shown" == "true" ]]; then
            echo
        fi
        
        # Tip
        echo -e "\033[0;90m💭 Tip: Type 'df' as a shortcut for 'dotfiles'\033[0m"
        echo
    fi
}

# Auto-run welcome message
dotfiles_welcome

# Function to manually show welcome message
function show_welcome() {
    unset DOTFILES_WELCOME_SHOWN
    dotfiles_welcome
}

# Dotfiles CLI aliases for convenience
alias df="dotfiles"
alias dfd="dotfiles dashboard"  
alias dfu="dotfiles update"
alias dfe="dotfiles edit"
alias dfr="dotfiles refresh"
alias dfh="dotfiles help"
alias welcome="show_welcome"