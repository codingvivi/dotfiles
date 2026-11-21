# Copy files to vivivault over SSH (rsync, as the `vivivault` host alias).
# Folders keep their own name on the server. Files that already exist there
# with the same size and date are skipped, so re-running is cheap.

const VIVIVAULT = "vivivault"

def "nu-complete kavita-libs" [] { [books comics manga] }

# rsync paths (files or folders, keeping their names) into one remote folder
def vivivault-rsync [paths: list<path>, dest: string, extra: list<string>, dry_run: bool] {
    for p in $paths {
        if not ($p | path exists) { error make {msg: $"not found: ($p)"} }
    }
    let srcs = $paths | each { path expand }    # no trailing slash: rsync copies the folder itself
    let flags = [-rt -s --mkpath --partial "--info=progress2,stats1" --human-readable] ++ $extra
    let flags = if $dry_run { $flags ++ [--dry-run --itemize-changes] } else { $flags }
    ^rsync ...$flags ...$srcs $"($VIVIVAULT):($dest)/"
}

# Upload books, comics or manga into a Kavita library on vivivault
#
# A folder becomes a series folder with its own name. Loose files need a series
# folder (Kavita ignores files at the top of a library): --series names it,
# otherwise each file gets a folder named after itself.
#
# Examples:
#   > books-up manga ~/Downloads/Berserk
#   > books-up manga 'Berserk v42.cbz' --series Berserk
#   > books-up books ~/Downloads/novel.epub
#   > books-up comics ~/Comics/* --dry-run
def books-up [
    library: string@"nu-complete kavita-libs"   # books, comics or manga
    ...paths: path                              # Files and/or folders
    --series(-s): string                        # Series folder for loose files
    --dry-run(-n)                               # Only show what would be copied
] {
    if $library not-in (nu-complete kavita-libs) { error make {msg: $"library must be one of (nu-complete kavita-libs | str join ', ')"} }
    if ($paths | is-empty) { error make {msg: "give at least one file or folder"} }

    let root = $"/tank/enc/books/($library)"
    let dirs = $paths | where { ($in | path type) == dir }
    let files = $paths | where { ($in | path type) != dir }

    if ($dirs | is-not-empty) { vivivault-rsync $dirs $root [] $dry_run }

    if ($files | is-not-empty) {
        if $series != null {
            vivivault-rsync $files $"($root)/($series)" [] $dry_run
        } else {
            for f in $files {
                vivivault-rsync [$f] $"($root)/($f | path parse | get stem)" [] $dry_run
            }
        }
    }
    if not $dry_run { print $"done, Kavita picks it up within a minute \(or Scan Library\)" }
}

# Upload camera RAWs to /tank/enc/photos/raw on vivivault, skipping JPEGs
#
# Folders keep their name; empty folders (e.g. ones that held only JPEGs) are
# not created. Existing files on the server are never overwritten.
#
# Examples:
#   > raw-up ~/Pictures/2026-11-21_berlin
#   > raw-up DSC01234.ARW DSC01235.ARW --into 2026/berlin
#   > raw-up /run/media/$env.USER/SD/DCIM/100MSDCF --dry-run
def raw-up [
    ...paths: path          # Files and/or folders
    --into(-i): string      # Subfolder under photos/raw, e.g. 2026/berlin
    --dry-run(-n)           # Only show what would be copied
] {
    if ($paths | is-empty) { error make {msg: "give at least one file or folder"} }
    let dest = if $into == null { "/tank/enc/photos/raw" } else { $"/tank/enc/photos/raw/($into | str trim -c '/')" }
    let skip_jpeg = [
        --exclude '*.[jJ][pP][gG]' --exclude '*.[jJ][pP][eE][gG]'
        --prune-empty-dirs --ignore-existing
    ]
    vivivault-rsync $paths $dest $skip_jpeg $dry_run
}
