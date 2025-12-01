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
	       ("C-; e" . flymake-show-diagnostics-buffer)
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

  ;; this was fucking up c-mode where { | } and RET would put the cursor one line
  ;; under!
  (add-to-list 'eglot-ignored-server-capabilities :documentOnTypeFormattingProvider)

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

  (defun my/do-then-quit (&rest args)
    "Execute function and quit window."
    (let ((win (selected-window)))
      (apply (car args) (cdr args))
      (quit-window nil win)))

  (advice-add #'xref-goto-xref :around #'my/do-then-quit)
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

(use-package yasnippet
  :diminish yas-minor-mode
  :bind ("M-e" . yas-expand)
  :hook (after-init . yas-global-mode)
  :config
  (setq hippie-expand-try-functions-list
        '(yas/hippie-try-expand
          try-complete-file-name-partially
          try-expand-all-abbrevs
          try-expand-dabbrev
          try-expand-dabbrev-all-buffers
          try-expand-dabbrev-from-kill
          try-complete-lisp-symbol-partially
          try-complete-lisp-symbol)))

(use-package yasnippet-snippets)

;; Yasnippet Completion At Point Function
(use-package yasnippet-capf
  :after cape eglot
  :commands yasnippet-capf
  :functions cape-capf-super eglot-completion-at-point my-eglot-capf-with-yasnippet
  :init
  (add-to-list 'completion-at-point-functions #'yasnippet-capf)

  ;; To integrate `yasnippet-capf' with `eglot' completion
  ;; https://github.com/minad/corfu/wiki#making-a-cape-super-capf-for-eglot
  (defun my-eglot-capf-with-yasnippet ()
    (setq-local completion-at-point-functions
                (list
	               (cape-capf-super
		              #'eglot-completion-at-point
		              #'yasnippet-capf))))
  (add-hook 'eglot-managed-mode-hook #'my-eglot-capf-with-yasnippet))
