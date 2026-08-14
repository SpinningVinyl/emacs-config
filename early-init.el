;; -*- lexical-binding: t -*-

(setq lexical-binding t)

(setq gc-cons-threshold (* 100 1024 1024)) 

;; display startup time
(defun prsv/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))
(add-hook 'emacs-startup-hook #'prsv/display-startup-time)

(setq package-enable-at-startup nil)


(provide 'early-init)
;;; early-init.el ends here
