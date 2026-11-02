;; -*- lexical-binding: t; -*-

(use-package easysession
  :straight t
  :custom
  (easysession-setup-load-session nil)
  (easysession-save-interval 300)
  (easysession-save-pretty-print t)
  :config
  (easysession-setup))
