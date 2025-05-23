-- :fennel:1747937601
require("keymaps")
local managed_apps = {Lexicon = {bundleID = "com.rekord.cloud.lexicon", keymaps = true}, Terminal = {bundleID = "com.apple.Terminal", keymaps = false}}
local function get_focused_bundleID()
  local app = hs.application.frontmostApplication()
  if app then
    return app:bundleID()
  else
    return nil
  end
end
local function managed_bundle_3f(bundleID)
  for managed_name, managed_info in pairs(managed_apps) do
    local managed_bundleID = managed_info.bundleID
    if (managed_bundleID == bundleID) then
      print(("App" .. bundleID .. "is managed under \"" .. managed_name .. "\"!"))
    else
    end
  end
  return nil
end
managed_bundle_3f("com.rekord.cloud.lexicon")
local function has_keymaps_3f(appname)
end
return has_keymaps_3f