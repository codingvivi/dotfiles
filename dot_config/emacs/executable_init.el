(message "Have a lot of fun....")

;;; --- Optimization & UI Basics ---

(setq gc-cons-threshold 100000000)
(setq max-specpdl-size 5000)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

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

  which-key-idle-delay 0.01
)

;;; --- Package Bootstrap ---

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org"   . "https://orgmode.org/elpa/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure t)

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package restart-emacs)

;;; --- Themes & Editing ---

(use-package autothemer)

(use-package oxocarbon-theme
  :vc (:url "https://github.com/konrad1977/oxocarbon-emacs"
       :rev :newest)
  :config (load-theme 'oxocarbon t))



; (use-package meow
;    :config
;    (setq meow-keypad-leader-transparent t))
;   (meow-global-mode 1))

(use-package god-mode
  :config
  (define-key god-local-mode-map [escape] #'my/god-to-helix-mode))

(use-package multiple-cursors)

(use-package helix
  :after multiple-cursors
  :hook ((helix-normal-mode . (lambda () (setq display-line-numbers 'relative)))
         (helix-insert-mode . (lambda () (setq display-line-numbers t))))
  :config
  (helix-multiple-cursors-setup)

  (defun my/toggle-helix-god-mode ()
    "Toggle between helix normal mode and god-local-mode."
    (interactive)
    (if god-local-mode
        (progn
          (god-local-mode -1)
          (setq helix-global-mode t)
          (helix-normal-mode 1))
      (helix-normal-mode -1)
      (setq helix-global-mode nil)
      (god-local-mode 1)))

  (helix-define-key 'space "g" #'my/toggle-helix-god-mode))

(global-set-key (kbd "C-;") #'my/toggle-helix-god-mode)

(helix-mode)
; (use-package corfu
;   :custom
;   (corfu-auto t)                 ; Enable auto completion
;   (corfu-cycle t)                ; Enable cycling for `corfu-next/previous`
;   (corfu-auto-delay 0.0)         ; Start completion immediately
;   (corfu-auto-prefix 2)          ; Complete after 2 characters
;   (corfu-popupinfo-delay 0.5)    ; Show documentation popup
;   :init
;   (global-corfu-mode))

;(use-package meow
;  :config
;  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
;
;  (meow-motion-define-key
;   '("j" . meow-next)
;   '("k" . meow-prev)
;   '("<escape>" . ignore))
;
;  (meow-leader-define-key
;   ;; '("m" . "C-c o")
;   '("1" . meow-digit-argument)
;   '("2" . meow-digit-argument)
;   '("3" . meow-digit-argument)
;   '("4" . meow-digit-argument)
;   '("5" . meow-digit-argument)
;   '("6" . meow-digit-argument)
;   '("7" . meow-digit-argument)
;   '("8" . meow-digit-argument)
;   '("9" . meow-digit-argument)
;   '("0" . meow-digit-argument)
;   '("/" . meow-keypad-describe-key)
;   '("?" . meow-cheatsheet))
;
;  (meow-normal-define-key
;   '("0" . meow-expand-0)
;   '("9" . meow-expand-9)
;   '("8" . meow-expand-8)
;   '("7" . meow-expand-7)
;   '("6" . meow-expand-6)
;   '("5" . meow-expand-5)
;   '("4" . meow-expand-4)
;   '("3" . meow-expand-3)
;   '("2" . meow-expand-2)
;   '("1" . meow-expand-1)
;   '("-" . negative-argument)
;   '(";" . meow-reverse)
;   '("," . meow-inner-of-thing)
;   '("." . meow-bounds-of-thing)
;   '("[" . meow-beginning-of-thing)
;   '("]" . meow-end-of-thing)
;   '("a" . meow-append)
;   '("A" . meow-open-below)
;   '("b" . meow-back-word)
;   '("B" . meow-back-symbol)
;   '("c" . meow-change)
;   '("d" . meow-delete)
;   '("D" . meow-backward-delete)
;   '("e" . meow-next-word)
;   '("E" . meow-next-symbol)
;   '("f" . meow-find)
;   '("g" . meow-cancel-selection)
;   '("G" . meow-grab)
;   '("h" . meow-left)
;   '("H" . meow-left-expand)
;   '("i" . meow-insert)
;   '("I" . meow-open-above)
;   '("j" . meow-next)
;   '("J" . meow-next-expand)
;   '("k" . meow-prev)
;   '("K" . meow-prev-expand)
;   '("l" . meow-right)
;   '("L" . meow-right-expand)
;   '("m" . meow-join)
;   '("n" . meow-search)
;   '("o" . meow-block)
;   '("O" . meow-to-block)
;   '("p" . meow-yank)
;   '("q" . meow-quit)
;   '("Q" . meow-goto-line)
;   '("r" . meow-replace)
;   '("R" . meow-swap-grab)
;   '("s" . meow-kill)
;   '("t" . meow-till)
;   '("u" . meow-undo)
;   '("U" . meow-undo-in-selection)
;   '("v" . meow-visit)
;   '("w" . meow-mark-word)
;   '("W" . meow-mark-symbol)
;   '("x" . meow-line)
;   '("X" . meow-goto-line)
;   '("y" . meow-save)
;   '("Y" . meow-sync-grab)
;   '("z" . meow-pop-selection)
;   '("'" . repeat)
;   '("<escape>" . ignore))
;
;  (meow-global-mode 1))

;;; --- Completion ---

(use-package vertico
  :custom
  (vertico-count 20)
  :init
  (vertico-mode))

(use-package savehist
  :init
  (savehist-mode))

(use-package emacs
  :custom
  (context-menu-mode t)
  (enable-recursive-minibuffers t)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

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
  ;; Correctly recursively find all .org files in your documents
  (setq org-agenda-files 
        (directory-files-recursively (expand-file-name "Documents/org" "~") "\\.org$"))

  (setq org-log-done 'time)

  (with-no-warnings
    (custom-declare-face '+org-todo-active  '((t (:inherit (bold font-lock-constant-face org-todo)))) "")
    (custom-declare-face '+org-todo-project '((t (:inherit (bold font-lock-doc-face org-todo)))) "")
    (custom-declare-face '+org-todo-onhold  '((t (:inherit (bold warning org-todo)))) "")
    (custom-declare-face '+org-todo-cancel  '((t (:inherit (bold error org-todo)))) ""))

  (setq org-todo-keywords
        '((sequence
           "TODO(t)"  ; A task that needs doing & is ready to do
           "PROJ(p)"  ; A project, which usually contains other tasks
           "LOOP(r)"  ; A recurring task
           "STRT(s)"  ; A task that is in progress
           "WAIT(w)"  ; Something external is holding up this task
           "HOLD(h)"  ; This task is paused/on hold because of me
           "IDEA(i)"  ; An unconfirmed and unapproved task or notion
           "|"
           "DONE(d)"  ; Task successfully completed
           "KILL(k!)") ; Task was cancelled, aborted, or is no longer applicable
          (sequence
           "[ ](T)"   ; A task that needs doing
           "[-](S)"   ; Task is in progress
           "[?](W)"   ; Task is being held up or paused
           "|"
           "[X](D)")  ; Task was completed
          (sequence
           "|"
           "OKAY(o)"
           "YES(y)"
           "NO(n)"))
        org-todo-keyword-faces
        '(("[-]"  . +org-todo-active)
          ("STRT" . +org-todo-active)
          ("[?]"  . +org-todo-onhold)
          ("WAIT" . +org-todo-onhold)
          ("HOLD" . +org-todo-onhold)
          ("PROJ" . +org-todo-project)
          ("NO"   . +org-todo-cancel)
          ("KILL" . +org-todo-cancel)))

  (setq org-agenda-skip-scheduled-if-done t)
  (setq org-agenda-skip-deadline-if-done t)

  (setq org-tag-alist 
        '(;; groups
          (:startgrouptag)
          ("work")
          (:grouptags)
          ("BcSCS")
          ("musicwork")
          (:endgrouptag)

          (:startgrouptag)
          ("BcSCS")
          (:grouptags)
          ("S1")
          ("S2")
          ("S3")
          (:endgrouptag)

          (:startgrouptag)
          ("S1")
          (:grouptags)
          ("1_1W")
          ("1_2T")
          ("1_3M")
          (:endgrouptag)

          (:startgrouptag)
          ("S2")
          (:grouptags)
          ("2_1W" . ?W)
          ("2_2T")
          (:endgrouptag)

          (:startgrouptag)
          ("musicwork")
          (:grouptags)
          ("DJing")
          ("production")
          ("st". ?s)
          ("CC". ?c)
          ("HSA". ?h)
          ("idElectro". ?e)
          ("idTrap". ?d)
          ("idLDnB". ?l)
          (:endgrouptag)

          (:startgrouptag)
          ("DJing")
          (:grouptags)
          ("library")
          ("DJgear")
          (:endgrouptag)

          (:startgrouptag)
          ("library")
          (:grouptags)
          ("recdigging". ?d)
          ("recgetting")
          (:endgrouptag)

          (:startgrouptag)
          ("recgetting")
          (:grouptags)
          ("IDs" . ?i)
          ("tracks" . ?t)
          (:endgrouptag)

          (:startgrouptag)
          ("DJgear")
          (:grouptags)
          ("viv2")
          ("model1")
          (:endgrouptag)

          (:startgrouptag)
          ("personal")
          (:grouptags)
          ("productivity")
          ("health")
          (:endgrouptag)

          (:startgrouptag)
          ("health")
          (:grouptags)
          ("mentalhealth")
          (:endgrouptag)

          (:startgrouptag)
          ("hometime")
          (:grouptags)
          ("watch")
          (:endgrouptag)

          (:startgrouptag)
          ("chores")
          (:grouptags)
          ("digichores")
          ("domestic")
          (:endgrouptag)

          (:startgrouptag)
          ("digichores")
          (:grouptags)
          ("ricefields")
          (:endgrouptag)

          (:startgrouptag)
          ("ricefields")
          (:grouptags)
          ("neovim")
          ("orgmode")
          ("keymappings")
          (:endgrouptag)

          (:startgrouptag)
          ("shopping")
          (:grouptags)
          ("groceries")
          ("living")
          (:endgrouptag)

          (:startgrouptag)
          ("locations")
          (:grouptags)
          ("berlin")
          ("stuttgart")
          ("fhafen")
          (:endgrouptag)))

  (setq org-agenda-custom-commands
        '(("p" "Personal"
           ((tags-todo "productivity")
            (tags-todo "neovim")
            (tags-todo "musicwork")
            (tags-todo "-{.+}")) ; without tags
           ((org-agenda-sorting-strategy '(priority-down))))

          ("c" "Chores"
           ((tags-todo "domestic")
            (tags-todo "ricefields"))
           ((org-agenda-sorting-strategy '(priority-down))))

          ("g" "girlfriemd....."
           ((tags-todo "+lucy+berlin")
            (tags-todo "+lucy+home")
            ;; (tags-todo "musicwork-{DJing\\|production\\|st}")
            (tags-todo "lucy-berlin-home"))
           ((org-agenda-sorting-strategy '(priority-down)))))))

  (setq org-file-apps
      '((auto-mode . emacs)
        ("\\.org\\'" . "hx %s")
        (t . "hx %s")))

  ;;; --- Org Roam ---
  (setq org-agenda-span 'month)

  (use-package org-roam
    :after org
    :config
    (require 'org-id)
    (setq org-roam-directory (expand-file-name "Documents/org" "~"))
    (setq org-roam-dailies-directory "daily/")

  (setq org-roam-capture-templates
    '(("d" "default" plain
       "%?"
       :if-new (file+head "${slug}.org" "#+title: ${title}\n")
       :unnarrowed t
       :before-finalize org-id-get-create)))

  (setq org-roam-dailies-capture-templates
    '(("d" "default" entry
       "* %<%Y-%m-%d>\n%?"
       :target (file+head "%<%Y-%m-%d>.org"
                          "#+title: %<%Y-%m-%d>\n#+filetags: :daily:\n"))))

  (add-hook 'org-roam-capture-new-node-hook #'org-id-get-create)
  (org-roam-db-autosync-mode))

(add-hook 'org-after-todo-state-change-hook #'org-save-all-org-buffers)

;;; --- Magit ---

(use-package magit
  :custom
  (magit-refresh-status-buffer nil))

;;; --- Custom File Location ---
(setq custom-file "~/.config/emacs/custom.el")
;; (load custom-file)

(require 'org-protocol)
(require 'org-roam-protocol)

(add-hook 'after-init-hook
  (lambda ()
    (setq org-agenda-sticky t) ;; Keeps the agenda buffer persistent
    (with-temp-buffer
      (org-agenda-list nil nil 'year) ;; Pre-builds the year view
      (message "Yearly agenda pre-cached."))))
