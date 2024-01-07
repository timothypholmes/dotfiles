#!/bin/bash

# deploy.sh
# Script is used to move files from dotfile repo to final destination
# to be read into by the system. 

copy_with_status () {
    local source="$1"
    local destination="$2"

    # Check for errors before copying
    if [[ ! -e "$source" ]]; then
        echo "Error: Source file '$source' does not exist."
        return 1
    fi

    if [[ -e "$destination" ]]; then
        read -p "Destination file '$destination' already exists. Overwrite? (y/n) " overwrite
        if [[ $overwrite != "y" ]]; then
            echo "Skipping copy."
            return 0
        fi
    fi

    # Perform the copy
    cp -r "$source" "$destination"

    # Check and print the copy status
    if [[ $? -eq 0 ]]; then
        echo "File copied successfully to '$destination'."
    else
        echo "Error: Failed to copy file to '$destination'."
    fi
}

echo "moving files from dotfile repo to destination"
copy_with_status .vimrc ~/.vimrc
copy_with_status .zshrc ~/.zshrc
copy_with_status starship.toml ~/.config/starship.toml
copy_with_status ./scripts ~/.config

if [[ $OSTYPE == 'darwin'* ]]; then
    copy_with_status settings.json. /Users/$USER/Library/Application\ Support/Code/User/settings.json
fi

echo "done copying"