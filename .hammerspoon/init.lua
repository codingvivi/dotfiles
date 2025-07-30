-- Adds fennel support?
print("============= Starting Hammerspoon! =============")
package.path =
package.path .. ";" .. os.getenv("HOME") .. "/.hammerspoon/?.lua"

fennel = require('fennel')
fennel.path =
  package.path .. ";" .. os.getenv("HOME") .. "/.hammerspoon/?.fnl"
table.insert(package.loaders or package.searchers, fennel.searcher)

print("Loading main module...")
require 'main'

-- Auto reloads config on change
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Hammerspoon config loaded!")
