;; -*- lexical-binding: t; -*-

;; eglot
(use-package eglot
  :straight (:type built-in)
  :ensure t
  :defer t
  :bind (("C-; a"   . eglot-code-actions)
	       ("C-; r n" . eglot-rename)
	       ("C-c k" . eldoc)
	       ("C-; f" . eglot-format)
	       ("C-; a" . eglot-code-actions)
	       ("C-; e" . flycheck-list-errors)
	       ("C-; d" . xref-find-definitions)
	       ("C-; r" . xref-find-references)
	       ("C-; p" . xref-go-back)
	       ("C-; n" . xref-go-forward)
	       ("C-; x a" . xref-find-apropos-at-point)
	       )
  :hook
  (
   ((c-mode c++-mode python-mode zig-mode) . eglot-ensure)
   )
  :custom
  ;; disable events buffer - SO ANNOYING!!!1!
  (eglot-events-buffer-size 0)

  ;; for non project files
  (eglot-extend-to-xref t)
  (eglot-autoreconnect nil)
  (eglot-connect-timeout nil)
  (eglot-sync-connect nil)
  :config
  ;; performance boost
  (fset #'jsonrpc--log-event #'ignore)

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

  ;; another way of disabling inlay hints
  (setq eglot-ignored-server-capabilities '(:inlayHintProvider))

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

;; for C/C++ definitions
(use-package eglot-inactive-regions
  :straight t
  :after (eglot)
  :custom
  (eglot-inactive-regions-style 'darken-foreground)
  (eglot-inactive-regions-opacity 0.4)
  :config
  (eglot-inactive-regions-mode 1)
  )

(use-package eglot-hierarchy
  :straight (:host github :repo "dolmens/eglot-hierarchy")
  :after (eglot)
  )

(use-package consult-eglot
  :after consult eglot
  :bind (:map eglot-mode-map
              ("C-M-." . consult-eglot-symbols)))
