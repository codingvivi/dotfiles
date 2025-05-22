-- :fennel:1747926215
print("wallpaper script:")
local wallpaper_folder = (os.getenv("HOME") .. "/Pictures/Wallpaper Rotation/master")
local supported_UTIs = {"com.apple.pict", "com.compuserve.gif", "com.microsoft.bmp", "public.heic", "public.heif", "public.jpeg", "public.png", "public.tiff"}
local function hassupportedUTI_3f(UTI_list, path)
  for _, UTI in ipairs(UTI_list) do
    if (UTI == hs.fs.fileUTI(path)) then
      return true
    else
    end
  end
  return nil
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
local function update_file_index(file_list, index)
  local image_list_length = #file_list
  print(("Number of files available:" .. image_list_length))
  print(("Current index position:" .. index))
  local _3_ = true
  local and_4_ = true
  if and_4_ then
    local _ = _3_
    and_4_ = not file_list
  end
  if and_4_ then
    local _ = _3_
    print("Error: file-list is nil (or false). Somewhere something went wrong...")
    return 0
  else
    local and_6_ = true
    if and_6_ then
      local _ = _3_
      and_6_ = (0 == image_list_length)
    end
    if and_6_ then
      local _ = _3_
      print("Error: no images found")
      return 0
    else
      local and_8_ = true
      if and_8_ then
        local _ = _3_
        and_8_ = (index <= 0)
      end
      if and_8_ then
        local _ = _3_
        print("Error: index <= 0. Setting wallpaper to file 1")
        return 1
      else
        local and_10_ = true
        if and_10_ then
          local _ = _3_
          and_10_ = (image_list_length < index)
        end
        if and_10_ then
          local _ = _3_
          print("Error: Index outside of total file list length. Setting wallpaper to file 1...")
          return 1
        else
          local and_12_ = true
          if and_12_ then
            local _ = _3_
            and_12_ = (image_list_length == index)
          end
          if and_12_ then
            local _ = _3_
            print("End of file list. Starting over.")
            return 1
          else
            local _ = _3_
            print("Changing wallpaper")
            return (index + 1)
          end
        end
      end
    end
  end
end
local function change_wallpaper(file_paths, index, screen)
  local url = ("file://" .. file_paths[index])
  return hs.screen.mainScreen:desktopImageURL(url)
end
local function _15_()
  return change_wallpaper({})
end
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "E", _15_)
return print("wallpaper-changer file loaded")