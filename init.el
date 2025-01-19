;; Many pieces of this configuration were taken from many different places on the internet:
;; - http://xahlee.info/emacs/emacs/organize_your_dot_emacs.html
;; - https://github.com/andersmurphy
;; - https://hugocisneros.com/org-config/
;; - https://github.com/meatcar/emacs.d
;; - https://github.com/jwiegley/dot-emacs/
;; - https://kristofferbalintona.me/posts/202202270056/
;; - https://github.com/protesilaos/dotfiles

;;; PACKAGE MANAGER
(progn ;;; Setup

  ;; To not increase Emacs startup time, check package modifications when
  ;; packages edited (with Emacs), instead of checking modifications at startup.
  (setq straight-check-for-modifications '(check-on-save find-when-checking))
  ;; Use default depth of 1 when cloning files with git to get
  ;; saves network bandwidth and disk space.
  (setq straight-vc-git-default-clone-depth 1)

  ;; Bootstrap straight.el package manager
  ;; https://github.com/raxod502/straight.el
  (defvar bootstrap-version)
  (let ((bootstrap-file
         (expand-file-name "straight/repos/straight.el/bootstrap.el"
                           user-emacs-directory))
        (bootstrap-version 5))
    (unless (file-exists-p bootstrap-file)
      (with-current-buffer
          (url-retrieve-synchronously
           "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
           'silent 'inhibit-cookies)
        (goto-char (point-max))
        (eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage))

  ;; Always load newest byte code
  (setq load-prefer-newer t)

  ;; straight utils
  (require 'straight-x)

  ;; Bootstrap use-package
  ;; Install use-package if it's not already installed.
  ;; use-package is used to configure the rest of the packages.
  (straight-use-package 'use-package)
  (defvar straight-use-package-by-default)
  (setq straight-use-package-by-default t)
  (setq straight-repository-branch "develop")
  (require 'use-package)

  ;; Forces Custom to save all customizations in a separate file
  (setq custom-file "~/.config/emacs/config/custom.el")

  ;; Prevents error if the custom.el file doesn't exist
  (load custom-file 'noerror))

;; other straight stuff that needs to be here
;; (use-package org :straight (:type built-in))

(load "~/.config/emacs/secrets.el")
(load "~/.config/emacs/config/init.el")
