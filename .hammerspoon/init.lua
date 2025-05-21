package.path =
package.path .. ";" .. os.getenv("HOME") .. "/.hammerspoon/?.lua"

fennel = require('fennel')
fennel.path =
  package.path .. ";" .. os.getenv("HOME") .. "/.hammerspoon/?.fnl"
table.insert(package.loaders or package.searchers, fennel.searcher)

require 'main'
