;; -*- lexical-binding: t; -*-

;; set fill column to 80 (yes, 80)
(setopt display-fill-column-indicator-column 80)

;; activate fill-column in general prog-mode
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)
