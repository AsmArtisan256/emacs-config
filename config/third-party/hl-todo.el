;; -*- lexical-binding: t; -*-

(use-package hl-todo
  :straight t
  :ensure t
  :hook (prog-mode . hl-todo-mode)
  :bind (:map prog-mode-map
              ("M-g t" . hl-todo-next)
              ("M-g T" . hl-todo-previous))
  :config
  (defvar-keymap hl-todo-repeat-map
    :repeat t
    "n" #'hl-todo-next
    "p" #'hl-todo-previous)
  (setq hl-todo-wrap-movement t))
