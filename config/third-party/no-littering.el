(use-package no-littering
  :demand t
  :config
  (setq
   auto-save-file-name-transforms
   `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  ; (setq custom-file (no-littering-expand-etc-file-name "custom.el"))
  (setq custom-file (or (and (fboundp 'null-device) (null-device))
                     (if (eq system-type 'windows-nt) "NUL" "/dev/null")))
  (setq custom-save-custom-dont-save t) ; Never save customizations
  (when (file-exists-p custom-file)
    (load custom-file)))
