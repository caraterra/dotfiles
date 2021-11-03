#
# .zshenv
# Written by Alexander J Carter
#

#!/bin/sh

export TERM=alacritty
export EDITOR=kak
export VISUAL=kak
export LESSHISTFILE=/dev/null                     # don't save less history
export HISTCONTROL=ignoredups:erasedups           # no duplicate entries

## set executable path

PATH=${HOME}/.local/bin:$PATH

scripts_path=${HOME}/.scripts
if [ -d $scripts_path ]; then
	PATH=$scripts_path:$PATH
fi

## rust

. "$HOME/.cargo/env" &> /dev/null

