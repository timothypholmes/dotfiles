#!/usr/bin/env bash
# Setup script for setting up a new macos machine

# local vars
HOME_ZPROFILE="$HOME/.zprofile"
HOME_ZSHRC="$HOME/.zshrc"
UNAME_MACHINE="$(/usr/bin/uname -m)"


#echo "Creating an SSH key for you..."
#ssh-keygen -t rsa

#echo "Please add this public key to Github \n"
#echo "https://github.com/account/ssh \n"
#read -p "Press [Enter] key after this..."

echo "Installing xcode-stuff"
xcode-select --install

# Check for Homebrew, install if not installed
if test ! $(which brew); then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo "Added Homebrew shell to ${HOME_ZPROFILE}."
  echo '# Add Homebrew support' >> ${HOME_ZPROFILE}

  # load shellenv for Apple Silicon
  if [[ "${UNAME_MACHINE}" == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ${HOME_ZPROFILE}
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  # add autocomplete for brew
  echo 'FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"' >> ${HOME_ZPROFILE}
fi

# update homebrew recipes
echo "Updating homebrew..."
brew update

# install vim packages
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

vim +PluginInstall +qall

# spaceship
npm install -g spaceship-prompt

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
git clone https://github.com/timothypholmes/dotfiles.git
cd .dotfiles

#Install Zsh & Oh My Zsh
echo "Installing Oh My ZSH..."
curl -L http://install.ohmyz.sh | sh

echo "Installing packages..."

PACKAGES=(
    bat
    cario
    cmake
    curl
    docker 
    docker-machine
    gcc
    git
    mysql
    node
    numpy
    php
    poppler
    poppler-qt5
    qt
    r
    sqlite
)
brew install ${PACKAGES[@]}

echo "Installing cask..."

CASKS=(
    adobe-acrobat-reader
    bitwarden
    chatgpt
    cyberduck
    discord
    firefox
    ghostty
    insomnia
    jordanbaird-ice
    monitorcontrol
    obsidian
    raycast
    shottr
    slack
    syncthing
    spotify
    tableplus
    visual-studio-code
)

echo "Installing cask apps..."
brew install --cask ${CASKS[@]}

echo "setting MacOS settings"

# automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# hide icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false

# show all filename extensions in finder by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# use column view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle Clmv

# show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# show file path in title
defaults write com.apple.finder _FXShowPosixPathInTitle -boolean true

# avoiding the creation of .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# hide the donate message
defaults write org.m0k.transmission WarningDonate -bool false

# hide the legal disclaimer
defaults write org.m0k.transmission WarningLegal -bool false

# setting screenshot format to png
defaults write com.apple.screencapture type -string "png"

# setting screenshots location to ~/Pictures/screenshots
mkdir ~/Pictures/screenshots
defaults write com.apple.screencapture location ~/Pictures/screenshots && killall SystemUIServer

killall Finder

echo "Done!"
