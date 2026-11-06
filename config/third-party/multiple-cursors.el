;; -*- lexical-binding: t; -*-

(use-package multiple-cursors
  :straight (multiple-cursors :type git :host github :repo "magnars/multiple-cursors.el")
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this))
  :init
  (with-eval-after-load 'multiple-cursors-core
    (defun my/mc-fix-adjacent-markers (overlay)
      (let ((p (overlay-get overlay 'point))
            (m (overlay-get overlay 'mark)))
        (when (and p m (marker-position p) (marker-position m)
                   (overlay-get overlay 'mark-active))
          (if (< (marker-position p) (marker-position m))
              (set-marker-insertion-type p t)
            (set-marker-insertion-type m t))))
      overlay)
    (advice-add 'mc/store-current-state-in-overlay :filter-return #'my/mc-fix-adjacent-markers)))
