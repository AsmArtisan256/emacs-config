;; -*- lexical-binding: t; -*-

(use-package savehist
  :demand t
  :config
  (setq-default history-length 1000)
  (setq-default history-delete-duplicates t)
  (setq-default savehist-save-minibuffer-history t)
  (setq-default savehist-additional-variables '(kill-ring search-ring regexp-search-ring))

  (savehist-mode 1)

  ;; save space
  (put 'savehist-minibuffer-history-variables 'history-length 50)
  (put 'org-read-date-history                 'history-length 50)
  (put 'read-expression-history               'history-length 50)
  (put 'org-table-formula-history             'history-length 50)
  (put 'extended-command-history              'history-length 50)
  (put 'ido-file-history                      'history-length 50)
  (put 'helm-M-x-input-history                'history-length 50)
  (put 'minibuffer-history                    'history-length 50)
  (put 'ido-buffer-history                    'history-length 50)
  (put 'buffer-name-history                   'history-length 50)
  (put 'file-name-history                     'history-length 50)
  )
