;; -*- lexical-binding: t; -*-

(use-package mixed-pitch
  :defer 1
  :commands mixed-pitch-mode
  :hook ((text-mode  . mixed-pitch-mode)
         (org-mode   . mixed-pitch-mode)
         (LaTeX-mode . mixed-pitch-mode)
         (latex-mode . mixed-pitch-mode))
  :custom
  (mixed-pitch-set-height t))
