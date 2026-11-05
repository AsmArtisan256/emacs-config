;; -*- lexical-binding: t; -*-

(use-package multiple-cursors
  :straight (multiple-cursors :type git :host github :repo "magnars/multiple-cursors.el")
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)))
