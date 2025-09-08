;; -*- lexical-binding: t; -*-

(defun my/split-window-right (&optional size)
  "Split the selected window into two side-by-side windows.
The selected window is on the left.  The newly split-off window
is on the right and displays the same buffer.  Return the new
window."
  (interactive "P")
  (select-window
   (if size
       (split-window (frame-root-window)
                     (floor (frame-width) 2)
                     t nil)
     (split-window-right size)))
  (when (interactive-p)
    (if (featurep 'consult)
        (consult-buffer)
      (call-interactively #'switch-to-buffer))))

(defun my/split-window-below (&optional size)
  "Split the selected window into two windows, one above the other.
The selected window is below.  The newly split-off window is
below and displays the same buffer.  Return the new window."
  (interactive "P")
  (select-window
   (if size
       (split-window (frame-root-window)
                     (floor (frame-height) 2)
                     nil nil)
     (split-window-below size)))
  (when (interactive-p)
    (if (featurep 'consult)
        (consult-buffer)
      (call-interactively #'switch-to-buffer))))

(defun my/delete-window-or-delete-frame (&optional window)
  "Delete WINDOW using `delete-window'.
If this is the sole window run `delete-frame' instead. WINDOW
must be a valid window and defaults to the selected one. Return
nil."
  (interactive)
  (condition-case nil
      (delete-window window)
    (error (if (and tab-bar-mode
                    (> (length (funcall tab-bar-tabs-function)) 1))
               (tab-bar-close-tab)
             (delete-frame)))))

(global-set-key [remap split-window-below] 'my/split-window-below)
(global-set-key [remap split-window-right] 'my/split-window-right)
(global-set-key [remap delete-window] 'my/delete-window-or-delete-frame)
