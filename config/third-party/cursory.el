;; -*- lexical-binding: t; -*-

(use-package cursory
  :config
  (setq cursory-presets
	'((box
	   :blink-cursor-interval 0.6)
	  (box-no-blink
	   :blink-cursor-mode -1)
	  (bar
	   :cursor-type (bar . 2)
	   :blink-cursor-interval 0.5)
	  (bar-no-other-window
	   :inherit bar
	   :cursor-in-non-selected-windows nil)
	  (underscore
	   :cursor-type (hbar . 3)
	   :blink-cursor-blinks 50)
	  (underscore-thin-other-window
	   :inherit underscore
	   :cursor-in-non-selected-windows (hbar . 1))
	  (underscore-thick
	   :cursor-type (hbar . 8)
	   :blink-cursor-interval 0.3
	   :blink-cursor-blinks 50
	   :cursor-in-non-selected-windows (hbar . 3))
	  (underscore-thick-no-blink
	   :blink-cursor-mode -1
	   :cursor-type (hbar . 8)
	   :cursor-in-non-selected-windows (hbar . 3))
	  (t ; the default values
	   :cursor-type box
	   :cursor-in-non-selected-windows hollow
	   :blink-cursor-mode 1
	   :blink-cursor-blinks 10
	   :blink-cursor-interval 0.2
	   :blink-cursor-delay 0.2)))

  ;; I am using the default values of `cursory-latest-state-file'.

  ;; Set last preset or fall back to desired style from `cursory-presets'.
  (cursory-set-preset (or (cursory-restore-latest-preset) 'box))

  ;; The other side of `cursory-restore-latest-preset'.
  (add-hook 'kill-emacs-hook #'cursory-store-latest-preset)
  )
