;; I guess this doesn't work if the buffer is from dired
;;
;; "dired buffers don't set buffer-file-name and thus the call to remove-if-not
;; in the above example will preserve dired buffers (as well as scratch buffer,
;; term buffers, help buffers, etc, anything not visiting a file)"
(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer
	(delq (current-buffer)
	      (remove-if-not 'buffer-file-name (buffer-list)))))

(defun kill-other-buffers-ext ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer
	(delq (current-buffer)
	      (remove-if-not '(lambda (x)
				(or (buffer-file-name x)
				    (eq 'dired-mode (buffer-local-value 'major-mode x))))
			     (buffer-list)))))

;; this one TRULY kills every single buffer
;; use with caution
(defun kill-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))
