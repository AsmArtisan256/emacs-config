;; -*- lexical-binding: t; -*-

(use-package flymake
  :straight (:type built-in)
  :ensure t
  :defer t
  :custom
  (flymake-fringe-indicator-position 'left-fringe)
  (flymake-show-diagnostics-at-end-of-line t)
  (flymake-suppress-zero-counters t)
  (flymake-wrap-around nil)
  )
