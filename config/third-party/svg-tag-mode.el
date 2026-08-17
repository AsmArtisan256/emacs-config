;; -*- lexical-binding: t; -*-

(use-package svg-lib
  :straight (svg-lib :type git :host github :repo "rougier/svg-lib")
  :demand t
  :config
  ;; True vector-centered text with guaranteed symmetric padding on both sides
  (defun svg-lib-text-tag (label &optional face-or-style &rest args)
    "Create an SVG pill with true vector centering and symmetric padding for LABEL."
    (let* ((style (cond ((facep face-or-style)
                         (apply #'svg-lib-style-from-face face-or-style args))
                        (face-or-style
                         (apply #'svg-lib-style face-or-style args))
                        (t
                         (apply #'svg-lib-style (svg-lib-style-default--get) args))))
           (foreground  (plist-get style :foreground))
           (background  (plist-get style :background))
           (crop-left   (plist-get style :crop-left))
           (crop-right  (plist-get style :crop-right))
           (alignment   (or (plist-get style :alignment) 0.5))
           (stroke      (or (plist-get style :stroke) 0))
           (height      (or (plist-get style :height) 0.88))
           (radius      (or (plist-get style :radius) 4))
           (margin      (or (plist-get style :margin) 0))
           (padding     (or (plist-get style :padding) 0.8))
           (font-family (or (plist-get style :font-family) (face-attribute 'default :family)))
           (font-weight (or (plist-get style :font-weight) (face-attribute 'default :weight)))
           (font-size   (or (plist-get style :font-size) 11))
           (txt-char-w  (max 8 (window-font-width)))
           (txt-char-h  (max 16 (window-font-height)))
           (font-info   (font-info (format "%s-%d" font-family font-size)))
           (font-size   (if font-info (aref font-info 2) font-size))
           (ascent      (if font-info (aref font-info 8) 12))
           (char-w      (if font-info (aref font-info 11) txt-char-w))
           ;; Snug, balanced bounding box with compact symmetric margins
           (tag-width   (+ (* (length label) (max char-w (* font-size 0.58))) (* padding txt-char-w 0.7)))
           (tag-height  (* txt-char-h height))
           (svg-width   (+ tag-width (* margin txt-char-w)))
           (svg-height  tag-height)
           (svg-ascent  (plist-get style :ascent))
           (tag-x       (* (- svg-width tag-width) alignment))
           (center-x    (+ tag-x (/ tag-width 2.0)))
           (text-y      ascent)
           (svg         (svg-create svg-width svg-height)))

      (when (>= stroke 0.25)
        (svg-rectangle svg tag-x 0 tag-width tag-height
                       :fill foreground :rx radius))
      (svg-rectangle svg (+ tag-x (/ stroke 2.0)) (/ stroke 2.0)
                     (- tag-width stroke) (- tag-height stroke)
                     :fill background :rx (- radius (/ stroke 2.0)))
      (svg-text svg label
                :font-family font-family :font-weight font-weight :font-size font-size
                :fill foreground :x center-x :y text-y :text-anchor "middle")
      (svg-lib--image svg :ascent svg-ascent))))

(use-package svg-tag-mode
  :straight (svg-tag-mode :type git :host github :repo "rougier/svg-tag-mode")
  :after (org svg-lib)
  :hook (org-mode . svg-tag-mode)
  :config
  (setq svg-tag-tags
        `(
          ;; TODO States with true rounded corners (radius 4)
          ("\\(\\<TODO\\>\\)" . ((lambda (tag)
                                   (svg-tag-make tag :face '(:foreground "#f28a8f" :background "#663f48" :weight bold) :padding 0.8 :margin 0.4 :radius 4))))
          ("\\(\\<STARTED\\>\\)" . ((lambda (tag)
                                      (svg-tag-make tag :face '(:foreground "#8bcfc7" :background "#365e6d" :weight bold) :padding 0.8 :margin 0.4 :radius 4))))
          ("\\(\\<WAITING\\>\\)" . ((lambda (tag)
                                      (svg-tag-make tag :face '(:foreground "#e8ca7a" :background "#5d5a3d" :weight bold) :padding 0.8 :margin 0.4 :radius 4))))
          ("\\(\\<DELEGATED\\>\\)" . ((lambda (tag)
                                        (svg-tag-make tag :face '(:foreground "#e5a1c3" :background "#5c4963" :weight bold) :padding 0.8 :margin 0.4 :radius 4))))
          ("\\(\\<SOMEDAY\\>\\)" . ((lambda (tag)
                                      (svg-tag-make tag :face '(:foreground "#a3afa5" :background "#394445" :weight bold) :padding 0.8 :margin 0.4 :radius 4))))
          ("\\(\\<DONE\\>\\)" . ((lambda (tag)
                                   (svg-tag-make tag :face '(:foreground "#b7d88d" :background "#3c5749" :weight bold) :padding 0.8 :margin 0.4 :radius 4))))
          ("\\(\\<CANCELED\\>\\)" . ((lambda (tag)
                                       (svg-tag-make tag :face '(:foreground "#89968c" :background "#4a5655" :weight bold) :padding 0.8 :margin 0.4 :radius 4))))

          ;; Strict colon-enclosed tags :tag: or :tag1:tag2:
          ("\\(:[A-Za-z_@#%][A-Za-z0-9_@#%]*:\\)" . ((lambda (tag)
                                                         (svg-tag-make tag :face '(:foreground "#a3afa5" :background "#394445") :beg 1 :end -1 :padding 0.8 :margin 0.8 :radius 4))))

          ;; Priority [#A], [#B], [#C]
          ("\\[#A\\]" . ((lambda (_tag) (svg-tag-make "A" :face '(:foreground "#f28a8f" :background "#663f48" :weight bold) :margin 0 :radius 3))))
          ("\\[#B\\]" . ((lambda (_tag) (svg-tag-make "B" :face '(:foreground "#e8ca7a" :background "#5d5a3d" :weight bold) :margin 0 :radius 3))))
          ("\\[#C\\]" . ((lambda (_tag) (svg-tag-make "C" :face '(:foreground "#8bcfc7" :background "#365e6d" :weight bold) :margin 0 :radius 3))))

          ;; Progress / Checkbox mini progress bars [2/5] or [40%]
          ("\\[\\([0-9]+\\%\\)\\]" . ((lambda (tag)
                                         (svg-lib-progress-bar (/ (string-to-number (substring tag 1 -2)) 100.0)
                                                               nil :margin 0 :stroke 2 :padding 1 :width 10 :radius 3
                                                               :foreground "#b7d88d" :background "#202728"))))
          ("\\[\\([0-9]+\\)/\\([0-9]+\\)\\]" . ((lambda (tag)
                                                  (let* ((parts (split-string (substring tag 1 -1) "/"))
                                                         (val (string-to-number (car parts)))
                                                         (total (string-to-number (cadr parts))))
                                                    (svg-lib-progress-bar (/ (float val) (max 1 (float total)))
                                                                          nil :margin 0 :stroke 2 :padding 1 :width 10 :radius 3
                                                                          :foreground "#b7d88d" :background "#202728")))))
          ))

  ;; Clear underlying org-todo / org-done backgrounds so they don't bleed behind the SVG pills
  (with-eval-after-load 'org
    (set-face-attribute 'org-todo nil :background 'unspecified :box nil)
    (set-face-attribute 'org-done nil :background 'unspecified :box nil)))
