-- :fennel:1747876041
print("wallpaper script:")
local imageFolder = (os.getenv("HOME") .. "/Pictures/Wallpaper Rotation/master")
local supported_UTIs = {"com.apple.pict", "com.compuserve.gif", "com.microsoft.bmp", "public.heic", "public.heif", "public.jpeg", "public.png", "public.tiff"}
local wallpaper_time = 30
print("UTIs supported:")
for _, UTI in ipairs(supported_UTIs) do
  print(UTI)
end
local function hassupportedUTI_3f(UTIs, path)
  for _, UTI in ipairs(UTIs) do
    if (UTI == hs.fs.fileUTI(path)) then
      return true
    else
    end
  end
  return nil
end
local candidate_paths, candidate_num, candidate_dir_num = hs.fs.fileListForPath(imageFolder, {subdirs = true})
print(("Candidate count: " .. tostring(candidate_num)))
local function make_file_list(UTIs, file_paths)
  local file_list = {}
  for _, path in ipairs(file_paths) do
    if hassupportedUTI_3f(UTIs, path) then
      table.insert(file_list, path)
    else
    end
  end
  return file_list
end
local wallpaper_list = make_file_list(supported_UTIs, candidate_paths)
print(("Number of images added to wallpaper rotation: " .. #wallpaper_list))
local function print_filelist(list_of_files)
  for _, file in ipairs(list_of_files) do
    print(file)
  end
  return nil
end
return print("wallpaper-changer file loaded")