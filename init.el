(set-language-environment "UTF-8")
;; (setq use-package-compute-statistics t)
;; (setq native-comp-async-report-warnings-errors 'silent)

;;;;; autosaves ;;;;;

(setq temporary-file-directory "/home/trd/sync/autosave/"
      org-preview-latex-image-directory "/home/trd/sync/autosave/ltximg/"
      trd-babel-temp-dir "/home/trd/sync/autosave/babel-temp/"
      project-list-file "/home/trd/sync/autosave/projects"
      bookmark-default-file "/home/trd/sync/autosave/bookmarks"
	  org-attach-id-dir "/home/trd/sync/autosave/org-attach/"
      
      bookmark-save-flag 0
      custom-file "/dev/null"
      auto-save-list-file-prefix nil
      auto-save-file-name-transforms `((".*" "/home/trd/sync/autosave/backups/" t)) ; #autosave#
      backup-directory-alist `(("." . "/home/trd/sync/autosave/backups/")) ; backup~
      create-lockfiles nil) ; .#lockfile

;;;;; package management ;;;;;

(require 'package)
(setq package-quickstart t)
;; (setq package-install-upgrade-built-in t)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
						 ("org" . "https://orgmode.org/elpa/")
						 ("nongnu" . "https://elpa.nongnu.org/nongnu/")
						 ("elpa" . "https://elpa.gnu.org/packages/")))

(require 'use-package)
(require 'use-package-ensure)
(setq use-package-always-defer t)
;; (setq use-package-always-ensure t)

;; (use-package auto-package-update
;;   :config
;;   (setq auto-package-update-interval 7
;; 		auto-package-update-delete-old-versions t))
;; (auto-package-update-maybe)

;;;;; meow ;;;;;

(defun trd--meow-setup ()
  "Run Meow setup."
  (push '(eat-mode . insert) meow-mode-state-list)
  
  (meow-normal-define-key '("0" . meow-expand-0)
						  '("9" . meow-expand-9)
						  '("8" . meow-expand-8)
						  '("7" . meow-expand-7)
						  '("6" . meow-expand-6)
						  '("5" . meow-expand-5)
						  '("4" . meow-expand-4)
						  '("3" . meow-expand-3)
						  '("2" . meow-expand-2)
						  '("1" . meow-expand-1)
						  '(";" . meow-reverse)
						  '("," . meow-inner-of-thing)
						  '("." . meow-bounds-of-thing)
						  '("[" . meow-beginning-of-thing)
						  '("]" . meow-end-of-thing)
						  '("a" . meow-append)
						  '("A" . meow-open-below)
						  '("b" . meow-back-word)
						  '("B" . meow-back-symbol)
						  '("c" . meow-change)
						  '("d" . meow-delete)
						  '("D" . meow-backward-delete)
						  '("e" . meow-next-word)
						  '("E" . meow-next-symbol)
						  '("f" . meow-find)
						  '("F" . meow-find-expand)
						  '("g" . meow-cancel-selection)
						  '("G" . meow-grab)
						  '("h" . meow-left)
						  '("H" . meow-left-expand)
						  '("i" . meow-insert)
						  '("I" . meow-open-above)
						  '("j" . meow-next)
						  '("J" . meow-next-expand)
						  '("k" . meow-prev)
						  '("K" . meow-prev-expand)
						  '("l" . meow-right)
						  '("L" . meow-right-expand)
						  '("m" . meow-join)
						  '("n" . meow-search)
						  '("o" . meow-block)
						  '("O" . meow-to-block)
						  '("p" . meow-yank)
						  '("r" . meow-replace)
						  '("R" . meow-swap-grab)
						  '("s" . meow-kill)
						  '("t" . meow-till)
						  '("T" . meow-till-expand)
						  '("v" . meow-visit)
						  '("w" . meow-mark-word)
						  '("W" . meow-mark-symbol)
						  '("x" . meow-line)
						  '("X" . meow-goto-line)
						  '("y" . meow-save)
						  '("Y" . meow-sync-grab)
						  '("z" . meow-pop-selection)
						  '("<escape>" . ignore)
						  '("u" . undo-fu-only-undo)
						  '("U" . undo-fu-only-redo)
						  ;; '("'" . next-buffer)
						  '("#" . other-window)
						  '("/" . (lambda () (interactive) (switch-to-buffer (other-buffer))))))

(use-package meow
  :demand t

  :config
  (trd--meow-setup)
  (setq meow-use-clipboard t
		meow-cursor-type-normal '(bar . 2)
		meow-cursor-type-default '(bar . 2)
		meow-expand-exclude-mode-list (remq 'org-mode meow-expand-exclude-mode-list))
  (push '(compilation-mode . normal) meow-mode-state-list)
		
  :custom-face
  (meow-normal-cursor ((t (:background "RoyalBlue" :inherit unspecified))))
  (meow-insert-cursor ((t (:background "OrangeRed" :inherit unspecified)))))

(meow-global-mode)

;;;;; org ;;;;;

(use-package org-superstar
  :init
  (setq org-superstar-leading-bullet ?\s
		org-superstar-prettify-item-bullets nil))

(defun trd--select-babel-error ()
  "If the org babel error output buffer exists, select it."
  (when-let ((error-win (get-buffer-window org-babel-error-buffer-name)))
	(select-window error-win)))

(defun trd-del-char-wspace ()
  "Delete up to 4 preceding whitespace chars, or one other char."
  (interactive)
  (backward-delete-char (cond ((looking-back "    ") 4)
							  ((looking-back "   ") 3)
							  ((looking-back "  ") 2)
							  (1))))

(defun trd-org-ctab ()
  "Decrease indent."
  (interactive)
  (save-excursion (back-to-indentation)
				  (when (char-equal (char-before) ?\s)
					(call-interactively #'trd-del-char-wspace))))

(defun trd-org-tab ()
  "Increase indent outside org stuff."
  (interactive)
  (save-excursion (beginning-of-line)
				  (insert-before-markers "    "))
  t) ;; return t so org-cycle quits

(defun trd-prev-src-block-header ()
  "Jump to previous block header."
  (interactive)
  (if (or (not (org-in-src-block-p))
		  (org-at-block-p)
		  ;; handle case where point immediately below block
		  (save-excursion (previous-line)
						  (beginning-of-line)
						  (looking-at (rx (| "#+begin_src" "#+end_src")))))
	  (org-babel-previous-src-block)
	(org-babel-goto-src-block-head)))

;; (defvar org-electric-pairs '((?/ . ?/)
;; 							 (?= . ?=)
;; 							 (?~ . ?~)
;; 							 (?* . ?*)
;; 							 (?_ . ?_)
;; 							 (?+ . ?+))
;;   "Electric pairs for org-mode.")

;; (defun org-add-electric-pairs ()
;;   "Register org-mode pairings with electric-pair-mode."
;;   (setq-local electric-pair-pairs (append electric-pair-pairs org-electric-pairs)))

(use-package org
  :init
  (setq org-startup-folded 'content
		org-modules nil)
  ;; (setq org-startup-with-inline-images t)
  
  (unless (file-exists-p trd-babel-temp-dir)
	(make-directory trd-babel-temp-dir))
  (setq org-babel-temporary-directory trd-babel-temp-dir
		org-confirm-babel-evaluate nil)
  
  :config
  (when-let ((old-img-list (directory-files org-preview-latex-image-directory t "^[^.]" t)))
	(mapc #'delete-file old-img-list))
  
  ;; https://orgmode.org/worg/org-contrib/babel/languages/index.html
  (org-babel-do-load-languages 'org-babel-load-languages
							   '((C . t)
								 (nix . t)
								 (java . t)
								 (shell . t)
								 (python . t)
								 (emacs-lisp . t)))
  
  (setq org-hide-leading-stars t
		org-list-indent-offset 2
		org-hide-block-startup t
		org-pretty-entities t
		org-preview-latex-default-process 'dvisvgm
		org-format-latex-options (plist-put org-format-latex-options :scale 3.0)
		org-format-latex-options (plist-put org-format-latex-options :foreground 'default))

  (push #'trd-org-tab org-tab-before-tab-emulation-hook)

  :bind
  (:map org-mode-map
		("C-c C-'" . org-edit-special)
		("M-p" . trd-prev-src-block-header)
		("M-n" . org-babel-next-src-block)
		("<return>" . org-return-and-maybe-indent)
		("C-<tab>" . trd-org-ctab))

  :hook
  (org-mode . (lambda () (electric-indent-local-mode -1)))
  (org-mode . (lambda () (setq-local indent-line-function #'indent-relative
									 indent-region-function #'ignore)))
  ;; (org-mode . org-add-electric-pairs)
  (org-mode . org-superstar-mode)
  (org-mode . org-indent-mode)
  (org-babel-after-execute . trd--select-babel-error))

;;;;; other packages ;;;;;

(use-package undo-fu
  :config
  (setq undo-fu-keyboard-quit nil))

(use-package which-key)
(which-key-mode 1)

(use-package eat
  :config
  (setq eat-enable-shell-prompt-annotation nil
		eat-enable-mouse nil
		eat-kill-buffer-on-exit t)
  
  :bind*
  (:map eat-semi-char-mode-map
		("<escape>" . eat-self-input)
		("C-u" . eat-self-input))
  
  (:map eat-mode-map
		("<escape>" . eat-self-input)
		("C-u" . eat-self-input)))

(use-package vertico
  :init
  (vertico-mode 1)
  (setq vertico-cycle t)

  :bind
  (:map vertico-map
		("<return>" . vertico-directory-enter)
		("<backspace>" . vertico-directory-delete-char)
		("M-<backspace>" . vertico-directory-delete-word))

  :hook
  (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package orderless
  :demand t
  :config
  (setq completion-styles '(orderless basic)
		completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package helpful
  :bind
  (:map global-map
		("C-h f" . helpful-callable)
		("C-h C-f" . helpful-callable)
		("C-h v" . helpful-variable)
		("C-h k" . helpful-key)
		("C-c C-d" . helpful-at-point))

  (:map helpful-mode-map
		("Q" . helpful-kill-buffers)))

(use-package doom-modeline
  :init
  (doom-modeline-mode 1)
  
  :config
  (setq-default header-line-format mode-line-format
				mode-line-format nil))

(use-package doom-themes)

;; (load-theme 'doom-dracula t)
(load-theme 'doom-one-light t)

(defun trd-toggle-theme ()
  "Toggle light/dark theme."
  (interactive)
  (let ((theme (car custom-enabled-themes)))
	(disable-theme theme)
	(load-theme (pcase theme
				  ('doom-dracula 'doom-one-light)
				  (_ 'doom-dracula))))
  (meow-update-display))

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package eglot
  :hook
  (c++-mode . eglot-ensure))

(use-package nix-mode
  :mode (rx ".nix" eos))

(use-package ob-nix)

(use-package company
  :init
  (setq company-show-quick-access t)
  ;; (setq company-global-modes '(c++-mode))
  
  :bind
  (:map company-active-map
		("<return>" . nil)
		("<tab>" . company-complete-selection))
  
  :hook
  (after-init . global-company-mode))

;; (use-package embark
;;   :bind
;;   (("C-." . embark-act)
;;    ("C-;" . embark-dwim)
;;    ("C-h B" . embark-bindings)))

;;;;; ui ;;;;;

(set-face-attribute 'default nil :font "Iosevka Light Extended" :height 120)

(tooltip-mode -1)
(blink-cursor-mode -1)
(global-display-line-numbers-mode -1)
(global-hl-line-mode 1)
(global-auto-revert-mode 1)
(global-visual-line-mode 1)

(electric-pair-mode 1)
;; (define-key key-translation-map (kbd "9") (kbd "("))
;; (define-key key-translation-map (kbd "0") (kbd ")"))
;; (define-key key-translation-map (kbd "(") (kbd "9"))
;; (define-key key-translation-map (kbd ")") (kbd "0"))

(setq initial-buffer-choice "/home/trd/sync/org/organise/priorities.org"
	  initial-major-mode #'fundamental-mode
	  initial-scratch-message nil
      inhibit-startup-message t
	  
      use-dialog-box nil
      custom-safe-themes t
      help-window-select t
      use-short-answers t
	  bookmark-set-fringe-mark nil
	  disabled-command-function nil
      mark-even-if-inactive nil
	  
      c-default-style "linux"
      c-basic-offset 4

	  next-screen-context-lines 5
	  scroll-conservatively 101
	  scroll-preserve-screen-position t

	  vc-follow-symlinks t
      isearch-repeat-on-direction-change t
      sentence-end-double-space nil
	  display-line-numbers-width-start t
	  fringe-mode 1
      global-auto-revert-non-file-buffers t
      confirm-kill-processes nil
      highlight-nonselected-windows t
      kill-buffer-query-functions nil)

;; nb suppressing message requires dedicated setq as below
(setq inhibit-startup-echo-area-message
	  "trd")

;; https://dougie.io/emacs/indentation/
(setq-default electric-indent-inhibit t
			  tab-width 4)

(push (cons (rx "meson.build" eos) 'text-mode) auto-mode-alist)

;;;;; global bindings ;;;;;

(dolist (binding '(("<escape>" . keyboard-escape-quit)
				   ("C-x 2" . (lambda () (interactive) (select-window (split-window-below))))
				   ("C-x 3" . (lambda () (interactive) (select-window (split-window-right))))
				   ("C-x C-o" . other-window)
				   ("C-x C-0" . delete-window)
				   ("C-x f" . find-file)
				   ("C-x C-j" . bookmark-jump)
				   ("C-x C-b" . switch-to-buffer)
				   ("C-x C-k" . kill-buffer)
				   ("`" . push-mark-command)
				   ("¬" . pop-to-mark-command)
				   ("<backspace>" . trd-del-char-wspace)
				   ("C-z" . meow-global-mode)
				   ("<f5>" . eat)
				   ("<f6>" . trd-toggle-theme)
				   ("<f7>" . display-line-numbers-mode)
				   ("<f8>" . (lambda () (interactive) (find-file initial-buffer-choice)))
				   ("<f9>" . (lambda () (interactive) (find-file user-init-file)))))
  (global-set-key
   (kbd (car binding))
   (cdr binding)))

(message (emacs-init-time))
