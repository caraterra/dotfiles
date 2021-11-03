#!/bin/zsh
# TODO: Replace ${HOME}/.zshrc with zshrc env var
# TODO: Replace ${HOME}/.zsh with zsh configuration dir

# installs zsh-autosuggestions if it is not installed already
zsh_auto_dir="${HOME}/.zsh/zsh-autosuggestions"
zsh_auto_src="${zsh_auto_dir}/zsh-autosuggestions.zsh"
[ -d "$zsh_auto_dir" ] || \
	git clone "https://github.com/zsh-users/zsh-autosuggestions" "$zsh_auto_dir" > /dev/null;

[ -d "$zsh_auto_dir" ] && \
	grep "source ${zsh_auto_src}" "${HOME}/.zshrc" > /dev/null || \
	printf "\n# zsh-autosuggestions\nsource %s\n" "${zsh_auto_src}" >> "${HOME}/.zshrc"

# installs zsh-completions if it is not installed already
zsh_compl_dir="${HOME}/.zsh/zsh-completions"
zsh_compl_src="${zsh_compl_dir}/src"
zsh_compl_fpath="fpath=(${zsh_compl_src} \$fpath)"
[ -d "$zsh_compl_dir" ] || \
	git clone "https://github.com/zsh-users/zsh-completions.git" "$zsh_compl_dir" > /dev/null

[ -d "$zsh_compl_dir" ] && \
	grep "${zsh_compl_fpath}" "${HOME}/.zshrc" > /dev/null || \
	printf "\n# zsh-completions\n%s\n" "${zsh_compl_fpath}" >> "${HOME}/.zshrc"
