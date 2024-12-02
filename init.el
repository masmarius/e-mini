;; -*- coding: utf-8; lexical-binding: t; -*-

(setopt load-prefer-newer t)

;; initial frame and default window

(add-to-list 'default-frame-alist '(height . 45)) ;initial frame size
(add-to-list 'default-frame-alist '(width . 160))
(push '(background-color . "ivory2") default-frame-alist) ;light bg color

(tooltip-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setopt frame-resize-pixelwise t
            frame-inhibit-implied-resize t
            frame-title-format '("%F--%b-[%f]--%Z")
            ring-bell-function 'ignore
            use-dialog-box t ; only for mouse events, which I seldom use
            use-short-answers t
            inhibit-splash-screen t
            inhibit-startup-screen t
            inhibit-x-resources t
            inhibit-startup-echo-area-message user-login-name ; read the docstring
            inhibit-startup-buffer-menu nil)

;; git-scoop setup for windows
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
(cond ((find-font (font-spec :name "JetBrainsMono NFP"))
       (set-face-attribute 'default nil :family "JetBrainsMono NFP" :height 100))
      ((find-font (font-spec :name "Consolas"))
       (set-face-attribute 'default nil :family "Consolas" :height 110)))


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
  (dired-mode . auto-revert-mode)
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
          ring-bell-function 'ignore
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
          echo-keystrokes 0.01
          x-stretch-cursor t
          help-window-select t 
          ;; win management
          split-width-threshold 120
          split-height-threshold nil
          ;; dired
          global-auto-revert-non-file-buffers t
          dired-dwim-target t
          dired-recursive-copies 'top   ;allow copy dir with subdirs
          dired-recursive-deletes 'top
          dired-kill-when-opening-new-dired-buffer t
          dired-listing-switches "-alh"
          ls-lisp-dirs-first t
          ls-lisp-ignore-case t         ;ignore case order
          ;; ido completion
          max-mini-window-height 0.5
          ; ido-separator "\n"
          ido-enable-flex-matching t
          completion-styles '(flex)
          ido-everywhere t
          ido-enable-last-directory-history t
          ido-max-work-directory-list 30
          ido-max-work-file-list 50
          ido-max-prospects 8
          ;; Display ido results vertically, rather than horizontally
          ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]"))
          ;ido-confirm-unique-completion t
          ido-create-new-buffer 'always
          ido-use-virtual-buffers t
          ;; mouse
          scroll-step 1
          ;; Marker distance from center (don't jump to center).
          scroll-conservatively 100000
          ;; Try to keep screen position when PgDn/PgUp.
          scroll-preserve-screen-position 1
          ;; Start scrolling when marker at top/bottom.
          scroll-margin 0
          ;; Mouse scroll moves 1 line at a time, instead of 5 lines.
          mouse-wheel-scroll-amount '(1)
          ;; On a long mouse scroll keep scrolling by 1 line.
          mouse-wheel-progressive-speed nil
          auto-window-vscroll nil
          ;; editing related
          indent-tabs-mode nil
          electric-indent-mode 1
          electric-pair-mode 1
          save-place-mode t             ;remember cursor position
          delete-selection-mode t
          default-directory "~/File"
          shift-select-mode nil
          set-mark-command-repeat-pop t ;repeated C-u set-mark-command move cursor to previous mark in current buffer
          mark-ring-max 10
          global-mark-ring-max 10)
  (ido-mode 1)
  (winner-mode t)
  (global-hl-line-mode 1)
  :bind
  ("C-c c" . org-capture)
  ("C-c l" . org-store-link)
  ("M-<SPC>" . hippie-expand)
  
  ("<capslock> o" . other-frame)      ;frames
  ("<capslock> n" . make-frame)
  
  ("C-<tab>" . ido-switch-buffer)       ;buffers
  ("<capslock> k" . ido-kill-buffer)
  ("M-<tab>" . next-buffer)
  
  ("<capslock> 1" . delete-other-windows) ;windows
  ("<capslock> 2" . split-window-below)
  ("<capslock> 3" . split-window-right))

(use-package windmove
  :config 
  (windmove-default-keybindings))

(use-package framemove   ;included locally in lisp dir
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
  :config
  (setopt org-startup-indented t
          org-startup-folded t
          org-level-color-stars-only t
          org-hide-emphasis-markers t
          org-outline-path-complete-in-steps nil)) ;for ido completion (?)

(use-package magit
  :ensure t
  :defer t)

(use-package org-web-tools
  :ensure t
  :bind
  (("C-c w w" . org-web-tools-insert-link-for-url)))
