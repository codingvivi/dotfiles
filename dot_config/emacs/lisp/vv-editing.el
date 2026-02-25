;;; vv-editing.el --- Theme and modal editing

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

(provide 'vv-editing)
