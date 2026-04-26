;;; doom_org_keybindings_for_vanilla_emacs.el --- Org mode keybindings from Doom Emacs

;;; Commentary:
;; This file contains Org mode keybindings translated from Doom Emacs's
;; configuration. They have been converted to standard Emacs Lisp.
;;
;; To use this, save this file somewhere in your load-path and add
;; `(load "path/to/this/file")` to your Emacs init file.
;;
;; Some of the commands listed here are custom to Doom Emacs (often prefixed
;; with `+org/`). For these keybindings to work, you will need to copy the
;; function definitions from the Doom Emacs source code into your own config.
;; The original file is in `modules/lang/org/config.el`.

;;; Code:

(with-eval-after-load 'org
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; General Org Mode keybindings
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;; In GUI Emacs, a `[tab]` binding in `outline-mode-cycle-map` can
  ;; override the Org mode binding. This ensures `org-cycle` is used.
  (define-key org-mode-map [tab] #'org-cycle)

  ;; NOTE: The following command is custom to Doom Emacs.
  (define-key org-mode-map (kbd "C-c C-S-l") #'+org/remove-link)

  (define-key org-mode-map (kbd "C-c C-i") #'org-toggle-inline-images)

  ;; Textmate-esque newline insertion
  ;; NOTE: These commands are custom to Doom Emacs.
  (define-key org-mode-map (kbd "S-RET") #'+org/shift-return)
  (define-key org-mode-map (kbd "C-RET") #'+org/insert-item-below)
  (define-key org-mode-map (kbd "C-S-RET") #'+org/insert-item-above)
  (define-key org-mode-map (kbd "C-M-RET") #'org-insert-subheading)
  (define-key org-mode-map [C-return] #'+org/insert-item-below)
  (define-key org-mode-map [C-S-return] #'+org/insert-item-above)
  (define-key org-mode-map [C-M-return] #'org-insert-subheading)

  ;; Org-aware C-a/C-e. This remaps the default beginning/end of line commands.
  (define-key org-mode-map [remap move-beginning-of-line] #'org-beginning-of-line)
  (define-key org-mode-map [remap move-end-of-line] #'org-end-of-line)


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Leader prefix (C-c o)
  ;; In Doom Emacs, these are bound under a "localleader" key. We will use
  ;; `C-c o` as the prefix. You can change this by modifying the line below.
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defvar my-org-leader-map (make-sparse-keymap) "Keymap for Org mode specific commands triggered by `SPC m`.")

  (define-key my-org-leader-map (kbd "#") #'org-update-statistics-cookies)
  (define-key my-org-leader-map (kbd "'") #'org-edit-special)
  (define-key my-org-leader-map (kbd "*") #'org-ctrl-c-star)
  (define-key my-org-leader-map (kbd "+") #'org-ctrl-c-minus)
  (define-key my-org-leader-map (kbd ",") #'org-switchb)
  (define-key my-org-leader-map (kbd ".") #'org-goto)
  (define-key my-org-leader-map (kbd "@") #'org-cite-insert)
  ;; The following bindings depend on the completion framework you use.
  ;; You may need to install packages like `counsel`, `helm-org`, or `consult`.
  ;; (define-key my-org-leader-map (kbd ".") #'counsel-org-goto)
  ;; (define-key my-org-leader-map (kbd "/") #'counsel-org-goto-all)
  ;; (define-key my-org-leader-map (kbd ".") #'helm-org-in-buffer-headings)
  ;; (define-key my-org-leader-map (kbd "/") #'helm-org-agenda-files-headings)
  ;; (define-key my-org-leader-map (kbd ".") #'consult-org-heading)
  ;; (define-key my-org-leader-map (kbd "/") #'consult-org-agenda)

  (define-key my-org-leader-map (kbd "A") #'org-archive-subtree-default)
  (define-key my-org-leader-map (kbd "e") #'org-export-dispatch)
  (define-key my-org-leader-map (kbd "f") #'org-footnote-action)
  (define-key my-org-leader-map (kbd "h") #'org-toggle-heading)
  (define-key my-org-leader-map (kbd "i") #'org-toggle-item)
  (define-key my-org-leader-map (kbd "I") #'org-id-get-create)
  (define-key my-org-leader-map (kbd "k") #'org-babel-remove-result)
  ;; NOTE: The following command is custom to Doom Emacs.
  (define-key my-org-leader-map (kbd "K") #'+org/remove-result-blocks)
  (define-key my-org-leader-map (kbd "n") #'org-store-link)
  (define-key my-org-leader-map (kbd "o") #'org-set-property)
  (define-key my-org-leader-map (kbd "q") #'org-set-tags-command)
  (define-key my-org-leader-map (kbd "t") #'org-todo)
  (define-key my-org-leader-map (kbd "T") #'org-todo-list)
  (define-key my-org-leader-map (kbd "x") #'org-toggle-checkbox)


  ;; -- Attachments prefix: C-c o a --
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "a") #'org-attach)
    (define-key map (kbd "d") #'org-attach-delete-one)
    (define-key map (kbd "D") #'org-attach-delete-all)
    ;; NOTE: The following two commands are custom to Doom Emacs.
    (define-key map (kbd "f") #'+org/find-file-in-attachments)
    (define-key map (kbd "l") #'+org/attach-file-and-insert-link)
    (define-key map (kbd "n") #'org-attach-new)
    (define-key map (kbd "o") #'org-attach-open)
    (define-key map (kbd "O") #'org-attach-open-in-emacs)
    (define-key map (kbd "r") #'org-attach-reveal)
    (define-key map (kbd "R") #'org-attach-reveal-in-emacs)
    (define-key map (kbd "u") #'org-attach-url)
    (define-key map (kbd "s") #'org-attach-set-directory)
    (define-key map (kbd "S") #'org-attach-sync)
    ;; The following require the `org-download` package.
    ;; (define-key map (kbd "c") #'org-download-screenshot)
    ;; (define-key map (kbd "p") #'org-download-clipboard)
    ;; (define-key map (kbd "P") #'org-download-yank)
    (define-key my-org-leader-map (kbd "a") map))

  ;; -- Tables prefix: C-c o b --
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "-") #'org-table-insert-hline)
    (define-key map (kbd "a") #'org-table-align)
    (define-key map (kbd "b") #'org-table-blank-field)
    (define-key map (kbd "c") #'org-table-create-or-convert-from-region)
    (define-key map (kbd "e") #'org-table-edit-field)
    (define-key map (kbd "f") #'org-table-edit-formulas)
    (define-key map (kbd "h") #'org-table-field-info)
    (define-key map (kbd "s") #'org-table-sort-lines)
    (define-key map (kbd "r") #'org-table-recalculate)
    (define-key map (kbd "R") #'org-table-recalculate-buffer-tables)
    (let ((delete-map (make-sparse-keymap)))
      (define-key delete-map (kbd "c") #'org-table-delete-column)
      (define-key delete-map (kbd "r") #'org-table-kill-row)
      (define-key map (kbd "d") delete-map))
    (let ((insert-map (make-sparse-keymap)))
      (define-key insert-map (kbd "c") #'org-table-insert-column)
      (define-key insert-map (kbd "h") #'org-table-insert-hline)
      (define-key insert-map (kbd "r") #'org-table-insert-row)
      (define-key insert-map (kbd "H") #'org-table-hline-and-move)
      (define-key map (kbd "i") insert-map))
    (let ((toggle-map (make-sparse-keymap)))
      (define-key toggle-map (kbd "f") #'org-table-toggle-formula-debugger)
      (define-key toggle-map (kbd "o") #'org-table-toggle-coordinate-overlays)
      (define-key map (kbd "t") toggle-map))
    ;; (define-key map (kbd "p") #'org-plot/gnuplot) ; Requires gnuplot
    (define-key my-org-leader-map (kbd "b") map))

  ;; -- Clock prefix: C-c o c --
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "c") #'org-clock-cancel)
    (define-key map (kbd "d") #'org-clock-mark-default-task)
    (define-key map (kbd "e") #'org-clock-modify-effort-estimate)
    (define-key map (kbd "E") #'org-set-effort)
    (define-key map (kbd "g") #'org-clock-goto)
    (define-key map (kbd "G") (lambda () (interactive) (org-clock-goto 'select)))
    ;; NOTE: The following command is custom to Doom Emacs.
    (define-key map (kbd "l") #'+org/toggle-last-clock)
    (define-key map (kbd "i") #'org-clock-in)
    (define-key map (kbd "I") #'org-clock-in-last)
    (define-key map (kbd "o") #'org-clock-out)
    (define-key map (kbd "r") #'org-resolve-clocks)
    (define-key map (kbd "R") #'org-clock-report)
    (define-key map (kbd "t") #'org-evaluate-time-range)
    (define-key map (kbd "=") #'org-clock-timestamps-up)
    (define-key map (kbd "-") #'org-clock-timestamps-down)
    (define-key my-org-leader-map (kbd "c") map))

  ;; -- Date/deadline prefix: C-c o d --
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "d") #'org-deadline)
    (define-key map (kbd "s") #'org-schedule)
    (define-key map (kbd "t") #'org-time-stamp)
    (define-key map (kbd "T") #'org-time-stamp-inactive)
    (define-key my-org-leader-map (kbd "d") map))

  ;; -- Goto prefix: C-c o g --
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "g") #'org-goto)
    ;; See notes above about completion frameworks for these keys.
    ;; (define-key map (kbd "g") #'counsel-org-goto)
    ;; (define-key map (kbd "G") #'counsel-org-goto-all)
    (define-key map (kbd "c") #'org-clock-goto)
    (define-key map (kbd "C") (lambda () (interactive) (org-clock-goto 'select)))
    (define-key map (kbd "i") #'org-id-goto)
    (define-key map (kbd "r") #'org-refile-goto-last-stored)
    ;; NOTE: The following command is custom to Doom Emacs.
    (define-key map (kbd "v") #'+org/goto-visible)
    (define-key map (kbd "x") #'org-capture-goto-last-stored)
    (define-key my-org-leader-map (kbd "g") map))

  ;; -- Links prefix: C-c o l --
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "c") #'org-cliplink)
    ;; NOTE: The following command is custom to Doom Emacs.
    (define-key map (kbd "d") #'+org/remove-link)
    (define-key map (kbd "i") #'org-id-store-link)
    (define-key map (kbd "l") #'org-insert-link)
    (define-key map (kbd "L") #'org-insert-all-links)
    (define-key map (kbd "s") #'org-store-link)
    (define-key map (kbd "S") #'org-insert-last-stored-link)
    (define-key map (kbd "t") #'org-toggle-link-display)
    ;; NOTE: The following command is custom to Doom Emacs.
    (define-key map (kbd "y") #'+org/yank-link)
    ;; (define-key map (kbd "g") #'org-mac-link-get-link) ; macOS only
    (define-key my-org-leader-map (kbd "l") map))

  ;; -- Publish prefix: C-c o P --
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "a") #'org-publish-all)
    (define-key map (kbd "f") #'org-publish-current-file)
    (define-key map (kbd "p") #'org-publish)
    (define-key map (kbd "P") #'org-publish-current-project)
    (define-key map (kbd "s") #'org-publish-sitemap)
    (define-key my-org-leader-map (kbd "P") map))

  ;; -- Refile prefix: C-c o r --
  (let ((map (make-sparse-keymap)))
    ;; NOTE: The following commands are custom to Doom Emacs.
    (define-key map (kbd ".") #'+org/refile-to-current-file)
    (define-key map (kbd "c") #'+org/refile-to-running-clock)
    (define-key map (kbd "l") #'+org/refile-to-last-location)
    (define-key map (kbd "f") #'+org/refile-to-file)
    (define-key map (kbd "o") #'+org/refile-to-other-window)
    (define-key map (kbd "O") #'+org/refile-to-other-buffer)
    (define-key map (kbd "v") #'+org/refile-to-visible)
    (define-key map (kbd "r") #'org-refile)
    (define-key map (kbd "R") #'org-refile-reverse)
    (define-key my-org-leader-map (kbd "r") map))

  ;; -- Subtree/tree prefix: C-c o s --
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "a") #'org-toggle-archive-tag)
    (define-key map (kbd "b") #'org-tree-to-indirect-buffer)
    (define-key map (kbd "c") #'org-clone-subtree-with-time-shift)
    (define-key map (kbd "d") #'org-cut-subtree)
    (define-key map (kbd "h") #'org-promote-subtree)
    (define-key map (kbd "j") #'org-move-subtree-down)
    (define-key map (kbd "k") #'org-move-subtree-up)
    (define-key map (kbd "l") #'org-demote-subtree)
    (define-key map (kbd "n") #'org-narrow-to-subtree)
    (define-key map (kbd "r") #'org-refile)
    (define-key map (kbd "s") #'org-sparse-tree)
    (define-key map (kbd "A") #'org-archive-subtree-default)
    (define-key map (kbd "N") #'widen)
    (define-key map (kbd "S") #'org-sort)
    (define-key my-org-leader-map (kbd "s") map))

  ;; -- Priority prefix: C-c o p --
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "d") #'org-priority-down)
    (define-key map (kbd "p") #'org-priority)
    (define-key map (kbd "u") #'org-priority-up)
    (define-key my-org-leader-map (kbd "p") map)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org Agenda keybindings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(with-eval-after-load 'org-agenda
  (define-key org-agenda-mode-map (kbd "C-SPC") #'org-agenda-show-and-scroll-up)

  (defvar my-org-agenda-leader-map (make-sparse-keymap))
  (define-key org-agenda-mode-map (kbd "C-c o") my-org-agenda-leader-map)

  ;; -- Date/deadline prefix: C-c o d --
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "d") #'org-agenda-deadline)
    (define-key map (kbd "s") #'org-agenda-schedule)
    (define-key my-org-agenda-leader-map (kbd "d") map))

  ;; -- Clock prefix: C-c o c --
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "c") #'org-agenda-clock-cancel)
    (define-key map (kbd "g") #'org-agenda-clock-goto)
    (define-key map (kbd "i") #'org-agenda-clock-in)
    (define-key map (kbd "o") #'org-agenda-clock-out)
    (define-key map (kbd "r") #'org-agenda-clockreport-mode)
    (define-key map (kbd "s") #'org-agenda-show-clocking-issues)
    (define-key my-org-agenda-leader-map (kbd "c") map))

  ;; -- Priority prefix: C-c o p --
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "d") #'org-agenda-priority-down)
    (define-key map (kbd "p") #'org-agenda-priority)
    (define-key map (kbd "u") #'org-agenda-priority-up)
    (define-key my-org-agenda-leader-map (kbd "p") map))

  (define-key org-agenda-mode-map (kbd "q") #'org-agenda-set-tags)
  (define-key org-agenda-mode-map (kbd "r") #'org-agenda-refile)
  (define-key org-agenda-mode-map (kbd "t") #'org-agenda-todo))

(provide 'org_keymaps)
;;; org_keymaps.el ends here
