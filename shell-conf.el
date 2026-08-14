;; -*- coding: utf-8; lexical-binding: t; -*-

(require 'cl-lib) ; required for cl-reduce

;;;;;;;;;;;;;;;; ghostel configuration

(use-package ghostel
  :bind (("C-x m" . ghostel)
         :map ghostel-semi-char-mode-map
         ("C-k"  . prsv/ghostel-send-C-k-and-kill)
         ;; I'm used to go up/down the shell history with M-n/p from eshell
         ;; Simulate this behavior in ghostel by sending C-p and C-n
         ("M-p" . (lambda () (interactive) (ghostel-send-key "p" "ctrl")))
         ("M-n" . (lambda () (interactive) (ghostel-send-key "n" "ctrl")))
         :map project-prefix-map
         ("m" . ghostel-project)
         ("M" . ghostel-project-list-buffers))
  :config
  (defun prsv/ghostel-send-C-k-and-kill ()
    "Send `C-k' to ghostel.
Like normal Emacs `C-k'.  Kill to end of line and put content in kill-ring."
    (interactive)
    (kill-ring-save (point) (line-end-position))
    (ghostel-send-key "k" "ctrl"))
)

;;;;;;;;;;;;;;;; eshell coniguration

;; eshell aliases
(setq prsv/eshell-aliases
      '((g . magit)
	(gl . magit-log)
	(gg . magit-status)
	(d . dired)
	(o . find-file)	
	(oo . find-file-other-window)
	(ll . (lambda () (eshell/ls '-la)))
	(eshell/clear . eshell/clear-scrollback)))
  
 (mapc (lambda (alias)
	(defalias (car alias) (cdr alias)))
       prsv/eshell-aliases)

(defun prsv/shortened-path (path max-len)
  "Return a potentially shortened version of the directory PATH, replacing
   parent directories with their initial characters to try to get the character
   length of PATH (sans directory slashes) down to MAX-LEN."
  (let* ((components (split-string (abbreviate-file-name path) "/"))
         (len (+ (1- (length components))
                 (cl-reduce '+ components :key 'length)))
         (str ""))
    (while (and (> len max-len)
                (cdr components))
      (setq str (concat str
                        (cond ((= 0 (length (car components))) "/")
                              ((= 1 (length (car components)))
                               (concat (car components) "/"))
                              (t
                               (if (string= "."
                                            (string (elt (car components) 0)))
                                   (concat (substring (car components) 0 2)
                                           "/")
                                 (string (elt (car components) 0) ?/)))))
            len (- len (1- (length (car components))))
            components (cdr components)))
    (concat str (cl-reduce (lambda (a b) (concat a "/" b)) components))))

(defun prsv/eshell-prompt ()
  (concat (prsv/shortened-path (eshell/pwd) 40)
	  (if (= (user-uid) 0) " # " " λ ")))

(setq eshell-prompt-function 'prsv/eshell-prompt)
(setq eshell-prompt-regexp "^.* [#λ] ")

;;; shell-conf.el ends here
