;; -*- lexical-binding: t; -*-
(setq scroll-conservatively 101
      scroll-preserve-screen-position 1
      mouse-wheel-follow-mouse t
      pixel-scroll-precision-use-momentum t)

(setq-default line-spacing 1)

;; highlight the current line
(global-hl-line-mode t)

;; workspaces (top bar) - compact & sleek with close/new buttons
(tab-bar-mode 1)
(setq tab-bar-show 1
      tab-bar-auto-width t
      tab-bar-close-button-show t
      tab-bar-new-button-show t
      tab-bar-tab-hints nil
      tab-bar-close-button (propertize " ✕ " 'close-tab t 'help "Click to close tab")
      tab-bar-new-button (propertize " + " 'help "Click to create a new tab")
      tab-bar-separator " ")

;; Top margin & breathing room around frame
(modify-all-frames-parameters '((internal-border-width . 8)))
(add-to-list 'default-frame-alist '(internal-border-width . 8))

;; Compact font & sleek styling with borders for workspace bar
(set-face-attribute 'tab-bar nil :height 0.8)
(set-face-attribute 'tab-bar-tab nil
                    :weight 'bold
                    :underline nil
                    :box '(:line-width 1 :color "#b7d88d" :style nil))
(set-face-attribute 'tab-bar-tab-inactive nil
                    :weight 'normal
                    :inherit 'shadow
                    :box '(:line-width 1 :color "#4a5655" :style nil))

;; fix color display when loading emacs in terminal
(defun enable-256color-term ()
  (interactive)
  (load-library "term/xterm")
  (terminal-init-xterm))

(unless (display-graphic-p)
  (if (string-suffix-p "256color" (getenv "TERM"))
      (enable-256color-term)))
