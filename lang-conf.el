;; -*- coding: utf-8; lexical-binding: t; -*-
(use-package go-mode)

;; use built-in versions of eglot and flymake
(use-package eglot
  :disabled)
(use-package flymake
  :disabled)

(add-to-list 'auto-mode-alist '("\\.mjs\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.js.tmpl\\'" . js-mode))

(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'python-mode-hook 'eglot-ensure)
(add-hook 'sh-mode-hook 'eglot-ensure)
(add-hook 'js-mode-hook 'eglot-ensure)
(add-hook 'go-mode-hook 'eglot-ensure)

;; format go files on save
(with-eval-after-load 'go-mode
      (add-hook 'go-mode-hook
                (lambda()
                  (add-hook 'before-save-hook #'gofmt-before-save))))

;;; eglot-conf.el ends here
