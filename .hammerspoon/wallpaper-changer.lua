-- :fennel:1753792198
local natcmp = require("string.natcmp")
local WALLPAPER_FOLDER = (os.getenv("HOME") .. "/Pictures/Wallpaper Rotation/master")
local WALLPAPER_DUR_MINS = 30
local SUPPORTED_UTIS = {"com.apple.pict", "com.compuserve.gif", "com.microsoft.bmp", "public.heic", "public.heif", "public.jpeg", "public.png", "public.tiff"}
print("UTIs supported:")
for _, UTI in ipairs(SUPPORTED_UTIS) do
  print(UTI)
end
local function get_files(folder_path)
  local files, filenum, dirnum = hs.fs.fileListForPath(folder_path, {subdirs = true})
  print(("Folder: " .. folder_path))
  print(#files)
  print(("Number of files: " .. filenum))
  print(("Number of directories: " .. dirnum))
  return files, filenum, dirnum
end
local function print_file_list(file_list)
  for _, file in ipairs(file_list) do
    print(file)
  end
  return nil
end
local function hassupportedUTI_3f(UTI_list, path)
  for _, UTI in ipairs(UTI_list) do
    if (UTI == hs.fs.fileUTI(path)) then
      return true
    else
    end
  end
  return false
end
local function get_supported_file_paths(UTIs, file_paths)
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
  print(("Number of screens detected: " .. screen_amount))
  return screen_list
end
local available_screens = get_available_screens
local function print_screens(screen_list)
  for i, screen in ipairs(screen_list()) do
    local _12_
    do
      local frame = screen:frame()
      _12_ = (frame.w .. "x" .. frame.h .. " px")
    end
    print(("Screen " .. i .. ": " .. screen:name() .. " - " .. _12_))
  end
  return nil
end
print_screens(available_screens)
local function change_wallpaper_on_screen(file_path, screen)
  print("test")
  if (file_path and screen) then
    do
      local url = ("file://" .. file_path)
      print(("Setting wallpaper to: " .. url))
      screen:desktopImageURL(url)
    end
    print(("Wallpaper: " .. hs.fs.displayName(file_path)))
    return 0.5
  else
    return nil
  end
end
local function run_rotator(folder)
  local supported_UTIs = {"com.apple.pict", "com.compuserve.gif", "com.microsoft.bmp", "public.heic", "public.heif", "public.jpeg", "public.png", "public.tiff"}
  local cadidate_paths, cadidate_num, cadidate_dir_num = get_files(folder)
  local image_paths = get_supported_file_paths(supported_UTIs, cadidate_paths)
  table.sort(image_paths, natcmp.utf8.lt)
  if (image_paths and (#image_paths > 0)) then
    table.sort(image_paths, natcmp.utf8.lt)
    local next_index = calculate_next_index(image_paths, hs.settings.get("wallpaper-index"))
    if next_index then
      hs.settings.set("wallpaper-index", next_index)
      return change_wallpaper_on_screen(image_paths[next_index], hs.screen.mainScreen())
    else
      return nil
    end
  else
    return nil
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
  print("Screens went to sleep.")
  print("Saving remaining wallpaper time")
  hs.settings.set("remaining-wallpaper-time", wallpaper_timer:nextTrigger())
  print((hs.settings.get("remaining-wallpaper-time") .. " seconds remaining"))
  return print("Stopping wallpaper-timer")
end
local function resume_wallpaper_timer()
  print("Screens woke up. Resuming wallpaper-timer")
  print((hs.settings.get("remaining-wallpaper-time") .. " seconds remaining"))
  return wallpaper_timer:setNextTrigger(hs.settings.get("remaining-wallpaper-time"))
end
hs.settings.set("remaining-wallpaper-time", 0)
print("Initalizing screen-state watcher")
local screen_state_watcher
local function _21_(event_type)
  if (event_type == hs.caffeinate.watcher.screensDidSleep) then
    pause_wallpaper_timer()
    wallpaper_timer:stop()
  else
  end
  if (event_type == (hs.caffeinate.watcher.screensaverDidStop or hs.caffeinate.watcher.screensDidWake)) then
    return resume_wallpaper_timer()
  else
    return nil
  end
end
screen_state_watcher = hs.caffeinate.watcher.new(_21_)
print("starting wallpaper-timer")
screen_state_watcher:start()
local function _24_()
  return print("Hotkey E triggered for wallpaper rotation.", run_rotator(WALLPAPER_FOLDER))
end
return hs.hotkey.bind({"cmd", "ctrl"}, "E", _24_)