;; -*- lexical-binding: t; -*-

(use-package compile
  :defer t
  :bind (("<f9>"    . compile)
         ("C-c c"   . compile)
         ("C-c C-c" . recompile))
  :custom
  ;; Native Emacs ANSI color rendering in compilation buffers
  (ansi-color-for-compilation-mode t)
  :config
  ;; Kill running compilation without prompt before launching new one
  (setq compilation-always-kill t
        compilation-ask-about-save nil
        compilation-scroll-output 'first-error)

  ;; Save all modified project buffers automatically before compilation
  (defun my-save-project-buffers (&rest _args)
    "Save all modified buffers belonging to current project without prompting."
    (cond
     ((and (fboundp 'projectile-project-p) (projectile-project-p))
      (projectile-save-project-buffers))
     ((and (fboundp 'project-current) (project-current))
      (let ((buffers (project-buffers (project-current))))
        (dolist (buf buffers)
          (with-current-buffer buf
            (when (and buffer-file-name (buffer-modified-p))
              (save-buffer))))))
     (t
      (save-some-buffers t))))

  (advice-add 'compile :before #'my-save-project-buffers)
  (advice-add 'recompile :before #'my-save-project-buffers))
