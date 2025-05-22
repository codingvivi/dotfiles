-- :fennel:1747837022
local function get_focused_app_bundle_id()
  local app = hs.application.frontmostApplication()
  if app then
    return app:bundleID()
  else
    return nil
  end
end
local function bundle_id_check(bundle_id_to_match)
  local curr_bundle_id = get_focused_app_bundle_id()
  print(("Current app bundle ID: " .. curr_bundle_id))
  if (curr_bundle_id == bundle_id_to_match) then
    return print("bundle id match!")
  else
    return print("bundle does not match...")
  end
end
local lexicon_id = "com.rekord.cloud.lexicon"
local function _3_()
  return bundle_id_check(lexicon_id)
end
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", _3_)
return print("keymap file loaded")