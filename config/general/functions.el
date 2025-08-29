;; -*- lexical-binding: t; -*-

;; I guess this doesn't work if the buffer is from dired
;;
;; "dired buffers don't set buffer-file-name and thus the call to remove-if-not
;; in the above example will preserve dired buffers (as well as scratch buffer,
;; term buffers, help buffers, etc, anything not visiting a file)"
(defun my/kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer
	      (delq (current-buffer)
	            (remove-if-not 'buffer-file-name (buffer-list)))))

(defun my/kill-other-buffers-ext ()
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
(defun my/kill-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

;; cd to project root
(defun my/cd-project-root ()
  (interactive)
  (if (projectile-project-root)
      (cd (projectile-project-root))))


(defun my/garbage-collect-with-report ()
  "Run `garbage-collect' and print stats about memory usage."
  (interactive)
  (message (cl-loop for (type size used free) in (garbage-collect)
                    for used = (* used size)
                    for free = (* (or free 0) size)
                    for total = (file-size-human-readable (+ used free))
                    for used = (file-size-human-readable used)
                    for free = (file-size-human-readable free)
                    concat (format "%s: %s + %s = %s\n" type used free total))))
