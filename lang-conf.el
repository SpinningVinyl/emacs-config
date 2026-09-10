;; -*- coding: utf-8; lexical-binding: t; -*-
(use-package go-mode)

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

(with-eval-after-load 'makefile-gmake-mode
 (add-hook 'makefile-mode-hook
  (lambda ()
    (setq indent-tabs-mode t)
    (setq-default indent-tabs-mode t)
    (setq tab-width 4)))
(add-hook 'makefile-gmake-mode-hook
  (lambda ()
    (setq indent-tabs-mode t)
    (setq-default indent-tabs-mode t)
    (setq tab-width 4)))
; Convert hard tabs to spaces on save
(add-hook 'before-save-hook
  (lambda ()
    ; But not Makefiles
    (if (member major-mode '(makefile-mode makefile-gmake-mode))
      (tabify (point-min) (point-max))
      (untabify (point-min) (point-max))))))

;; format go files on save
(with-eval-after-load 'go-mode
      (add-hook 'go-mode-hook
                (lambda()
                  (add-hook 'before-save-hook #'gofmt-before-save))))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((js-mode js-ts-mode rjsx-mode typescript-mode tsx-ts-mode)
                 . ("tsc" "--lsp" "--stdio"))))


;;; eglot-conf.el ends here
