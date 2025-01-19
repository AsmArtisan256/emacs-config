;;; -*- lexical-binding: t; -*-

(defvar comp-deferred-compilation)
(setq comp-deferred-compilation t)
(setq native-comp-async-report-warnings-errors nil)
(setq warning-minimum-level :emergency)


;; disable ui elements
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(unless (and (display-graphic-p) (eq system-type 'darwin))
  (push '(menu-bar-lines . 0) default-frame-alist))
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; temporarily avoid special handling of files
(defvar me/-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist me/-file-name-handler-alist)))

(setq site-run-file nil)

(setq inhibit-compacting-font-caches t)

;; improve i/o
(when (boundp 'read-process-output-max)
  ;; 1MB in bytes, default 4096 bytes
  (setq read-process-output-max 1048576))

(add-function :after
              after-focus-change-function
              (lambda () (unless (frame-focus-state) (garbage-collect))))

(setq frame-resize-pixelwise t ;; resize it properly for TWM

      ;; Resizing the Emacs frame can be a terribly expensive part of changing the
      ;; font. By inhibiting this, we easily halve startup times with fonts that are
      ;; larger than the system default.
      frame-inhibit-implied-resize t

      frame-title-format '("%b")
      ring-bell-function 'ignore
      use-dialog-box t
      use-file-dialog nil
      use-short-answers t
      inhibit-splash-screen t
      inhibit-startup-screen t
      inhibit-x-resources t
      inhibit-startup-echo-area-message user-login-name ; read the docstring
      inhibit-startup-buffer-menu t)

(provide 'early-init)
