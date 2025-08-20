;; -*- lexical-binding: t; -*-

(use-package projectile
  :demand t
  :custom
  (projectile-completion-system 'default)
  (projectile-enable-caching t)
  (projectile-sort-order 'recently-active)
  (projectile-indexing-method 'native)
  (projectile-project-search-path '(("~/Documents/Projects/" . 1) ("~/Documents/Projects-Work/" . 1)))
  :config

  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

  (projectile-save-known-projects)
  (projectile-mode +1)
  )
