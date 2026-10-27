;; -*- lexical-binding: t; -*-

(use-package apheleia
  :straight t
  :defer 1
  :bind (("C-c C-f" . apheleia-format-buffer))
  :config
  ;; Ensure clang-format is associated with C/C++ modes
  (setf (alist-get 'c-mode apheleia-mode-alist) '(clang-format))
  (setf (alist-get 'c++-mode apheleia-mode-alist) '(clang-format))
  (setf (alist-get 'c-ts-mode apheleia-mode-alist) '(clang-format))
  (setf (alist-get 'c++-ts-mode apheleia-mode-alist) '(clang-format))
  (apheleia-global-mode +1))
