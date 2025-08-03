# Dotfiles

![](https://i.imgur.com/SuN8gKt.png)

A modern, topic-based dotfiles management system with automatic syncing and symlink management across multiple machines.

## Quick Start

### First-time setup on a new machine:

```bash
# Clone your dotfiles
git clone https://github.com/timothypholmes/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run the bootstrap script
./bootstrap.sh
```

### Daily usage:

```bash
# Update dotfiles on current machine (pulls latest + deploys)
./bootstrap.sh

# Force update without prompts
./bootstrap.sh --force
```

## How It Works

### Directory Structure
```
dotfiles/
├── bootstrap.sh              # Main deployment script
├── topics/                   # Topic-based configuration
│   ├── zsh/
│   │   ├── zshrc.symlink    # → ~/.zshrc
│   │   └── install.sh       # ZSH setup automation
│   ├── vim/
│   │   ├── vimrc.symlink    # → ~/.vimrc
│   │   └── install.sh       # Vim plugins setup
│   ├── vscode/
│   │   ├── settings.json.symlink  # → VSCode settings
│   │   └── install.sh       # Extensions installation
│   ├── starship/
│   │   ├── starship.toml.symlink  # → ~/.config/starship.toml
│   │   └── install.sh       # Starship installation
│   └── ghostty/
│       ├── config.symlink   # → ~/.config/ghostty/config
│       └── install.sh       # Ghostty setup
├── homebrew/
│   └── install.sh           # Homebrew packages & casks
├── bin/                     # Scripts added to PATH
├── macos/                   # macOS system defaults
└── firefox/                 # Firefox customization
    ├── sidebery.css
    └── userChrome.css
```

### Symlink Convention
Files ending in `.symlink` get automatically linked to your home directory:
- `zshrc.symlink` → `~/.zshrc`
- `vimrc.symlink` → `~/.vimrc`
- `settings.json.symlink` → `~/Library/Application Support/Code/User/settings.json` (macOS)

### Topic Install Scripts
Each topic can have an `install.sh` script that runs during bootstrap to:
- Install dependencies
- Setup plugins
- Configure applications

## Multi-Machine Workflow

### Making changes:
1. Edit files directly in your dotfiles repo
2. Commit and push changes: `git add . && git commit -m "Update config" && git push`
3. On other machines, run: `./bootstrap.sh`

### The magic:
- **Symlinks** mean changes appear instantly in your repo
- **Bootstrap script** pulls latest changes and deploys them
- **No manual copying** between machines needed

## What Gets Installed

### Automatic Installations
- **Oh My Zsh** + plugins (syntax highlighting, autosuggestions, etc.)
- **Vim plugins** via Vundle
- **Starship prompt**
- **VSCode extensions**
- **Homebrew packages** (see `homebrew/install.sh`)

### Configurations Managed
- Shell configuration (Zsh)
- Terminal prompt (Starship)
- Text editor (Vim)
- Code editor (VSCode)
- Terminal emulator (Ghostty)
- System preferences (macOS)

## Customization

### Adding a new topic:
1. Create directory: `mkdir topics/newtopic`
2. Add config file: `topics/newtopic/config.symlink`
3. Add installer: `topics/newtopic/install.sh` (optional)
4. Run: `./bootstrap.sh`

### Adding packages:
Edit `homebrew/install.sh` and add packages to the arrays, then run `./bootstrap.sh`

## Advanced Usage

### Environment-specific configs:
Create machine-specific configs that won't be synced:
- `~/.extra` - Extra shell commands (sourced by zshrc)
- `~/.gitconfig.local` - Local git configuration

### Manual installations:

#### Firefox Setup
1. Paste `firefox/sidebery.css` into Sidebery extension styles
2. Paste `firefox/userChrome.css` into Firefox profile's `chrome/userChrome.css`

#### Homebrew (if not auto-installed):
```bash
./homebrew/install.sh
```

## Multi-Machine Setup Example

```bash
# Work Mac
cd ~/dotfiles
# Make changes to configs...
git commit -am "Update work settings"
git push

# Personal MacBook
cd ~/dotfiles
./bootstrap.sh  # Pulls changes and updates configs

# Mac Mini
cd ~/dotfiles  
./bootstrap.sh  # Same configs everywhere!
```

---

*Inspired by [Mathias Bynens](https://github.com/mathiasbynens/dotfiles) and [Zach Holman](https://github.com/holman/dotfiles) dotfiles approaches.*