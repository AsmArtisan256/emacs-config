(use-package rust-mode
  :straight t
  :config
  (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
  )
