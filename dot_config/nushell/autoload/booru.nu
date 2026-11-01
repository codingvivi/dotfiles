# Upload files and/or folders to the oxibooru on vivivault
#
# Folders are searched recursively for images and videos. Content the booru
# already has counts as a duplicate, not a failure. Auth is read from
# ~/.config/oxibooru/auth (or $env.OXI_AUTH_FILE) as `username:token`.
#
# Examples:
#   > booru-up drawing.png
#   > booru-up ~/Pictures/memes --tags [meme]
#   > booru-up ~/Downloads/art scan.jpg --safety sketchy --delete
def booru-up [
    ...paths: path                          # Files and/or folders
    --tags(-t): list<string> = []           # Tags for every post, e.g. [meme] or [photo]
    --safety(-s): string = "safe"           # safe, sketchy or unsafe
    --source: string                        # Source URL for every post
    --delete(-d)                            # Delete each local file once the booru has it (i.e. move)
    --url: string = "http://10.10.10.1:8080"
] {
    if ($paths | is-empty) { error make {msg: "give at least one file or folder"} }
    if $safety not-in [safe sketchy unsafe] { error make {msg: $"invalid safety '($safety)'"} }

    let auth_file = ($env.OXI_AUTH_FILE? | default ($env.HOME | path join '.config/oxibooru/auth'))
    if not ($auth_file | path exists) { error make {msg: $"missing ($auth_file), it should contain username:token"} }
    let auth = $"Authorization: Token (open --raw $auth_file | str trim | encode base64)"

    # Fail once up front instead of once per file
    let check = (^curl -sS -o /dev/null -w '%{http_code}' -H $auth $"($url)/api/posts/?limit=1" | complete)
    if $check.exit_code != 0 { error make {msg: $"can't reach ($url): ($check.stderr | str trim)"} }
    if $check.stdout != "200" { error make {msg: $"booru answered ($check.stdout), check the token in ($auth_file)"} }

    let exts = [jpg jpeg png gif webp avif jxl bmp webm mp4 mov mkv]
    let files = $paths | each {|p|
        match ($p | path type) {
            dir => (do { cd $p; glob '**/*' --no-dir } | where {|f| ($f | path parse | get extension | str lowercase) in $exts } | sort)
            file => [($p | path expand)]
            _ => (error make {msg: $"not found: ($p)"})
        }
    } | flatten
    if ($files | is-empty) { print "no images or videos found"; return [] }

    let meta = {tags: $tags, safety: $safety}
    let meta = if $source == null { $meta } else { $meta | insert source $source }
    let meta_file = (mktemp -t booru-meta.XXXXXX)
    let resp_file = (mktemp -t booru-resp.XXXXXX)
    $meta | to json -r | save -f $meta_file

    let total = $files | length
    let results = $files | enumerate | each {|it|
        let f = $it.item
        # curl -F treats ; and , as separators unless the filename is quoted
        let quoted = $f | str replace -a '\' '\\' | str replace -a '"' '\"'
        let r = (^curl -sS -o $resp_file -w '%{http_code}' -X POST $"($url)/api/posts/"
            -H $auth -H 'Accept: application/json'
            -F $"metadata=@($meta_file);type=application/json"
            -F $"content=@\"($quoted)\"" | complete)
        let body = if $r.exit_code == 0 { try { open --raw $resp_file | from json } catch { {} } } else { {} }
        let status = if $r.exit_code != 0 { "failed" } else {
            match $r.stdout { "200" => "uploaded", "409" => "duplicate", _ => "failed" }
        }
        if $delete and $status != "failed" { rm $f }
        print $"[($it.index + 1)/($total)] ($status) ($f | path basename)"
        {
            file: $f
            status: $status
            post: ($body.id? | default null)
            error: (if $status == "failed" { $body.description? | default ($r.stderr | str trim) } else { null })
        }
    }

    rm -f $meta_file $resp_file
    $results
}
