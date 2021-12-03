#!/bin/sh
#
# .zshenv
# Written by Alexander J Carter
#

export TERM=alacritty
export EDITOR=kak
export VISUAL=kak
export LESSHISTFILE=/dev/null                     # don't save less history
export HISTCONTROL=ignoredups:erasedups           # no duplicate entries

# fzf
command -v fzf > /dev/null && {
	export FZF_DEFAULT_OPTS="--layout=reverse --color=bg+:-1"
	export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
	export FZF_CTRL_T_OPTS="--preview '(bat --color=always --style=numbers {} 2>/dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
}

# bat
command -v bat> /dev/null && {
	export BAT_THEME="Solarized (dark)"
}

## set executable path

PATH=${HOME}/.local/bin:$PATH

scripts_path=${HOME}/.scripts
[ -d "$scripts_path" ] && PATH="$scripts_path:$PATH"
