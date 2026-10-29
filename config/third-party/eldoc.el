;; -*- lexical-binding: t; -*-

(declare-function eglot-current-server "eglot" ())
(declare-function eglot--TextDocumentPositionParams "eglot" ())
(declare-function eglot-uri-to-path "eglot" (uri))

(defvar-local my/eldoc-box-c-type-cache nil
  "Cached (TICK POINT SNIPPET) for on-demand C/C++ type definition lookup.")

(defun my/c-ts-extract-record-at (code lang line char)
  "Extract struct/union/enum/class definition from CODE at 0-indexed LINE and CHAR."
  (when (and (fboundp 'treesit-language-available-p)
             (treesit-language-available-p lang))
    (with-temp-buffer
      (insert code)
      (treesit-parser-create lang)
      (goto-char (point-min))
      (forward-line line)
      (forward-char (min char (- (line-end-position) (point))))
      (let* ((node (treesit-node-at (point) lang))
             (spec-types '("struct_specifier" "union_specifier"
                           "enum_specifier" "class_specifier"))
             (spec
              (and node
                   (or (treesit-parent-until
                        node
                        (lambda (n) (member (treesit-node-type n) spec-types))
                        t)
                       (let ((td (treesit-parent-until
                                  node
                                  (lambda (n)
                                    (member (treesit-node-type n)
                                            '("type_definition" "alias_declaration")))
                                  t)))
                         (and td
                              (let ((tc (treesit-node-child-by-field-name td "type")))
                                (and tc (member (treesit-node-type tc) spec-types) tc))))))))
        ;; Resolve forward declarations (e.g. `typedef struct Node Node;`) in the same file
        (when (and spec (not (treesit-node-child-by-field-name spec "body")))
          (let ((nm (treesit-node-child-by-field-name spec "name"))
                (stype (treesit-node-type spec)))
            (when nm
              (let ((tname (treesit-node-text nm t)))
                (setq spec
                      (treesit-search-subtree
                       (treesit-buffer-root-node lang)
                       (lambda (n)
                         (and (equal (treesit-node-type n) stype)
                              (treesit-node-child-by-field-name n "body")
                              (let ((n2 (treesit-node-child-by-field-name n "name")))
                                (and n2 (equal (treesit-node-text n2 t) tname)))))))))))
        (when (and spec (treesit-node-child-by-field-name spec "body"))
          (let* ((parent (treesit-node-parent spec))
                 (full (if (and parent
                                (member (treesit-node-type parent)
                                        '("type_definition" "alias_declaration")))
                           parent
                         spec))
                 (beg (treesit-node-start full))
                 (end (treesit-node-end full))
                 (semi (if (and (not (eq full parent))
                                (eq (char-after end) ?\;))
                           ";"
                         ""))
                 (indent (save-excursion
                           (goto-char beg)
                           (if (looking-back "^[ \t]*" (line-beginning-position))
                               (- beg (line-beginning-position))
                             0)))
                 (raw (concat (buffer-substring-no-properties beg end) semi))
                 (lines (split-string raw "\n")))
            (when (> indent 0)
              (let ((prefix (make-string indent ?\s)))
                (setq lines
                      (cons (car lines)
                            (mapcar (lambda (l) (string-remove-prefix prefix l))
                                    (cdr lines))))))
            (when (> (length lines) 35)
              (setq lines (append (seq-take lines 32)
                                  '("  /* ... */" "};"))))
            (string-join lines "\n")))))))

(defun my/c-fontify-snippet (code is-cpp)
  "Fontify C/C++ CODE string without running mode hooks."
  (with-temp-buffer
    (insert code)
    (let ((noninteractive nil))
      (delay-mode-hooks
        (cond
         ((and is-cpp (fboundp 'c++-ts-mode) (treesit-language-available-p 'cpp))
          (c++-ts-mode))
         ((and (not is-cpp) (fboundp 'c-ts-mode) (treesit-language-available-p 'c))
          (c-ts-mode))
         (is-cpp (c++-mode))
         (t (c-mode))))
      (font-lock-mode 1)
      (font-lock-ensure))
    (buffer-string)))

(defun my/eglot-c-type-definition-at-point ()
  "Return syntax-highlighted C/C++ record/enum definition for symbol at point."
  (when (and (derived-mode-p 'c-mode 'c++-mode 'c-ts-mode 'c++-ts-mode)
             (fboundp 'eglot-current-server)
             (eglot-current-server)
             (require 'treesit nil t))
    (let ((tick (buffer-chars-modified-tick))
          (pt (point)))
      (if (and my/eldoc-box-c-type-cache
               (equal (nth 0 my/eldoc-box-c-type-cache) tick)
               (equal (nth 1 my/eldoc-box-c-type-cache) pt))
          (nth 2 my/eldoc-box-c-type-cache)
        (let* ((is-cpp (derived-mode-p 'c++-mode 'c++-ts-mode))
               (lang (if (and is-cpp (treesit-language-available-p 'cpp)) 'cpp 'c))
               (server (eglot-current-server))
               (resp (ignore-errors
                       (jsonrpc-request server
                                        :textDocument/typeDefinition
                                        (eglot--TextDocumentPositionParams)
                                        :timeout 0.5
                                        :cancel-on-input t)))
               (loc (cond
                     ((and (vectorp resp) (> (length resp) 0)) (aref resp 0))
                     ((and (listp resp) (or (plist-get resp :uri)
                                            (plist-get resp :targetUri)))
                      resp)
                     (t nil)))
               (uri (and loc (or (plist-get loc :uri) (plist-get loc :targetUri))))
               (range (and loc (or (plist-get loc :targetSelectionRange)
                                   (plist-get loc :range)
                                   (plist-get loc :targetRange))))
               (start (and range (plist-get range :start)))
               (line (and start (plist-get start :line)))
               (char (and start (plist-get start :character)))
               (file (and uri (eglot-uri-to-path uri)))
               (code (and file
                          (let ((visiting (find-buffer-visiting file)))
                            (cond
                             (visiting
                              (with-current-buffer visiting
                                (save-restriction
                                  (widen)
                                  (buffer-substring-no-properties (point-min) (point-max)))))
                             ((file-readable-p file)
                              (with-temp-buffer
                                (insert-file-contents file)
                                (buffer-substring-no-properties (point-min) (point-max))))))))
               (extracted (and code line char
                               (my/c-ts-extract-record-at code lang line char)))
               (highlighted (and extracted
                                 (my/c-fontify-snippet extracted is-cpp))))
          (setq my/eldoc-box-c-type-cache (list tick pt highlighted))
          highlighted)))))

(defun my/eldoc-box-enrich-c-type (args)
  "Replace clangd's collapsed struct/typedef stubs with full definitions in `eldoc-box'."
  (let* ((str (car args))
         (snippet (my/eglot-c-type-definition-at-point)))
    (if (not snippet)
        args
      (let* ((no-doc-p (string-match-p "\\`There['’]s no doc to display" str))
             (cleaned
              (replace-regexp-in-string
               (concat "\\(?:\n+\\(?:---+\\)?\n*\\)"
                       "\\(?:```[A-Za-z0-9_+]*\n\\)?"
                       "\\(?:"
                       "typedef[ \t]+\\(?:struct\\|union\\|enum\\|class\\)[ \t]+[^\n{}]+"
                       "\\|"
                       "\\(?:struct\\|union\\|enum\\|class\\)[ \t]+[A-Za-z0-9_:]+[ \t]*{}[ \t]*;?"
                       "\\)"
                       "\\(?:\n```\\)?[ \t\n]*\\'")
               ""
               str)))
        (list
         (cond
          (no-doc-p snippet)
          ((string-search (substring-no-properties snippet)
                          (substring-no-properties str))
           str)
          (t (concat (string-trim-right cleaned) "\n\n" snippet))))))))

(defun my/eldoc-box-refresh-now (&rest _)
  "Trigger immediate non-interactive Eldoc refresh when opening `eldoc-box-help-at-point'."
  (when (bound-and-true-p eldoc-mode)
    (eldoc-print-current-symbol-info nil)))

(use-package markdown-mode
  :straight t
  :defer t
  :config
  (advice-add 'markdown-get-lang-mode :filter-return #'major-mode-remap))

(use-package eldoc-box
  :straight t
  :ensure t
  :defer nil
  :bind (("C-; k" . eldoc-box-help-at-point)
         ("C-c k" . eldoc-box-help-at-point))
  :custom
  (eldoc-echo-area-use-multiline-p nil)
  :config
  (with-eval-after-load 'eldoc-box
    (when (facep 'eldoc-box-border)
      (set-face-attribute 'eldoc-box-border nil :background "#cba6f7"))
    (advice-add 'eldoc-box--display :filter-args #'my/eldoc-box-enrich-c-type)
    (advice-add 'eldoc-box-help-at-point :after #'my/eldoc-box-refresh-now)))
