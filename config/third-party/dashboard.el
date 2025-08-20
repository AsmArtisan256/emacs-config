;; -*- lexical-binding: t; -*-

(use-package dashboard
  :demand t
  :after projectile
  :if (< (length command-line-args) 2)
  :custom
  ;; show in `emacsclient -c`
  (initial-buffer-choice #'(lambda () (get-buffer-create "*dashboard*")))
  (dashboard-startup-banner 'logo)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-center-content t)
  (dashboard-items '((recents  . 10)
                     (projects . 5)
                     (bookmarks . 5)))
  :config
  (dashboard-setup-startup-hook)
  )
