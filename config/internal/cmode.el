;; -*- lexical-binding: t; -*-

;; C / C++ mode configuration (supporting both Tree-sitter and classic CC Mode)

;; Forward declaration for header switching defined in eglot.el
(declare-function eglot-clangd-find-other-file "eglot" (&optional new-window))

;; Common setup function for C/C++ buffers
(defun my-c-mode-common-setup ()
  "Common configuration for C/C++ buffers."
  (setq-local tab-width 2)
  (setq-local comment-start "// ")
  (setq-local comment-end "")
  (setq-local electric-pair-pairs '((?\" . ?\")
                                    (?\{ . ?\})
                                    (?\( . ?\))
                                    (?\[ . ?\]))))

;; 1. Classic CC Mode
(use-package cc-mode
  :ensure nil
  :defer t
  :bind (:map c-mode-base-map
              ("<f12>" . compile)
              ("C-c o" . eglot-clangd-find-other-file)
              ("C-d"   . duplicate-line))
  :config
  (setq c-basic-offset 2
        tab-width 2
        c-default-style "linux")
  (add-hook 'c-mode-common-hook #'my-c-mode-common-setup))

;; 2. Modern Tree-sitter C/C++ (Emacs 29+)
(use-package c-ts-mode
  :ensure nil
  :defer t
  :init
  ;; Automatically use c-ts-mode and c++-ts-mode if tree-sitter grammars are present
  (when (and (fboundp 'treesit-available-p) (treesit-available-p))
    (when (treesit-language-available-p 'c)
      (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode)))
    (when (treesit-language-available-p 'cpp)
      (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
      (add-to-list 'major-mode-remap-alist '(c-or-c++-mode . c-or-c++-ts-mode))))
  :bind (:map c-ts-base-mode-map
              ("<f12>" . compile)
              ("C-c o" . eglot-clangd-find-other-file)
              ("C-d"   . duplicate-line))
  :config
  (setq c-ts-mode-indent-offset 2
        c-ts-mode-indent-style 'linux)
  (add-hook 'c-ts-base-mode-hook #'my-c-mode-common-setup))
