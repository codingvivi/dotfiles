;;; vv-org-roam.el --- Org-roam configuration

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
                          "#+title: %<%Y-%m-%d>\n"))))

  (add-hook 'org-roam-capture-new-node-hook #'org-id-get-create)
  (org-roam-db-autosync-mode))

(require 'org-protocol)
(require 'org-roam-protocol)

(provide 'vv-org-roam)
