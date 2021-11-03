#
# .zshrc
# Written by Alexander Carter
#

#!/bin/zsh

autoload -Uz compinit vcs_info
compinit

# vcs integration
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' formats '  %b'

# prompt
# <cwd> <git_branch> <exit status> %
PROMPT='%~%B${vcs_info_msg_0_}%b %(?..%F{red}(%?%) )%#%f '

# zsh-autosuggestions
source /home/alex/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-completions
fpath=(/home/alex/.zsh/zsh-completions/src $fpath)
