#!/usr/bin/env bash

ascii_dir=~/dotfiles/ascii
if [ -d "$ascii_dir" ]; then
    ascii_script=$(find "$ascii_dir" -type f | shuf -n 1)
    if [ -n "$ascii_script" ]; then
        chmod +x "$ascii_script" 2>/dev/null
        "$ascii_script"
    else
        echo "No files found in $ascii_dir."
    fi
else
    echo "ASCII script directory not found: $ascii_dir"
fi


month=`date +%B`
day=`date +%d`
time=`date +"%I:%M %p"`
echo -e " \033[0;34m $month $day, $time \033[0;35m | \"Either write something worth reading or do something worth writing.\" \033[0;33m - Benjamin Franklin"

# general
alias v="vim ~/.vimrc"
alias z="vim ~/.zshrc"
alias s="vim ~/.config/scripts"
alias c="clear"
alias reload="source ~/.zshrc"
alias myip="curl http://ipecho.net/plain; echo"
alias hs="history | grep"
