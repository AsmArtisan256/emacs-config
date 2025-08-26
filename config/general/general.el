;; -*- lexical-binding: t; -*-
;; general settings - requires further organization

;; tabs stuff
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq-default tab-stop-list (number-sequence 2 80 2))
(setq c-basic-indent 2)
(setq sh-basic-offset 2)

(setq default-directory "~/"
      ;; always follow symlinks when opening files
      vc-follow-symlinks t
      ;; quiet startup
      inhibit-startup-message t
      initial-scratch-message nil
      ;; hopefully all themes we install are safe
      custom-safe-themes t
      ;; when quiting emacs, just kill processes
      confirm-kill-processes nil
      ;; ask if local variables are safe once.
      enable-local-variables t

      ;; final newline
      require-final-newline t

      ;; Use 'fancy' ellipses for truncated strings
      truncate-string-ellipsis "…"

      ;; cursor
      cursor-type 'box
      cursor-in-non-selected-windows t

      ;; other
      apropos-do-all t
      )

;; window move
(windmove-default-keybindings 'meta)

;; Make switching buffers more consistent
(setopt switch-to-buffer-obey-display-actions t)

(setq-default
 ;; regex
 ;; regexp to match text at start of line that constitutes indentation
 adaptive-fill-regexp "[ t]+|[ t]*([0-9]+.|*+)[ t]*"
 ;; regexp specifying whether to set fill prefix from a one-line paragraph
 adaptive-fill-first-line-regexp "^* *$"
 ;; regexp describing the end of a sentence
 sentence-end "\\([。、！？]\\|……\\|[,.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*"
 )

;;
;; editing
;;

;; treat camel-cased words as individual words.
;; (add-hook 'prog-mode-hook 'subword-mode)
;; don't assume sentences end with two spaces after a period.
(setq sentence-end-double-space nil)

;;
;; modes
;;

;; show parenthesis
(show-paren-mode t)
(setq show-paren-delay 0.0)

;; autopair
(electric-pair-mode 1)

;; overwrite text when selected
(delete-selection-mode 1)

;; handle long lines without killing emacs
(global-so-long-mode)

;; save place
(setq save-place-file "~/.config/emacs/saveplace")
(save-place-mode 1)

;; treat as subword globally
(global-subword-mode 1)

;; stuff about marks dunno lmao
(transient-mark-mode 1)

;; Automatically reread from disk if the underlying file changes
(setopt auto-revert-avoid-polling t)
(setopt auto-revert-interval 5)
(setopt auto-revert-check-vc-info t)
(global-auto-revert-mode 1)

;; code folding
(add-hook 'prog-mode-hook #'hs-minor-mode)
