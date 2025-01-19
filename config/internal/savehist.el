(use-package savehist
  :demand t
  :config
  (setq-default history-length t)
  (setq-default history-delete-duplicates t)
  (setq-default savehist-save-minibuffer-history 1)
  (setq-default savehist-additional-variables '(kill-ring search-ring regexp-search-ring))

  (savehist-mode))
