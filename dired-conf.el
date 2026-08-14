;; -*- coding: utf-8; lexical-binding: t; -*-

(use-package dired
  :straight (:type built-in)
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump) ; jump to the currently open file in dired
	 :map dired-mode-map
	 ("C-c o" . 'prsv/dired-open-file))
  :defines (dired-mode-map)
  :config
  (setq wdired-allow-to-change-permissions t)
  (setq wdired-create-parent-directories t)
  (setq dired-dwim-target t)
  (when (string= system-type "darwin")
    (setq insert-directory-program "/usr/local/bin/gls"))
  :custom ((dired-listing-switches "-agho --group-directories-first")))

;; use file icons in dired
(use-package all-the-icons-dired
  :if (display-graphic-p)
  :hook (dired-mode . all-the-icons-dired-mode))

;; colorize dired output
(use-package diredfl
  :ensure t
  :hook (dired-mode . diredfl-mode))

;; use `a' to open directories and files in the same buffer
(put 'dired-find-alternate-file 'disabled nil)

;; use `^' to open the parent directory in the same buffer 
(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map (kbd "^")
                        (lambda () (interactive) (find-alternate-file "..")))))

;; refresh dired buffers automatically (and silently)
(defun prsv/quiet-auto-revert ()
  "A hook to run for buffers you want to revert automatically and silently."
  (auto-revert-mode 1)
  (setq-local auto-revert-verbose nil))
(add-hook 'dired-mode-hook #'prsv/quiet-auto-revert t nil)

;; open files from dired using xdg-open
(defun prsv/dired-open-file ()
  "In dired, open the file named on this line."
  (interactive)
  (let* ((file (dired-get-filename nil t)))
    (call-process "xdg-open" nil 0 nil file)))

;; hide dotfiles in dired (off by default)
(use-package dired-hide-dotfiles
  :after dired
;  :hook (dired-mode . dired-hide-dotfiles-mode)
  :bind (:map dired-mode-map ("C-c ." . 'dired-hide-dotfiles-mode)))


;;; dired-conf.el ends here
