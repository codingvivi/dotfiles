-- :fennel:1745501533
local function _1_()
  return require("nvim-treesitter.configs").setup({highlight = {enable = true}, ensure_installed = {"c", "rust", "python", "lua", "racket", "fennel", "css", "bash", "xml", "toml", "yaml", "csv", "tsv", "markdown", "latex", "typst", "mermaid", "vimdoc"}})
end
return {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = _1_}