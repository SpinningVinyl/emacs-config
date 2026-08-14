;; -*- coding: utf-8; lexical-binding: t; -*-

; use recentf to provide the list of recent files to helm
(use-package recentf
  :config
  (add-to-list 'recentf-exclude "\\elpa")
  (add-to-list 'recentf-exclude "private/tmp")
  (setq-default recent-save-file "~/.emacs.d/recentf")
  :init
  (recentf-mode 1))

;; install helm
(use-package helm)
(global-unset-key (kbd "C-x C-f"))
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-unset-key (kbd "C-x b"))
(global-set-key (kbd "C-x b") 'helm-mini)
(global-unset-key (kbd "M-x"))
(global-set-key (kbd "M-x") 'helm-M-x)
(global-unset-key (kbd "M-y"))
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(setq completion-styles '(flex))

;; enable helm
(helm-mode 1)
;; make sure that helm does not take all available space in the frame
(helm-autoresize-mode 1)
(setq
      ;; open helm buffer inside the current window, do not occupy the whole frame
      helm-split-window-in-side-p           t
      ;; cycle through completions
      helm-move-to-line-cycle-in-source     t
      ;; search for library in `require' and `declare-function' sexp.
      helm-ff-search-library-in-sexp        t
      ; scroll the other window 8 lines using M-<next>/M-<prior>
      helm-scroll-amount                    8
      ;; use recentf to provide file history
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

; rebind TAB to persistent action
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
; make TAB work in terminal sessions
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

;; improved help
(use-package helpful)
(global-set-key (kbd "C-h f") #'helpful-callable)
(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)
(global-set-key (kbd "C-h x") #'helpful-command)


;;; completions-conf.el ends here
