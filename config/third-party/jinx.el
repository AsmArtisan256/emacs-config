;; -*- lexical-binding: t; -*-

(use-package jinx
  :hook ((org-mode . jinx-mode)
         (LaTeX-mode . jinx-mode)
         (latex-mode . jinx-mode))
  :bind (("M-$" . jinx-correct)
	 ("C-M-$" . jinx-languages))
  :custom
  (jinx-languages "en_US pt_PT")
  (jinx-exclude-regexps
   '((t "[A-Z]+\\>"
	"\\<[[:upper:]][[:lower:]]+\\>"
	"\\w*?[0-9\.'\"-]\\w*"
	"[a-z]+://\\S-+"
	"<?[-+_.~a-zA-Z][-+_.~:a-zA-Z0-9]*@[-.a-zA-Z0-9]+>?")))
  )
