;; (straight-use-package 'catppuccin-theme)
;; (load-theme 'catppuccin :no-confirm)

(use-package modus-themes
  :custom
  (modules-themes-custom-auto-reload nil)
  (modus-themes-mixed-fonts t)
  (modus-themes-variable-pitch-ui t)
  (modus-themes-italic-constructs t)
  (modus-themes-bold-constructs nil)
  (modus-themes-org-blocks nil)
  (modus-themes-completions '((t . (extrabold))))
  (modus-themes-prompts '(extrabold))

  (modus-themes-headings
   '((agenda-structure . (variable-pitch semibold 2.2))
     (agenda-date . (variable-pitch semibold 1.3))
     (t . (semibold 1.15))))

  (modus-themes-with-colors
    ;; (set-face-attribute 'fill-column-indicator nil
    ;;			:background bg-inactive
    ;;			:foreground bg-inactive)
    (custom-set-faces
     `(separator-line ((,class :background ,"#242424"))))

    (set-face-attribute 'separator-line nil
			:inherit 'shadow
			:background nil
			:underline t
			:height 1)

    )


  (modus-themes-common-palette-overrides nil)
  :config
  (load-theme 'modus-vivendi :no-confirm)
  )
