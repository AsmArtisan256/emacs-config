;; general settings - requires further organization

;; spaces instead of tabs
(setq-default indent-tabs-mode nil)

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

      ;; backups
      backup-directory-alist `(("." . "~/.config/emacs/backups"))
      create-lockfiles nil
      backup-by-copying t
      delete-old-versions t
      load-prefer-newer t
      kept-old-version 2
      kept-new-version 6

      ;; copy/paste stuff
      kill-whole-line t
      save-interprogram-paste-before-kill t
      mouse-yank-at-point t
      select-enable-clipboard t
      x-select-enable-clipboard t

      ;; final newline
      require-final-newline t

      ;; Use 'fancy' ellipses for truncated strings
      truncate-string-ellipsis "…"

      ;; cursor
      cursor-type 'box
      cursor-in-non-selected-windows t

      ;; fill column
      fill-column 80

      ;; other
      apropos-do-all t
      )

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
;; limit files to 80 columns. Controversial, I know.
(setq-default fill-column 80)


;;
;; dired
;;

;; clean up dired buffers
(setq dired-kill-when-opening-new-dired-buffer t)

;; use human-readable sizes in dired
(setq-default dired-listing-switches "-alh")

;;
;; modes
;;

;; show parenthesis
(show-paren-mode t)
(setq show-paren-delay 0.0)

;; autopair
(electric-pair-mode 1)

;; refresh a buffer if changed on disk
(global-auto-revert-mode 1)

;; overwrite text when selected
(delete-selection-mode 1)

;; handle long lines without killing emacs
(global-so-long-mode)

;; save place
(setq save-place-file "~/.config/emacs/saveplace")
(save-place-mode 1)

;; treat as subword globally
(global-subword-mode 1)

;; buffer size in modeline
(size-indication-mode 1)

;; column number in modeline
(column-number-mode 1)

;; stuff about marks dunno lmao
(transient-mark-mode 1)

;; show fill column
(display-fill-column-indicator-mode 1)
