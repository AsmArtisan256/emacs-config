;; eglot
(use-package eglot
  :straight (:type built-in)
  :ensure t
  :defer t
  :bind (("C-; a"   . eglot-code-actions)
	 ("C-; r n" . eglot-rename)
	 ("C-; e d" . eldoc)
	 ("C-; e f" . eglot-format)
	 ("C-; e a" . eglot-code-actions)
	 ("C-; e e" . flycheck-list-errors)
	 ("C-; x d" . xref-find-definitions)
	 ("C-; x r" . xref-find-references)
	 ("C-; x p" . xref-go-back)
	 ("C-; x n" . xref-go-forward)
	 ("C-; x a" . xref-find-apropos-at-point)
	 )
  :hook
  (
   ((c-mode c++-mode python-mode zig-mode) . eglot-ensure)
   )
  :custom
  (eglot-auto-reconnect t)
  (eglot-stay-out-of (eldoc-documentation-strategy))
  (eglot-connect-timeout 120)
  :config
  (setq completion-category-overrides '((eglot (styles orderless))
					(eglot-capf (styles orderless))))

  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)

  (defun my/lsp-mode ()
    ;; dunno whatever this does idc
    (setq-local completion-at-point-functions
		(list (cape-capf-super
		       #'eglot-completion-at-point
		       #'tempel-expand)))

    ;; disable inlay hints
    (eglot-inlay-hints-mode -1)
    )

  (add-hook 'eglot-managed-mode-hook 'my/lsp-mode)

  ;; disable events buffer - SO ANNOYING!!!1!
  (setq-default eglot-events-buffer-size 0)

  ;; another way of disabling inlay hints
  (setq eglot-ignored-server-capabilities '(:inlayHintProvider))

  ;; activate Eglot in cross-referenced non-project files
  ;; is this that useful though?
  (setq eglot-extend-to-xref t)

  ;; server programs
  (add-to-list 'eglot-server-programs
	       '((c++-mode c-mode cc-mode)
		 "clangd"
		 "-j=2"
		 "--background-index"
		 "--clang-tidy"
		 "--completion-style=bundled"
		 "--header-insertion=never"
		 "--header-insertion-decorators"))
  )
