;; -*- coding: utf-8; lexical-binding: t; -*-

;; bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; install use-package
(straight-use-package 'use-package)
;; Configure use-package to use straight.el by default
(use-package straight
  :custom
  (straight-built-in-pseudo-packages '(emacs nadvice python image-mode project flymake xref))
  (straight-use-package-by-default t))

;; add modern language features to emacs-lisp
;; required by helm-org etc.
(use-package dash)
(use-package f)
(use-package s)

;; make sure that `exec-path' matches the PATH environment variable
;; adopted from ag.el:
;; https://agel.readthedocs.io/en/latest/configuration.html#path-to-the-ag-executable 
(defun prsv/set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match
   that used by the user's shell.
   This is particularly useful under macOS, where GUI apps are not 
   started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
			  "[ \t\n]*$" "" (shell-command-to-string
					  "$SHELL --login -c 'echo $PATH'"
						    ))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

;; on macOS, GUI apps (stupidly) don't inherit the shell's PATH
(when (eq system-type 'darwin)
  (prsv/set-exec-path-from-shell-PATH))

;; start the server to make sure that emacsclient opens files in the same frame
(load "server")
(unless (server-running-p) (server-start))
(setopt multiple-terminals-merge-keyboards nil)

(load "~/.emacs.d/ui-conf.el") ;; general UI configuration
(load "~/.emacs.d/editor-conf.el") ;; settings for actually editing text files
(load "~/.emacs.d/completions-conf.el") ;; helm and stuff
(load "~/.emacs.d/dired-conf.el") ;; Dired configuration
(load "~/.emacs.d/shell-conf.el") ;; eshell settings
(load "~/.emacs.d/lang-conf.el") ;; programming languages and eglot
(load "~/.emacs.d/scheme-conf.el") ;; MIT Scheme settings
(load "~/.emacs.d/company-conf.el") ;; completion with company-mode
(load "~/.emacs.d/modes.el") ;; various modes that are not Org ;)
(load "~/.emacs.d/org-conf.el") ;; the meat and potatoes
(load "~/.emacs.d/hyperbole.el")

;; don't allow Custom to put its junk into init.el
(setq custom-file "~/.emacs.d/emacs-custom.el")
(load custom-file)


;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)
