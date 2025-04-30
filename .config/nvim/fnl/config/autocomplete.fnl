(local triggers ["."])
(vim.api.nvim_create_autocmd :InsertCharPre
                             {:buffer (vim.api.nvim_get_current_buf)
                              :callback (fn []
                                          (when (or (= (vim.fn.pumvisible) 1)
                                                    (= (vim.fn.state :m) :m))
                                            (lua "return "))
                                          (local char vim.v.char)
                                          (when (vim.list_contains triggers
                                                                   char)
                                            (local key
                                                   (vim.keycode :<C-x><C-n>))
                                            (vim.api.nvim_feedkeys key :m false)))})  

