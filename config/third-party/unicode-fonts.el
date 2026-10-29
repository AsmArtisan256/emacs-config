;; -*- lexical-binding: t; -*-

(use-package persistent-soft
  :defer t)

(use-package fontaine
  :config
  (setq x-underline-at-descent-line t)

  ;; And this is for Emacs28.
  (setq-default text-scale-remap-header-line t)

  (defun my/font-available-p (font-family)
    "Return non-nil if FONT-FAMILY is available on the system."
    (or (and (fboundp 'find-font) (find-font (font-spec :family font-family)))
        (member font-family (font-family-list))
        (and (executable-find "fc-list")
             (not (string-empty-p
                   (string-trim
                    (shell-command-to-string
                     (format "fc-list :family=%s family"
                             (shell-quote-argument font-family)))))))))

  (setq fontaine-presets
        (if (my/font-available-p "Cozette")
            '((small
               :default-family "Cozette"
               :default-height 90
               :variable-pitch-family "Cozette"
               :default-width normal)
              (regular
               :default-family "Cozette"
               :default-height 100
               :variable-pitch-family "Cozette"
               :default-width normal)
              (medium
               :default-family "Cozette"
               :default-height 100
               :default-weight regular
               :variable-pitch-family "Cozette"
               :default-width normal)
              (large
               :default-family "Cozette"
               :default-height 120
               :variable-pitch-family "Cozette"
               :default-width normal)
              (presentation
               :default-family "Cozette"
               :default-height 130
               :variable-pitch-family "Cozette"
               :default-width normal)
              (t
               :default-family "Cozette"
               :default-weight regular
               :default-height 100
               :default-width normal
               :variable-pitch-family "Cozette"
               :variable-pitch-weight regular
               :variable-pitch-height 100))
          '((small
             :default-family "Iosevka Custom"
             :default-height 140
             :variable-pitch-family "Iosevka Custom"
             :default-width condensed)
            (regular) ; like this it uses all the fallback values and is named `regular'
            (medium
             :default-weight semibold
             :default-height 155
             :bold-weight extrabold
             :default-width condensed)
            (large
             :inherit medium
             :default-height 170)
            (presentation
             :default-height 180)
            (t
             ;; I keep all properties for didactic purposes, but most can be
             ;; omitted.  See the fontaine manual for the technicalities:
             ;; <https://protesilaos.com/emacs/fontaine>.
             :default-family "Iosevka Custom"
             :default-weight semibold
             :default-height 155
             :default-width condensed
             :variable-pitch-family "Iosevka Custom"
             :variable-pitch-weight regular
             :variable-pitch-height 155
             :variable-pitch-height 1.0))))

  ;; Set last preset or fall back to desired style from `fontaine-presets'.
  (fontaine-set-preset (or (fontaine-restore-latest-preset) 'regular))

  ;; The other side of `fontaine-restore-latest-preset'.
  (add-hook 'kill-emacs-hook #'fontaine-store-latest-preset)

  ;; Persist font configurations while switching themes.  The
  ;; `enable-theme-functions' is from Emacs 29.
  (add-hook 'enable-theme-functions #'fontaine-apply-current-preset)

  (define-key global-map (kbd "C-c f") #'fontaine-set-preset)
  (define-key global-map (kbd "C-c F") #'fontaine-set-face-font)

  ;; other font settings
  (set-face-attribute 'font-lock-comment-face nil :slant 'italic)
  (set-face-attribute 'font-lock-comment-delimiter-face nil :slant 'italic)
  (set-face-attribute 'font-lock-comment-delimiter-face nil :slant 'italic)
  )

(use-package unicode-fonts
  :defer 2
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
