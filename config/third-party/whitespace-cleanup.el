(defun me/hide-trailing-whitespace ()
  (setq show-trailing-whitespace nil))

(use-package whitespace-cleanup-mode
  :demand t
  :hook
  (special-mode     . me/hide-trailing-whitespace)
  (comint-mode      . me/hide-trailing-whitespace)
  (compilation-mode . me/hide-trailing-whitespace)
  (term-mode        . me/hide-trailing-whitespace)
  (vterm-mode       . me/hide-trailing-whitespace)
  (shell-mode       . me/hide-trailing-whitespace)
  (minibuffer-setup . me/hide-trailing-whitespace)
  :custom
  (show-trailing-whitespace t)
  :config
  (global-whitespace-cleanup-mode 1))
