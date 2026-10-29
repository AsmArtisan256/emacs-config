;; -*- lexical-binding: t; -*-

(use-package treesit
  :straight (:type built-in)
  :when (and (fboundp 'treesit-available-p) (treesit-available-p))
  :custom
  (treesit-enabled-modes t)
  (treesit-auto-install-grammar 'ask)
  (treesit-font-lock-level 4)
  :config
  (add-to-list 'major-mode-remap-alist '(json-mode . json-ts-mode)))
