-- :fennel:1747938770
local target_bundle_id = "com.apple.Terminal"
local app_specific_hotkeys = {}
local app_watcher = nil
local function setup_target_app_hotkeys()
  for _, hk in ipairs(app_specific_hotkeys) do
    hk:delete()
  end
  app_specific_hotkeys = {}
  do
    local hk1
    local function _1_()
      hs.alert.show(("Hotkey active in " .. target_bundle_id .. "!"))
      return hs.notify.show({title = (target_bundle_id .. " Action"), informativeText = "Cmd+Shift+H was pressed!"})
    end
    hk1 = hs.hotkey.bind({"cmd", "shift"}, "h", _1_)
    table.insert(app_specific_hotkeys, hk1)
  end
  do
    local hk2
    local function _2_()
      hs.alert.show(("Another one for " .. target_bundle_id .. "!"))
      return hs.execute(("say \"Hello from " .. target_bundle_id .. "\""))
    end
    hk2 = hs.hotkey.bind({"ctrl", "opt"}, "p", _2_)
    table.insert(app_specific_hotkeys, hk2)
  end
  for _, hk in ipairs(app_specific_hotkeys) do
    hk:disable()
  end
  return nil
end
local function update_hotkey_states_for_app(app_object)
  local current_bundle_id
  if app_object then
    current_bundle_id = app_object:bundleID()
  else
    current_bundle_id = nil
  end
  if (current_bundle_id == target_bundle_id) then
    print(("INFO: " .. target_bundle_id .. " is focused. Enabling hotkeys."))
    for _, hk in ipairs(app_specific_hotkeys) do
      hk:enable()
    end
    return nil
  else
    for _, hk in ipairs(app_specific_hotkeys) do
      hk:disable()
    end
    return nil
  end
end
local function application_activated_callback(app_name, event_type, app_object)
  if (event_type == hs.application.watcher.activated) then
    return update_hotkey_states_for_app(app_object)
  else
    return nil
  end
end
local function start_app_watcher()
  if app_watcher then
    app_watcher:stop()
    app_watcher = nil
  else
  end
  app_watcher = hs.application.watcher.new(application_activated_callback)
  app_watcher:start()
  return print(("INFO: Application watcher started for " .. target_bundle_id .. " hotkeys."))
end
local function init()
  print(("INFO: Initializing app-specific keymaps for: " .. target_bundle_id))
  setup_target_app_hotkeys()
  start_app_watcher()
  return update_hotkey_states_for_app(hs.application.frontmostApplication())
end
init()
local function stop_everything()
  if app_watcher then
    app_watcher:stop()
    app_watcher = nil
  else
  end
  for _, hk in ipairs(app_specific_hotkeys) do
    hk:delete()
  end
  app_specific_hotkeys = {}
  return print("INFO: App-specific keymaps and watcher stopped.")
end
return stop_everything