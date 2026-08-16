;; -*- lexical-binding: t; -*-

(use-package tex
  :defer t
  :straight auctex
  :hook
  ((latex-mode LaTeX-mode) . (lambda ()
		                           (turn-on-reftex)
		                           (setq reftex-plug-into-AUCTeX t)
		                           (setq reftex-cite-format 'biblatex)
		                           (reftex-isearch-minor-mode)
		                           (setq TeX-PDF-mode t)
		                           (setq TeX-source-correlate-method 'synctex)
		                           (setq TeX-source-correlate-start-server t)
                               ;; symbols and font
                               (LaTeX-math-mode 1)
                               (prettify-symbols-mode)
                               (variable-pitch-mode)
                               (visual-line-mode 1)))
  :bind
  (:map LaTeX-mode-map
        ("C-c b b" . citar-insert-citation)
        ("C-c b o" . citar-open-files)
        ("C-c b n" . citar-open-notes))
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-electric-math '("$" . "$"))
  (TeX-electric-sub-and-superscript t)
  (LaTeX-electric-left-right-brace t)
  (TeX-save-query nil)
  (TeX-source-correlate-mode t)
  (reftex-toc-split-windows-horizontally t)
  (font-latex-fontify-script 'multi-level)
  (font-latex-fontify-sectioning 'color)
  (TeX-view-program-selection '((output-pdf "Evince") (output-pdf "PDF Tools") (output-pdf "xdg-open")))
  )
