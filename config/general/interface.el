;; -*- lexical-binding: t; -*-
(setq scroll-conservatively 101
      scroll-preserve-screen-position 1
      mouse-wheel-follow-mouse t
      pixel-scroll-precision-use-momentum t)

(setq-default line-spacing 1)

;; highlight the current line
(global-hl-line-mode t)

;; fix color display when loading emacs in terminal
(defun enable-256color-term ()
  (interactive)
  (load-library "term/xterm")
  (terminal-init-xterm))

(unless (display-graphic-p)
  (if (string-suffix-p "256color" (getenv "TERM"))
      (enable-256color-term)))
