;; -*- lexical-binding: t; -*-

(use-package syntax-subword
  :straight (:host github :repo "jpkotta/syntax-subword")
  :ensure t
  :init
  (setq syntax-subword-skip-spaces nil)
  :config
  (global-syntax-subword-mode))
