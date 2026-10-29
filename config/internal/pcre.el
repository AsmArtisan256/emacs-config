;; -*- lexical-binding: t; -*-

(use-package pcre2el
  :straight t
  :ensure t
  :defer 2
  :config (pcre-mode t)
  :diminish pcre-mode)
