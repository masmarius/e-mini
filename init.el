;; -*- coding: utf-8; lexical-binding: t; -*-

(setopt load-prefer-newer t)

;; initial frame and default window

(add-to-list 'default-frame-alist '(height . 45)) ;initial frame size
(add-to-list 'default-frame-alist '(width . 90))
(push '(background-color . "white smoke") default-frame-alist) ;light bg color

(tooltip-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setopt frame-resize-pixelwise t
            frame-inhibit-implied-resize t
            frame-title-format '("%b")
            ring-bell-function 'ignore
            use-dialog-box t ; only for mouse events, which I seldom use
            use-short-answers t
            inhibit-splash-screen t
            inhibit-startup-screen t
            inhibit-x-resources t
            inhibit-startup-echo-area-message user-login-name ; read the docstring
            inhibit-startup-buffer-menu nil)

;; git-scoop setup
(setq my-git-path
      (concat (getenv "USERPROFILE") "\\scoop\\apps\\Git\\current"))
;; linux-find-fix for windows (depends on git install)
(setq my-git-find-executable
      (concat my-git-path "\\usr\\bin\\find.exe"))
(setq find-program my-git-find-executable)

;; basic keybinding setup
(setopt w32-pass-lwindow-to-system nil
        w32-lwindow-modifier 'super ;left Windows key
        w32-enable-caps-lock nil)
(w32-register-hot-key [M-tab])
(w32-register-hot-key [s-])
(w32-register-hot-key [A-])

;; UTF-8 as default encoding

(set-language-environment "utf-8")
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)

;; font defaults
(set-face-attribute 'default nil :family "Consolas" :height 110)

;; load emacs package system. Add GNU, MELPA repository.
(require 'package)
  (add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Make sure that we dont' clutter the init file
(setopt custom-file (expand-file-name "custom.el" user-emacs-directory))

;; Custom lisp directory
(setopt custom-elisp-dir
      (expand-file-name "lisp" user-emacs-directory))

(add-to-list 'load-path custom-elisp-dir)

(use-package use-package
  :custom
  (use-package-always-ensure t)
  (package-native-compile t)
  (warning-minimum-level :error))

;; emacs server (allow emacsclient to connect to running session)
(use-package server
  :ensure nil
  :defer t
  :config
  (setq server-client-instructions nil)
  (unless (server-running-p)
    (server-start)))

(use-package emacs
  :ensure nil
  :defer t
  :hook
  (prog-mode . display-line-numbers-mode)
  (dired-mode . dired-hide-details-mode)
  :config
  (setopt make-backup-files nil         ;no backups or lockfiles
          create-lockfiles nil
          auto-save-default nil         ;filenames with #hashtags#
          ;; keytabs
          tab-width 4  
          indent-tabs-mode nil
          ;; bookmarks init
          bookmark-save-flag t
          ;; history
          savehist-mode t
          ;; file related
          global-auto-revert-mode t     ;auto refresh
          recentf-mode t                ;recently opened files
          ;; user interface
          line-spacing 2
          fill-column 80
          inhibit-startup-screen t
          column-number-mode t
          blink-cursor-mode 0
          truncate-lines t
          show-paren-mode t
          show-paren-style 'parenthesis
          sentence-end-double-space nil
          use-short-answers t
          ;; win management
          split-width-threshold 120
          split-height-threshold nil
          ;; dired
          dired-dwim-target t
          dired-recursive-copies 'top   ;allow copy dir with subdirs
          dired-recursive-deletes 'top
          dired-kill-when-opening-new-dired-buffer t
          dired-listing-switches "-alh"
          ls-lisp-dirs-first t
          ls-lisp-ignore-case t         ;ignore case order
          ;; mouse
          mouse-wheel-progressive-speed nil
          scroll-conservatively 101
          ;; editing related
          electric-indent-mode 1
          electric-pair-mode 1
          save-place-mode t             ;remember cursor position
          delete-selection-mode t
          default-directory "~/File"
          shift-select-mode nil
          set-mark-command-repeat-pop t ;repeated C-u set-mark-command move cursor to previous mark in current buffer
          mark-ring-max 10
          global-mark-ring-max 10)
  :bind
  ("C-c c" . org-capture)
  ("C-c l" . org-store-link)
  ("M-<SPC>" . hippie-expand)
  
  ("<capslock> 5 o" . other-frame)      ;frames
  ("<capslock> 5 2" . make-frame)
  
  ("C-<tab>" . consult-buffer)       ;buffers
  ("<capslock> k" . ido-kill-buffer)
  ("M-<tab>" . next-buffer)
  
  ("<capslock> 1" . delete-other-windows) ;windows
  ("<capslock> 2" . split-window-below)
  ("<capslock> 3" . split-window-right))

(use-package windmove
  :config 
  (windmove-default-keybindings))

(use-package framemove
  :ensure nil
  :config 
  (framemove-default-keybindings)
  (setopt framemove-hook-into-windmove t))

(use-package text-mode
  :ensure nil
  :hook
  (text-mode . visual-line-mode)
  :custom
  (sentence-end-double-space nil)
  (scroll-error-top-bottom t))

(use-package ediff
  :ensure nil
  :custom
  (ediff-keep-variants nil)
  (ediff-split-window-function 'split-window-horizontally)
  (ediff-window-setup-function 'ediff-setup-windows-plain))

(use-package org
  :ensure nil
  :defer t
  :config
  (setopt org-startup-indented t
          org-startup-folded t
          org-pretty-entities t))

(use-package magit
  :ensure t
  :defer t)

(use-package org-web-tools
  :ensure t
  :bind
  (("C-c w w" . org-web-tools-insert-link-for-url)))

(use-package consult
  :ensure t)

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :custom
  (vertico-sort-function 'vertico-sort-history-alpha))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles partial-completion)))))

;; Enable richer annotations using the Marginalia package

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package visual-fill-column
  :ensure t)
