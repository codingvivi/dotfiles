-- :fennel:1753909506
print("~~~~~~~~~~~~~~~ wallpaper rotator ~~~~~~~~~~~~~~~")
local natcmp = require("string.natcmp")
local WALLPAPER_FOLDER = (os.getenv("HOME") .. "/Pictures/Wallpaper Rotation/master")
local WALLPAPER_DUR_MINS = 30
local SUPPORTED_FILETYPE_UTIS = {"com.apple.pict", "com.compuserve.gif", "com.microsoft.bmp", "public.heic", "public.heif", "public.jpeg", "public.png", "public.tiff"}
local PAUSE_EVENTS = {[hs.caffeinate.watcher.screensDidSleep] = true, [hs.caffeinate.watcher.screensaverDidStart] = true}
local RESUME_EVENTS = {[hs.caffeinate.watcher.screensDidWake] = true, [hs.caffeinate.watcher.screensaverDidStop] = true}
local function get_files(folder_path)
  _G.assert((nil ~= folder_path), "Missing argument folder-path on .hammerspoon/wallpaper-changer.fnl:38")
  local files, filenum, dirnum = hs.fs.fileListForPath(folder_path, {subdirs = true})
  print(("Folder: " .. folder_path))
  print(#files)
  print(("Number of files: " .. filenum))
  print(("Number of directories: " .. dirnum))
  return files, filenum, dirnum
end
local function print_file_list(file_list)
  _G.assert((nil ~= file_list), "Missing argument file-list on .hammerspoon/wallpaper-changer.fnl:48")
  for _, file in ipairs(file_list) do
    print(file)
  end
  return nil
end
local function hassupportedUTI_3f(UTI_list, path)
  _G.assert((nil ~= path), "Missing argument path on .hammerspoon/wallpaper-changer.fnl:57")
  _G.assert((nil ~= UTI_list), "Missing argument UTI-list on .hammerspoon/wallpaper-changer.fnl:57")
  for _, UTI in ipairs(UTI_list) do
    if (UTI == hs.fs.fileUTI(path)) then
      return true
    else
    end
  end
  return false
end
local function get_supported_file_paths(UTIs, file_paths)
  _G.assert((nil ~= file_paths), "Missing argument file-paths on .hammerspoon/wallpaper-changer.fnl:66")
  _G.assert((nil ~= UTIs), "Missing argument UTIs on .hammerspoon/wallpaper-changer.fnl:66")
  local file_list = {}
  for _, path in ipairs(file_paths) do
    if hassupportedUTI_3f(UTIs, path) then
      table.insert(file_list, path)
    else
    end
  end
  return file_list
end
local function calculate_next_index(file_list, current_idx)
  _G.assert((nil ~= current_idx), "Missing argument current-idx on .hammerspoon/wallpaper-changer.fnl:74")
  _G.assert((nil ~= file_list), "Missing argument file-list on .hammerspoon/wallpaper-changer.fnl:74")
  if (file_list == nil) then
    return print("Error: file list is nil...")
  else
    local image_list_length = #file_list
    local _3_ = true
    local and_4_ = true
    if and_4_ then
      local _ = _3_
      and_4_ = (0 == image_list_length)
    end
    if and_4_ then
      local _ = _3_
      print("Error: No images found in file-list.")
      return nil
    else
      local and_6_ = true
      if and_6_ then
        local _ = _3_
        and_6_ = (not current_idx or (current_idx <= 0) or (current_idx > image_list_length))
      end
      if and_6_ then
        local _ = _3_
        print(("Info: Invalid or uninitialized index (" .. tostring(current_idx) .. "). Setting to 1."))
        return 1
      else
        local and_8_ = true
        if and_8_ then
          local _ = _3_
          and_8_ = (current_idx == image_list_length)
        end
        if and_8_ then
          local _ = _3_
          print("Info: End of file list. Starting over.")
          return 1
        else
          local _ = _3_
          print(("Info: Advancing index from " .. current_idx .. " to " .. (current_idx + 1)))
          return (current_idx + 1)
        end
      end
    end
  end
end
local function get_available_screens()
  print("Refreshing screens available...")
  local screen_list = hs.screen.allScreens()
  local screen_amount = #screen_list
  if (0 == screen_amount) then
    print("Error: No screens detected...")
    return nil
  else
    print(("Number of screens detected: " .. screen_amount))
    return screen_list
  end
end
local function print_screen_details(screen)
  _G.assert((nil ~= screen), "Missing argument screen on .hammerspoon/wallpaper-changer.fnl:122")
  local _13_
  do
    local frame = screen:frame()
    _13_ = (frame.w .. " x " .. frame.h .. "px")
  end
  return print(("Screen " .. screen:name() .. " - " .. _13_))
end
local function iterate_screens(screen_list, func, _3fargs)
  _G.assert((nil ~= func), "Missing argument func on .hammerspoon/wallpaper-changer.fnl:128")
  _G.assert((nil ~= screen_list), "Missing argument screen-list on .hammerspoon/wallpaper-changer.fnl:128")
  for i, screen in ipairs(screen_list) do
    func(screen, _3fargs)
  end
  return nil
end
local function change_wallpaper_on_screen(screen, file_path)
  _G.assert((nil ~= file_path), "Missing argument file-path on .hammerspoon/wallpaper-changer.fnl:134")
  _G.assert((nil ~= screen), "Missing argument screen on .hammerspoon/wallpaper-changer.fnl:134")
  do
    local url = ("file://" .. file_path)
    print(("Setting wallpaper to: " .. url))
    screen:desktopImageURL(url)
  end
  print(("Wallpaper: " .. hs.fs.displayName(file_path)))
  return 0.5
end
local function run_rotator(folder)
  _G.assert((nil ~= folder), "Missing argument folder on .hammerspoon/wallpaper-changer.fnl:142")
  local cadidate_paths, cadidate_num, cadidate_dir_num = get_files(folder)
  local image_paths = get_supported_file_paths(SUPPORTED_FILETYPE_UTIS, cadidate_paths)
  local screens = get_available_screens()
  local main_screen = hs.screen.mainScreen()
  table.sort(image_paths, natcmp.utf8.lt)
  if not (image_paths and (#image_paths > 0) and screens and main_screen) then
    return print("Error: something is nil that shouldnt be...")
  else
    print("Screens available:")
    iterate_screens(screens, print_screen_details)
    print("Main screen:")
    print_screen_details(main_screen)
    local next_index = calculate_next_index(image_paths, hs.settings.get("wallpaper-index"))
    local next_image = image_paths[next_index]
    if next_index then
      hs.settings.set("wallpaper-index", next_index)
      return iterate_screens(screens, change_wallpaper_on_screen, image_paths[next_index])
    else
      return nil
    end
  end
end
local function check_value_change(value_new, value_old)
  local change = (value_new - value_old)
  if (0 == change) then
    print("Value remains the same")
  else
    print(("Value has changed by " .. change))
  end
  return change
end
local function init_WALLPAPER_DUR_MINS(duration)
  _G.assert((nil ~= duration), "Missing argument duration on .hammerspoon/wallpaper-changer.fnl:177")
  local duration_secs_new = hs.timer.minutes(duration)
  print(("Converted duration of " .. duration .. " minutes into " .. duration_secs_new .. " seconds"))
  local duration_secs_old = hs.settings.get("wallpaper-timer-dur")
  if (nil == duration_secs_old) then
    print("Old wallpaper timer duration is nil (due to this being the first run, or a bug. Setting it to 0")
    duration_secs_old = 0
  else
  end
  print("checking timer change (in seconds)")
  local change = check_value_change(duration_secs_new, duration_secs_old)
  local _18_ = print(("Adjusting timer by " .. change .. " seconds"))
  if ((0 ~= change) or (change ~= _18_) or (_18_ ~= print("No change in duration of timer since last initialization"))) then
    return hs.settings.set("wallpaper-timer-dur", duration_secs_new)
  else
    return nil
  end
end
print("Initalizing duration and timer")
init_WALLPAPER_DUR_MINS(WALLPAPER_DUR_MINS)
local wallpaper_timer
local function _20_()
  return run_rotator(WALLPAPER_FOLDER)
end
wallpaper_timer = hs.timer.new(hs.settings.get("wallpaper-timer-dur"), _20_)
print("starting wallpaper-timer")
wallpaper_timer:start()
local function pause_wallpaper_timer()
  if not wallpaper_timer:running() then
    return print("Warning: Timer not running. No action taken")
  else
    print("Saving time and pausing")
    local remaining_time = wallpaper_timer:nextTrigger()
    print(("Saving remaining wallpaper time: " .. remaining_time .. " seconds"))
    hs.settings.set("remaining-wallpaper-time", remaining_time)
    print(("Saved " .. hs.settings.get("remaining-wallpaper-time") .. " seconds"))
    wallpaper_timer:stop()
    return print("Stopped wallpaper-timer")
  end
end
local function resume_wallpaper_timer()
  if wallpaper_timer:running() then
    return print("Warning: Resumer called, but timer was already running. No action taken.")
  else
    print("Timer was stopped, running resumer...")
    local remaining_time = hs.settings.get("remaining-wallpaper-time")
    if not (remaining_time and (remaining_time > 0)) then
      print("Warning: No valid remaining time found")
      wallpaper_timer:start()
      return print("Restarted wallpaper timer")
    else
      print("Remaining time found")
      wallpaper_timer:setNextTrigger(remaining_time)
      print(("Recalled remaining time of " .. remaining_time .. "s"))
      wallpaper_timer:start()
      return print(("Resumed timer with " .. hs.settings.get("remaining-wallpaper-time")))
    end
  end
end
hs.settings.set("remaining-wallpaper-time", 0)
print("Initalizing screen-state watcher")
local screen_state_watcher
local function _24_(event_type)
  if PAUSE_EVENTS[event_type] then
    resume_wallpaper_timer()
    print("Screens went to sleep! running pauser")
    pause_wallpaper_timer()
  else
  end
  if RESUME_EVENTS[event_type] then
    print("Screens have gone WOKE! running remainer")
    return resume_wallpaper_timer()
  else
    return nil
  end
end
screen_state_watcher = hs.caffeinate.watcher.new(_24_)
print("starting wallpaper-timer")
screen_state_watcher:start()
print("wallpaper-timer started!")
local function _27_()
  return print("Hotkey E triggered for wallpaper rotation.", run_rotator(WALLPAPER_FOLDER))
end
return hs.hotkey.bind({"cmd", "ctrl"}, "E", _27_)