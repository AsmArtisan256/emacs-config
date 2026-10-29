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

(defun my/vertico-posframe-get-size (buffer)
  (let ((width (min (max 85 (round (* (frame-width) 0.65)))
                    (frame-width)))
        (height (+ (or (bound-and-true-p vertico-count) 13) 1)))
    (list
     :height (buffer-local-value 'vertico-posframe-height buffer)
     :width (or (buffer-local-value 'vertico-posframe-width buffer) width)
     :min-height (or (buffer-local-value 'vertico-posframe-min-height buffer) height)
     :min-width (or (buffer-local-value 'vertico-posframe-min-width buffer) width))))

(use-package vertico-posframe
  :straight t
  :after vertico
  :init
  (vertico-posframe-mode 1)
  :custom
  (vertico-posframe-size-function #'my/vertico-posframe-get-size)
  (vertico-posframe-truncate-lines t)
  (vertico-posframe-poshandler #'posframe-poshandler-frame-center)
  (vertico-posframe-border-width 2)
  (vertico-posframe-parameters
   '((left-fringe . 8)
     (right-fringe . 8))))
