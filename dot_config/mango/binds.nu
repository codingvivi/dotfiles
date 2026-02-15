def main [] {
  help binds   
}

def "main mode switch" [mode:string] {
  let lastmode = (mmsg -b | split words | last) 
  mmsg -d $"setkeymode,($mode)"
  notify-send -c "wm-mode" -t 700 $mode -h string:x-canonical-private-synchronous:wm-mode
  match [$lastmode $mode] {
    ["default" "default"] => {}
    ["default" _ ] => { mmsg -d toggle_render_border }
    [_ "default"] => { mmsg -d toggle_render_border }
    [_ _] => {}
  }
}

# def "main focus-or-open" [] {
#   
# }
