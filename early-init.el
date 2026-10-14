;; -*- lexical-binding: t -*-

(setq lexical-binding t)

;; speed up initialization
(setq gc-cons-threshold (* 100 1024 1024))

;; reduce GC threshold after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold
                  (* 16 1024 1024))))

;; display startup time
(defun prsv/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))
(add-hook 'emacs-startup-hook #'prsv/display-startup-time)

(setq package-enable-at-startup nil)

;; suppress lexical binding warnings globally
;; until openSUSE fixes their site-lisp packages
(add-to-list 'warning-inhibit-types '(files missing-lexbind-cookie))
(load "site-start" t)

(provide 'early-init)
;;; early-init.el ends here
