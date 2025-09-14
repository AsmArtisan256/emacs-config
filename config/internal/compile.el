;; -*- lexical-binding: t; -*-

(use-package compile
  :defer t
  :hook (compilation-filter . ansi-color-compilation-filter)
  :config
  (setq compilation-always-kill t
        compilation-ask-about-save nil
        compilation-scroll-output 'first-error)
  (global-set-key [(f9)] 'compile)
  )
