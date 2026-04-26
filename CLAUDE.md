# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A [chezmoi](https://www.chezmoi.io/) dotfiles repository managing configs across openSUSE Tumbleweed and Fedora (including Asahi). Nushell is the primary shell; all chezmoi scripts after the bootstrap (01) are written in nushell (`.nu.tmpl`).

## Repository layout

- `.chezmoiscripts/` — numbered `run_onchange_NN-*.nu.tmpl` scripts executed by chezmoi. Script 01 is bash (bootstraps nushell); 02+ are nushell.
- `.chezmoidata/packages.yaml` — declarative package list with per-distro overrides (`opensuse:` / `fedora:` blocks, `install: exclusive|ignore`).
- `.chezmoitemplates/` — Go-template fragments (e.g. systemd units) included by scripts.
- `.chezmoiexternal.toml.tmpl` — external archives/files (fonts, glide browser).
- `dot_config/` — config files, mapped to `~/.config/` by chezmoi. Prefix conventions: `private_` (0700), `executable_` (0755), `symlink_` (symlinks), `readonly_` (0444).
- `dot_local/bin/` — user scripts (`executable_*`), mapped to `~/.local/bin/`.
- `dot_local/share/applications/` — `.desktop` files.
- `dot_config/systemd/user/` — systemd user units and symlinks in target `.wants/` dirs.

## Key conventions

- **Chezmoi naming**: files use chezmoi prefixes (`dot_`, `executable_`, `private_`, `symlink_`, `readonly_`). A file at `dot_config/foo/bar` deploys to `~/.config/foo/bar`.
- **Templates**: `.tmpl` suffix means Go template. Access chezmoi data via `{{ .chezmoi.* }}` and custom data via `{{ .name }}`, `{{ .email }}`, etc.
- **Nushell interpreter**: `.chezmoi.toml.tmpl` registers `nu` as the interpreter for `.nu` scripts.
- **Script numbering**: scripts run in lexical order. Current range is 01–05. Use the next available number or a high number (e.g. 99) for "always run" scripts.
- **`run_onchange_` vs `run_every_`**: `run_onchange_` scripts include a hash comment (e.g. `# packages.yaml hash: {{ include ... | sha256sum }}`) and only re-run when that hash changes. For scripts that should run on every `chezmoi apply`, use `run_every_` prefix (no hash needed, but no `.tmpl` suffix needed either unless using template features).

## Commands

```bash
chezmoi apply          # apply dotfiles to home
chezmoi apply -n       # dry run
chezmoi diff           # show what would change
chezmoi edit <file>    # edit a managed file in the source dir
chezmoi add <file>     # add a new file to chezmoi management
chezmoi data           # show template data
```

## Managed applications (partial)

Hyprland (hypridle), foot, nushell, emacs, helix, waybar, yazi, rofi (if installed), kanata, beets, rmpc/mpd, qutebrowser, mako, swaylock, zathura, mango, broot, iamb.
