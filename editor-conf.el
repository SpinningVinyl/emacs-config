;; -*- coding: utf-8; lexical-binding: t -*-

;; main editor configuration -- most settings dedicated to actually editing text
;; (including keybindings) go here

;; use UTF-8 as preferred encoding
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;; Treat clipboard input as UTF-8 string first; compound text next, etc.
;; WARNING!!! Causes intermittent problems with pasting in Wayland
;; (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; Basic editor configuration
(save-place-mode 1) ;; save point position when saving files
(turn-on-font-lock) ; enable syntax highlighting
(setq sentence-end-double-space nil) ; double spaces after sentences are a crime against humanity
(column-number-mode t) ; enable column numbers in the modeline
(global-auto-revert-mode t) ; autoreload buffers when changed on disk

(use-package sudo-edit) ; enable editing of files that require sudo permissions

;; make parentheses easier to match
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; insert parentheses, brackets and quotation marks in matching pairs
; (electric-pair-mode 1)

;; disable automatching of angle brackets: <>
; (setq electric-pair-inhibit-predicate
;               `(lambda (c)
;                  (if (char-equal c ?<) t (,electric-pair-inhibit-predicate c))))

;; highlight parentheses
(progn
  (show-paren-mode 1)
  (setq show-paren-style 'parenthesis))

;; highlight the current line only in some modes
;; (this does not work properly in vterm or eshell)
(require 'hl-line)
(defun prsv/enable-hl-line-hook ()
  (hl-line-mode 1)
  )
(add-hook 'prog-mode-hook 'prsv/enable-hl-line-hook)
(add-hook 'text-mode-hook 'prsv/enable-hl-line-hook)
(add-hook 'conf-mode-hook 'prsv/enable-hl-line-hook)

;; overwrite selected text by typing; after all, we're not in the 1980s anymore
(defun prsv/delete-selection-hook ()
  (delete-selection-mode 1)
  )
(add-hook 'prog-mode-hook 'prsv/delete-selection-hook)
(add-hook 'text-mode-hook 'prsv/delete-selection-hook)
(add-hook 'conf-mode-hook 'prsv/delete-selection-hook)

;; use this later to disable line numbers in Org-mode
(defun prsv/disable-line-numbers-hook ()
  (display-line-numbers-mode 0)
  )

;; enable line numbers in some modes
(defun prsv/display-line-numbers-hook ()
  (display-line-numbers-mode 1)
  )

;; enable electric pairs in some modes
(defun prsv/electric-pairs-hook ()
  (electric-pair-local-mode 1)
  )

;; fix indentation when writing code, and especially if using eglot-format to autoformat source files
(defun prsv/fix-indentation-hook ()
  (setq indent-tabs-mode nil)
  (setq tab-width 4)
)

(add-hook 'prog-mode-hook 'prsv/display-line-numbers-hook)
(add-hook 'prog-mode-hook 'prsv/electric-pairs-hook)
(add-hook 'prog-mode-hook 'prsv/fix-indentation-hook)
(add-hook 'text-mode-hook 'prsv/display-line-numbers-hook)
(add-hook 'conf-mode-hook 'prsv/display-line-numbers-hook)
(add-hook 'conf-mode-hook 'prsv/electric-pairs-hook)

;; use C-c d to duplicate the current line
(defun prsv/duplicate-line (arg)
  "Duplicate current line, leaving point in lower line."
  (interactive "*p")
  ;; save the point for undo
  (setq buffer-undo-list (cons (point) buffer-undo-list))
  ;; local variables for start and end of line
  (let ((bol (save-excursion (beginning-of-line) (point)))
	eol)
    (save-excursion
      ;; don't use forward-line for this, because you would have
      ;; to check whether you are at the end of the buffer
      (end-of-line)
      (setq eol (point))
      ;; store the line and disable the recording of undo information
      (let ((line (buffer-substring bol eol))
	    (buffer-undo-list t)
	    (count arg))
	;; insert the line arg times
	(while (> count 0)
	  (newline)         ;; because there is no newline in 'line'
	  (insert line)
	  (setq count (1- count)))
	)
      ;; create the undo information
      (setq buffer-undo-list (cons (cons eol (point)) buffer-undo-list)))
    ) ; end-of-let
  ;; put the point in the lowest line and return
  (next-line arg))
(global-unset-key (kbd "C-c d"))
(global-set-key (kbd "C-c d") 'prsv/duplicate-line)

;; use C-c u to insert an emoji or a Unicode character
(global-unset-key (kbd "C-c u"))
(global-set-key (kbd "C-c u") 'insert-char)

;; alt + cursor keys to move line/region around the buffer
(use-package move-text
  :ensure t
  :init
  (move-text-default-bindings))

;; indent lines after moving them
(defun prsv/indent-region-advice (&rest ignored)
  (let ((deactivate deactivate-mark))
    (if (region-active-p)
        (indent-region (region-beginning) (region-end))
      (indent-region (line-beginning-position) (line-end-position)))
    (setq deactivate-mark deactivate)))

(advice-add 'move-text-up :after 'prsv/indent-region-advice)
(advice-add 'move-text-down :after 'prsv/indent-region-advice)


(defun prsv/smarter-ctrl-a (arg)
  "Move point back to the first non-whitespace character of the current line.

     Move point to the first non-whitespace character on this line.
     If point is already there, move to the beginning of the line.
     Effectively toggle between the first non-whitespace character and
     the beginning of the line.

     If ARG is not nil or 1, move forward ARG - 1 lines first. If point
     reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))
  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to `prsv/smarter-ctrl-a'
(global-set-key [remap move-beginning-of-line] 'prsv/smarter-ctrl-a)

(defun prsv/kill-line-backwards ()
  "Kill line backwards.

    This function kills the line backwards up to and including the first non-whitespace character
    (i.e. preserving indentation). If there are no non-whitespace characters between the point and
    the beginning of the line, it kills all characters between the point and the beginning of the line."
  (interactive)
  (let ((orig-point (point)))
    (back-to-indentation)
    (if (= orig-point (point))
        (kill-line 0)
      (kill-region orig-point (point))))
  )

;; Use Ctrl+Shift+k to kill line backwards
(global-unset-key (kbd "C-S-k"))
(global-set-key (kbd "C-S-k") 'prsv/kill-line-backwards)

;; press C-= to quickly select text (expand by word or expression)
(use-package expand-region
  :ensure t
  :bind (("C-=" . er/expand-region)))

(defun prsv/create-parent-directory ()
  "Create the parent directory of the current file if necessary."
  (when-let* ((filename buffer-file-name)
              (directory (file-name-directory filename)))
    (unless (file-directory-p directory)
      (make-directory directory t))))

;; Create parent directory when saving a file
(add-hook 'before-save-hook
          #'prsv/create-parent-directory)

;; functions to find and delete surrounding pairs (brackets, braces, quotes, etc.)
(defun prsv/delete-surround-at-point--find-brackets (pos)
  "Return a pair of buffer positions for the opening & closing bracket positions,
or nil when nothing is found."
  (save-excursion
    (goto-char pos)
    (when
        (or
         ;; Check if we're on the opening brace.
         (when
             ;; Note that the following check for opening brace
             ;; can be skipped, however it can cause the entire buffer
             ;; to be scanned for an opening brace causing noticeable lag.
             (and
              ;; Opening brace.
              (eq (syntax-class (syntax-after pos)) 4)
              ;; Not escaped.
              (= (logand (skip-syntax-backward "/\\") 1) 0))
           (forward-char 1)
           (if (and (ignore-errors (backward-up-list 1) t) (eq (point) pos))
               t
             ;; Restore location and fall through to the next check.
             (goto-char pos)
             nil))
         ;; Check if we're on the closing or final brace.
         (ignore-errors (backward-up-list 1) t))

      ;; Upon success, return the pair as a list.
      (list (point)
            (progn
              (forward-list)
              (1- (point)))))))

(defun prsv/delete-surround-at-point ()
  "Delete the surrounding pair at point."
  (interactive)
  (let ((range (prsv/delete-surround-at-point--find-brackets (point))))
    (unless range
      (user-error "No surrounding pair"))
    (pcase-let ((`(,beg ,end) range))
      ;; For user message.
      (let ((lines (count-lines beg end))
            (beg-char (char-after beg))
            (end-char (char-after end)))

        (save-excursion
          (goto-char end)
          (delete-char 1)
          (goto-char beg)
          (delete-char 1))
        (message
         "Delete surrounding \"%c%c\"%s" beg-char end-char
         (if (> lines 1)
             (format " across %d lines" lines)
           ""))))))

;; use C-c k to kill surrounding brackets, braces, parentheses, quotation marks etc.
(global-set-key (kbd "C-c k") 'prsv/delete-surround-at-point)

;; Backups and undo
; save all backup files in one folder
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

; save lots of backups to enable recovery at a later date if necessary
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; don't create lock files
(setq create-lockfiles nil)

(use-package undo-tree
  :ensure t
  :diminish undo-tree-mode
  :init
  (global-undo-tree-mode)
  :custom
  (undo-tree-visualizer-diff t)
  ;; save undo-tree files to the Emacs user directory
  (undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  (undo-tree-visualizer-timestamps t))

;; multiple cursors

(use-package multiple-cursors
  :ensure t
  :bind (("C-c C-n" . mc/mark-next-like-this)
         ("C-c C-p" . mc/mark-previous-like-this)
         ("C-c C-a" . mc/mark-all-like-this)
         ("C-S-c C-S-c". mc/edit-lines)))

;;; editor-conf.el ends here
