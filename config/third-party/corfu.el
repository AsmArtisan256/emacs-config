;; -*- lexical-binding: t; -*-

(use-package corfu
  :straight (corfu :files (:defaults "extensions/*")
		               :includes (corfu-info corfu-history corfu-popupinfo))
  :ensure t
  :demand t
  :bind (:map corfu-map
	            ("<escape>". corfu-quit)
              ;;	      ("<return>" . corfu-insert)
              ;;	      ("M-d" . corfu-info-documentation)
              ;;	      ("M-l" . 'corfu-info-location)
              ;;	      ("TAB" . corfu-next)
              ;;	      ([tab] . corfu-next)
              ;;	      ("S-TAB" . corfu-previous)
              ;;	      ([backtab] . corfu-previous)
              ;;	      ("M-n" . corfu-popupinfo-scroll-up)
              ;;	      ("M-p" . corfu-popupinfo-scroll-down)
              ;;	      ([remap corfu-show-documentation] . corfu-popupinfo-toggle)
	            )
  :custom
  (corfu-auto nil)

  (corfu-auto-prefix 1)
  (corfu-auto-delay 0.25)

  (corfu-min-width 80)
  ;; always have the same width
  (corfu-max-width corfu-min-width)
  (corfu-count 14)
  (corfu-scroll-margin 4)
  (corfu-cycle t)

  (corfu-quit-no-match 'separator)
  (corfu-preselect-first nil)

  (corfu-echo-documentation nil)

  ;; popupinfo
  (corfu-popupinfo-delay 0.5)
  (corfu-popupinfo-max-width 70)
  (corfu-popupinfo-max-height 20)

  ;; completion
  (tab-always-indent t)
  (completion-cycle-threshold nil)
  (completions-detailed t)
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode)
  )

(use-package kind-icon
  :after (corfu)
  :custom
  (kind-icon-use-icons t)
  (kind-icon-default-face 'corfu-default) ; Have background color be the same as `corfu' face background
  (kind-icon-blend-background nil)  ; Use midpoint color between foreground and background colors ("blended")?
  (kind-icon-blend-frac 0.08)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter) ; Enable `kind-icon'

  ;; NOTE: use this to not have issues with hidden completion items
  ;; because of icon height fucking up completion
  (setq kind-icon-default-style `(:padding -1 :stroke 0 :margin 0 :radius 0 :scale 1.0 :height 0.85))

  ;; Add hook to reset cache so the icon colors match my theme
  ;; NOTE 2022-02-05: This is a hook which resets the cache whenever I switch
  ;; the theme using my custom defined command for switching themes. If I don't
  ;; do this, then the backgound color will remain the same, meaning it will not
  ;; match the background color corresponding to the current theme. Important
  ;; since I have a light theme and dark theme I switch between. This has no
  ;; function unless you use something similar
  (add-hook 'kb/themes-hooks #'(lambda () (interactive) (kind-icon-reset-cache)))
  )

(use-package cape
  :after (corfu tempel)
  :demand t
  :bind (("C-c . p" . completion-at-point)
	       ("C-c . t" . complete-tag)
	       ("C-c . d" . cape-dabbrev)
	       ("C-c . h" . cape-history)
	       ("C-c . f" . cape-file)
	       ("C-c . k" . cape-keyword)
	       ("C-c . s" . cape-symbol)
	       ("C-c . a" . cape-abbrev)
	       ("C-c . l" . cape-line)
	       ("C-c . w" . cape-dict)
	       ("C-c . \\" . cape-tex)
	       ("C-c . _" . cape-tex)
	       ("C-c . ^" . cape-tex)
	       ("C-c . r" . cape-rfc1345))
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  (add-to-list 'completion-at-point-functions #'cape-file)
  :config
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
  )
