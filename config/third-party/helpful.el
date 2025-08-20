;; -*- lexical-binding: t; -*-

(use-package helpful
  :defer 1
  :config
  (add-to-list 'display-buffer-alist
               '("*[Hh]elp"
                 (display-buffer-reuse-mode-window
                  display-buffer-pop-up-window))))
