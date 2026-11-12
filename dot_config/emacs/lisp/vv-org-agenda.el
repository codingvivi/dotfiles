(setq org-agenda-window-setup 'only-window)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-span 'month)

;; Effort shows up in column view and agenda (C-c C-x e to set)
(setq org-global-properties
      '(("Effort_ALL" . "0:15 0:30 1:00 1:30 2:00 3:00 4:00 6:00")))
(setq org-columns-default-format "%50ITEM %TODO %PRIORITY %TAGS %Effort{:}")

;; a PROJ is stuck when it has no TODO/STRT child: nothing to do next
(setq org-stuck-projects '("/PROJ" ("TODO" "STRT") nil ""))

(setq org-agenda-custom-commands
      '(("f" . "Focus (by energy)")
        ("fu" "Ugh: dreaded tasks, for the vyvanse window"
         ((tags-todo "ugh"))
         ((org-agenda-sorting-strategy '(priority-down effort-up))))
        ("fd" "Deep work"
         ((tags-todo "+deep-ugh"))
         ((org-agenda-sorting-strategy '(priority-down effort-up))))
        ("fs" "Shallow: cooked mode"
         ((tags-todo "+shallow-ugh"))
         ((org-agenda-sorting-strategy '(priority-down effort-up))))
        ("fc" "Chill: recharge"
         ((tags-todo "chill"))
         ((org-agenda-sorting-strategy '(priority-down))))
        ("fn" "Untagged: needs deep/shallow tag"
         ((tags-todo "-deep-shallow"))
         ((org-agenda-sorting-strategy '(priority-down))))

        ("P" "Projects overview"
         ((todo "PROJ")
          (stuck ""))
         ((org-agenda-sorting-strategy '(priority-down))))

        ("p" "Personal"
         ((tags-todo "productivity")
          (tags-todo "+musicwork-tracks")) ; without tags
         ((org-agenda-sorting-strategy '(priority-down))))

        ("c" "Chores"
         ((tags-todo "domestic")
          (tags-todo "+chores+ricefields")
          (tags-todo "+shopping+online"))
         ((org-agenda-sorting-strategy '(priority-down))))

        ("e" "Errands"
         ((tags-todo "-lucy+buy+city")
          (tags-todo "-lucy-buy+city"))
         ((org-agenda-sorting-strategy '(priority-down))))

        ("r" "r&r"
         ((tags-todo "rnr|fun")
          (tags-todo "+larporator+research")
          (tags-todo "+ricefields"))
         ((org-agenda-sorting-strategy '(priority-down))))

        ("i" "inbox"
         ((tags-todo "-{.+}")
          (tags-todo "-musicwork-rnr")
          (tags-todo "+ricefields-rnr-chores"))
         ((org-agenda-sorting-strategy '(priority-down))))

        ("t" "Tracks"
         ((tags-todo "get-st-CC-HSA-idElectro-idTrap-idLDnB|recdigging-st-CC-HSA-idElectro-idTrap-idLDnB|id-st-CC-HSA-idElectro-idTrap-idLDnB")
          (tags-todo "dig-st-CC-HSA-idElectro-idTrap-idLDnB|recgetting-st-CC-HSA-idElectro-idTrap-idLDnB")
          (tags-todo "get&st|recdigging&st|id&st")
          (tags-todo "get&CC|recdigging&CC|id&CC")
          (tags-todo "get&HSA|recdigging&HSA|id&HSA")
          (tags-todo "get&idElectro|recdigging&idElectro|id&idElectro")
          (tags-todo "get&idTrap|recdigging&idTrap|id&idTrap")
          (tags-todo "get&idLDnB|recdigging&idLDnB|id&idLDnB")
          (tags-todo "dig&st|recgetting&st")
          (tags-todo "dig&CC|recgetting&CC")
          (tags-todo "dig&HSA|recgetting&HSA")
          (tags-todo "dig&idElectro|recgetting&idElectro")
          (tags-todo "dig&idTrap|recgetting&idTrap")
          (tags-todo "dig&idLDnB|recgetting&idLDnB"))
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
