(use-package magit
  :commands magit
  ;; :custom
  ;; (magit-repository-directories `((,*project-dir* . 3)))
  :config
  ;; speed up magit for large repos
  (dir-locals-set-class-variables 'huge-git-repository
				  '((magit-status-mode
				     . ((eval . (magit-disable-section-inserter 'magit-insert-tags-header))))))
  )

(use-package magit-todos
  :after magit
  :commands magit-todos-list magit-todos-mode)

(use-package magit-delta
  :after magit
  :commands magit-delta-mode
  :hook (magit-mode . magit-delta-mode))
