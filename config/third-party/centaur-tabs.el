;; -*- lexical-binding: t; -*-

(use-package centaur-tabs
  :demand t
  :config
  (centaur-tabs-mode 1)
  (setq centaur-tabs-show-navigation-buttons t
        centaur-tabs-backward-tab-text " ‹ "
        centaur-tabs-forward-tab-text " › "
        centaur-tabs-set-icons nil      ; Disables large icon fonts that expand bar height
        centaur-tabs-style "bar"
        centaur-tabs-height 12          ; Ultra-slim height
        centaur-tabs-set-bar nil
        centaur-tabs-set-modified-marker t
        centaur-tabs-show-count nil
        centaur-tabs-adjust-buffer-order nil
        centaur-tabs-cycle-scope 'tabs)

  ;; Explicit 1px crisp contiguous borders on tabs (Everforest palette)
  (set-face-attribute 'centaur-tabs-default nil
                      :height 0.75
                      :box '(:line-width 1 :color "#4a5655" :style nil))
  (set-face-attribute 'centaur-tabs-selected nil
                      :height 0.75
                      :weight 'bold
                      :box '(:line-width 1 :color "#b7d88d" :style nil))
  (set-face-attribute 'centaur-tabs-unselected nil
                      :height 0.75
                      :weight 'normal
                      :box '(:line-width 1 :color "#4a5655" :style nil))
  (set-face-attribute 'centaur-tabs-selected-modified nil
                      :height 0.75
                      :weight 'bold
                      :box '(:line-width 1 :color "#b7d88d" :style nil))
  (set-face-attribute 'centaur-tabs-unselected-modified nil
                      :height 0.75
                      :weight 'normal
                      :box '(:line-width 1 :color "#4a5655" :style nil))

  ;; Ensure the modified marker glyph continues the enclosing tab box border
  (set-face-attribute 'centaur-tabs-modified-marker-selected nil
                      :height 0.75
                      :foreground "#f28a8f"
                      :box '(:line-width 1 :color "#b7d88d" :style nil))
  (set-face-attribute 'centaur-tabs-modified-marker-unselected nil
                      :height 0.75
                      :foreground "#f28a8f"
                      :box '(:line-width 1 :color "#4a5655" :style nil))

  ;; Hide tabs in temporary popups, help, messages, and special windows
  (defun my/centaur-tabs-hide-tab (buf)
    (let ((name (buffer-name buf)))
      (or
       (window-minibuffer-p)
       (string-prefix-p " " name)
       (and (string-prefix-p "*" name)
            (not (string= name "*scratch*")))
       (with-current-buffer buf
         (derived-mode-p 'help-mode 'messages-buffer-mode 'special-mode 'completion-list-mode)))))
  (setq centaur-tabs-hide-tab-function #'my/centaur-tabs-hide-tab)

  ;; Single unified tab list across all buffers
  (defun centaur-tabs-buffer-groups ()
    (list "All"))

  ;; Automatic theme color integration
  (centaur-tabs-headline-match))
