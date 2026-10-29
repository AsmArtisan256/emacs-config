;; -*- lexical-binding: t; -*-

(let ((auto-save-dir (expand-file-name "auto-save/" user-emacs-directory)))
  (unless (file-directory-p auto-save-dir)
    (make-directory auto-save-dir t))
  (setopt auto-save-file-name-transforms `((".*" ,auto-save-dir t))
          auto-save-list-file-prefix (concat auto-save-dir ".saves-")))

(setopt auto-save-interval 2400)
(setopt auto-save-timeout 300)

(setopt
 backup-directory-alist `(("." . ,(expand-file-name "backups" user-emacs-directory)))
 create-lockfiles nil
 backup-by-copying t
 load-prefer-newer t
 delete-old-versions t
 kept-old-version 2
 kept-new-version 6
 kept-old-versions 2
 kept-new-versions 6
 )
