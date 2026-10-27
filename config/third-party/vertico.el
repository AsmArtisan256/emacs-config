;; -*- lexical-binding: t; -*-

(use-package vertico
  :straight (vertico :files (:defaults "extensions/*")
		     :includes (vertico-indexed
				vertico-flat
				vertico-grid
				vertico-mouse
				vertico-quick
				vertico-buffer
				vertico-repeat
				vertico-reverse
				vertico-directory
				vertico-multiform
				vertico-unobtrusive
				))
  :custom
  (vertico-count 13)
  (vertico-resize t)
  (vertico-cycle t)
  (vertico-grid-separator "       ")
  (vertico-grid-lookahead 50)
  (vertico-buffer-display-action '(display-buffer-reuse-window)) ; Default
  :config
  (advice-add #'vertico--format-candidate :around
	      (lambda (orig cand prefix suffix index _start)
		(setq cand (funcall orig cand prefix suffix index _start))
		(concat
		 (if (= vertico--index index)
		     (propertize "» " 'face 'vertico-current)
		   "  ")
		 cand)))

  (vertico-mode)
  )

(use-package vertico-posframe
  :straight t
  :after vertico
  :init
  (vertico-posframe-mode 1)
  :custom
  (vertico-posframe-poshandler #'posframe-poshandler-frame-center)
  (vertico-posframe-border-width 2)
  (vertico-posframe-parameters
   '((left-fringe . 8)
     (right-fringe . 8))))
