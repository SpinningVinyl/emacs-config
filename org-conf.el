;; -*- coding: utf-8; lexical-binding: t; -*-

(use-package org-auto-tangle
  :defer t)

;; use Org for presentations
(use-package org-present)

(defun prsv/org-tempo-setup ()
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("j" . "src java"))
  )

(defun prsv/org-babel-setup ()
  (require 'ob-tangle)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (ditaa . t)
     (dot . t)
     (gnuplot . t)
     (org . t)
     (plantuml . t)
     (latex . t)
     (python . t)))
  (setq org-confirm-babel-evaluate nil)
  (setq org-ditaa-jar-path (expand-file-name "~/bin/java/ditaa-0.11.0-standalone.jar"))
  (setq org-plantuml-jar-path (expand-file-name "~/bin/java/plantuml.jar"))
  )

(defun prsv/org-mode-setup ()
  (org-indent-mode)
  (visual-line-mode 1)
  (prsv/disable-line-numbers-hook)
  (prsv/delete-selection-hook)
  (prsv/org-set-font-sizes)
  ;; fix indentation in Org-mode code blocks
  (setq org-edit-src-content-indentation 0)
  (setq org-pretty-entities t)
  (setq org-list-allow-alphabetical t)
  ;; use wide margins and center text on the screen for better readability
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t
	visual-fill-column-enable-sensible-window-split t)
  (visual-fill-column-mode 1)
  (org-auto-tangle-mode 1)
  )

(defun prsv/org-set-font-sizes ()
  "Sets proper font sizes for headings in Org-mode."
  (custom-set-faces
    '(org-level-1 ((t (:inherit outline-1 :height 1.75))))
    '(org-level-2 ((t (:inherit outline-2 :height 1.5))))
    '(org-level-3 ((t (:inherit outline-3 :height 1.25))))
    '(org-level-4 ((t (:inherit outline-4 :height 1.1))))
    '(org-level-5 ((t (:inherit outline-5 :height 1.0))))
    (set-face-attribute 'org-document-title nil :height 1.5))
  )

(use-package org
  :hook ((org-mode . prsv/org-mode-setup))
  :config
  (prsv/org-tempo-setup)
  (prsv/org-babel-setup)
  ;; handle movements
  (setq org-special-ctrl-a/e t)
  (setq org-special-ctrl-k t)
  (setq org-special-ctrl-o t)
  ;; directory for storing attachments
  (setq org-attach-id-dir "~/Documents/Org/attachments")
  (setq org-attach-use-inheritance t) ; !!!IMPORTANT: inherit attachments from parent nodes 
  (setq org-agenda-files '("~/Documents/Org/Current.org"
                           "~/Documents/Org/Archive.org"))
  (setq org-refile-targets
    '(("Archive.org" :maxlevel . 1)
      ("Current.org" :maxlevel . 1)))
  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)
  ;; set keywords for todo entries
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "SOMEDAY(s)" "|" "DONE(d@)" "CANCELED(k@)")))

  (setq org-capture-templates
    `(("t" "Task" entry (file+headline "~/Documents/Org/Current.org" "Inbox")
         "** TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
      ("j" "Journal" entry (file+olp+datetree "~/Documents/Org/Journal.org")
       "* %?\nEntered on %U\n %i\n" :empty-lines 1)))
  
  (require 'org-id)
  )

;; org-roam setup
(use-package org-roam
      :ensure t
      :custom
      (org-roam-directory (file-truename "~/Documents/Org/roam"))
      :bind (("C-c n l" . org-roam-buffer-toggle)
             ("C-c n f" . org-roam-node-find)
             ("C-c n g" . org-roam-graph)
             ("C-c n i" . org-roam-node-insert)
             ("C-c n c" . org-roam-capture)
             ("C-c n a" . org-roam-alias-add)
             ;; Completion-at-point
             ("C-M-i" . completion-at-point))
      :config
      (setq org-roam-completion-everywhere t)
      (org-roam-setup)
      ;; If using org-roam-protocol
      (require 'org-roam-protocol))
(setq org-roam-v2-ack t)

;; custom functions for reindexing IDs of org-roam files
(defun prsv/org-id-update-org-roam-files ()
  "Update Org-ID locations for all Org-roam files."
  (interactive)
  (org-id-update-id-locations (org-roam--list-all-files)))

(defun prsv/org-id-update-id-current-file ()
  "Scan the current buffer for Org-ID locations and update them."
  (interactive)
  (org-id-update-id-locations (list (buffer-file-name (current-buffer)))))


(defun prsv/org-toggle-emphasis ()
  "Toggle hiding/showing of Org-mode emphasis markers."
  (interactive)
  (if org-hide-emphasis-markers
      (set-variable 'org-hide-emphasis-markers nil)
    (set-variable 'org-hide-emphasis-markers t))
  (org-mode-restart))


;; set up Org keybindings
(with-eval-after-load "org"
  (define-key org-mode-map (kbd "M-g h") #'helm-org-in-buffer-headings)
  (define-key org-mode-map (kbd "C-c t e") 'prsv/org-toggle-emphasis)
  (define-key org-mode-map (kbd "C-c t l") 'org-toggle-link-display)
  (define-key org-mode-map (kbd "C-a") 'org-beginning-of-line) 
  (define-key org-mode-map (kbd "C-e") 'org-end-of-line)
  (define-key org-mode-map (kbd "C-k") 'org-kill-line)
  (define-key org-mode-map (kbd "C-c t t") 'org-babel-tangle)
  )

(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

;; make sure that the calendar looks like a proper calendar
;; and that weeks start on Mondays
(add-hook 'calendar-load-hook
              (lambda ()
                (calendar-set-date-style 'european)))
(setq calendar-week-start-day 1)

(use-package helm-org-rifle) ;; quickly find information in Org-mode files
(use-package helm-org) ;; enable Helm-powered navigation in Org buffers
(add-to-list 'helm-completing-read-handlers-alist '(org-capture . helm-org-completing-read-tags))
(add-to-list 'helm-completing-read-handlers-alist '(org-set-tags . helm-org-completing-read-tags))

;;; org-conf.el ends here
