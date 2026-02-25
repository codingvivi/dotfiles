;;; vv-org.el --- Org mode configuration

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
           ((org-agenda-sorting-strategy '(priority-down))))))

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

(require 'org-protocol)
(require 'org-roam-protocol)

(add-hook 'after-init-hook
  (lambda ()
    (setq org-agenda-sticky t) ;; Keeps the agenda buffer persistent
    (with-temp-buffer
      (org-agenda-list nil nil 'year) ;; Pre-builds the year view
      (message "Yearly agenda pre-cached."))))

(provide 'vv-org)
