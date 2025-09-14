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
(use-package paren
  :defer 2
  :config
  (show-paren-mode 1)
  (setq show-paren-delay 0.1
        show-paren-highlight-openparen t
        show-paren-when-point-inside-paren t))

;; autopair
(electric-pair-mode 1)

;; overwrite text when selected
(delete-selection-mode 1)

;; handle long lines without killing emacs
(use-package so-long
  :hook (after-init . global-so-long-mode))

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


;;
;;
;;
;;
;;

(use-package window
  :straight (:type built-in)
  :bind (("H-+" . balance-windows-area)
         ;; ("C-x +" . balance-windows-area)
         ("C-x q" . my/kill-buffer-and-window)
         ("ESC M-v" . scroll-other-window-down)
         :map window-prefix-map
         ("1" . my/window-toggle-dedicated))
  :config
  (setq switch-to-prev-buffer-skip nil) ;'this
  (setq truncate-partial-width-windows t)
  (setq other-window-scroll-default
        (lambda ()
          (or (get-mru-window nil nil 'not-this-one-dummy)
              (next-window)
              (next-window nil nil 'visible))))
  (defun my/kill-buffer-and-window ()
    "Kill buffer.

Also kill this window, tab or frame if necessary."
    (interactive)
    (if (one-window-p)
        (progn (kill-buffer)
               (my/delete-window-or-delete-frame))
      (kill-buffer-and-window)))

  ;; quit-window behavior is completely broken
  ;; Fix by adding winner-mode style behavior to quit-window
  (defun my/better-quit-window-save (window)
    (push (window-parameter window 'quit-restore)
          (window-parameter window 'quit-restore-stack))
    window)
  (defun my/better-quit-window-restore (origfn &optional window bury-or-kill)
    (let ((sw (or window (selected-window))))
      (funcall origfn window bury-or-kill)
      (when (eq sw (selected-window))
        (pop (window-parameter nil 'quit-restore-stack))
        (setf (window-parameter nil 'quit-restore)
              (car (window-parameter nil 'quit-restore-stack))))))

  (defun my/window-toggle-dedicated (&optional win)
    (interactive (list (selected-window)))
    (let ((dedicated (window-dedicated-p win)))
      (set-window-dedicated-p win (not dedicated))
      (message "Window marked as %s." (if dedicated "free" "dedicated"))))

  (advice-add 'display-buffer :filter-return #'my/better-quit-window-save)
  (advice-add 'quit-restore-window :around #'my/better-quit-window-restore))
