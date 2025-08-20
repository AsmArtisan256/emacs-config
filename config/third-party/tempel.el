;; -*- lexical-binding: t; -*-

(use-package tempel
  :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
	 ("M-*" . tempel-insert))
  :bind (:map tempel-map
	      ([backtab] . tempel-previous)
	      ([tab] . tempel-next))
  :init
  ;; Setup completion at point
  (defun tempel-setup-capf ()
    ;; Add the Tempel Capf to `completion-at-point-functions'.
    ;; `tempel-expand' only triggers on exact matches. Alternatively use
    ;; `tempel-complete' if you want to see all matches, but then you
    ;; should also configure `tempel-trigger-prefix', such that Tempel
    ;; does not trigger too often when you don't expect it. NOTE: We add
    ;; `tempel-expand' *before* the main programming mode Capf, such
    ;; that it will be tried first.
    (setq-local completion-at-point-functions
		(cons #'tempel-expand
		      completion-at-point-functions))
    ;; (add-hook 'completion-at-point-functions #'tempel-complete -100 t)
    ;; (add-to-list 'completion-at-point-functions #'tempel-complete -1 'local)
    )

  (add-hook 'conf-mode-hook 'tempel-setup-capf)
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf)
  (add-hook 'org-mode-hook 'tempel-setup-capf)
  )

(use-package tempel-collection
  :after (tempel)
  )
