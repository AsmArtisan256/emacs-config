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

;; the definitive theme TBHBBQFAM (the lightest of them all)
(add-to-list 'default-frame-alist '(reverse . t))
(setq initial-frame-alist default-frame-alist)

;; line highlight
(require 'hl-line)
(set-face-background 'hl-line "#3e4446")
(set-face-foreground 'highlight nil)


;; selection
(set-face-attribute 'region nil :background "#666")
