#!/bin/bash
# .bash_profile

export EDITOR=kak
export LESSHISTFILE=/dev/null            # don't save less history
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries

## set executable path
PATH=${HOME}/.local/bin:$PATH

## shopt
shopt -s autocd # change to named directory
shopt -s expand_aliases # expand aliases
shopt -s checkwinsize # checks term size when bash regains control

# source .bashrc
[ -f "${HOME}/.bashrc" ] && . "${HOME}/.bashrc"

