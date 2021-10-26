declare-option -hidden str copycmd
declare-option -hidden str pastecmd
evaluate-commands %sh{
	case $(uname) in
		Linux|FreeBSD|OpenBSD)
			if [[ -n $WAYLAND_DISPLAY ]] && command -v wl-copy > /dev/null; then
				copy="wl-copy > /dev/null 2>&1 &"
				paste="wl-paste -n"
			elif [[ -n $DISPLAY ]] && command -v xclip > /dev/null; then
				copy="xclip -i -selection clipboard >&- 2>&-"
				paste="xclip -o -selection clipboard"
			elif [[ -n $DISPLAY ]] && command -v xsel > /dev/null; then
					copy="xsel --input --clipboard"
					paste="xsel --output --clipboard"
			fi
			;;
		Darwin)
			if command -v pbcopy > /dev/null; then
				copy="pbcopy"
				paste="pbpaste"
			fi
			;;
	esac

	# Checks if copy is set then sets option
	if [[ -n $copy ]]; then
		printf "set-option global copycmd \'%s\'\n" "$copy"
	fi

	# Checks if paste is set then sets options and keybindings
	if [[ -n $paste ]]; then
		printf "set-option global pastecmd \'%s\'\n" "$paste"
		printf "map global normal P \'!%s<ret>\'\n" "$paste"
		printf "map global normal p \'<a-!>%s<ret>\'\n" "$paste"
	fi
}

# Sets contents of register " to be piped into copycmd
hook global RegisterModified '"' %{ nop %sh{
	if [[ -n $kak_opt_copycmd ]]; then
		printf %s "$kak_main_reg_dquote" | (eval $kak_opt_copycmd) >/dev/null 2>&1 &
	fi
}}
