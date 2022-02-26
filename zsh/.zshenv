#!/bin/zsh
#
# .zshenv
# Written by Alexander J Carter
#

export TERM=alacritty
export EDITOR=kak
export VISUAL=kak
export LESSHISTFILE=/dev/null                     # don't save less history
export HISTCONTROL=ignoredups:erasedups           # no duplicate entries

## set executable path
PATH="${HOME}/.local/bin:$PATH"

scripts_path=${HOME}/.scripts
[ -d "$scripts_path" ] && PATH="$scripts_path:$PATH"
