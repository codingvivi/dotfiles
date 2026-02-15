# config.nu
#
# Installed by:
# version = "0.109.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

use std/util "path add"

path add ($env.GO_HOME | path join "bin")
path add ($env.HOMEBREW_PREFIX | path join "bin")
path add ($env.HOMEBREW_PREFIX | path join "sbin")
#$env.MANPATH = ($env.MANPATH? | default [] | append '/home/linuxbrew/.linuxbrew/share/man' | uniq)
#$env.INFOPATH = ($env.INFOPATH? | default [] | append '/home/linuxbrew/.linuxbrew/share/info' | uniq)
# 
#path add ($env.)

$env.DOTFILE_REPO = ($env.HOME | path join '.dotfile-repo')
def --wrapped  dotfiles [...rest] {
    git --git-dir=($env.DOTFILE_REPO) --work-tree=($env.HOME) ...$rest
}

$env.CHEZMOI_HOME = ($env.XDG_DATA_HOME | path join 'chezmoi')
alias chezmoi-cd = cd $env.CHEZMOI_HOME

alias fzfgo = cd (fzf)
alias fzfcb =  wl-copy (fzf)
alias mydl = deadline42 25-11-24 
alias francinette = bash -c $'($env.HOME)/francinette/tester.sh'
alias paco = francinette 

alias gognl = cd ($env.HOME | path join 'src/github.com/codingvivi/42_get_next_line')
#alias ghq = mise exec ghq

alias keepassxc-cli = flatpak run --command=keepassxc-cli org.keepassxc.KeePassXC
alias kp = flatpak run --command=keepassxc-cli org.keepassxc.KeePassXC

#alias ghq = mise use ghq

def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	^yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

def tstmp [] {
    date now | format date "%Y-%m-%dT%H:%M:%S"
}

mkdir ($nu.data-dir | path join "vendor/autoload")
#starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

$env.local-autoload-dir = ($nu.data-dir | path join "vendor/autoload")

#const NU_PLUGIN_DIRS = [
#    ($nu.config-path | path dirname | path join 'scripts')
#]
#source activate.nu
source appearance.nu

use ($env.HOME | path join '.config/broot/launcher/nushell/br') *
