;; -*- lexical-binding: t; -*-
(setq scroll-conservatively 101
      scroll-preserve-screen-position 1
      mouse-wheel-follow-mouse t
      pixel-scroll-precision-use-momentum t)

(setq-default line-spacing 1
              bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)

(setq bidi-inhibit-bpa t
      redisplay-skip-fontification-on-input t)

;; highlight the current line
(global-hl-line-mode t)

;; Frame margins & visible split dividers on all frames
(modify-all-frames-parameters '((internal-border-width . 8)
                                (right-divider-width . 3)
                                (bottom-divider-width . 0)))
(add-to-list 'default-frame-alist '(internal-border-width . 8))
(add-to-list 'default-frame-alist '(right-divider-width . 3))
(add-to-list 'default-frame-alist '(bottom-divider-width . 0))

;; Visible separators / dividers between all window splits (both horizontal and vertical)
(setq window-divider-default-places 'right-only
      window-divider-default-bottom-width 0
      window-divider-default-right-width 3)
(window-divider-mode 1)

;; fix color display when loading emacs in terminal
(defun enable-256color-term ()
  (interactive)
  (load-library "term/xterm")
  (terminal-init-xterm))

(unless (display-graphic-p)
  (if (string-suffix-p "256color" (getenv "TERM"))
      (enable-256color-term)))
