;; -*- lexical-binding: t; -*-

(use-package marginalia
  :custom
  (marginalia-max-relative-age 0)
  (marginalia-align 'right)
  :init
  (marginalia-mode)
  )

(use-package all-the-icons)
(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode)
  :config
  (defun my/enable-all-the-icons-on-frame ()
    (when (display-graphic-p)
      (all-the-icons-completion-mode 1)))

  (add-hook 'server-after-make-frame-hook #'my/enable-all-the-icons-on-frame)
  )
