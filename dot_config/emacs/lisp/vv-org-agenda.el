;;; vv-org-agenda.el --- Org agenda configuration

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
(setq org-agenda-span 'month)

(require 'vv-org-tags)

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

(add-hook 'after-init-hook
  (lambda ()
    (setq org-agenda-sticky t) ;; Keeps the agenda buffer persistent
    (with-temp-buffer
      (org-agenda-list nil nil 'year) ;; Pre-builds the year view
      (message "Yearly agenda pre-cached."))))

(provide 'vv-org-agenda)
