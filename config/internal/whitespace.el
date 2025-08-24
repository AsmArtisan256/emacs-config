;; -*- lexical-binding: t; -*-

(defun me/hide-trailing-whitespace ()
  (setq show-trailing-whitespace nil))

;; always show trailing whitespace
(setq-default show-trailing-whitespace t)

;; do not show trailing whitesapce when in these modes
(add-hook 'special-mode      'me/hide-trailing-whitespace)
(add-hook 'comint-mode       'me/hide-trailing-whitespace)
(add-hook 'compilation-mode  'me/hide-trailing-whitespace)
(add-hook 'term-mode         'me/hide-trailing-whitespace)
(add-hook 'vterm-mode        'me/hide-trailing-whitespace)
(add-hook 'shell-mode        'me/hide-trailing-whitespace)
(add-hook 'minibuffer-setup  'me/hide-trailing-whitespace)
(add-hook 'eww-mode          'me/hide-trailing-whitespace)
(add-hook 'ielm-mode         'me/hide-trailing-whitespace)
(add-hook 'gdb-mode          'me/hide-trailing-whitespace)
(add-hook 'help-mode         'me/hide-trailing-whitespace)

;; delete trailing whitespace before save
(add-hook 'before-save-hook 'delete-trailing-whitespace)
