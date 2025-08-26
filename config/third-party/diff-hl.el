;; -*- lexical-binding: t; -*-

(use-package diff-hl
  :straight t
  :hook
  (dired-mode . diff-hl-dired-mode-unless-remote)
  :init
  (global-diff-hl-mode 1)
  :config
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  )
