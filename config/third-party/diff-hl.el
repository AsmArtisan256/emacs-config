;; -*- lexical-binding: t; -*-

(use-package diff-hl
  :straight t
  :defer 1
  :hook
  (dired-mode . diff-hl-dired-mode-unless-remote)
  :config
  (global-diff-hl-mode 1)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  )
