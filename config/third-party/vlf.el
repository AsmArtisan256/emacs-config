;; -*- lexical-binding: t; -*-

(use-package vlf
  :straight (vlf :type git :host github :repo "m00natic/vlfi")
  :init
  (require 'vlf-setup)
  :custom
  (vlf-batch-size (* 1 1024 1024)) ; 1MB batches
  (vlf-application 'ask))          ; Prompt: open normally (o), with vlf (v), or abort (a)
