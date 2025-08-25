;; -*- lexical-binding: t; -*-

(use-package projectile
  :demand t
  :custom
  (projectile-completion-system 'default)
  (projectile-enable-caching t)
  (projectile-sort-order 'recently-active)
  (projectile-indexing-method 'native)
  (projectile-track-known-projects-automatically t)
  (projectile-project-search-path '(("~/Documents/Projects/Projects-Personal" . 1)))
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

  (add-hook 'kill-emacs-hook #'projectile-save-known-projects)

  (when (file-exists-p projectile-known-projects-file)
    (projectile-load-known-projects))

  (projectile-mode +1)
  )
