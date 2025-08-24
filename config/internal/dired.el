;; -*- lexical-binding: t; -*-

(defvar dired-filelist-cmd
  '(("mpv")))

(defun dired-start-process (cmd &optional file-list)
  (interactive
   (let ((files (dired-get-marked-files
                 t current-prefix-arg)))
     (list
      (dired-read-shell-command "Open with: "
                                current-prefix-arg files)
      files)))
  (let (list-switch)
    (start-process
     cmd nil shell-file-name
     shell-command-switch
     (format
      "nohup 1>/dev/null 2>/dev/null %s \"%s\""
      (if (and (> (length file-list) 1)
               (setq list-switch
                     (cadr (assoc cmd dired-filelist-cmd))))
          (format "%s %s" cmd list-switch)
        cmd)
      (mapconcat #'expand-file-name file-list "\" \"")))))

;; clean up dired buffers
(setopt dired-kill-when-opening-new-dired-buffer t)
;; use human-readable sizes in dired and other stuff
(setopt dired-listing-switches "-alh --group-directories-first")
;; recursive
(setopt dired-recursive-copies 'always)
(setopt dired-recursive-deletes 'always)
;; guess default dir
(setopt dired-dwim-target t)

(setopt dired-omit-verbose nil)
(setopt dired-dwim-target 'dired-dwim-target-next)
(setopt dired-hide-details-hide-symlink-targets nil)
(setopt dired-kill-when-opening-new-dired-buffer t)
(setopt delete-by-moving-to-trash t)

;; file opening
(setopt dired-guess-shell-alist-user
        '(("\\.pdf\\'" "evince")
          ("\\.\\(?:djvu\\|eps\\)\\'" "zathura")
          ("\\.\\(?:jpg\\|jpeg\\|png\\|gif\\|xpm\\)\\'" "sxiv")
          ("\\.\\(?:xcf\\)\\'" "gimp")
          ("\\.\\(?:mp4\\|mp3\\|mkv\\|avi\\|flv\\|ogv\\)\\(?:\\.part\\)?\\'"
           "mpv")
          ("\\.\\(?:html\\|svg\\)\\'" "firefox")
          ))

(define-key dired-mode-map "!" 'dired-do-async-shell-command)
(define-key dired-mode-map "&" 'dired-start-process)

;; async stuff
(use-package async
  :ensure t
  :defer t
  :custom
  (dired-async-mode 1))

;; colors
(use-package diredfl
  :ensure t
  :hook
  (dired-mode . diredfl-mode))

(use-package dired-git-info
  :ensure t
  :bind
  (:map dired-mode-map
        (")" . dired-git-info-mode)))
