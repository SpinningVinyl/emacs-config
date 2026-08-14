;; -*- coding: utf-8; lexical-binding: t; -*-

(use-package company
  :ensure t)

(defun prsv/text-mode-company-hook ()
  (setq-local company-backends
	      '((company-dabbrev company-ispell :separate) company-files))
  )

(defun prsv/prog-mode-company-hook ()
  (setq-local company-backends
	      '((company-capf company-dabbrev-code company-files)))
  )

(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'text-mode-hook #'prsv/text-mode-company-hook)
(add-hook 'prog-mode-hook #'prsv/prog-mode-company-hook)

;;; company-conf.el ends here
