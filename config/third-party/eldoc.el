;; -*- lexical-binding: t; -*-

(use-package eldoc-box
  :straight t
  :ensure t
  :defer nil
  :bind (("C-; k"   . eldoc-box-help-at-point))
  :custom
  (eldoc-echo-area-use-multiline-p nil)
  )
