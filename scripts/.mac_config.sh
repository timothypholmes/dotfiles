#!/usr/bin/env bash

# alias
alias icloud="~/Library/Mobile\ Documents/com~apple~CloudDocs/"
alias brew="arch -arm64 brew"

# lsd (lsdeluxe)
alias ls="lsd"
alias la="ls -a"
alias lls="ls -la"
alias lt="ls -tree"

function set_wallpaper() {
    cd ~/Pictures/wallpapers
    ls |sort -R |tail -1 |while read file; do
    osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$PWD/$file\""
    done
    cd -
}

function confetti() {
    open raycast://confetti
}
