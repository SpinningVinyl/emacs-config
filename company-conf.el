;; -*- coding: utf-8; lexical-binding: t; -*-

(use-package company
  :ensure t)

(defun prsv/text-mode-company-hook ()
  (setq-local company-backends
	      '((company-dabbrev company-ispell :separate) company-files))
  )

(defun prsv/prog-mode-company-hook ()
  (setq-local company-backends
	      '((company-capf company-files company-dabbrev-code)))
  )

;; allow case-insensitive suggestions without
;; overwriting existing capitalization
(setq company-dabbrev-ignore-case 'keep-prefix
      company-dabbrev-downcase nil)

(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'text-mode-hook #'prsv/text-mode-company-hook)
(add-hook 'prog-mode-hook #'prsv/prog-mode-company-hook)

;; don't spawn pop-ups in the mini-buffer
(with-eval-after-load 'company
  (setq company-global-minibuffer nil))

;;; company-conf.el ends here
