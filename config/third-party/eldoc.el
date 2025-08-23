;; -*- lexical-binding: t; -*-

(use-package eldoc-box
  :straight t
  :ensure t
  :defer nil
  :bind (("C-; k"   . eldoc-box-help-at-point))
  :custom
  (eldoc-echo-area-use-multiline-p nil)
  :config
  (set-face-attribute 'eldoc-box-border nil :background "#cba6f7")
  )
