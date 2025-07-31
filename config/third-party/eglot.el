;; eglot
(use-package eglot
  :after (cape)
  :ensure t
  :defer t
  :hook (
	 (python-mode . eglot-ensure)
	 )
  :config
  (setq completion-category-overrides '((eglot (styles orderless))
					(eglot-capf (styles orderless))))

  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)

  (defun my/eglot-capf ()
    (setq-local completion-at-point-functions
		(list (cape-capf-super
		       #'eglot-completion-at-point
		       #'tempel-expand))))

  (add-hook 'eglot-managed-mode-hook #'my/eglot-capf)
  )
