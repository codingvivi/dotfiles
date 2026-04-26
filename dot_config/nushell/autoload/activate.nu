export def main [] {
 help activate
}

export def "activate mise" [] {
 mise activate nu | save -f $"($env.local-autoload-dir)/mise.nu"
}

export def --wrapped "activate zoxide" [...rest] {
 zoxide init ...$rest nushell  | save -f $"($env.local-autoload-dir)/zoxide.nu"
}
