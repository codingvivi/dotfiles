;;; vv-completion.el --- Completion framework

(use-package vertico
  :custom
  (vertico-count 20)
  :init
  (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package savehist
  :init
  (savehist-mode))

;; In-buffer completion popup. Org's built-in capf already completes tags
;; (from `org-tag-alist' + tags in the buffer) after a `:' on a headline,
;; so corfu-auto just needs to be on in org buffers.
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 1)
  (corfu-cycle t)
  :hook (org-mode . corfu-mode))

(use-package emacs
  :custom
  (context-menu-mode t)
  (enable-recursive-minibuffers t)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

(provide 'vv-completion)
