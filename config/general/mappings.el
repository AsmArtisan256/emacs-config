;; -*- lexical-binding: t; -*-

;; (global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-x C-b") 'ibuffer)
;; (global-set-key (kbd "M-z") 'zap-up-to-char)

;; duplicate line
(global-set-key (kbd "C-d") 'duplicate-line)

;; move to other window
(global-set-key (kbd "C-.") 'other-window)
;; move to previous window
(global-set-key (kbd "C-,") 'prev-window)

;; completion
(global-set-key (kbd "C-SPC") 'completion-at-point)

;; backwards delete word without polluting clipboard
(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))
(global-set-key (kbd "C-<backspace>") 'backward-delete-word)

;; Move point to first non-whitespace character or beginning-of-line.
(defun smart-beginning-of-line ()
  "Move point to first non-whitespace character or beginning-of-line."
  (interactive "^")
  (let ((oldpos (point)))
    (back-to-indentation)
    (and (= oldpos (point))
         (beginning-of-line))))
(global-set-key (kbd "<home>") 'smart-beginning-of-line)

;; unsetting
(global-unset-key [mouse-2])
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))
(global-unset-key (kbd "C-h h"))
