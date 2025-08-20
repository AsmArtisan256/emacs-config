;; -*- lexical-binding: t; -*-

(use-package orderless
  :custom
  ;; Use backslash for literal space
  (orderless-component-separator 'orderless-escapable-split-on-space)
  (completion-styles '(orderless))
  (completion-category-defaults nil)    ; I want to be in control!
  (completion-category-overrides
   '((file (styles orderless))))
  :config
  (defun prefix-if-tilde (pattern _index _total)
    (when (string-suffix-p "~" pattern)
      `(orderless-prefixes . ,(substring pattern 0 -1))))

  (defun regexp-if-slash (pattern _index _total)
    (when (string-prefix-p "/" pattern)
      `(orderless-regexp . ,(substring pattern 1))))

  (defun literal-if-equal (pattern _index _total)
    (when (string-suffix-p "=" pattern)
      `(orderless-literal . ,(substring pattern 0 -1))))

  (defun without-if-bang (pattern _index _total)
    (cond
     ((equal "!" pattern)
      '(orderless-literal . ""))
     ((string-prefix-p "!" pattern)
      `(orderless-without-literal . ,(substring pattern 1)))))

  (setq orderless-matching-styles '(orderless-flex))
  (setq orderless-style-dispatchers
	'(prefix-if-tilde
	  regexp-if-slash
	  literal-if-equal
	  without-if-bang)))
