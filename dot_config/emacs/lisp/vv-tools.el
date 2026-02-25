;;; vv-tools.el --- External tools and utilities

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package restart-emacs)

(use-package magit
  :custom
  (magit-refresh-status-buffer nil))

(setq custom-file "~/.config/emacs/custom.el")
;; (load custom-file)

(provide 'vv-tools)
