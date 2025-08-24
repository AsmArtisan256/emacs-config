;; -*- lexical-binding: t; -*-

;; enable indent-tabs-mode when using c-mode

(use-package cc-mode
  :ensure nil
  :bind (:map c-mode-base-map
	            ("<f12>" . compile)
              ("C-d" . duplicate-line))
  :config
  (setq c-basic-offset 2)
  (setq tab-width 2)
  (setq c-default-style "linux")

  (add-hook
   'c-mode-common-hook (
                        lambda ()
				                (setq indent-tabs-mode t)
                        (setq comment-start "// "
                              comment-end   "")
				                )
	 )

  )
