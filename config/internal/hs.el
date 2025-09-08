;; -*- lexical-binding: t; -*-

;; from https://karthinks.com/software/simple-folding-with-hideshow/

(use-package hideshow ; built-in
  :commands (hs-cycle
             hs-global-cycle)
  :bind (:map prog-mode-map
              ("C-<tab>" . hs-cycle)
              ("C-S-<iso-lefttab>" . hs-global-cycle))
  :config
  (setq hs-hide-comments-when-hiding-all nil
        ;; Nicer code-folding overlays (with fringe indicators)
        hs-set-up-overlay #'hideshow-set-up-overlay-fn)

  (defface hideshow-folded-face
    `((t (:inherit font-lock-comment-face :weight light)))
    "Face to hightlight `hideshow' overlays."
    :group 'hideshow)

  (defun hideshow-set-up-overlay-fn (ov)
    (when (eq 'code (overlay-get ov 'hs))
      (overlay-put
       ov 'display (propertize "  [...]  " 'face 'hideshow-folded-face))))

  (dolist (hs-command (list #'hs-cycle
                            #'hs-global-cycle))
    (advice-add hs-command :before
                (lambda (&optional end) "Advice to ensure `hs-minor-mode' is enabled"
                  (unless (bound-and-true-p hs-minor-mode)
                    (hs-minor-mode +1)))))

  (defun hs-cycle (&optional level)
    (interactive "p")
    (save-excursion
      (if (= level 1)
          (pcase last-command
            ('hs-cycle
             (hs-hide-level 1)
             (setq this-command 'hs-cycle-children))
            ('hs-cycle-children
             ;;TODO: Fix this case. `hs-show-block' needs to be called twice to
             ;;open all folds of the parent block.
             (hs-show-block)
             (hs-show-block)
             (setq this-command 'hs-cycle-subtree))
            ('hs-cycle-subtree
             (hs-hide-block))
            (_
             (if (not (hs-already-hidden-p))
                 (hs-hide-block)
               (hs-hide-level 1)
               (setq this-command 'hs-cycle-children))))
        (hs-hide-level level)
        (setq this-command 'hs-hide-level))))

  (defun hs-global-cycle ()
    (interactive)
    (pcase last-command
      ('hs-global-cycle
       (save-excursion (hs-show-all))
       (setq this-command 'hs-global-show))
      (_ (hs-hide-all))))

  ;; extra folding support for more languages
  (unless (assq 't hs-special-modes-alist)
    (setq hs-special-modes-alist
          (append
           '((vimrc-mode "{{{" "}}}" "\"")
             ;; (yaml-mode "\\s-*\\_<\\(?:[^:]+\\)\\_>"
             ;;            ""
             ;;            "#"
             ;;            +fold-hideshow-forward-block-by-indent-fn nil)
             ;; (haml-mode "[#.%]" "\n" "/" +fold-hideshow-haml-forward-sexp-fn nil)
             ;; (ruby-mode "class\\|d\\(?:ef\\|o\\)\\|module\\|[[{]"
             ;;            "end\\|[]}]"
             ;;            "#\\|=begin"
             ;;            ruby-forward-sexp)
             ;; (enh-ruby-mode "class\\|d\\(?:ef\\|o\\)\\|module\\|[[{]"
             ;;                "end\\|[]}]"
             ;;                "#\\|=begin"
             ;;                enh-ruby-forward-sexp nil)
             (matlab-mode "^\s*if\\|switch\\|case\\|otherwise\\|while\\|^\s*for\\|try\\|catch\\|function"
                          "end"
                          "" (lambda (_arg) (matlab-forward-sexp)))
             (nxml-mode "<!--\\|<[^/>]*[^/]>"
                        "-->\\|</[^/>]*[^/]>"
                        "<!--" sgml-skip-tag-forward nil))
           hs-special-modes-alist
           '((t)))))
  )
