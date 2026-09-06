;; -*- coding: utf-8; lexical-binding: t -*-

;; General UI settings
(setq
 inhibit-startup-screen t ;; disable the splash
 save-interprogram-paste-before-kill t ;; save clipboard
 use-dialog-box nil ;; use the echo area instead
 use-short-answers t ;; use y-or-n instead of yes-or-no
 visible-bell t ;; silence, bitch!
 native-comp-async-report-warnings-errors 'silent ;; not much I can do if native-comp barfs
 warning-minimum-level :error) ;; please don't pester me with warnings

(tool-bar-mode -1) ;; disable the toolbar
(scroll-bar-mode -1) ;; and the scrollbar
(tooltip-mode -1) ;; and the tooltips
(unless (display-graphic-p) (menu-bar-mode -1)) ; disable menus in the text console

;; default frame size
(add-to-list 'default-frame-alist '(height . 40))
(add-to-list 'default-frame-alist '(width . 124))

;; maximize window when starting Emacs
;; (add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; define font size
(defvar prsv/default-font-size 110)
(defvar prsv/variable-pitch-font-size 120)

;; set default font
(set-face-attribute 'default nil :font "IBM Plex Mono" :height prsv/default-font-size)
;; set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "IBM Plex Mono" :height prsv/default-font-size)
(set-face-attribute 'variable-pitch nil :font "IBM Plex Sans" :height prsv/variable-pitch-font-size :weight 'regular)

;; use color emojis (requires Cairo and harfbuzz)
(set-fontset-font
 t 'emoji (font-spec :family "Noto Color Emoji") nil 'prepend)

;; Use C-c + cursor keys to move between windows
(use-package windmove
  :ensure nil
  :defer t
  :config
  (setq windmove-create-window nil)     ; Emacs 27.1 or later
  :bind (("C-c <up>" . windmove-up)
         ("C-c <right>" . windmove-right)
         ("C-c <down>" . windmove-down)
         ("C-c <left>" . windmove-left)))

;; Use C-c s to swap the contents of two windows
;; (the selected one and the window next to it)
(global-unset-key (kbd "C-c s"))
(global-set-key (kbd "C-c s") 'window-swap-states)

;; which-key shows contextual help for the current prefix
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.5))

;; make it a bit more obvious which window is currently active
(use-package dimmer
  :ensure t
  :init
  (dimmer-configure-which-key)
  (dimmer-configure-helm)
  (setq dimmer-fraction 0.2)
  (dimmer-mode 1)
  )

;; improved search
(use-package ctrlf
  :ensure t
  :init
  (ctrlf-mode +1))

;; hide minor modes from the modeline
(use-package minions
  :config
  (setq minions-mode-line-lighter ";")
  ;; NOTE: This will be expanded whenever I find a mode that should not
  ;; be hidden by default
  (setq minions-prominent-modes (list 'defining-kbd-macro
				      'flymake-mode
				      'company-mode
				      'lsp-mode
				      'lsp-modeline-code-actions-mode
				      'overwrite-mode))
  (minions-mode 1))

(use-package eyebrowse
  :ensure t)

(use-package all-the-icons
  :if (display-graphic-p))

;; (use-package modus-themes)
;; (load-theme 'modus-vivendi-tinted :no-confirm)

;; (load-theme 'wombat :no-confirm)
;; (custom-set-faces
;;  '(highlight ((t (:underline nil)))))

(use-package modus-nordic-night-theme
  :straight (modus-nordic-night-theme :type git :host codeberg :repo "ashton314/modus-nordic-night")
  :config
  (load-theme 'modus-nordic-midnight t))

;;; ui-conf.el ends here
