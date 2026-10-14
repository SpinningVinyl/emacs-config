;; -*- coding: utf-8; lexical-binding: t; -*-
(use-package go-mode
  :hook (go-mode . prsv/go-mode-setup))

;; format Go files on save (make it buffer-local)
(defun prsv/go-mode-setup ()
  (add-hook 'before-save-hook
            #'gofmt-before-save
            nil t))

(use-package qml-ts-mode
   :straight (qml-ts-mode :type git :host github :repo "xhcoding/qml-ts-mode"))

;; use built-in versions of eglot and flymake
(use-package eglot
  :disabled)
(use-package flymake
  :disabled)

(add-to-list 'auto-mode-alist '("\\.mjs\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.js.tmpl\\'" . js-mode))
(add-to-list 'auto-mode-alist '("Makefile.*" . makefile-gmake-mode))

(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'python-mode-hook 'eglot-ensure)
(add-hook 'sh-mode-hook 'eglot-ensure)
(add-hook 'js-mode-hook 'eglot-ensure)
(add-hook 'go-mode-hook 'eglot-ensure)


;; unify Tab-related settings
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(add-hook 'makefile-mode-hook
          (lambda ()
            (setq-local indent-tabs-mode t)))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((js-mode js-ts-mode rjsx-mode typescript-mode tsx-ts-mode)
                 . ("tsc" "--lsp" "--stdio"))))

;;; eglot-conf.el ends here
