-- :fennel:1739677385
local function _1_()
  return require("mason").setup()
end
return {"williamboman/mason.nvim", event = "VeryLazy", config = _1_}