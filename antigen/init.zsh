#-- START ZCACHE GENERATED FILE
#-- GENERATED: Wed Aug 13 04:55:18 AM CEST 2025
#-- ANTIGEN v2.2.2
_antigen () {
	local -a _1st_arguments
	_1st_arguments=('apply:Load all bundle completions' 'bundle:Install and load the given plugin' 'bundles:Bulk define bundles' 'cleanup:Clean up the clones of repos which are not used by any bundles currently loaded' 'cache-gen:Generate cache' 'init:Load Antigen configuration from file' 'list:List out the currently loaded bundles' 'purge:Remove a cloned bundle from filesystem' 'reset:Clears cache' 'restore:Restore the bundles state as specified in the snapshot' 'revert:Revert the state of all bundles to how they were before the last antigen update' 'selfupdate:Update antigen itself' 'snapshot:Create a snapshot of all the active clones' 'theme:Switch the prompt theme' 'update:Update all bundles' 'use:Load any (supported) zsh pre-packaged framework') 
	_1st_arguments+=('help:Show this message' 'version:Display Antigen version') 
	__bundle () {
		_arguments '--loc[Path to the location <path-to/location>]' '--url[Path to the repository <github-account/repository>]' '--branch[Git branch name]' '--no-local-clone[Do not create a clone]'
	}
	__list () {
		_arguments '--simple[Show only bundle name]' '--short[Show only bundle name and branch]' '--long[Show bundle records]'
	}
	__cleanup () {
		_arguments '--force[Do not ask for confirmation]'
	}
	_arguments '*:: :->command'
	if (( CURRENT == 1 ))
	then
		_describe -t commands "antigen command" _1st_arguments
		return
	fi
	local -a _command_args
	case "$words[1]" in
		(bundle) __bundle ;;
		(use) compadd "$@" "oh-my-zsh" "prezto" ;;
		(cleanup) __cleanup ;;
		(update|purge) compadd $(type -f \-antigen-get-bundles &> /dev/null || antigen &> /dev/null; -antigen-get-bundles --simple 2> /dev/null) ;;
		(theme) compadd $(type -f \-antigen-get-themes &> /dev/null || antigen &> /dev/null; -antigen-get-themes 2> /dev/null) ;;
		(list) __list ;;
	esac
}
antigen () {
  local MATCH MBEGIN MEND
  [[ "$ZSH_EVAL_CONTEXT" =~ "toplevel:*" || "$ZSH_EVAL_CONTEXT" =~ "cmdarg:*" ]] && source "/home/sisa/.antigen/antigen.zsh" && eval antigen $@;
  return 0;
}
typeset -gaU fpath path
fpath+=(/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/git /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/ssh /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/ssh-agent /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/ufw /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/cp /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/sudo /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/history /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/archlinux /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/aliases /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/tailscale /home/sisa/.antigen/bundles/zsh-users/zsh-autosuggestions /home/sisa/.antigen/bundles/zsh-users/zsh-syntax-highlighting /home/sisa/.antigen/bundles/zsh-users/zsh-history-substring-search) path+=(/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/git /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/ssh /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/ssh-agent /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/ufw /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/cp /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/sudo /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/history /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/archlinux /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/aliases /home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/tailscale /home/sisa/.antigen/bundles/zsh-users/zsh-autosuggestions /home/sisa/.antigen/bundles/zsh-users/zsh-syntax-highlighting /home/sisa/.antigen/bundles/zsh-users/zsh-history-substring-search)
_antigen_compinit () {
  autoload -Uz compinit; compinit -d "/home/sisa/.antigen/.zcompdump"; compdef _antigen antigen
  add-zsh-hook -D precmd _antigen_compinit
}
autoload -Uz add-zsh-hook; add-zsh-hook precmd _antigen_compinit
compdef () {}

if [[ -n "/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh" ]]; then
  ZSH="/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh"; ZSH_CACHE_DIR="/home/sisa/.cache/zsh"
fi
#--- BUNDLES BEGIN
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/async_prompt.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/bzr.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/clipboard.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/cli.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/compfix.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/completion.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/correction.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/diagnostics.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/directories.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/functions.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/git.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/grep.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/history.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/key-bindings.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/misc.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/nvm.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/prompt_info_functions.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/spectrum.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/termsupport.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/theme-and-appearance.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/vcs_info.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/git/git.plugin.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/ssh/ssh.plugin.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/ssh-agent/ssh-agent.plugin.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/cp/cp.plugin.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/sudo/sudo.plugin.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/history/history.plugin.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/archlinux/archlinux.plugin.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/aliases/aliases.plugin.zsh';
source '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/tailscale/tailscale.plugin.zsh';
source '/home/sisa/.antigen/bundles/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh';
source '/home/sisa/.antigen/bundles/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh';
source '/home/sisa/.antigen/bundles/zsh-users/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh';

#--- BUNDLES END
typeset -gaU _ANTIGEN_BUNDLE_RECORD; _ANTIGEN_BUNDLE_RECORD=('https://github.com/robbyrussell/oh-my-zsh.git lib plugin true' 'https://github.com/robbyrussell/oh-my-zsh.git plugins/git plugin true' 'https://github.com/robbyrussell/oh-my-zsh.git plugins/ssh plugin true' 'https://github.com/robbyrussell/oh-my-zsh.git plugins/ssh-agent plugin true' 'https://github.com/robbyrussell/oh-my-zsh.git plugins/ufw plugin true' 'https://github.com/robbyrussell/oh-my-zsh.git plugins/cp plugin true' 'https://github.com/robbyrussell/oh-my-zsh.git plugins/sudo plugin true' 'https://github.com/robbyrussell/oh-my-zsh.git plugins/history plugin true' 'https://github.com/robbyrussell/oh-my-zsh.git plugins/archlinux plugin true' 'https://github.com/robbyrussell/oh-my-zsh.git plugins/aliases plugin true' 'https://github.com/robbyrussell/oh-my-zsh.git plugins/tailscale plugin true' 'https://github.com/zsh-users/zsh-autosuggestions.git / plugin true' 'https://github.com/zsh-users/zsh-syntax-highlighting.git / plugin true' 'https://github.com/zsh-users/zsh-history-substring-search.git / plugin true')
typeset -g _ANTIGEN_CACHE_LOADED; _ANTIGEN_CACHE_LOADED=true
typeset -ga _ZCACHE_BUNDLE_SOURCE; _ZCACHE_BUNDLE_SOURCE=('/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/async_prompt.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/bzr.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/clipboard.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/cli.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/compfix.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/completion.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/correction.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/diagnostics.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/directories.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/functions.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/git.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/grep.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/history.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/key-bindings.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/misc.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/nvm.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/prompt_info_functions.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/spectrum.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/termsupport.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/theme-and-appearance.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/lib/vcs_info.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/git' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/git/git.plugin.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/ssh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/ssh/ssh.plugin.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/ssh-agent' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/ssh-agent/ssh-agent.plugin.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/ufw' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/cp' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/cp/cp.plugin.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/sudo' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/sudo/sudo.plugin.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/history' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/history/history.plugin.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/archlinux' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/archlinux/archlinux.plugin.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/aliases' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/aliases/aliases.plugin.zsh' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/tailscale' '/home/sisa/.antigen/bundles/robbyrussell/oh-my-zsh/plugins/tailscale/tailscale.plugin.zsh' '/home/sisa/.antigen/bundles/zsh-users/zsh-autosuggestions//' '/home/sisa/.antigen/bundles/zsh-users/zsh-autosuggestions///zsh-autosuggestions.plugin.zsh' '/home/sisa/.antigen/bundles/zsh-users/zsh-syntax-highlighting//' '/home/sisa/.antigen/bundles/zsh-users/zsh-syntax-highlighting///zsh-syntax-highlighting.plugin.zsh' '/home/sisa/.antigen/bundles/zsh-users/zsh-history-substring-search//' '/home/sisa/.antigen/bundles/zsh-users/zsh-history-substring-search///zsh-history-substring-search.plugin.zsh')
typeset -g _ANTIGEN_CACHE_VERSION; _ANTIGEN_CACHE_VERSION='v2.2.2'

#-- END ZCACHE GENERATED FILE
