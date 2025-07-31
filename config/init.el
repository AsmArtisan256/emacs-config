(require 'package)
(package-initialize)

(defun xah-get-fullpath (@file-relative-path)
  (concat (file-name-directory (or load-file-name buffer-file-name)) @file-relative-path))

					; (debug-on-variable-change 'org-directory)
					; (debug-on-variable-change 'org-cite-global-bibliography)

;;
;; general
;;
(load (xah-get-fullpath "general/general.el"))
(load (xah-get-fullpath "general/theme.el"))
(load (xah-get-fullpath "general/interface.el"))
(load (xah-get-fullpath "general/font.el"))

(load (xah-get-fullpath "general/mappings.el"))

(load (xah-get-fullpath "general/world-clock.el"))

;;
;; internal
;;
(load (xah-get-fullpath "internal/uniquify.el"))
(load (xah-get-fullpath "internal/savehist.el"))
(load (xah-get-fullpath "internal/icomplete.el"))

;;
;; third party
;;

;; theme related (theme.el already has modus-theme)
(load (xah-get-fullpath "third-party/pulsar.el"))
(load (xah-get-fullpath "third-party/lin.el"))
(load (xah-get-fullpath "third-party/cursory.el"))

(load (xah-get-fullpath "third-party/projectile.el"))

(load (xah-get-fullpath "third-party/dashboard.el"))
(load (xah-get-fullpath "third-party/fast-scroll.el"))

;; search
(load (xah-get-fullpath "third-party/ctrlf.el"))
(load (xah-get-fullpath "third-party/rg.el"))

;; fonts
(load (xah-get-fullpath "third-party/unicode-fonts.el"))
(load (xah-get-fullpath "third-party/mixed-pitch.el"))
(load (xah-get-fullpath "third-party/ligature.el"))

;; (load (xah-get-fullpath "third-party/no-littering.el"))
(load (xah-get-fullpath "third-party/gcmh.el"))

;; editing
(load (xah-get-fullpath "third-party/hungry-delete.el"))
(load (xah-get-fullpath "third-party/whitespace-cleanup.el"))
(load (xah-get-fullpath "third-party/multiple-cursors.el"))

(load (xah-get-fullpath "third-party/avy.el"))

(load (xah-get-fullpath "third-party/which-key.el"))

;; editing history
(load (xah-get-fullpath "third-party/undo-fu-session.el"))

;; completion, info, snippets, etc
(load (xah-get-fullpath "third-party/tempel.el"))
(load (xah-get-fullpath "third-party/corfu.el"))
(load (xah-get-fullpath "third-party/vertico.el"))
(load (xah-get-fullpath "third-party/marginalia.el"))
(load (xah-get-fullpath "third-party/consult.el"))
(load (xah-get-fullpath "third-party/orderless.el"))
(load (xah-get-fullpath "third-party/embark.el"))
;; (load (xah-get-fullpath "third-party/eglot.el"))

;; spell checking, errors, etc
(load (xah-get-fullpath "third-party/jinx.el"))

;; colors and help stuff
(load (xah-get-fullpath "third-party/helpful.el"))
(load (xah-get-fullpath "third-party/info-colors.el"))

;; formatting
(load (xah-get-fullpath "third-party/apheleia.el"))

;; git
(load (xah-get-fullpath "third-party/diff-hl.el"))
(load (xah-get-fullpath "third-party/magit.el"))

;; org mode
(load (xah-get-fullpath "third-party/org.el"))

;; LaTeX
(load (xah-get-fullpath "third-party/auctex.el"))

;; other modes
(load (xah-get-fullpath "third-party/vimrc-mode.el"))
(load (xah-get-fullpath "third-party/rust-mode.el"))
(load (xah-get-fullpath "third-party/nasm-mode.el"))
(load (xah-get-fullpath "third-party/php-mode.el"))
