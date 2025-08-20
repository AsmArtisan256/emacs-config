;; -*- lexical-binding: t; -*-

(use-package pulsar
  :config

  ;; There are convenience functions/commands which pulse the line using
  ;; a specific colour: `pulsar-pulse-line-red' is one of them.
  (add-hook 'next-error-hook #'pulsar-pulse-line-red)
  (add-hook 'next-error-hook #'pulsar-recenter-top)
  (add-hook 'next-error-hook #'pulsar-reveal-entry)

  (add-hook 'minibuffer-setup-hook #'pulsar-pulse-line-red)

  (pulsar-global-mode 1)
  )
