#!/usr/bin/env bash
# Setup script for setting up a new macos machine

echo "Creating an SSH key for you..."
ssh-keygen -t rsa

echo "Please add this public key to Github \n"
echo "https://github.com/account/ssh \n"
read -p "Press [Enter] key after this..."

echo "Installing xcode-stuff"
xcode-select --install

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update


# GNU utilities and tools
brew install coreutils
brew install gnu-sed
brew install gnu-tar
brew install gnu-indent
brew install gnu-which

brew install findutils

export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"

echo "Installing Git..."
brew install git

echo "Git config"

git config --global user.name "Timothy Holmes"
git config --global user.email tpholmes7@gmail.com

brew install wget
brew install node

echo "Cleaning up brew"
brew cleanup

echo "Copying dotfiles from Github"
cd ~
git clone git@github.com:bradp/dotfiles.git .dotfiles
cd .dotfiles
sh symdotfiles

#Install Zsh & Oh My Zsh
echo "Installing Oh My ZSH..."
curl -L http://install.ohmyz.sh | sh

echo "Installing packages..."

PACKAGES=(
    docker 
    docker-machine
)
brew install ${PACKAGES[@]}

echo "Installing cask..."

CASKS=(
    iterm2
    adobe-acrobat-reader
    slack
    spotify
    visual-studio-code
    filezilla
)

echo "Installing cask apps..."
brew cask install ${CASKS[@]}

#"Setting screenshot format to PNG"
defaults write com.apple.screencapture type -string "png"

killall Finder

echo "Done!"