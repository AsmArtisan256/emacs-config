;; -*- lexical-binding: t; -*-

(use-package zig-mode
  :straight t
  :config
  (add-to-list 'auto-mode-alist '("\\.zig\\'" . zig-mode))
  )
