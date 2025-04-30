{1 :nvim-treesitter/nvim-treesitter
          ; :event :BufReadPost 
          ; :dependencies [:nvim-treesitter/nvim-treesitter-textobjects]
          :build ":TSUpdate"
          :config (fn []
                    ((. (require :nvim-treesitter.configs) :setup) 
                     {:highlight { 
                                  :enable true}
                        ;:disable {:markdown}
                      :ensure_installed [
                      ;; langs
                                         :c
                                         :rust
                                         :python
                                         :lua
                        ;; lispin
                                         :racket
                                         :fennel
                        ;; webshit
                                         :css
                        ;; scriptin
                                         :bash
                       ;; plaintext
                       ;;; markup
                       ;;;; misc
                                         :xml
                                         :toml
                                         :yaml
                                         :csv
                                         :tsv
                       ;;;; docs light
                                         :markdown
                                         ;:org
                        ;;;; docs heavy
                                         :latex
                                         :typst
                        ;; misc
                                         :mermaid
                                         :vimdoc]}))}
