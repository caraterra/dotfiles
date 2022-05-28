#!/bin/zsh
# .zshenv

export EDITOR=kak
export LESSHISTFILE=/dev/null            # don't save less history
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries

## set executable path
PATH="${HOME}/.local/bin:$PATH"
