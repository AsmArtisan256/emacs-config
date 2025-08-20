;; -*- lexical-binding: t; -*-

(use-package diff-hl
  :defer 1
  :hook
  (dired-mode . diff-hl-dired-mode-unless-remote)
  :config
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

  (global-diff-hl-mode 1))
