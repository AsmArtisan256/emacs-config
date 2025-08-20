;; -*- lexical-binding: t; -*-

(use-package nasm-mode
  :straight t
  :config
  (add-to-list 'auto-mode-alist '("\\.asm\\'" . nasm-mode))
  )
