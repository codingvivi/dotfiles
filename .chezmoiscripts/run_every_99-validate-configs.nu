#!/usr/bin/env nu

# Validate installed application configs after chezmoi apply.

print "── validating configs ──────────────────────────────"

# ── rofi ──────────────────────────────────────────────────────────────────────

match [(which rofi | is-not-empty) (glob ~/.config/rofi/**/*.rasi | is-not-empty)] {
    [false _] => { print "  rofi: not installed, skipping" }
    [_ false] => { print "  rofi: no .rasi files found, skipping" }
    _ => {
        let results = glob ~/.config/rofi/**/*.rasi | each {|file|
            try {
                ^rofi -rasi-validate $file
                print $"  rofi: ✓ ($file)"
                true
            } catch {|e|
                print $"  rofi: ✗ ($file) — ($e.msg)"
                false
            }
        }
        match ($results | all {|r| $r }) {
            true => {print "rofi: all rasi configs valid"}
            false  => {
                let version = rofi -version
                try {
                    $version
                    | rg "2.0.0"
                    | print "Your rofi version has a buggy config checker so you might ignore these errors"
                }
            }
        }
    }
}

print "── config validation done ──────────────────────────"
