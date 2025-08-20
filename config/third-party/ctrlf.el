;; -*- lexical-binding: t; -*-

(use-package ctrlf
  :straight t
  :bind (("C-s" . ctrlf-forward-default)
         ("C-M-s" . ctrlf-forward-alternate)
         ("C-r" . ctrlf-backward-default)
         ("C-M-r" . ctrlf-backward-alternate))
  :config (ctrlf-mode +1)
  )
