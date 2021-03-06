#!/bin/zsh
#
# .zshrc
# Written by Alexander Carter
#

source ~/.aliases

autoload -Uz compinit vcs_info
compinit

# vcs integration
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' formats ' %b'

# prompt
# <cwd> <git_branch> <exit status> %
PROMPT='%3~%B${vcs_info_msg_0_}%b %(?..%F{red}(%?%) )%#%f '

# edit commands in editor
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# zsh-autosuggestions
source /home/alex/.local/share/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-completions
fpath=(/home/alex/.local/share/zsh/zsh-completions/src $fpath)
