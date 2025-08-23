;; -*- lexical-binding: t; -*-

(use-package nyan-mode
  :straight t
  :demand t)

(use-package mood-line
  :straight (mood-line :type git :host gitlab :repo "jessieh/mood-line" :branch "main")
  :demand t
  ;; OK I dunno WTF is going on but functions that already exist from mood-line
  ;; aren't working if I don't declare them here in preface.
  :preface
  (defvar flymake--mode-line-format)
  (defun mood-line--string-trim (string)
    "Remove whitespace at the beginning and end of STRING."
    (mood-line--string-trim-left (mood-line--string-trim-right string)))

  (defun mood-line-segment-flymake ()
    "Displays information about the current status of flymake in the mode-line (if available)."
    (when (and (boundp 'flymake-mode) flymake-mode)
      (concat (mood-line--string-trim (format-mode-line flymake--mode-line-format)) "  ")))
  :custom
  (mood-line-glyph-alist mood-line-glyphs-unicode)
  (mood-line-format '((" "
                       (mood-line-segment-modal)
                       " "
                       (or
                        (mood-line-segment-buffer-status)
                        (mood-line-segment-client)
                        " ")
                       " "
                       (mood-line-segment-project)
                       "/"
                       (mood-line-segment-buffer-name)
                       "  "
                       (mood-line-segment-multiple-cursors)
                       "  "
                       (mood-line-segment-cursor-position)
                       "  "
                       (nyan-create)
                       "")
                      ;; right
                      ((mood-line-segment-indentation)
                       "  "
                       (mood-line-segment-eol)
                       "  "
                       (mood-line-segment-encoding)
                       "  "
                       (mood-line-segment-vc)
                       "  "
                       (mood-line-segment-major-mode)
                       "  "
                       (mood-line-segment-misc-info)
                       "  "
                       (mood-line-segment-checker)
                       "  "
                       (mood-line-segment-process)
                       "  " " ")))
  :config
  (mood-line-mode)
  )
