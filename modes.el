;; -*- coding: utf-8; lexical-binding: t; -*-

;; used for centering text in the window
(use-package visual-fill-column
  :ensure t)

(defun prsv/markdown-mode-hook ()
  (prsv/disable-line-numbers-hook)
  (visual-line-mode 1)
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t
	visual-fill-column-enable-sensible-window-split t)
  (visual-fill-column-mode 1)
  )

(use-package markdown-mode
  :hook (markdown-mode . prsv/markdown-mode-hook))

;;; modes.el ends here
