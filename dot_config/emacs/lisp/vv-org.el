;;; vv-org.el --- Core org configuration

;;; --- Org Mode Aliases ---

; (defalias '+org/shift-return #'org-meta-return)
; (defalias '+org/insert-item-below #'org-insert-heading)
; (defalias '+org/insert-item-above #'org-insert-heading)
; (defalias '+org/toggle-last-clock #'org-clock-in-last)

; ;; Dummy functions for unimplemented commands
; (defun +org/remove-link () (interactive) (message "Doom command not yet implemented"))
; (defun +org/remove-result-blocks () (interactive) (message "Doom command not yet implemented"))
; (defun +org/find-file-in-attachments () (interactive) (message "Doom command not yet implemented"))
; (defun +org/attach-file-and-insert-link () (interactive) (message "Doom command not yet implemented"))
; (defun +org/refile-to-current-file () (interactive) (message "Doom command not yet implemented"))
; (defun +org/refile-to-running-clock () (interactive) (message "Doom command not yet implemented"))
; (defun +org/refile-to-last-location () (interactive) (message "Doom command not yet implemented"))
; (defun +org/refile-to-file () (interactive) (message "Doom command not yet implemented"))
; (defun +org/refile-to-other-window () (interactive) (message "Doom command not yet implemented"))
; (defun +org/refile-to-other-buffer () (interactive) (message "Doom command not yet implemented"))
; (defun +org/refile-to-visible () (interactive) (message "Doom command not yet implemented"))
; (defun +org/goto-visible () (interactive) (message "Doom command not yet implemented"))

; ;; Attempt to require your custom keymaps file
; ;; (Ignore errors if file is missing)
; (require 'org_keymaps nil t)

;;; --- Org Mode Configuration ---

(use-package org
  :config
  (setq org-agenda-files
        (directory-files-recursively (expand-file-name "Documents/org" "~") "\\.org$"))

  (setq org-log-done 'time)

  (setq org-file-apps
      '((auto-mode . emacs)
        ("\\.org\\'" . "hx %s")
        (t . "hx %s")))

  (require 'vv-org-agenda))

(add-hook 'org-after-todo-state-change-hook #'org-save-all-org-buffers)

(require 'vv-org-roam)

(provide 'vv-org)
