;; -*- lexical-binding: t; -*-

(use-package eldoc-box
  :straight t
  :ensure t
  :defer nil
  :bind (("C-; k" . eldoc-box-help-at-point)
         ("C-c k" . eldoc-box-help-at-point))
  :custom
  (eldoc-echo-area-use-multiline-p nil)
  :config
  (with-eval-after-load 'eldoc-box
    (when (facep 'eldoc-box-border)
      (set-face-attribute 'eldoc-box-border nil :background "#cba6f7"))))
