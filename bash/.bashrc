#!/bin/bash
# .bashrc

alias_file=${HOME}/.aliases
[ -f "${alias_file}" ] && . "${alias_file}"

PROMPT_COMMAND=__prompt_command # Func to gen PS1 after CMDs

__prompt_command() {
	local EXIT="$?" # This needs to be first

	local reset='\[\e[0m\]'
	local bold='\[\e[1m\]'

	local bright_black='\[\e[0;90m\]'
	local red='\[\e[0;31m\]'

	PS1="\u${bright_black}@\h${reset} "

	PS1+="\W "

	# Git branch
	is_in_git_dir=$(git rev-parse --is-inside-work-tree 2> /dev/null)
	if [ "$is_in_git_dir" ]; then
		git_branch=$(git symbolic-ref --short HEAD)
		PS1+="${bold}${git_branch}${reset} "
	fi

	# Escape code in $
	if [ $EXIT != 0 ]; then
		PS1+="${red}(${EXIT}) "
	fi
	PS1+="\$${reset} "
}
