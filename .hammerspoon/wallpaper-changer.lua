-- :fennel:1747928376
local wallpaper_folder = (os.getenv("HOME") .. "/Pictures/Wallpaper Rotation/master")
local supported_UTIs = {"com.apple.pict", "com.compuserve.gif", "com.microsoft.bmp", "public.heic", "public.heif", "public.jpeg", "public.png", "public.tiff"}
print("UTIs supported:")
for _, UTI in ipairs(supported_UTIs) do
  print(UTI)
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
local function print_file_list(file_list)
  for _, file in ipairs(file_list) do
    print(file)
  end
  return nil
end
local function list_supported_files(UTIs, file_paths)
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
  local image_list_length = #file_list
  local _3_ = true
  local and_4_ = true
  if and_4_ then
    local _ = _3_
    and_4_ = (not file_list or (0 == image_list_length))
  end
  if and_4_ then
    local _ = _3_
    print("Error: No images found in file-list or file-list is nil.")
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
local function change_wallpaper_on_screen(file_path, screen)
  if (file_path and screen) then
    do
      local url = ("file://" .. file_path)
      print(("Setting wallpaper to: " .. url))
      screen:desktopImageURL(url)
    end
    hs.alert.show(("Wallpaper: " .. hs.fs.displayName(file_path)))
    return 0.5
  else
    return nil
  end
end
local function setup_wallpaper_rotator_new()
  return print("Setting up wallpaper rotator...")
end
local function setup_wallpaper_rotator()
  print("Setting up wallpaper rotator...")
  local all_files_in_folder = hs.fs.fileListForPath(wallpaper_folder, {subdirs = true})
  if not all_files_in_folder then
    print(("Error: Could not read wallpaper folder: " .. wallpaper_folder))
    return function() print('Wallpaper rotator not initialized: folder error.') end
  else
  end
  print(("Found " .. #all_files_in_folder .. " total items in folder."))
  local available_wallpapers = list_supported_files(supported_UTIs, all_files_in_folder)
  print(("Found " .. #available_wallpapers .. " supported wallpaper files."))
  local current_wallpaper_idx = 0
  local function rotate_wallpaper_action()
    print("--- Hotkey Pressed: Rotate Wallpaper ---")
    if (#available_wallpapers == 0) then
      print("No wallpapers available to rotate.")
      return hs.alert.show("No wallpapers found!", 2)
    else
      local next_idx = calculate_next_index(available_wallpapers, current_wallpaper_idx)
      if next_idx then
        local current_wallpaper_idx0 = next_idx
        return change_wallpaper_on_screen(available_wallpapers[current_wallpaper_idx0], hs.screen.mainScreen())
      else
        return hs.alert.show("Error calculating next wallpaper index.", 2)
      end
    end
  end
  return rotate_wallpaper_action
end
local rotate_wallpaper = setup_wallpaper_rotator()
local function _15_()
  print("Hotkey E triggered for wallpaper rotation.")
  if rotate_wallpaper then
    return rotate_wallpaper()
  else
    return nil
  end
end
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "E", _15_)
return print("Wallpaper rotator script loaded. Press Cmd+Alt+Ctrl+E to change wallpaper.")