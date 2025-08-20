;; -*- lexical-binding: t; -*-

(use-package consult
  :defer 1
  :bind
  ([remap goto-line] . consult-goto-line)
  ([remap switch-to-buffer] . consult-buffer)

  ("C-c h" . consult-history)
  ("C-c m" . consult-mode-command)
  ("C-c k" . consult-kmacro)
  :custom
  (consult-project-root-function #'projectile-project-root)
  (consult-narrow-key "<"))

;; kinda works like shit?
(use-package consult-projectile
  :after (consult projectile)
  :demand t
  :straight (consult-projectile :type git :host gitlab :repo "OlMon/consult-projectile" :branch "master")
  )

(use-package consult-notes
  :after (embark-consult)
  :straight t
  :commands (consult-notes
	     consult-notes-search-in-all-notes
	     ;; if using org-roam
	     consult-notes-org-roam-find-node
	     consult-notes-org-roam-find-node-relation)
  :config
  (setq consult-notes-file-dir-sources
	`(
	  ("Bibliography" ?b "~/Documents/Org/Brain/BibliographyNotes")
	  ("Definitions" ?d ,(expand-file-name "~/Documents/Org/Brain/Definitions"))
	  ("Lists" ?l ,(expand-file-name "~/Documents/Org/Lists"))
	  ("Thoughts" ?t ,(expand-file-name "~/Documents/Org/Brain/Thoughts"))
	  )
	)
  )

(use-package consult-org-roam
  :ensure t
  :after (consult org-roam)
  :init
  (require 'consult-org-roam)
  ;; Activate the minor mode
  (consult-org-roam-mode 1)
  :custom
  ;; Use `ripgrep' for searching with `consult-org-roam-search'
  (consult-org-roam-grep-func #'consult-ripgrep)
  ;; Configure a custom narrow key for `consult-buffer'
  (consult-org-roam-buffer-narrow-key ?r)
  ;; Display org-roam buffers right after non-org-roam buffers
  ;; in consult-buffer (and not down at the bottom)
  (consult-org-roam-buffer-after-buffers t)
  :config
  ;; Eventually suppress previewing for certain functions
  (consult-customize
   consult-org-roam-forward-links
   :preview-key "M-.")
  )
