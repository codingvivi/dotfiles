$env.config.table.mode = "none"
$env.config.edit_mode = 'vi'
$env.config.render_right_prompt_on_last_line = false
$env.PROMPT_INDICATOR_VI_INSERT = {|| " \n** > " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| " \nRW > " }

$env.config.cursor_shape = {
    vi_insert: block
    vi_normal: block
}

let fish_completer = {|spans|
    fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {|row|
      let value = $row.value
      let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
      if ($need_quote and ($value | path exists)) {
        let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
        $'"($expanded_path | str replace --all "\"" "\\\"")"'
      } else {$value}
    }
}

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | any {|| $in.display | str starts-with "ERR"}) { null } else { $in }
}

# This completer will use carapace by default
let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -o 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        # carapace completions are incorrect for nu
        nu => $fish_completer
        # fish completes commits and branch names in a nicer way
        git => $fish_completer
        # carapace doesn't have completions for asdf
        #asdf => $fish_completer
        # _ => $carapace_completer #too slow, cumon step it up!
        _ => $fish_completer
    } | do $in $spans
}

$env.config = {
    # ...
    completions: {
        external: {
            enable: true
            completer: $external_completer
        }
    }
    # ...
}

