;; -*- lexical-binding: t; -*-
;; general settings - requires further organization

;; tabs stuff
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq-default tab-stop-list (number-sequence 2 80 2))
;; (setq c-basic-indent 2)
;; (setq sh-basic-offset 2)

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

;; soft line wrapping for prose/writing
(add-hook 'text-mode-hook #'visual-line-mode)

;; show parenthesis
(use-package paren
  :defer 2
  :config
  (show-paren-mode 1)
  (setq show-paren-delay 0.1
        show-paren-highlight-openparen t
        show-paren-when-point-inside-paren t))

;; autopair
(require 'elec-pair)
(electric-pair-mode 1)

;; Disable automatic pairing in the minibuffer / echo area (e.g. search prompts like ctrlf, consult, find-file)
(setq electric-pair-inhibit-predicate
      (lambda (char)
        (if (minibufferp)
            t
          (electric-pair-default-inhibit char))))

(add-hook 'minibuffer-setup-hook
          (lambda ()
            (setq-local electric-pair-mode nil)))

;; overwrite text when selected
(delete-selection-mode 1)

;; handle long lines without killing emacs
(use-package so-long
  :hook (after-init . global-so-long-mode))

;;
;; Large file performance safeguards (>1MB)
;;
(defcustom my-large-file-size (* 1 1024 1024) ; 1MB
  "File size threshold in bytes above which a buffer is considered large."
  :type 'integer
  :group 'files)

;; Set warning threshold for VLF / Emacs
(setq large-file-warning-threshold my-large-file-size)

(defun my/buffer-large-p ()
  "Return non-nil if current buffer exceeds `my-large-file-size'."
  (and buffer-file-name (> (buffer-size) my-large-file-size)))

;; Inhibit Eglot LSP from starting on large files
(with-eval-after-load 'eglot
  (defun my/eglot-ensure-skip-large (orig-fn &rest args)
    "Do not automatically start Eglot LSP on large files (>1MB)."
    (unless (my/buffer-large-p)
      (apply orig-fn args)))
  (advice-add 'eglot-ensure :around #'my/eglot-ensure-skip-large))

(defun my/large-file-setup ()
  "Disable heavy minor modes in large buffers (>1MB) to prevent freezing/stuttering."
  (when (my/buffer-large-p)
    ;; Prevent memory bloat and accidental heavy undo logs
    (setq-local buffer-read-only t)
    (buffer-disable-undo)

    ;; Disable LSP if active
    (when (bound-and-true-p eglot--managed-mode)
      (ignore-errors (eglot-shutdown (eglot-current-server))))

    ;; Disable heavy background checkers and tools
    (when (fboundp 'flymake-mode) (flymake-mode -1))
    (when (fboundp 'diff-hl-mode) (diff-hl-mode -1))
    (when (fboundp 'apheleia-mode) (apheleia-mode -1))
    (when (fboundp 'hl-todo-mode) (hl-todo-mode -1))
    (when (fboundp 'syntax-subword-mode) (syntax-subword-mode -1))

    ;; Disable syntax fontification and bracket matching
    (font-lock-mode -1)
    (setq-local show-paren-mode nil)
    (setq-local electric-pair-mode nil)

    ;; Disable auto-saving and auto-reverting for this buffer
    (auto-save-mode -1)
    (setq-local auto-revert-mode nil)

    ;; Fast scrolling & bidi display optimization
    (setq-local bidi-paragraph-direction 'left-to-right)
    (setq-local bidi-inhibit-bpa t)
    (setq-local fast-but-imprecise-scrolling t)

    (message "Large file safeguard (>1MB): heavy features (LSP, linters, git-gutter, font-lock, undo) disabled.")))

(add-hook 'find-file-hook #'my/large-file-setup)

;; save place
(setq save-place-file "~/.config/emacs/saveplace")
(save-place-mode 1)

;; stuff about marks dunno lmao
(transient-mark-mode 1)

;; Automatically reread from disk if the underlying file changes
(setopt auto-revert-avoid-polling t)
(setopt auto-revert-interval 5)
(setopt auto-revert-check-vc-info nil)
(global-auto-revert-mode 1)

;; code folding
;; (add-hook 'prog-mode-hook #'hs-minor-mode)


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
