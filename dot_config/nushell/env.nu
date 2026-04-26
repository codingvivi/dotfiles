# env.nu
#
# Installed by:
# version = "0.109.1"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

#let mise_path = $nu.default-config-dir | path join mise.nu
#^mise activate nu | str replace "export-env {" "" | prepend "export-env {" | save $mise_path --force

$env.EDITOR = "hx"

$env.GPG_TTY = (tty)
### XDG
$env.XDG_CONFIG_HOME = ($env.HOME | path join '.config')
$env.XDG_DATA_HOME = ($env.HOME | path join '.local/share')
$env.XDG_STATE_HOME = ($env.HOME | path join '.local/state')
$env.XDG_PICTURES_DIR = ($env.HOME | path join 'Pictures')
$env.XDG_DOCUMENTS_DIR = ($env.HOME | path join 'Documents')
### Personal base dirs
$env.VVG_FINANCE_DIR = ( $env.XDG_DOCUMENTS_DIR | path join 'Finance/')

### Tooling
# Rust
$env.CARGO_HOME = ($env.HOME | default '~/.cargo' | path join ".cargo")
# Go
$env.GOPATH = ($env.HOME | path join "go")
$env.GOBIN = ($env.HOME | path join "bin")

### Package managers
$env.HOMEBREW_PREFIX = '/home/linuxbrew/.linuxbrew'
$env.HOMEBREW_CELLAR = '/home/linuxbrew/.linuxbrew/Cellar'
$env.HOMEBREW_REPOSITORY = '/home/linuxbrew/.linuxbrew/Homebrew'

### Config vars
$env.GRIM_DEFAULT_DIR = ($env.XDG_PICTURES_DIR | path join 'Screenshots')

$env.SRC_HOME = ($env.HOME | path join 'code')
$env.QMK_HOME = ($env.SRC_HOME | path join "git.0x0.st/mia/qmk_firmware")


$env.HLEDGER_DIR = ( $env.VVG_FINANCE_DIR | path join 'hledger')
$env.LEDGER_FILE = ( $env.HLEDGER_DIR | path join 'all.journal')

# Personal script configs
$env.ORG_DIR = ($env.XDG_DOCUMENTS_DIR | path join 'org')
$env.ORG_DAILIES_DIR = ($env.ORG_DIR | path join 'daily')

$env.STATEMENT_DIR = ( $env.VVG_FINANCE_DIR | path join 'Statements')
