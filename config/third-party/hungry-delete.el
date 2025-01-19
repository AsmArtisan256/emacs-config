(use-package hungry-delete
  :diminish
  :config
  (setq hungry-delete-chars-to-skip " \t\r\f\v")

  ;; (defun my/hungry-delete-off ()
  ;;   (hungry-delete-mode -1))

  ;; hungry delete mode doesnt play well with multiple cursors...
  ;; (add-hook 'multiple-cursors-mode-enabled-hook #'my/hungry-delete-off)
  ;; (add-hook 'multiple-cursors-mode-disabled-hook #'my/hungry-delete-off)

  (global-hungry-delete-mode)
  )
