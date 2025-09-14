;; -*- lexical-binding: t; -*-

(setopt auto-save-interval 2400)
(setopt auto-save-timeout 300)

(setopt
 backup-directory-alist `(("." . "~/.config/emacs/backups"))
 create-lockfiles nil
 backup-by-copying t
 load-prefer-newer t
 delete-old-versions t
 kept-old-version 2
 kept-new-version 6
 )
