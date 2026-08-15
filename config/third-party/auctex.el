;; -*- lexical-binding: t; -*-

(use-package tex
  :defer t
  :straight auctex
  :hook
  ((latex-mode LaTeX-mode) . (lambda ()
		                           (turn-on-reftex)
		                           (setq reftex-plug-into-AUCTeX t)
		                           (reftex-isearch-minor-mode)
		                           (setq TeX-PDF-mode t)
		                           (setq TeX-source-correlate-method 'synctex)
		                           (setq TeX-source-correlate-start-server t)
                               ;; symbols and font
                               (prettify-symbols-mode)
                               (variable-pitch-mode)
                               (visual-line-mode 1)
                               )
   )
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-electric-math '("$" . "$"))
  (TeX-electric-sub-and-superscript t)
  (LaTeX-electric-left-right-brace t)
  (TeX-save-query nil)
  (TeX-source-correlate-mode t)
  (reftex-toc-split-windows-horizontally t)
  )
