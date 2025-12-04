;; -*- lexical-binding: t; -*-

(use-package expand-region
  :straight t
  :ensure t
  :defer nil
  :preface
  (defun my/er-contract-region ()
    "Contract region like calling C-- C-]."
    (interactive)
    (let ((current-prefix-arg '(-1)))
      (call-interactively #'er/expand-region)))
  :bind (
         ("C-]" . er/expand-region)
         ("C-c ]" . my/er-contract-region)
         )
  )

;; prefix with C-u to copy instead of kill
(use-package change-inner
  :after (expand-region)
  :straight t
  :defer nil
  :ensure t
  :bind (("M-i" . 'change-inner)
         ("M-o" . 'change-outer))
  )
