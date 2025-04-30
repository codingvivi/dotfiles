-- :fennel:1745692679
vim.diagnostic.config({virtual_text = true})
return vim.lsp.enable({"clangd", "racket_langserver", "basedpyright", "lemminx", "tinymist"})