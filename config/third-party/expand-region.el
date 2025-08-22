;; -*- lexical-binding: t; -*-

(use-package expand-region
  :straight t
  :ensure t
  :defer nil
  :bind (("C-]" . er/expand-region))
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
