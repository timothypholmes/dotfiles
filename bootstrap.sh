#!/usr/bin/env bash

# Bootstrap script for dotfiles management
# Combines sync functionality with symlink management

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() {
    printf "\r  [ ${BLUE}..${NC} ] $1\n"
}

user() {
    printf "\r  [ ${YELLOW}??${NC} ] $1\n"
}

success() {
    printf "\r\033[2K  [ ${GREEN}OK${NC} ] $1\n"
}

fail() {
    printf "\r\033[2K  [${RED}FAIL${NC}] $1\n"
    echo ''
    exit 1
}

# Pull latest changes from git
pull_latest() {
    info "Pulling latest changes from git..."
    
    # Check if we have uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        success "Skipping git pull - you have uncommitted changes"
        return 0
    fi
    
    # Check if remote exists and is reachable
    if ! git ls-remote --exit-code origin >/dev/null 2>&1; then
        success "Skipping git pull - remote not reachable or doesn't exist"
        return 0
    fi
    
    if git pull origin $(git branch --show-current) > /dev/null 2>&1; then
        success "Updated dotfiles from remote"
    else
        success "Git pull failed, continuing with local changes"
    fi
}

# Create symlink with backup option
link_file() {
    local src=$1 dst=$2

    # Use global variables that are set in install_dotfiles
    local overwrite=false
    local backup=false
    local skip=false

    if [ -f "$dst" ] || [ -d "$dst" ] || [ -L "$dst" ]; then
        if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]; then
            local currentSrc="$(readlink "$dst" 2>/dev/null || echo "")"

            if [ "$currentSrc" == "$src" ]; then
                skip=true;
            else
                user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
                read -n 1 action

                case "$action" in
                    o )
                        overwrite=true;;
                    O )
                        overwrite_all=true;;
                    b )
                        backup=true;;
                    B )
                        backup_all=true;;
                    s )
                        skip=true;;
                    S )
                        skip_all=true;;
                    * )
                        ;;
                esac
            fi
        fi

        overwrite=${overwrite:-$overwrite_all}
        backup=${backup:-$backup_all}
        skip=${skip:-$skip_all}

        if [ "$overwrite" == "true" ]; then
            rm -rf "$dst"
            success "removed $dst"
        fi

        if [ "$backup" == "true" ]; then
            mv "$dst" "${dst}.backup"
            success "moved $dst to ${dst}.backup"
        fi

        if [ "$skip" == "true" ]; then
            success "skipped $src"
        fi
    fi

    if [ "$skip" != "true" ]; then
        ln -s "$1" "$2"
        success "linked $1 to $2"
    fi
}

# Install dotfiles by creating symlinks
install_dotfiles() {
    info "Installing dotfiles..."

    # Set global variables for link_file function
    overwrite_all=$OVERWRITE_ALL 
    backup_all=false 
    skip_all=false

    # Handle .config directory conflicts first
    if [ -f "$HOME/.config" ] && [ ! -d "$HOME/.config" ]; then
        info "Found .config as file, backing up and creating directory..."
        mv "$HOME/.config" "$HOME/.config.backup.$(date +%s)"
        mkdir -p "$HOME/.config"
        success "Backed up .config file and created directory"
    fi
    
    # Ensure .config directory exists
    mkdir -p "$HOME/.config"

    # Handle special cases first (before general symlink loop)
    # SSH config goes to ~/.ssh/config
    if [ -f "$PWD/topics/ssh/config.symlink" ]; then
        mkdir -p "$HOME/.ssh"
        link_file "$PWD/topics/ssh/config.symlink" "$HOME/.ssh/config"
    fi

    # Ghostty config goes to ~/.config/ghostty/config
    if [ -f "$PWD/topics/ghostty/config.symlink" ]; then
        mkdir -p "$HOME/.config/ghostty"
        link_file "$PWD/topics/ghostty/config.symlink" "$HOME/.config/ghostty/config"
    fi

    # Starship config goes to ~/.config/starship.toml
    if [ -f "$PWD/topics/starship/starship.toml.symlink" ]; then
        mkdir -p "$HOME/.config"
        link_file "$PWD/topics/starship/starship.toml.symlink" "$HOME/.config/starship.toml"
    fi

    # VSCode settings (macOS)
    if [[ "$OSTYPE" == "darwin"* ]] && [ -f "$PWD/topics/vscode/settings.json.symlink" ]; then
        local vscode_dir="$HOME/Library/Application Support/Code/User"
        mkdir -p "$vscode_dir"
        link_file "$PWD/topics/vscode/settings.json.symlink" "$vscode_dir/settings.json"
    fi

    # Find all symlink files in topics directories (exclude special cases)
    for src in $(find -H "$PWD/topics" -maxdepth 2 -name '*.symlink' -not -path '*.git*'); do
        local filename=$(basename "${src%.*}")
        local topic_dir=$(basename "$(dirname "$src")")
        
        # Skip files we handle specially
        case "$topic_dir/$filename" in
            "ssh/config"|"ghostty/config"|"starship/starship.toml"|"vscode/settings.json")
                # Skip - already handled above
                continue
                ;;
            *)
                # Standard symlink to home directory
                dst="$HOME/.$filename"
                link_file "$src" "$dst"
                ;;
        esac
    done
}

# Run topic install scripts
run_installers() {
    info "Running topic installers..."

    find . -name install.sh | while read installer; do
        if [ -x "$installer" ]; then
            info "Running ${installer}"
            sh -c "${installer}"
        fi
    done
}

# Add bin directory to PATH
setup_bin_path() {
    info "Setting up bin directory in PATH..."
    
    local bin_path="$PWD/bin"
    
    # Add to zshrc if not already present
    if [ -f "$HOME/.zshrc" ] && ! grep -q "$bin_path" "$HOME/.zshrc"; then
        echo "export PATH=\"$bin_path:\$PATH\"" >> "$HOME/.zshrc"
        success "Added $bin_path to PATH in ~/.zshrc"
    fi
}

# Source zsh functions from topics
source_zsh_functions() {
    info "Sourcing zsh functions..."
    
    # Find all .zsh files in topics directories
    for zsh_file in $(find "$PWD/topics" -name "*.zsh" -not -path "*.git*"); do
        if [ -f "$zsh_file" ]; then
            # Add source line to zshrc if not already present
            if [ -f "$HOME/.zshrc" ] && ! grep -q "source $zsh_file" "$HOME/.zshrc"; then
                echo "source \"$zsh_file\"" >> "$HOME/.zshrc"
                success "Added source for $(basename $zsh_file)"
            fi
        fi
    done
}

# Main execution
main() {
    info "🚀 Bootstrapping dotfiles..."

    # Check if we should skip git operations
    if [[ "$SKIP_GIT" == "true" ]]; then
        info "Skipping git operations (--local flag)"
    elif git rev-parse --git-dir > /dev/null 2>&1; then
        pull_latest
    else
        info "Not in a git repository, skipping pull"
    fi

    install_dotfiles
    run_installers
    setup_bin_path
    source_zsh_functions

    # Reload shell configuration
    if [ -n "$ZSH_VERSION" ]; then
        source ~/.zshrc 2>/dev/null || true
    elif [ -n "$BASH_VERSION" ]; then
        source ~/.bashrc 2>/dev/null || source ~/.bash_profile 2>/dev/null || true
    fi

    success "🎉 Dotfiles bootstrap complete!"
    info "To sync changes across machines, commit your changes and run ./bootstrap.sh on other machines"
}

# Parse command line arguments
SKIP_GIT=false
FORCE=false
OVERWRITE_ALL=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --force|-f)
            FORCE=true
            shift
            ;;
        --local|-l)
            SKIP_GIT=true
            shift
            ;;
        --overwrite-all|-o)
            OVERWRITE_ALL=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -f, --force           Skip confirmation prompt"
            echo "  -l, --local           Skip git operations (for local testing)"
            echo "  -o, --overwrite-all   Overwrite all existing files without prompting"
            echo "  -h, --help            Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Execute main function
if [[ "$FORCE" == "true" ]]; then
    main
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        main
    fi
fi