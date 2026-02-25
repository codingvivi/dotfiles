;;; vv-ui.el --- UI & appearance settings

(when (fboundp 'which-key-mode) (which-key-mode))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode 1)
(setq frame-title-format "%b")

(setq
  ;; No need to see GNU agitprop.
  inhibit-startup-screen t
  ;; No need to remind me what a scratch buffer is.
  initial-scratch-message nil
  ;; Double-spaces after periods is morally wrong.
  sentence-end-double-space nil
  ;; Never ding at me, ever.
  ring-bell-function 'ignore
  ;; Save existing clipboard text into the kill ring before replacing it.
  save-interprogram-paste-before-kill t
  ;; Prompts should go in the minibuffer, not in a GUI.
  use-dialog-box nil
  ;; Fix undo in commands affecting the mark.
  mark-even-if-inactive nil

  ;; eke out a little more scrolling performance
  fast-but-imprecise-scrolling t

  ;; when I say to quit, I mean quit
  confirm-kill-processes nil

  ;; unicode ellipses are better
  truncate-string-ellipsis "…"

  ;; this certainly can't hurt anything
  delete-by-moving-to-trash t

  ;; more info in completions
  completions-detailed t
  ;; highlight error messages more aggressively
  next-error-message-highlight t
  ;; don't let the minibuffer muck up my window tiling
  read-minibuffer-restore-windows t
  ;; scope save prompts to individual projects
  save-some-buffers-default-predicate 'save-some-buffers-root
  ;; don't keep duplicate entries in kill ring
  kill-do-not-save-duplicates t

  which-key-idle-delay 0.01)

(provide 'vv-ui)
