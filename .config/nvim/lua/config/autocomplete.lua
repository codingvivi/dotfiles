-- :fennel:1745747838
local triggers = {"."}
local function _1_()
  if ((vim.fn.pumvisible() == 1) or (vim.fn.state("m") == "m")) then
    return 
  else
  end
  local char = vim.v.char
  if vim.list_contains(triggers, char) then
    local key = vim.keycode("<C-x><C-n>")
    return vim.api.nvim_feedkeys(key, "m", false)
  else
    return nil
  end
end
return vim.api.nvim_create_autocmd("InsertCharPre", {buffer = vim.api.nvim_get_current_buf(), callback = _1_})