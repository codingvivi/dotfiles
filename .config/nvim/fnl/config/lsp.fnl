(vim.diagnostic.config {:virtual_text true})  
(vim.lsp.enable [:clangd
                 :racket_langserver
                 :basedpyright
                 :lemminx
                 :tinymist])  
