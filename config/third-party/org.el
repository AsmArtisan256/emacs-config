;; -*- lexical-binding: t; -*-

;; many thanks to Nicolas Rougier https://github.com/rougier/dotemacs/blob/master/dotemacs.org

(use-package org
  :straight (:type built-in)
  :hook
  (org-mode . org-toggle-pretty-entities)
  (org-mode . variable-pitch-mode)
  :config
  ;;
  ;; directories
  ;;
  (setq org-directory my-org-dir)
  ;; (setq org-metadir my-org-meta-dir)
  ;; (setq org-archive-location my-org-archive-dir)
  (setq diary-file my-org-diary-file)

  ;; bibliography
  (setq org-cite-global-bibliography (file-expand-wildcards (expand-file-name "Bibliography/*.bib" org-directory)))

  ;;
  ;; general config
  ;;

  ;; resize image to window width
  (setq org-image-actual-width nil)
  ;; NO indentation (src blocks)
  (setq org-startup-indented t)
  ;; show everything
  (setq org-startup-folded 'fold)
  ;; show images inline
  (setq org-startup-with-inline-images t)

  ;; return hit doesnt follow links (should I have this though? Use mouse??)
  (setq org-return-follows-link nil)

  (setq org-use-speed-commands t)
  (setq org-reverse-note-order nil)
  (setq org-catch-invisible-edits 'show-and-error)
  (setq org-return-follows-link t)
  (setq org-loop-over-headlines-in-active-region 'start-level)
  (setq org-imenu-depth 7)

  (setq org-drawers '("PROPERTIES" "CLOCK" "LOGBOOK" "OUT"))

  (setq org-log-done 'time)

  (setq org-enforce-todo-dependencies t)

  ;; controls
  (setq org-special-ctrl-a/e t)
  (setq org-special-ctrl-k t)

  ;; selection
  (setq org-fast-tag-selection-single-key t)
  (setq org-use-fast-todo-selection t)
  (setq org-treat-S-cursor-todo-selection-as-state-change nil)
  (setq org-support-shift-select 'always)

  ;; tags
  (setq org-auto-align-tags nil)
  (setq org-tags-column 1)
  (setq org-insert-heading-respect-content t)

  ;; inheritance
  (setq org-use-tag-inheritance nil)
  (setq org-use-property-inheritance t)

  ;;
  ;; styling
  ;;
  (setq org-hide-emphasis-markers t)
  (setq org-ellipsis " …")

  (setq org-pretty-entities t)
  (setq org-pretty-entities-include-sub-superscripts t)

  (setq org-descriptive-links t)

  ;; number of empty lines between sections
  (setq org-cycle-separator-lines 2)

  (setq org-fontify-done-headline t)
  (setq org-fontify-quote-and-verse-blocks t)
  (setq org-fontify-whole-heading-line t)
  (setq org-fontify-whole-block-delimiter-line t)

  ;; headline sizes
  (set-face-attribute 'org-level-1 nil :height 1.3)
  (set-face-attribute 'org-level-2 nil :height 1.2)
  (set-face-attribute 'org-level-3 nil :height 1.1)
  (set-face-attribute 'org-level-4 nil :height 1.0)
  (set-face-attribute 'org-level-5 nil :height 1.0)
  (set-face-attribute 'org-level-6 nil :height 1.0)
  (set-face-attribute 'org-level-7 nil :height 1.0)
  (set-face-attribute 'org-level-8 nil :height 1.0)

  ;; footnotes
  (setq org-footnote-define-inline t)

  ;;
  ;; logs
  ;;
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-log-note-clock-out nil)
  (setq org-log-redeadline nil)
  (setq org-log-reschedule nil)
  (setq org-read-date-prefer-future 'time)

  ;;
  ;; refile
  ;;
  ;; (defun my/org-files ()
  ;;   (seq-filter 'file-exists-p
  ;;               (directory-files-recursively my-org-roam-directory "\\.org\\'")))
  ;; (setq-default org-refile-targets '((my/org-files . (:level . 1))))
  (setq-default org-refile-targets '((my-org-refile-files . (:level . 1))))

  (setq org-refile-use-outline-path 'file)
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  (setq org-refile-use-cache t)
  (setq org-outline-path-complete-in-steps nil)

  ;;
  ;; todo
  ;;
  (setq org-todo-keywords
	      '(
	        (sequence "TODO(t)" "STARTED(s!)" "WAITING(w@/!)"
		                "DELEGATED(g@/!)" "SOMEDAY(y)" "|" "DONE(d@)" "CANCELED(x@)")
	        ;; (sequence "TOREAD(t)" "READING(r!)" "WAITING(w@/!)" "|" "DONE(d!)")
	        ))

  (defun my/string-equal-to-any (str)
    (let ((string-list '("STARTED")))
      (member str string-list)))

  (defun my/log-todo-next-creation-date (&rest ignore)
    "Log second-phase creation time in the property drawer under the key 'ACTIVATED'"
    (when (and (my/string-equal-to-any (org-get-todo-state))
	             (not (org-entry-get nil "ACTIVATED")))
      (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d %a %H:%M]"))))
  (add-hook 'org-after-todo-state-change-hook #'my/log-todo-next-creation-date)

  ;;
  ;; checkbox logging
  ;;
  (defun org-log-checklist-item (item)
    "Insert clocked item into logbook drawer.
    Create drawer if it does not exist yet."
    (save-excursion
      (org-previous-visible-heading 1)
      (while (not (= (org-current-level) 1))
	      (org-previous-visible-heading 1))
      (forward-line)
      (let* ((element (org-element-at-point))
	           (logbookp (string= (org-element-property :drawer-name element)
				                        "LOGBOOK")))
	      (if logbookp
	          (goto-char (org-element-property :contents-end element))
	        (org-insert-drawer nil "LOGBOOK"))
	      (insert "- \"" item "\" was checked ")
	      (org-insert-time-stamp (current-time) t t)
	      (when logbookp
	        (insert "\n")))))

  (defun org-checkbox-item ()
    "Retrieve the contents (text) of the item."
    (save-excursion
      (beginning-of-line)
      (search-forward "]")
      (forward-char)
      (buffer-substring-no-properties (point) (line-end-position))))

  (defun org-checklist-change-advice-function (&rest _)
    (when (org-at-item-checkbox-p)
      (let ((checkedp (save-excursion
			                  (beginning-of-line)
			                  (search-forward "[")
			                  (looking-at-p "X"))))
	      (when checkedp
	        (org-log-checklist-item (org-checkbox-item))))))

  (advice-add 'org-list-struct-apply-struct :after #'org-checklist-change-advice-function)

  ;;
  ;; cycle
  ;;
  (setq org-cycle-global-at-bob t)
  (setq org-cycle-inline-images-display t)

  ;; latex (maybe move to ox? or org-babel?)
  (setq org-preview-latex-default-process 'dvisvgm)
  (setq org-latex-create-formula-image-program 'dvipng)

  (setq org-latex-default-packages-alist
	      '(("T1" "fontenc" t)
	        ("" "fixltx2e" nil)
	        ("" "graphicx" t)
	        ("" "longtable" nil)
	        ("" "float" nil)
	        ("" "wrapfig" nil)
	        ("" "rotating" nil)
	        ("normalem" "ulem" t)
	        ("" "amsmath" t)
	        ("" "textcomp" t)
	        ("" "marvosym" t)
	        ("" "wasysym" t)
	        ("" "amssymb" t)
	        ("" "hyperref" nil)
	        "\\tolerance=1000"))
  (setq org-latex-minted-options
	      '(("fontsize" "\\footnotesize")
	        ("linenos" "true")
	        ("xleftmargin" "0em")))
  (setq org-latex-pdf-process
	      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
	        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
	        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
  (setq org-latex-src-block-backend 'minted)
  (setq org-latex-listings 'minted
	      org-latex-packages-alist '(("newfloat" "minted"))
	      org-latex-pdf-process
	      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
	        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
  )

(use-package org-modern
  :after org
  :custom
  (org-modern-table nil)
  (org-modern-list '((?+ . "➤") (?- . "•") (?* . "•")))
  ;; (org-modern-checkbox nil)
  (org-modern-checkbox
   '((88 . "☒")
     (45 . "◫")
     (32 . "☐")))
  (org-modern-todo-faces
   '(
     ("CANCELED" :background "tomato" :foreground "white")
     ))
  :config
  (global-org-modern-mode)

  (modify-all-frames-parameters
   '((right-divider-width . 4)
     (internal-border-width . 4)))
  ;; (dolist (face '(window-divider
  ;;		  window-divider-first-pixel
  ;;		  window-divider-last-pixel))
  ;;   (face-spec-reset-face face)
  ;;   (set-face-foreground face (face-attribute 'default :background)))
  (set-face-background 'fringe (face-attribute 'default :background))

  ;; set custom org emphasis faces here (after org-modern)
  (defface org-custom-emphasis-bold
    '((default :inherit bold)
      (((class color) (min-colors 88) (background light)) :foreground "#a60000")
      (((class color) (min-colors 88) (background dark))  :foreground "#ff8059"))
    "Custom Org-Mode bold emphasis face.")

  (setq org-emphasis-alist
        '(("*" org-custom-emphasis-bold)
          ("/" italic)
          ("_" underline)
          ("=" org-verbatim verbatim)
          ("~" org-code verbatim)
          ("+" (:strike-through t))))
  )

(use-package org-tempo
  :straight nil
  :after (org)
  :ensure nil
  :config
  (add-to-list 'org-structure-template-alist
	             '("S" . "src emacs-lisp"))
  )

(use-package org-agenda
  :straight nil
  :after (org)
  :ensure nil
  :preface
  ;; TODO: test
  (defun my/org-cancel-meeting ()
    (interactive)
    (org-entry-put (point) "CATEGORY" "cancelled")
    (org-entry-put (point) "NOTE" "Cancelled")
    (org-set-tags ":CANCELLED:"))
  :config

  ;; org agenda files
  (setq org-agenda-files my-org-agenda-files)

  (setq org-agenda-span 7)
  (setq org-agenda-show-all-dates t)
  (setq org-agenda-time-in-grid t)
  (setq org-agenda-show-current-time-in-grid t)
  (setq org-agenda-start-on-weekday 1) ; monday
  (setq org-agenda-hide-tags-regexp nil) ; all tags
  (setq org-agenda-tags-column 0)
  (setq org-agenda-block-separator ?—)
  (setq org-agenda-category-icon-alist nil)
  (setq org-agenda-sticky t)

  (setq org-agenda-time-grid
	      '((daily today require-timed)
	        (0700 0800 0900 1000 1100
		            1200 1300 1400 1500 1600
		            1700 1800 1900 2000 2100)
	        " -----" "—————————————————"))

  (setq org-agenda-current-time-string
	      "—·—·—·—·—·—·—·—·— NOW")

  ;; (setq org-agenda-prefix-format
  ;;	'((agenda . " %i %-12:c%?-12t% s")
  ;;	  (todo   . " %i %-12:c")
  ;;	  (tags   . " %i %-12:c")
  ;;	  (search . " %i %-12:c")))
  (setq org-agenda-prefix-format
	      '((agenda . "%i %?-12t%s")
	        (todo .   "%i")
	        (tags .   "%i")
	        (search . "%i")))

  (setq org-agenda-sorting-strategy
	      '((agenda deadline-down scheduled-down todo-state-up time-up
		              habit-down priority-down category-keep)
	        (todo   priority-down category-keep)
	        (tags   timestamp-up priority-down category-keep)
	        (search category-keep)))

  (setq org-agenda-custom-commands
	      '(
	        ("g" "Get Things Done (GTD)"
	         ((agenda ""
		                ((org-agenda-skip-function
		                  '(org-agenda-skip-entry-if 'deadline))
		                 (org-deadline-warning-days 0)))
	          (todo "STARTED|WAITING"
		              ((org-agenda-skip-function
		                '(org-agenda-skip-entry-if 'deadline))
		               (org-agenda-prefix-format "  %i %-12:c [%e] ")
		               (org-agenda-overriding-header "\nTasks\n")))
	          (agenda nil
		                ((org-agenda-entry-types '(:deadline))
		                 (org-agenda-format-date "")
		                 (org-deadline-warning-days 31)
		                 (org-agenda-skip-function
		                  '(org-agenda-skip-entry-if 'regexp "\\* DONE"))
		                 (org-agenda-overriding-header "\nDeadlines")))
	          (tags-todo "inbox"
		                   ((org-agenda-prefix-format "  %?-12t% s")
			                  (org-agenda-overriding-header "\nInbox\n")))
	          (tags "CLOSED>=\"<today>\""
		              ((org-agenda-overriding-header "\nCompleted today\n")))))
	        ("x" "Tasks"
	         ((todo "TODO"
		              ((org-agenda-todo-keyword-format ":%s:")
		               (org-agenda-prefix-format '((todo   . " ")))
		               (org-agenda-skip-function '(org-agenda-skip-entry-if 'timestamp))
		               (org-agenda-overriding-header " Todo \n")))

	          (tags "+work-TODO=\"DONE\""
		              ((org-agenda-span 90)
		               (org-agenda-overriding-header "\nPending Work Tasks\n")))

	          ;; (tags "+TALK+TIMESTAMP>=\"<now>\""
	          ;;	  ((org-agenda-span 90)
	          ;;	   (org-agenda-max-tags 5)
	          ;;	   (org-agenda-overriding-header "\n Upcoming talks\n")))

	          ;; (tags "TEACHING+TIMESTAMP>=\"<now>\""
	          ;;	  ((org-agenda-span 90)
	          ;;	   (org-agenda-max-tags 5)
	          ;;	   (org-agenda-overriding-header "\n Upcoming lessons\n")))

	          ;; (tags "TRAVEL+TIMESTAMP>=\"<now>\""
	          ;;	  ((org-agenda-span 90)
	          ;;	   (org-agenda-max-tags 5)
	          ;;	   (org-agenda-overriding-header "\n Upcoming travels\n")))

	          ;; (tags "DEADLINE>=\"<today>\""
	          ;;	  ((org-agenda-span 90)
	          ;;	   (org-agenda-max-tags 5)
	          ;;	   (org-agenda-overriding-header "\n Upcoming deadlines\n")))
	          )
	         )
	        )
	      )

  ;;
  ;; agenda timer
  ;; TODO: keep it? worth it?
  ;;
  ;; (defvar my/org-agenda-update-delay 60)
  ;; (defvar my/org-agenda-update-timer nil)

  ;; (defun my/org-agenda-update ()
  ;;   "Refresh daily agenda view"

  ;;   (when my/org-agenda-update-timer
  ;;     (cancel-timer my/org-agenda-update-timer))

  ;;   (let ((window (get-buffer-window "*Org Agenda(a)*" t)))
  ;;     (when window
  ;;	(with-selected-window window
  ;;	  (let ((inhibit-message t))
  ;;	    (org-agenda-redo)))))

  ;;   (setq my/org-agenda-update-timer
  ;;	  (run-with-idle-timer
  ;;	   (time-add (current-idle-time) my/org-agenda-update-delay)
  ;;	   nil
  ;;	   'my/org-agenda-update)))

  ;; (run-with-idle-timer my/org-agenda-update-delay t 'my/org-agenda-update)

  )

;; (use-package org-super-agenda
;;   :after (org)
;;   :config
;;   ;; (setq org-super-agenda-groups
;;   ;;	'((:name "Important" :priority "A")
;;   ;;	  (:name "Overdue" :deadline past)
;;   ;;	  (:name "Reschedule" :and (:scheduled past :not (:habit t)))
;;   ;;	  (:name "Calls" :tag "Call")
;;   ;;	  (:name "Work" :file-path "Agenda/Inbox.org")
;;   ;;	  (:name "Tasks" :not (:priority "A" :priority "C"))
;;   ;;	  (:name "Needs review" :todo "WAITING" :todo "DELEGATED" :todo "STARTED")
;;   ;;	  (:name "Optional" :priority "C" :order 9)
;;   ;;	  (:name "Errands" :tag "Errand")
;;   ;;	  (:name "Due Soon" :deadline future)))
;;   (setq org-super-agenda-header-separator "")
;;   (setq org-super-agenda-hide-empty-groups t)

;;   :config
;;   (org-super-agenda-mode)
;;   )

;; (use-package org-agenda
;;   :straight nil
;;   :after (org)
;;   :ensure nil
;;   :preface
;;   (defun org-todo-age-time (&optional pos)
;;     (let ((stamp (org-entry-get (or pos (point)) "CREATED" t)))
;;       (when stamp
;;	(time-subtract (current-time)
;;		       (org-time-string-to-time
;;			(org-entry-get (or pos (point)) "CREATED" t))))))

;;   (defun org-todo-age (&optional pos)
;;     (let ((days (time-to-number-of-days (org-todo-age-time pos))))
;;       (cond
;;        ((< days 1)   "today")
;;        ((< days 7)   (format "%dd" days))
;;        ((< days 30)  (format "%.1fw" (/ days 7.0)))
;;        ((< days 358) (format "%.1fM" (/ days 30.0)))
;;        (t            (format "%.1fY" (/ days 365.0))))))
;;   :custom
;;   (org-agenda-file-regexp "\\`\\\([^.].*\\.org\\\|[0-9]\\\{8\\\}\\\(\\.gpg\\\)?\\\)\\'")
;;   (org-agenda-files (list
;;		     "~/Documents/Org/Agenda/Todo.org"
;;		     "~/Documents/Org/Agenda/Work.org"
;;		     "~/Documents/Org/Agenda/Birthdays.org"

;;		     "~/Documents/Org/Travel.org"

;;		     "~/Documents/Org/Lists/Games.org"
;;		     "~/Documents/Org/Lists/Manga.org"
;;		     "~/Documents/Org/Lists/Books.org"

;;		     my-org-journal-dir
;;		     )
;;		    )

;;   ;; general
;;   (org-agenda-show-all-dates t)
;;   ;; ui
;;   (org-agenda-fontify-priorities t)

;;   ;; calendar
;;   (org-icalendar-combined-agenda-file "~/Documents/Org/Agenda/org.ics")
;;   (org-icalendar-timezone "Europe/Lisbon")

;;   :config

;;   ;;
;;   ;; general
;;   ;;
;;   ;; (setq org-agenda-archives-mode t)
;;   (setq org-agenda-span 14)
;;   (setq org-agenda-start-on-weekday 1)  ; Monday
;;   (setq org-agenda-confirm-kill t)
;;   (setq org-agenda-show-all-dates t)
;;   (setq org-agenda-show-outline-path t)
;;   (setq org-agenda-window-setup 'current-window)
;;   (setq org-agenda-skip-comment-trees nil)
;;   (setq org-agenda-menu-show-matcher t)
;;   (setq org-agenda-menu-two-columns t)
;;   (setq org-agenda-sticky nil)
;;   (setq org-agenda-custom-commands-contexts nil)
;;   (setq org-agenda-max-entries nil)
;;   (setq org-agenda-max-todos nil)
;;   (setq org-agenda-max-tags nil)
;;   (setq org-agenda-max-effort nil)
;;   (setq org-agenda-restore-windows-after-quit t)

;;   (setq org-agenda-time-in-grid t)
;;   (setq org-agenda-show-current-time-in-grid t)

;;   ;; General view options
;;   (setq org-agenda-prefix-format
;;	'(
;;	  (agenda . " %i %-12:c%?-12t %s %?-12b ")
;;	  (todo . " %i %-12:c")
;;	  (tags . " %i %-12:c")
;;	  (search . " %i %-12:c")
;;	  ))

;;   (setq org-agenda-sorting-strategy
;;	'((agenda deadline-down scheduled-down todo-state-up time-up
;;		  habit-down priority-down category-keep)
;;	  (todo   priority-down category-keep)
;;	  (tags   timestamp-up priority-down category-keep)
;;	  (search category-keep)))

;;   (setq org-agenda-breadcrumbs-separator " -> ")
;;   (setq org-agenda-todo-keyword-format "%-1s")
;;   (setq org-agenda-diary-sexp-prefix nil)
;;   (setq org-agenda-fontify-priorities 'cookies)
;;   (setq org-agenda-category-icon-alist nil)
;;   (setq org-agenda-remove-times-when-in-prefix nil)
;;   (setq org-agenda-remove-timeranges-from-blocks nil)
;;   (setq org-agenda-compact-blocks nil)
;;   (setq org-agenda-block-separator ?—)

;;   (defun prot/org-agenda-format-date-aligned (date)
;;     "Format a DATE string for display in the daily/weekly agenda.
;;   This function makes sure that dates are aligned for easy reading.

;;   Slightly tweaked version of `org-agenda-format-date-aligned' that
;;   produces dates with a fixed length."
;;     (require 'cal-iso)
;;     (let* ((dayname (calendar-day-name date t))
;;	   (day (cadr date))
;;	   (day-of-week (calendar-day-of-week date))
;;	   (month (car date))
;;	   (monthname (calendar-month-name month t))
;;	   (year (nth 2 date))
;;	   (iso-week (org-days-to-iso-week
;;		      (calendar-absolute-from-gregorian date)))
;;	   (weekyear (cond ((and (= month 1) (>= iso-week 52))
;;			    (1- year))
;;			   ((and (= month 12) (<= iso-week 1))
;;			    (1+ year))
;;			   (t year)))
;;	   (weekstring (if (= day-of-week 1)
;;			   (format " (W%02d)" iso-week)
;;			 "")))
;;       (format "%s %2d %s %4d%s"
;;	      dayname day monthname year weekstring)))

;;   (setq org-agenda-format-date #'prot/org-agenda-format-date-aligned)

;;   ;; Marks
;;   (setq org-agenda-bulk-mark-char "#")
;;   (setq org-agenda-persistent-marks nil)

;;   ;; Diary entries
;;   (setq org-agenda-insert-diary-strategy 'date-tree)
;;   (setq org-agenda-insert-diary-extract-time nil)
;;   (setq org-agenda-include-diary t)

;;   ;; inactive timestamps
;;   (setq org-agenda-include-inactive-timestamps t)

;;   ;; Follow mode
;;   (setq org-agenda-start-with-follow-mode nil)
;;   (setq org-agenda-follow-indirect t)

;;   ;; Multi-item tasks
;;   (setq org-agenda-dim-blocked-tasks t)
;;   (setq org-agenda-todo-list-sublevels t)

;;   ;; Filters and restricted views
;;   (setq org-agenda-persistent-filter nil)
;;   (setq org-agenda-restriction-lock-highlight-subtree t)

;;   ;; Items with deadline and scheduled timestamps
;;   (setq org-agenda-include-deadlines t)
;;   (setq org-deadline-warning-days 5)
;;   (setq org-agenda-skip-scheduled-if-done nil)
;;   (setq org-agenda-skip-scheduled-if-deadline-is-shown nil)
;;   (setq org-agenda-skip-timestamp-if-deadline-is-shown nil)
;;   (setq org-agenda-skip-deadline-if-done nil)
;;   (setq org-agenda-skip-deadline-prewarning-if-scheduled 1)
;;   (setq org-agenda-skip-scheduled-delay-if-deadline nil)
;;   (setq org-agenda-skip-additional-timestamps-same-entry nil)
;;   (setq org-agenda-skip-timestamp-if-done nil)
;;   (setq org-agenda-search-headline-for-time t)
;;   (setq org-scheduled-past-days 365)
;;   (setq org-deadline-past-days 365)
;;   (setq org-agenda-move-date-from-past-immediately-to-today t)
;;   (setq org-agenda-show-future-repeats t)
;;   (setq org-agenda-prefer-last-repeat nil)
;;   (setq org-agenda-timerange-leaders
;;	'("" "(%d/%d): "))
;;   (setq org-agenda-scheduled-leaders
;;	'("Scheduled: " "Sched.%2dx: "))
;;   (setq org-agenda-inactive-leader "[")
;;   (setq org-agenda-deadline-leaders
;;	'("Deadline:  " "In %3d d.: " "%2d d. ago: "))
;;   ;; Time grid
;;   (setq org-agenda-time-leading-zero t)
;;   (setq org-agenda-timegrid-use-ampm nil)
;;   (setq org-agenda-use-time-grid t)
;;   (setq org-agenda-show-current-time-in-grid t)
;;   (setq org-agenda-current-time-string
;;	"—·—·—·—·—·—·—·—·—")
;;   (setq org-agenda-time-grid
;;	'((daily today require-timed)
;;	  (0700 0800 0900 1000 1100
;;		1200 1300 1400 1500 1600
;;		1700 1800 1900 2000 2100)
;;	  " -----" "—————————————————"))
;;   (setq org-agenda-default-appointment-duration nil)

;;   ;; Global to-do list
;;   (setq org-agenda-todo-ignore-with-date nil)
;;   (setq org-agenda-todo-ignore-timestamp nil)
;;   (setq org-agenda-todo-ignore-scheduled nil)
;;   (setq org-agenda-todo-ignore-deadlines nil)
;;   (setq org-agenda-todo-ignore-time-comparison-use-seconds t)
;;   (setq org-agenda-tags-todo-honor-ignore-options nil)

;;   ;; Tagged items
;;   (setq org-agenda-show-inherited-tags t)
;;   (setq org-agenda-use-tag-inheritance
;;	'(todo search agenda))
;;   (setq org-agenda-hide-tags-regexp nil)
;;   (setq org-agenda-remove-tags nil)
;;   (setq org-agenda-tags-column -120)

;;   ;; Agenda entry
;;   ;;
;;   (setq org-agenda-start-with-entry-text-mode nil)
;;   (setq org-agenda-entry-text-maxlines 5)
;;   (setq org-agenda-entry-text-exclude-regexps nil)
;;   (setq org-agenda-entry-text-leaders "    > ")

;;   ;; Logging, clocking
;;   ;;
;;   (setq org-agenda-log-mode-items '(closed clock state))
;;   (setq org-agenda-clock-consistency-checks
;;	'((:max-duration "10:00" :min-duration 0 :max-gap "0:05" :gap-ok-around
;;			 ("4:00")
;;			 :default-face ; This should definitely be reviewed
;;			 ((:background "DarkRed")
;;			  (:foreground "white"))
;;			 :overlap-face nil :gap-face nil :no-end-time-face nil
;;			 :long-face nil :short-face nil)))
;;   (setq org-agenda-log-mode-add-notes t)
;;   (setq org-agenda-start-with-log-mode t)
;;   (setq org-agenda-start-with-clockreport-mode nil)

;;   (setq org-agenda-clockreport-parameter-plist '(:link t :maxlevel 2))
;;   (setq org-agenda-search-view-always-boolean nil)
;;   (setq org-agenda-search-view-force-full-words nil)
;;   (setq org-agenda-search-view-max-outline-level 0)
;;   (setq org-agenda-search-headline-for-time t)
;;   (setq org-agenda-use-time-grid t)
;;   (setq org-agenda-cmp-user-defined nil)
;;   (setq org-sort-agenda-notime-is-late t)
;;   (setq org-sort-agenda-noeffort-is-high t)

;;   ;; Agenda column view
;;   ;;
;;   ;; NOTE I do not use these, but may need them in the future.
;;   (setq org-agenda-view-columns-initially nil)
;;   (setq org-agenda-columns-show-summaries t)
;;   (setq org-agenda-columns-compute-summary-properties t)
;;   (setq org-agenda-columns-add-appointments-to-effort-sum nil)
;;   (setq org-agenda-auto-exclude-function nil)
;;   (setq org-agenda-bulk-custom-functions nil)


;;   (setq org-agenda-custom-commands
;;	'(
;;	  ("W" "Waiting/delegated tasks" tags
;;	   "W-TODO=\"DONE\"|TODO={WAITING\\|DELEGATED}"
;;	   ((org-agenda-skip-function
;;	     '(org-agenda-skip-entry-if 'scheduled))
;;	    (org-agenda-sorting-strategy
;;	     '(todo-state-up priority-down category-up))))
;;	  ))
;;   )

(use-package org-habit
  :straight nil
  :after (org-agenda)
  :custom
  (org-habit-preceding-days 42)
  (org-habit-today-glyph 45)
  (org-habit-following-days 7)
  (org-habit-show-habits t)
  (org-habit-show-all-today t)
  (org-habit-show-habits-only-for-today nil)
  (org-modules '(org-habit))
  )

(use-package ol
  :defer
  :straight nil
  :ensure nil
  :after (org)
  :config
  (setq org-link-keep-stored-after-insertion t)
  )

(use-package org-src
  :straight nil
  :after (org)
  :ensure nil
  :config
  (setq org-src-window-setup 'current-window)
  (setq org-src-fontify-natively t)
  (setq org-src-preserve-indentation t)
  (setq org-src-tab-acts-natively t)
  (setq org-edit-src-content-indentation 0)

  (setq org-src-lang-modes '(
			                       ("C"      . c)
			                       ("C++"    . c++)
			                       ("bash"   . sh)
			                       ("cpp"    . c++)
			                       ("elisp"  . emacs-lisp)
			                       ("ocaml"  . tuareg)
			                       ("shell"  . sh)
			                       ("vimrc"  . vimrc)
			                       ("python" . python)
			                       ("lua"    . lua-ts)
			                       ("php"    . php)
			                       ))
  )

(use-package org-id
  :straight nil
  :after org
  :ensure nil
  :bind (:map org-mode-map ("C-c C-x i" . org-id-get-create))
  :commands (contrib/org-get-id
	           contrib/org-id-headlines)
  :config
  (setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)

  (defun contrib/org-get-id (&optional pom create prefix)
    "Get the CUSTOM_ID property of the entry at point-or-marker
POM. If POM is nil, refer to the entry at point. If the entry
does not have an CUSTOM_ID, the function returns nil. However,
when CREATE is non nil, create a CUSTOM_ID if none is present
already. PREFIX will be passed through to `org-id-new'. In any
case, the CUSTOM_ID of the entry is returned."
    (interactive)
    (org-with-point-at pom
      (let ((id (org-entry-get nil "CUSTOM_ID")))
	      (cond
	       ((and id (stringp id) (string-match "\\S-" id))
	        id)
	       (create
	        (setq id (org-id-new (concat prefix "h")))
	        (org-entry-put pom "CUSTOM_ID" id)
	        (org-id-add-location id (buffer-file-name (buffer-base-buffer)))
	        id)))))

  (defun contrib/org-id-headlines ()
    "Add CUSTOM_ID properties to all headlines in the current
file which do not already have one."
    (interactive)
    (org-map-entries (lambda ()
		                   (contrib/org-get-id (point) 'create))))
  )

(use-package org-clock
  :after (org)
  :straight nil
  :custom
  ;; Show lot of clocking history so it's easy to pick items off the C-F11 list
  (org-clock-history-length 23)
  ;; Resume clocking task on clock-in if the clock is open
  (org-clock-in-resume t)
  ;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
  (org-clock-out-remove-zero-time-clocks t)
  ;; Clock out when moving task to a done state
  (org-clock-out-when-done t)
  ;; Save the running clock and all clock history when exiting Emacs, load it on startup
  (org-clock-persist t)
  ;; Include current clocking task in clock reports
  (org-clock-report-include-clocking-task t)

  (org-clock-clocked-in-display 'mode-line)
  (org-clock-idle-time nil)
  (org-clock-in-switch-to-state "STARTED")
  (org-clock-into-drawer "LOGBOOK")
  (org-clock-mode-line-total 'current)
  (org-clock-out-switch-to-state nil)
  (org-clock-resolve-expert nil)
  (org-clone-delete-id t)
  :config
  ;; Resume clocking task when emacs is restarted
  (org-clock-persistence-insinuate)
  )

(use-package org-mouse
  :straight nil
  :after (org))

(use-package org-checklist
  :straight nil
  :after (org))

(use-package org-contacts
  :after (org)
  :custom
  (org-contacts-files my-org-contacts-files))

(use-package org-attach
  :straight nil
  :after org
  :custom
  (org-attach-file-list-property "ATTACHED")
  (org-attach-id-dir my-org-attach-id-dir)
  (org-attach-method 'mv)
  (org-attach-store-link-p 'file)
  )

(use-package org-capture
  :straight nil
  :after (org)
  :preface
  (defun my/date-sha256 ()
    (secure-hash 'sha256 (format-time-string "%Y-%m-%d %a %H:%M"))
    )

  (defun my/get-journal-file-year ()
    (let ((yearly-name (format-time-string "%Y")))
      (expand-file-name (concat my-org-journal-dir yearly-name ".org")))
    )

  (defun my/org-capture-agenda-inbox ()
    (interactive)
    ;; (call-interactively 'org-store-link)
    (org-capture nil "a")
    )
  :config
  ;; TODO: improve and add more templates
  (setq org-capture-templates my-org-capture-templates)
  )

(use-package org-cliplink
  :after (org org-capture))

(use-package org-contrib
  :ensure t
  :after (org)
  )

(use-package ox
  :straight nil
  :after (org)
  :ensure nil
  :custom
  (org-export-with-section-numbers nil)
  (org-export-with-date nil)
  (org-export-time-stamp-file nil)
  (org-export-with-timestamps nil)
  (org-export-with-email t)
  (org-export-with-toc t)
  (org-export-headline-levels 8)
  (org-export-dispatch-use-expert-ui nil)
  ;; fix missing links in ASCII export
  (org-ascii-links-to-notes nil)
  ;; adjust the number of blank lines inserted around headlines
  (org-ascii-headline-spacing (quote (1 . 1)))
  (org-html-htmlize-output-type 'css)
  (org-html-validation-link nil)
  (org-html-postamble nil)

  (org-export-backends '(ascii html icalendar latex md))
  (org-export-latex-classes
   '(("article" "\\documentclass[11pt]{article}"
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
      ("\\paragraph{%s}" . "\\paragraph*{%s}")
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
     ("linalg" "\\documentclass{article}
\\usepackage{linalgjh}
[DEFAULT-PACKAGES]
[EXTRA]
[PACKAGES]"
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
      ("\\paragraph{%s}" . "\\paragraph*{%s}")
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
     ("report" "\\documentclass[11pt]{report}"
      ("\\part{%s}" . "\\part*{%s}")
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
     ("book" "\\documentclass[11pt]{book}"
      ("\\part{%s}" . "\\part*{%s}")
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
     ("beamer" "\\documentclass{beamer}" org-beamer-sectioning)))
  )

(use-package ox-extra
  :after (org)
  :straight org-contrib
  :ensure nil
  :config
  ;; if headline has ignore tag, dont export it. But export its contents!
  (ox-extras-activate '(ignore-headlines org-export-ignore-headlines))
  (setq org-export-time-stamp-file nil)
  )

;; NOTE: this one doesn't seem to be active anymore
;; (use-package ox-gfm
;;   :after (org ox)
;;   :straight org-contrib
;;   :ensure nil
;;   )

(use-package ox-pandoc
  :after (org)
  :preface
  (defun markdown-to-org-region (start end)
    "Convert region from markdown to org, replacing selection"
    (interactive "r")
    (shell-command-on-region start end "pandoc -f markdown -t org" t t)))

(use-package toc-org
  ;; :bind
  ;; (:map markdown-mode-map
  ;;       ("C-c C-o" . toc-org-markdown-follow-thing-at-point))
  :hook
  (org-mode . toc-org-mode)
  ;; (markdown-mode . toc-org-mode)
  )

(use-package org-babel
  :no-require t
  :straight nil
  :after (org)
  :config
  ;; no confirmation before executing code
  (setq org-confirm-babel-evaluate nil)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python     . t)
     (emacs-lisp . t)
     (plantuml   . t)
     (shell      . t)
     ))

  (remove-hook 'kill-emacs-hook 'org-babel-remove-temporary-directory)

  (defun org-babel-sh-strip-weird-long-prompt (string)
    "Remove prompt cruft from a string of shell output."
    (while (string-match "^.+?;C;�" string)
      (setq string (substring string (match-end 0))))
    string)

  (advice-add 'org-babel-edit-prep:emacs-lisp :after
	            #'(lambda (_info) (run-hooks 'emacs-lisp-mode-hook))))

(use-package org-ref
  :after (org)
  :demand t
  :config
  (setq org-ref-default-bibliography my-org-ref-default-bibliography)
  (setq org-ref-bibliography-notes my-org-ref-bibliography-notes)

  ;; these are already set in bibtex... are these even useful?
  (setq bibtex-completion-bibliography my-bibtex-completion-bibliography-list)
  (setq bibtex-completion-notes-path my-bibtex-completion-notes-path)

  (setq bibtex-completion-additional-search-fields '(keywords))
  (setq	bibtex-completion-display-formats
	      '((article       . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${journal:40}")
	        (inbook        . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
	        (incollection  . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
	        (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
	        (t             . "${=has-pdf=:1}${=has-note=:1} ${year:4} ${author:36} ${title:*}")))
  )

(use-package bibtex
  :after (org org-ref)
  :demand t
  :config
  (setq bibtex-completion-pdf-open-function
	      (lambda (fpath)
	        (cond ((eq system-type 'darwin) (start-process "open" "*open*" "open" fpath))
		            ((eq system-type 'gnu/linux) (start-process "evince" "*evince*" "evince" fpath)))))

  (setq bibtex-completion-pdf-field "file")
  (setq bibtex-completion-pdf-symbol "⌘")
  (setq bibtex-completion-notes-symbol "✎")

  ;; TODO: these are being set again, is this OK? and WHY?
  (setq bibtex-completion-bibliography my-bibtex-completion-bibliography-list)
  (setq bibtex-completion-notes-path my-bibtex-completion-notes-path)

  (setq bibtex-autokey-year-length 4
	      bibtex-autokey-name-year-separator "-"
	      bibtex-autokey-year-title-separator "-"
	      bibtex-autokey-titleword-separator "-"
	      bibtex-autokey-titlewords 2
	      bibtex-autokey-titlewords-stretch 1
	      bibtex-autokey-titleword-length 5
	      bibtex-autokey-edit-before-use nil
	      bibtex-autokey-names 1
	      )
  )

(use-package oc-bibtex
  :after (bibtex)
  :straight nil)

;; TODO: verify if this is anything good at all
(use-package citar
  :after (org all-the-icons)
  :demand t
  :custom
  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar)

  (citar-bibliography org-cite-global-bibliography)

  (citar-notes-paths my-citar-notes-paths)
  (citar-file-note-extensions '("org"))

  (citar-indicators
   (list citar-indicator-files ; plain text
	       citar-indicator-notes-icons)) ; icon

  (citar-symbol-separator "   ")
  :hook (
	       (LaTeX-mode . citar-capf-setup)
	       (org-mode . citar-capf-setup)
	       )
  :config
  (setq citar-templates
	      '((main . "${author editor:20%sn} ${date year issued:4}     ${title:60}")
	        (suffix . "          ${=key= id:15}    ${=type=:12}    ${tags keywords:*}")
	        (preview . "${author editor:%etal} (${year issued date}) ${title}, ${journal journaltitle publisher container-title collection-title}.\n")
	        (note . "${author editor:%etal}: ${title}")))
  )

(use-package citar-embark
  :after (citar embark)
  :demand t
  :custom
  (citar-at-point-function 'embark-act)
  :hook (
	       (LaTeX-mode . citar-embark-mode)
	       (org-mode . citar-embark-mode)
	       )
  )

(use-package org-crypt
  :straight nil
  :after (org)
  :bind (:map org-mode-map
	            ("C-c C-x /"    . my-org-set-crypt-tag)
	            ("C-c C-x C-/"  . org-decrypt-entry)
	            ("C-c C-x C-\\" . org-encrypt-entry))
  :custom
  (org-tags-exclude-from-inheritance (quote ("crypt")))
  (org-crypt-disable-auto-save nil)
  (org-crypt-key "09852491")
  :preface
  (defun my-org-set-crypt-tag ()
    (interactive)
    (save-excursion
      (org-back-to-heading-or-point-min)
      (org-set-tags '("crypt"))))
  ;; FIXME: this was messing up Citar and the use of TAB
  ;; :config
  ;; (org-crypt-use-before-save-magic)
  )

(use-package org-edna
  :after (org)
  :diminish
  :config
  (org-edna-mode))

(use-package org-pomodoro
  :after (org org-agenda)
  :commands org-pomodoro)

(use-package org-remark
  :after (org)
  :commands (org-remark-global-tracking-mode)
  :bind (:map org-mode-map
	            ("C-c C-x R" . org-remark-mode))
  :config
  (org-remark-global-tracking-mode t))

(use-package oc-csl
  :straight nil)

;; TODO: verify if actually needed, at all.
(use-package org-journal
  :after (org)
  :preface
  (defun get-journal-file-today ()
    "Gets filename for today's journal entry."
    (let ((daily-name (format-time-string "%Y%m%d.org")))
      (expand-file-name (concat org-journal-dir daily-name))))

  (defun journal-file-today ()
    "Creates and/or loads a journal file based on today's date."
    (interactive)
    (find-file (get-journal-file-today)))

  (defun get-journal-file-yesterday ()
    "Gets filename for yesterday's journal entry."
    (let* ((yesterday (time-subtract (current-time) (days-to-time 1)))
	         (daily-name (format-time-string "%Y%m%d.org" yesterday)))
      (expand-file-name (concat org-journal-dir daily-name))))

  (defun journal-file-yesterday ()
    "Creates and/or loads a file based on yesterday's date."
    (interactive)
    (find-file (get-journal-file-yesterday)))
  :init
  (setq org-journal-enable-agenda-integration t)
  :custom
  (org-journal-update-org-agenda-files)
  ;; (org-journal-carryover-items "TODO=\"TODO\"|TODO=\"DOING\"|TODO=\"BLOCKED\"|TODO=\"REVIEW\"")
  (org-journal-carryover-items nil)
  :config
  (setq org-journal-dir my-org-journal-dir)
  (setq org-journal-file-format "%Y%m%d.org")
  (setq org-journal-date-format "%A, %d %B %Y")

  (setq org-journal-date-prefix "#+TITLE: ")
  (setq org-journal-time-prefix "* ")
  )

(use-package org-sticky-header
  :commands org-sticky-header-mode)

(use-package org-roam
  :ensure t
  :demand t
  :init
  (setq org-roam-v2-ack t)
  (defun me/org-roam-refresh-id-locations()
    "Refresh ID locations. Use when moving files around. Also, sync database."
    (interactive)
    (org-id-update-id-locations (directory-files-recursively org-roam-directory ".org$\\|.org.gpg$")))

  (defun me/org-roam-node-insert-immediate (arg &rest args)
    "Insert node immediatly without prompting for input."
    (interactive "P")
    (let ((args (cons arg args))
	        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
						                                        '(:immediate-finish t)))))
      (apply #'org-roam-node-insert args)))
  (defun my/org-roam-add-this-file-to-org-roam ()
    (interactive)
    (org-id-store-link)
    (me/org-roam-refresh-id-locations)
    )
  :custom
  (org-roam-directory my-org-roam-directory)

  ;; dailies
  (org-roam-dailies-directory "Journal/")
  (org-roam-dailies-capture-templates
   '(("d" "default" entry
      "* %?"
      :target (file+head "%<%Y-%m-%d>.org"
                         "#+title: %<%Y-%m-%d>\n"))))

  (org-roam-completion-everywhere t)

  (org-roam-capture-templates my-org-roam-capture-templates)
  (org-roam-node-display-template (concat "${type:15} ${title:*} " (propertize "${tags:45}" 'face 'org-tag)))
  :bind (("C-c n l" . org-roam-buffer-toggle)
	       ("C-c n f" . org-roam-node-find)
	       ("C-c n i" . org-roam-node-insert)
	       :map org-mode-map
	       ("C-M-i"    . completion-at-point))
  :config
  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE."
    (condition-case nil
	      (file-name-nondirectory
	       (directory-file-name
	        (file-name-directory
	         (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (error "")))

  (org-roam-setup)
  )

(use-package citar-org-roam
  :after (citar org-roam)
  :defer t
  :custom
  (citar-org-roam-subdir "BibliographyNotes")
  (citar-org-roam-capture-template-key "n")
  :config
  (citar-org-roam-mode)
  )

(use-package org-download
  :after (org)
  :ensure t
  :demand t
  :hook
  (dired-mode . org-download-enable)
  :preface
  (defun my/org-download-clipboard ()
    "Sets image dir to the correct value and downloads the image."
    (interactive)
    (setq org-download-heading-lvl nil)
    ;; (setq org-download-image-dir (concat "~/Documents/Org/ImagesDirectory/" (file-name-sans-extension (buffer-name))))
    (if (string-prefix-p (expand-file-name "~/Documents/Projects/Projects-Personal/asmartisan256.github.io/")
			                   (expand-file-name default-directory))
	      (setq org-download-image-dir (concat (file-name-sans-extension (buffer-file-name)) "-img"))
      (setq org-download-image-dir (concat my-org-images-directory (file-name-sans-extension (buffer-name))))
      )

    (org-download-clipboard)
    )
  :config
  (setq org-download-method 'directory)
  ;; (setq org-download-image-dir (concat (file-name-sans-extension (buffer-file-name)) "-img"))
  ;; (setq org-download-image-dir (concat "~/Documents/Org/ImagesDirectory/" (file-name-sans-extension (buffer-name))))
  (setq org-download-image-org-width 600)
  (setq org-download-link-format "[[file:%s]]\n")
  (setq org-download-abbreviate-filename-function #'file-relative-name)
  (setq org-download-heading-lvl nil)
  )

(use-package org-noter
  :after (org)
  :ensure t
  :demand t
  )
