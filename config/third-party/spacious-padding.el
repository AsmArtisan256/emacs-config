;; -*- lexical-binding: t; -*-

(use-package spacious-padding
  :straight t
  :custom
  (spacious-padding-widths
   '( :internal-border-width 8
      :header-line-width 3
      :mode-line-width 4
      :tab-width 3
      :right-divider-width 2
      :scroll-bar-width 8
      :fringe-width 8))
  :init
  (with-eval-after-load 'spacious-padding
    (advice-add 'spacious-padding-set-window-divider
                :override (lambda (face _color)
                            (list face '((t (:background "#b7d88d" :foreground "#b7d88d"))))))
    (advice-add 'spacious-padding-set-faces
                :after (lambda (&rest _)
                         (set-face-attribute 'vertical-border nil :foreground "#b7d88d" :background "#b7d88d")
                         (set-face-attribute 'window-divider nil :foreground "#b7d88d" :background "#b7d88d")
                         (set-face-attribute 'window-divider-first-pixel nil :foreground "#b7d88d" :background "#b7d88d")
                         (set-face-attribute 'window-divider-last-pixel nil :foreground "#b7d88d" :background "#b7d88d")
                         (set-face-attribute 'mode-line nil :box '(:line-width 1 :color "#b7d88d" :style nil))
                         (set-face-attribute 'mode-line-active nil :box '(:line-width 1 :color "#b7d88d" :style nil))
                         (set-face-attribute 'mode-line-inactive nil :box '(:line-width 1 :color "#8bcfc7" :style nil)))))
  :config
  (spacious-padding-mode 1))
