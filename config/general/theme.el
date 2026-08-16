;; -*- lexical-binding: t; -*-

;; (use-package catppuccin-theme
;;   :ensure t
;;   :demand t
;;   :config
;;   (load-theme 'catppuccin :no-confirm)

;;   (setq catppuccin-flavor 'mocha)
;;   (catppuccin-set-color 'base "#11111b")
;;   (catppuccin-reload)

;;   (custom-set-faces
;;    ;; modeline customizations
;;    '(mode-line ((t (:box (:line-width 2 :color "#cba6f7") :background "#11111b" :foreground "#cdd6f4" :weight bold))))
;;    '(mode-line-active ((t (:box (:line-width 2 :color "#cba6f7") :background "#11111b" :foreground "#cdd6f4" :weight bold))))
;;    '(mode-line-inactive ((t (:box (:line-width 2 :color "#cba6f7") :background "#11111b" :foreground "#cdd6f4" :weight bold))))
;;    ;; show paren match customizations
;;    '(show-paren-match ((t (:foreground "#f38ba8" :background "#45475a" :underline t :weight bold))))
;;    )
;;   )

;; (use-package modus-themes
;;   :custom
;;   (modules-themes-custom-auto-reload nil)

;;   (modus-themes-mixed-fonts t)
;;   (modus-themes-variable-pitch-ui t)
;;   (modus-themes-italic-constructs t)
;;   (modus-themes-bold-constructs t)
;;   (modus-themes-completions '((t . (extrabold))))
;;   (modus-themes-prompts '(extrabold))

;;   (modus-themes-headings
;;    '((agenda-structure . (variable-pitch semibold 2.2))
;;      (agenda-date . (variable-pitch semibold 1.3))
;;      (t . (semibold 1.15))))

;;   (modus-themes-with-colors
;;     ;; (set-face-attribute 'fill-column-indicator nil
;;     ;;			:background bg-inactive
;;     ;;			:foreground bg-inactive)
;;     (custom-set-faces
;;      `(separator-line ((,class :background ,"#242424"))))

;;     (set-face-attribute 'separator-line nil
;; 			                  :inherit 'shadow
;; 			                  :background nil
;; 			                  :underline t
;; 			                  :height 1)

;;     )


;;   (modus-themes-common-palette-overrides nil)
;;   :config
;;   (load-theme 'modus-vivendi :no-confirm)
;;   )


;; line highlight
(require 'hl-line)
(set-face-background 'hl-line "#202728")
(set-face-foreground 'highlight nil)

;; selection (bg_visual)
(set-face-attribute 'region nil :background "#634452")

;; everforest theme with custom Vim palette overrides
(use-package everforest-theme
  :straight (everforest-theme :type git :host github :repo "theorytoe/everforest-emacs")
  :demand t
  :init
  (add-to-list 'custom-theme-load-path (straight--build-dir "everforest-theme"))
  (add-to-list 'custom-theme-load-path (straight--build-dir "everforest"))
  (setq everforest-hard-dark-colors-alist
        '(("everforest-hard-dark-accent"   . "#b7d88d")  ; green / statusline1
          ("everforest-hard-dark-fg"       . "#f4ead5")  ; fg
          ("everforest-hard-dark-bg"       . "#151a1b")  ; bg0
          ("everforest-hard-dark-bg-1"     . "#202728")  ; bg1
          ("everforest-hard-dark-bg-hl"    . "#2b3435")  ; bg2
          ("everforest-hard-dark-gutter"   . "#394445")  ; bg3
          ("everforest-hard-dark-mono-1"   . "#c0c9bf")  ; grey2
          ("everforest-hard-dark-mono-2"   . "#5c4963")  ; bg_purple
          ("everforest-hard-dark-mono-3"   . "#89968c")  ; grey0
          ("everforest-hard-dark-cyan"     . "#93d9a6")  ; aqua
          ("everforest-hard-dark-blue"     . "#8bcfc7")  ; blue
          ("everforest-hard-dark-purple"   . "#e5a1c3")  ; purple
          ("everforest-hard-dark-green"    . "#b7d88d")  ; green
          ("everforest-hard-dark-red"      . "#f28a8f")  ; red
          ("everforest-hard-dark-orange"   . "#f2ad7c")  ; orange
          ("everforest-hard-dark-yellow"   . "#e8ca7a")  ; yellow
          ("everforest-hard-dark-gray"     . "#5d6b67")  ; bg5
          ("everforest-hard-dark-silver"   . "#a3afa5")  ; grey1
          ("everforest-hard-dark-black"    . "#0c1011")  ; bg_dim
          ("everforest-hard-dark-border"   . "#4a5655")  ; bg4
          ("everforest-hard-dark-visual"   . "#634452"))) ; bg_visual
  :config
  (load-theme 'everforest-hard-dark t)

  ;; Harmonious Everforest mode-line styling
  (custom-set-faces
   '(mode-line ((t (:background "#202728" :foreground "#f4ead5" :box (:line-width 1 :color "#4a5655" :style nil)))))
   '(mode-line-inactive ((t (:background "#151a1b" :foreground "#89968c" :box (:line-width 1 :color "#394445" :style nil)))))
   '(mode-line-buffer-id ((t (:foreground "#b7d88d" :weight bold))))
   '(mode-line-emphasis ((t (:foreground "#b7d88d" :weight bold))))
   '(mood-line-status-neutral ((t (:foreground "#8bcfc7"))))
   '(mood-line-status-info ((t (:foreground "#93d9a6"))))
   '(mood-line-status-success ((t (:foreground "#b7d88d"))))
   '(mood-line-status-warning ((t (:foreground "#e8ca7a"))))
   '(mood-line-status-error ((t (:foreground "#f28a8f"))))))
