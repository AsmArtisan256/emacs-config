;; -*- lexical-binding: t; -*-

(use-package persistent-soft
  :demand t)

(use-package fontaine
  :config
  (setq x-underline-at-descent-line t)

  ;; And this is for Emacs28.
  (setq-default text-scale-remap-header-line t)

  (setq fontaine-presets
	'((small
	   :default-family "Iosevka Comfy Motion"
	   :default-height 140
	   :variable-pitch-family "Iosevka Comfy Duo")
	  (regular) ; like this it uses all the fallback values and is named `regular'
	  (medium
	   :default-weight semibold
	   :default-height 155
	   :bold-weight extrabold)
	  (large
	   :inherit medium
	   :default-height 170)
	  (presentation
	   :default-height 180)
	  (t
	   ;; I keep all properties for didactic purposes, but most can be
	   ;; omitted.  See the fontaine manual for the technicalities:
	   ;; <https://protesilaos.com/emacs/fontaine>.
	   :default-family "Iosevka Comfy"
	   :default-weight semibold
	   :default-height 155
	   :fixed-pitch-family nil ; falls back to :default-family
	   :fixed-pitch-weight nil ; falls back to :default-weight
	   :fixed-pitch-height 1.0
	   :fixed-pitch-serif-family nil ; falls back to :default-family
	   :fixed-pitch-serif-weight nil ; falls back to :default-weight
	   :fixed-pitch-serif-height 1.0
	   :variable-pitch-family "Iosevka Comfy Motion Duo"
	   :variable-pitch-weight nil
	   :variable-pitch-height 1.0
	   :bold-family nil ; use whatever the underlying face has
	   :bold-weight bold
	   :italic-family nil
	   :italic-slant italic
	   :line-spacing nil)))

  ;; Set last preset or fall back to desired style from `fontaine-presets'.
  (fontaine-set-preset (or (fontaine-restore-latest-preset) 'regular))

  ;; The other side of `fontaine-restore-latest-preset'.
  (add-hook 'kill-emacs-hook #'fontaine-store-latest-preset)

  ;; Persist font configurations while switching themes.  The
  ;; `enable-theme-functions' is from Emacs 29.
  (add-hook 'enable-theme-functions #'fontaine-apply-current-preset)

  (define-key global-map (kbd "C-c f") #'fontaine-set-preset)
  (define-key global-map (kbd "C-c F") #'fontaine-set-face-font)
  )

(use-package unicode-fonts
  :after (fontaine)
  :demand t
  :after persistent-soft
  :config
  (unicode-fonts-setup)

  ;; (custom-set-faces
  ;;  `(default ((t (:family "Iosevka Nerd Font"
  ;;			  :height 155
  ;;			  :width normal
  ;;			  :weight regular
  ;;			  ))))
  ;;  `(fixed-pitch ((t (:family "Iosevka Nerd Font"
  ;;			      :height 155
  ;;			      :width normal
  ;;			      :weight regular
  ;;			      ))))
  ;;  `(variable-pitch ((t (:family "Iosevka Nerd Font"
  ;;				 :height 155
  ;;				 :weight regular)))))
  )
