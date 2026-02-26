;;; vv-org-agenda.el --- Org agenda configuration

(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-span 'month)

(setq org-agenda-custom-commands
      '(("p" "Personal"
         ((tags-todo "-{.+}")
          (tags-todo "productivity")
          (tags-todo "neovim")
          (tags-todo "+musicwork-tracks")) ; without tags
         ((org-agenda-sorting-strategy '(priority-down))))

        ("c" "Chores"
         ((tags-todo "domestic")
          (tags-todo "+chores+ricefields"))
         ((org-agenda-sorting-strategy '(priority-down))))

        ("r" "r&r"
         ((tags-todo "rnr|fun")
          (tags-todo "+rnr+ricefields"))
         ((org-agenda-sorting-strategy '(priority-down))))

        ("i" "r&r"
         ((tags-todo "rnr|fun")
          (tags-todo "+rnr+ricefields"))
         ((org-agenda-sorting-strategy '(priority-down))))

        ("t" "Tracks"
         ((tags-todo "get|recdigging")
          (tags-todo "dig|recgetting"))
         ((org-agenda-sorting-strategy '(priority-down))))

        ("g" "girlfriemd....."
         ((tags-todo "+lucy+berlin")
          (tags-todo "+lucy+home")
          (tags-todo "+lucy+watch")
          (tags-todo "+lucy+stuttgart")
          ;; (tags-todo "musicwork-{DJing\\|production\\|st}")
          (tags-todo "lucy-berlin-home"))
         ((org-agenda-sorting-strategy '(priority-down))))))

(add-hook 'after-init-hook
  (lambda ()
    (setq org-agenda-sticky t) ;; Keeps the agenda buffer persistent
    (with-temp-buffer
      (org-agenda-list nil nil 'year) ;; Pre-builds the year view
      (message "Yearly agenda pre-cached."))))

(use-package org-super-agenda)

(provide 'vv-org-agenda)
