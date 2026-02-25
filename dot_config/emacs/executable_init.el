(message "Have a lot of fun....")

;;; --- Optimization ---

(setq gc-cons-threshold 100000000)
(setq max-specpdl-size 5000)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

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

;;; --- Modules ---

(require 'vv-ui)
(require 'vv-tools)
(require 'vv-editing)
(require 'vv-completion)
(require 'vv-org)
