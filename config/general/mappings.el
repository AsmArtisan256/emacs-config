;; (global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-x C-b") 'ibuffer)
;; (global-set-key (kbd "M-z") 'zap-up-to-char)

(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

(global-set-key (kbd "C-d") 'duplicate-line)

;; move to other window
(global-set-key (kbd "C-.") 'other-window)
;; move to previous window
(global-set-key (kbd "C-,") 'prev-window)

;; completion
(global-set-key (kbd "C-SPC") 'completion-at-point)

;; unsetting
(global-unset-key [mouse-2])

(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))
(global-unset-key (kbd "C-h h"))
