#!/bin/zsh
#
# .zprofile
# Written by Alexander Carter
#
# FIXME: If the programs below have already been installed somewhere like
# /usr/share by the package manager, this script will redundantly install
# them anyway.

install_zsh_autosuggestions=true
install_zsh_completions=true

# installs zsh-autosuggestions if it is not installed already
[ $install_zsh_autosuggestions ] && {
	zsh_auto_dir="${HOME}/.local/share/zsh/zsh-autosuggestions"
	zsh_auto_src="${zsh_auto_dir}/zsh-autosuggestions.zsh"
	[ -d "$zsh_auto_dir" ] || \
		git clone "https://github.com/zsh-users/zsh-autosuggestions" "$zsh_auto_dir" > /dev/null

	[ -d "$zsh_auto_dir" ] && \
		grep "source ${zsh_auto_src}" "${ZDOTDIR-$HOME}/.zshrc" > /dev/null || \
		printf "\n# zsh-autosuggestions\nsource %s\n" "${zsh_auto_src}" >> "${ZDOTDIR-$HOME}/.zshrc"
}

# installs zsh-completions if it is not installed already
[ $install_zsh_completions ] && {
	zsh_compl_dir="${HOME}/.local/share/zsh/zsh-completions"
	zsh_compl_src="${zsh_compl_dir}/src"
	zsh_compl_fpath="fpath=(${zsh_compl_src} \$fpath)"
	[ -d "$zsh_compl_dir" ] || \
		git clone "https://github.com/zsh-users/zsh-completions.git" "$zsh_compl_dir" > /dev/null

	[ -d "$zsh_compl_dir" ] && \
		grep "${zsh_compl_fpath}" "${ZDOTDIR-$HOME}/.zshrc" > /dev/null || \
		printf "\n# zsh-completions\n%s\n" "${zsh_compl_fpath}" >> "${ZDOTDIR-$HOME}/.zshrc"
}
