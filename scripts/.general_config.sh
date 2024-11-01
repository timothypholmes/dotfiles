#!/usr/bin/env bash

echo "\033[0;34m
                      .   *        .       .
       *      -0-
          .                .  *       - )-
       .      *       o       .       *
 o                |
           .     -O-
.                 |        *      .     -0-
       *  o     .    '       *      .        o
              .         .        |      *
   *             *              -O-          .
         .             *         |     ,
                .           o
        .---.
  =   _/__~0_\_     .  *            o       '
 = = (_________)             .
                 .                        *
       *               - ) -       *
              .               ."

month=`date +%B`
day=`date +%d`
time=`date +"%I:%M %p"`
echo -e " \033[0;34m $month $day, $time \033[0;35m | \"Experience is the teacher of all things.\" \033[0;33m - Julius Caesar"

# general
alias v="vim ~/.vimrc"
alias z="vim ~/.zshrc"
alias s="vim ~/.config/scripts"
alias c="clear"
alias reload="source ~/.zshrc"
alias myip="curl http://ipecho.net/plain; echo"
alias hs="history | grep"
