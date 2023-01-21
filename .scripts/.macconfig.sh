#!/usr/bin/env bash

alias brew="arch -arm64 brew"

# lsd (lsdeluxe)
alias ls="lsd"
alias la="ls -a"
alias lls="ls -la"
alias lt="ls -tree"

alias start_page="cd ~/Documents/development/startup-page && serve -s build -p 8000"

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

