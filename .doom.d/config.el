;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'oxocarbon)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Library/Mobile Documents/ Documents/iCloud~com~appsonthemove~beorg/Documents/org")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(use-package! typst-ts-mode
  :custom
  (typst-ts-mode-enable-raw-blocks-highlight t))

(setq treesit-language-source-alist
      '((mermaid "https://github.com/monaqa/tree-sitter-mermaid")))

(setq company-idle-delay 0); immediately show autosuggestions

;; Org
(setq org-log-done 'time)

(setq org-tag-alist '(;; groups
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
                      ("neovim")
                      ("productivity")
                      ("health")
                      (:endgrouptag)

                      (:startgrouptag)
                      ("health")
                      (:grouptags)
                      ("mentalhealth")
                      (:endgrouptag)
                      ))

(setq org-agenda-custom-commands
      '(("p" "Personal"
         ((tags-todo "productivity")
          (tags-todo "neovim")
          (tags-todo "musicwork")
          (tags-todo "-{.+}")) ;without tags
         ((org-agenda-sorting-strategy '(priority-down))))))


(after! org
  (setq org-agenda-files '("/Users/musicvivireal/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org")))


(setq org-roam-directory "/Users/musicvivireal/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org")
(setq org-roam-capture-templates
      '(("d" "default" plain
         "%?"
         ;;:if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "${title}\n")
         :if-new (file+head "${slug}.org" "${title}\n")
         :unnarrowed t)))


(setq org-journal-dir "/Users/musicvivireal/Library/Mobile Documents/iCloud~com~appsonthemove~beorg/Documents/org"
      org-journal-file-format "%Y%m%d-dailyfile.org"
      org-journal-carryover-items "asdfsdf")


(after! org-download
  (setq org-download-method 'directory)
  (setq org-download-image-dir (concat (file-name-sans-extension (buffer-file-name)) "-img"))
  (setq org-download-image-org-width 600)
  (setq org-download-link-format "[[file:%s]]\n"
        org-download-abbreviate-filename-function #'file-relative-name)
  (setq org-download-link-format-function #'org-download-link-format-function-default))
