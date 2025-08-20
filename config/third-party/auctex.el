;; -*- lexical-binding: t; -*-

(use-package tex
  :defer t
  :straight auctex
  :hook
  (LaTeX-mode . (lambda ()
		  (turn-on-reftex)
		  (setq reftex-plug-into-AUCTeX t)
		  (reftex-isearch-minor-mode)
		  (setq TeX-PDF-mode t)
		  (setq TeX-source-correlate-method 'synctex)
		  (setq TeX-source-correlate-start-server t)))
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  )
