-- :fennel:1748530399
local natcmp = require("string.natcmp")
local wallpaper_folder = (os.getenv("HOME") .. "/Pictures/Wallpaper Rotation/master")
local supported_UTIs_old = {"com.apple.pict", "com.compuserve.gif", "com.microsoft.bmp", "public.heic", "public.heif", "public.jpeg", "public.png", "public.tiff"}
print("UTIs supported:")
for _, UTI in ipairs(supported_UTIs_old) do
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
local function change_wallpaper_on_screen(file_path, screen)
  print("test")
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
local function _15_()
  return print("Hotkey E triggered for wallpaper rotation.", run_rotator(wallpaper_folder))
end
return hs.hotkey.bind({"cmd", "ctrl"}, "E", _15_)