;; -*- lexical-binding: t; -*-

(use-package syntax-subword
  :straight (:host github :repo "jpkotta/syntax-subword")
  :ensure t
  :init
  (setq syntax-subword-skip-spaces t)
  :config
  (global-syntax-subword-mode))
