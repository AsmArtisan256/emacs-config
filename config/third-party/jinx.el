;; -*- lexical-binding: t; -*-

(use-package jinx
  :hook (org-mode . jinx-mode)
  :bind (("M-$" . jinx-correct)
	 ("C-M-$" . jinx-languages))
  :custom
  (jinx-languages "en_US pt_PT")
  (jinx-include-faces
   '((prog-mode font-lock-doc-face)
     (conf-mode font-lock-comment-face)))
  (jinx-exclude-regexps
   '((t "[A-Z]+\\>"
	"\\<[[:upper:]][[:lower:]]+\\>"
	"\\w*?[0-9\.'\"-]\\w*"
	"[a-z]+://\\S-+"
	"<?[-+_.~a-zA-Z][-+_.~:a-zA-Z0-9]*@[-.a-zA-Z0-9]+>?")))
  )
