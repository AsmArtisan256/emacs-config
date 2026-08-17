;; -*- lexical-binding: t; -*-

(use-package spacious-padding
  :straight t
  :custom
  (spacious-padding-widths
   '( :internal-border-width 8
      :header-line-width 4
      :mode-line-width 4
      :tab-width 3
      :right-divider-width 4
      :scroll-bar-width 8
      :fringe-width 8))
  :config
  (spacious-padding-mode 1))
