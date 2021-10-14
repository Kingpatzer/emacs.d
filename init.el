(setq load-prefer-newer noninteractive)

(setq package-enable-at-startup nil)

;;; package --- Summary: -*- lexical-binding: t; -*-

(defvar vterm)
(defvar vterm-always-compile-module)
(defvar auto-package-updat)
(defvar evil-emacs-state-modes)
(defvar undo-tree)
(defvar undo-tree-auto-save-history)
(defvar evil-want-keybindings)
(defvar evil)
(defvar evil-ex-search-vim-style-regexp)
(defvar evil-ex-visual-char-range)
(defvar evil-mode-line-format)
(defvar evil-symbol-word-search)
(defvar evil-default-cursor)
(defvar evil-normal-state-cursor)
(defvar evil-emacs-state-cursor)
(defvar evil-insert-state-cursor)
(defvar evil-visual-state-cursor)
(defvar evil-ex-interactive-search-highlight)
(defvar evil-kbd-macro-suppress-motion-error)
(defvar evil-undo-system)
(defvar evil-collection)
(defvar evil-want-integration)
(defvar evil-snipe)
(defvar evil-magit)
(defvar magit)
(defvar general)
(defvar +my-leader-key-def)
(defvar +my-ctrl-c-keys)
(defvar use-package-chords)
(defvar aggressive-indent)
(defvar aggressive-indent-excluded-modes)
(defvar visual-fill-column)
(defvar all-the-icons)
(defvar doom-modeline)
(defvar modus-themes)
(defvar modus-themes-italic-constructs)
(defvar modus-themes-bold-constructs)
(defvar modus-themes-no-mixed-fonts)
(defvar modus-themes-subtle-line-numbers)
(defvar modus-themes-success-dueteranopia)
(defvar modus-themes-tabs-accented)
(defvar modus-themes-fringes)
(defvar modus-themes-language-checkers)
(defvar modus-themes-mode-line)
(defvar modus-themes-syntax)
(defvar modus-themes-paren-match)
(defvar modus-themes-region)
(defvar modus-themes-org-blocks)
(defvar modus-themes-headings)
(defvar modus-themes-scale-1)
(defvar modus-themes-scale-2)
(defvar modus-themes-scale-3)
(defvar modus-themes-scale-4)
(defvar modus-themes-scale-title)
(defvar modus-themes-scale-small)
(defvar modus-themes-scale-headings)
(defvar modus-themes-variable-pitch-headings)
(defvar org-image-actual-width)

(defconst +my-file-version "1.0.0-beta"
  "Current version of My .init.el.")

(defvar +my-init-p nil
  "Non-nil if emacs has been initialized.")

(defvar +my-init-time nil
  "The time it took, in seconds, for Emacs to initialize.")

(defvar +my-debug-p (or (getenv-internal "DEBUG") init-file-debug)
  "If non-nil, Emacs will log more.
Use `+my-debug-mode' to toggle it. The --debug-init flag and setting the DEBUG
envvar will enable this at startup.")

(defconst +my-interactive-p (not noninteractive)
  "If non-nil, Emacs is in interactive mode.")

(defconst IS-EMACS28+   (> emacs-major-version 27))
(defconst IS-MAC     (eq system-type 'darwin))
(defconst IS-LINUX   (eq system-type 'gnu/linux))
(defconst IS-WINDOWS (memq system-type '(cygwin windows-nt ms-dos)))
(defconst IS-BSD     (or IS-MAC (eq system-type 'berkeley-unix)))

(add-to-list 'load-path (file-name-directory load-file-name))

(dolist (var '(exec-path load-path process-environment))
  (unless (get var 'initial-value)
    (put var 'initial-value (default-value var))))

(when (and IS-WINDOWS (null (getenv-internal "HOME")))
  (setenv "HOME" (getenv "USERPROFILE"))
  (setq abbreviated-home-dir nil))

(set-language-environment "UTF-8")
(unless IS-WINDOWS
  (setq selection-coding-system 'utf-8)) ; with sugar on top

(defconst +my-emacs-dir user-emacs-directory
  "The path to the currently loaded .emacs.d directory. Must end with a slash.")

(defconst +my-core-dir (concat +my-emacs-dir "core/")
  "The root directory of +My's core files. Must end with a slash.")

(defconst +my-modules-dir (concat +my-emacs-dir "modules/")
  "The root directory for Emacs modules. Must end with a slash.")

(defconst +my-local-dir
  (let ((localdir (getenv-internal "+MYLOCALDIR")))
(if localdir
	(expand-file-name (file-name-as-directory localdir))
  (concat +my-emacs-dir ".local/")))
  "Root directory for local storage.
Use this as a storage location for this system's installation of +My Emacs.
These files should not be shared across systems. By default, it is used by
`+my-etc-dir' and `+my-cache-dir'. Must end with a slash.")

(defconst +my-etc-dir (concat +my-local-dir "etc/")
  "Directory for non-volatile local storage.
Use this for files that don't change much, like server binaries, external
dependencies or long-term shared data. Must end with a slash.")

(defconst +my-cache-dir (concat +my-local-dir "cache/")
  "Directory for volatile local storage.
Use this for files that change often, like cache files. Must end with a slash.")

(defconst +my-docs-dir (concat +my-emacs-dir "docs/")
  "Where +My's documentation files are stored. Must end with a slash.")

(defconst +my-private-dir
  (let ((+mydir (getenv-internal "+MYDIR")))
(if +mydir
	(expand-file-name (file-name-as-directory +mydir))
  (or (let ((xdgdir
		 (expand-file-name "~/.config/+my/"
				   (or (getenv-internal "XDG_CONFIG_HOME")
				   "~/.config/+my/"))))
	(if (file-directory-p xdgdir) xdgdir))
	  "~/.config/+my/")))
  "Where your private configuration is placed.
Defaults to ~/.config/+my, ~/.+my.d or the value of the +MYDIR envvar;
whichever is found first. Must end in a slash.")

(defconst +my-autoloads-file
  (concat +my-local-dir "autoloads." emacs-version ".el")
  "Where `+my-reload-core-autoloads' stores its core autoloads.
This file is responsible for informing Emacs where to find all of +My's
autoloaded core functions (in core/autoload/*.el).")

(defconst +my-env-file (concat +my-local-dir "env")
  "The location of your envvar file, generated by `+my env`.
This file contains environment variables scraped from your shell environment,
which is loaded at startup (if it exists). This is helpful if Emacs can't
\(easily) be launched from the correct shell session (particularly for MacOS
users).")

(defconst +my-snippets-dir
  (concat +my-private-dir "snippets")
  "Where yasnippets looks for my private snippets.")

(defvar +my-first-input-hook nil
  "Transient hooks run before the first user input.")
(put '+my-first-input-hook 'permanent-local t)

(defvar +my-first-file-hook nil
  "Transient hooks run before the first interactively opened file.")
(put '+my-first-file-hook 'permanent-local t)

(defvar +my-first-buffer-hook nil
  "Transient hooks run before the first interactively opened buffer.")
(put '+my-first-buffer-hook 'permanent-local t)

(defvar +my-after-reload-hook nil
  "A list of hooks to run after `+my/reload' has reloaded Emacs.")

(defvar +my-before-reload-hook nil
  "A list of hooks to run before `+my/reload' has reloaded Emacs.")

(when IS-EMACS28+
  (mapc (lambda (varset)
          (unless (boundp (car varset))
            (defvaralias (car varset) (cdr varset))))
        '((native-comp-deferred-compilation . comp-deferred-compilation)
          (native-comp-deferred-compilation-deny-list . comp-deferred-compilation-deny-list)
          (native-comp-eln-load-path . comp-eln-load-path)
          (native-comp-warning-on-missing-source . comp-warning-on-missing-source)
          (native-comp-driver-options . comp-native-driver-options)
          (native-comp-async-query-on-exit . comp-async-query-on-exit)
          (native-comp-async-report-warnings-errors . comp-async-report-warnings-errors)
          (native-comp-async-env-modifier-form . comp-async-env-modifier-form)
          (native-comp-async-all-done-hook . comp-async-all-done-hook)
          (native-comp-async-cu-done-functions . comp-async-cu-done-functions)
          (native-comp-async-jobs-number . comp-async-jobs-number)
          (native-comp-never-optimize-functions . comp-never-optimize-functions)
          (native-comp-bootstrap-deny-list . comp-bootstrap-deny-list)
          (native-comp-always-compile . comp-always-compile)
          (native-comp-verbose . comp-verbose)
          (native-comp-debug . comp-debug)
          (native-comp-speed . comp-speed))))

;; Don't store eln files in ~/.emacs.d/eln-cache (they are likely to be purged).
(when (boundp 'native-comp-eln-load-path)
  (add-to-list 'native-comp-eln-load-path (concat +my-cache-dir "eln/")))

(with-eval-after-load 'comp
  ;; HACK Disable native-compilation for some troublesome packages
  (mapc (apply-partially #'add-to-list 'native-comp-deferred-compilation-deny-list)
        (let ((local-dir-re (concat "\\`" (regexp-quote +my-local-dir))))
          (list (concat "\\`" (regexp-quote +my-autoloads-file) "\\'")
                (concat local-dir-re ".*/evil-collection-vterm\\.el\\'")
                (concat local-dir-re ".*/with-editor\\.el\\'")
                ;; https://github.com/nnicandro/emacs-jupyter/issues/297
                (concat local-dir-re ".*/jupyter-channel\\.el\\'")))))

(require 'subr-x)
(require 'cl-lib)
(require 'core-lib)

(setq ad-redefinition-action 'accept) ;; this disables a lot of old advice warnings which aren't useful and really don't do anything


(setq debug-on-error +my-debug-p
    jka-compr-verbose +my-debug-p) ;; if we don't explicitely ask for debugging info, don't give us debugging info


(unless (daemonp)
 (advice-add #'display-startup-echo-area-message :override #'ignore)) ;; We don't need to be told that we can contact the GNU Foundation about GNU.


(setq inhibit-startup-message t
    inhibit-startup-echo-area-message user-login-name
    inhibit-default-init t
    ;; Shave seconds off startup time by starting the scratch buffer in
    ;; `fundamental-mode', rather than, say, `org-nmode' or `text-mode', which
    ;; pull in a ton of packages. `+my/open-scratch-buffer' provides a better
    ;; scratch buffer anyway.
    initial-major-mode 'fundamental-mode
    initial-scratch-message nil)

(setq-default async-byte-compile-log-file  (concat +my-etc-dir "async-bytecomp.log")
  custom-file                  (concat +my-private-dir "custom.el")
  desktop-dirname              (concat +my-etc-dir "desktop")
  desktop-base-file-name       "autosave"
  desktop-base-lock-name       "autosave-lock"
  pcache-directory             (concat +my-cache-dir "pcache/")
  request-storage-directory    (concat +my-cache-dir "request")
  shared-game-score-directory  (concat +my-etc-dir "shared-game-score/"))

(defadvice! +my--write-to-etc-dir-a (orig-fn &rest args)
  "Resolve Emacs storage directory to `+my-etc-dir', to keep local files from
polluting `+my-emacs-dir'."
  :around #'locate-user-emacs-file
  (let ((user-emacs-directory +my-etc-dir))
    (apply orig-fn args)))

(defadvice! +my--write-enabled-commands-to-+my-a (orig-fn &rest args)
  "When enabling a disabled command, the `put' call is written to
~/.emacs.d/init.el, which causes issues for Emacs, so write it to the user's
config.el instead."
  :around #'en/disable-command
  (let ((user-init-file custom-file))
    (apply orig-fn args)))

;; A second, case-insensitive pass over `auto-mode-alist' is time wasted, and
;; indicates misconfiguration (don't rely on case insensitivity for file names).
(setq auto-mode-case-fold nil)

;; Disable bidirectional text scanning for a modest performance boost. I've set
;; this to `nil' in the past, but the `bidi-display-reordering's docs say that
;; is an undefined state and suggest this to be just as good:
(setq-default bidi-display-reordering 'left-to-right
	  bidi-paragraph-direction 'left-to-right)

;; Disabling the BPA makes redisplay faster, but might produce incorrect display
;; reordering of bidirectional text with embedded parentheses and other bracket
;; characters whose 'paired-bracket' Unicode property is non-nil.
(setq bidi-inhibit-bpa t)  ; Emacs 27 only

;; Reduce rendering/line scan work for Emacs by not rendering cursors or regions
;; in non-focused windows.
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

;; More performant rapid scrolling over unfontified regions. May cause brief
;; spells of inaccurate syntax highlighting right after scrolling, which should
;; quickly self-correct.
(setq fast-but-imprecise-scrolling t)

;; Don't ping things that look like domain names.
(setq-default ffap-machine-p-known 'reject)

;; Resizing the Emacs frame can be a terribly expensive part of changing the
;; font. By inhibiting this, we halve startup times, particularly when we use
;; fonts that are larger than the system default (which would resize the frame).
(setq frame-inhibit-implied-resize t)

;; The GC introduces annoying pauses and stuttering into our Emacs experience,
;; so we use `gcmh' to stave off the GC while we're using Emacs, and provoke it
;; when it's idle.
(setq-default gcmh-idle-delay 5  ; default is 15s
  gcmh-high-cons-threshold (* 16 1024 1024)  ; 16mb
  gcmh-verbose +my-debug-p)

;; Emacs "updates" its ui more often than it needs to, so slow it down slightly
(setq idle-update-delay 1.0)  ; default is 0.5

;; Font compacting can be terribly expensive, especially for rendering icon
;; fonts on Windows. Whether disabling it has a notable affect on Linux and Mac
;; hasn't been determined, but do it there anyway, just in case. This increases
;; memory usage, however!
(setq inhibit-compacting-font-caches t)

;; Increase how much is read from processes in a single chunk (default is 4kb).
;; This is further increased elsewhere, where needed (like our LSP module).
(setq read-process-output-max (* 64 1024))  ; 64kb

;; Introduced in Emacs HEAD (b2f8c9f), this inhibits fontification while
;; receiving input, which should help a little with scrolling performance.
(setq redisplay-skip-fontification-on-input t)

;; Performance on Windows is considerably worse than elsewhere. We'll need
;; everything we can get.
(when IS-WINDOWS
  (setq-default w32-get-true-file-attributes nil   ; decrease file IO workload
	w32-pipe-read-delay 0              ; faster IPC
	w32-pipe-buffer-size (* 64 1024))) ; read more at a time (was 4K)

;; Remove command line options that aren't relevant to our current OS; means
;; slightly less to process at startup.
(unless IS-MAC   (setq command-line-ns-option-alist nil))
(unless IS-LINUX (setq command-line-x-option-alist nil))

;; HACK `tty-run-terminal-initialization' is *tremendously* slow for some
;;      reason; inexplicably doubling startup time for terminal Emacs. Keeping
;;      it disabled will have nasty side-effects, so we simply delay it instead,
;;      and invoke it later, at which point it runs quickly; how mysterious!
(unless (daemonp)
  (advice-add #'tty-run-terminal-initialization :override #'ignore)
  (add-hook 'window-setup-hook 
    (defun my-init-tty-h ()
  (advice-remove #'tty-run-terminal-initialization #'ignore)
  (tty-run-terminal-initialization (selected-frame) nil t))))

;; Emacs is essentially one huge security vulnerability, what with all the
;; dependencies it pulls in from all corners of the globe. Let's try to be at
;; least a little more discerning.
(defvar gnutls-verify-error)
(setq-default gnutls-verify-error (not (getenv-internal "INSECURE"))
      gnutls-algorithm-priority
      (when (boundp 'libgnutls-version)
        (concat "SECURE128:+SECURE192:-VERS-ALL"
                (if (and (not IS-WINDOWS)
                         (>= libgnutls-version 30605))
                    ":+VERS-TLS1.3")
                ":+VERS-TLS1.2"))
      ;; `gnutls-min-prime-bits' is set based on recommendations from
      ;; https://www.keylength.com/en/4/
      gnutls-min-prime-bits 3072
      tls-checktrust gnutls-verify-error
      ;; Emacs is built with `gnutls' by default, so `tls-program' would not be
      ;; used in that case. Otherwise, people have reasons to not go with
      ;; `gnutls', we use `openssl' instead. For more details, see
      ;; https://redd.it/8sykl1
      tls-program '("openssl s_client -connect %h:%p -CAfile %t -nbio -no_ssl3 -no_tls1 -no_tls1_1 -ign_eof"
                    "gnutls-cli -p %p --dh-bits=3072 --ocsp --x509cafile=%t \
--strict-tofu --priority='SECURE192:+SECURE128:-VERS-ALL:+VERS-TLS1.2:+VERS-TLS1.3' %h"
                    ;; compatibility fallbacks
                    "gnutls-cli -p %p %h"))

;; Emacs stores `authinfo' in $HOME and in plain-text. Let's not do that, mkay?
;; This file stores usernames, passwords, and other such treasures for the
;; aspiring malicious third party.
(setq-default auth-sources (list (concat +my-etc-dir "authinfo.gpg")
                         "~/.authinfo.gpg"))

(setq-default indent-tabs-mode nil
      tab-width 4)

(setq-default tab-awlways-indent 'complete)

(setq-default tabify-regexp "^\t* [ \t]+")

(setq-default fill-column 80)
(setq-default word-wrap t)
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil)
(setq sentence-end-double-space nil)
(setq require-final-newline t)
(add-hook 'text-mode-hook #'visual-line-mode)
(add-hook 'text-mode-hook #'visual-fill-column-mode)

(setq kill-do-not-save-duplicates t)

;; Allow UTF or composed text from the clipboard, even in the terminal or on
;; non-X systems (like Windows or macOS), where only `STRING' is used.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))


;;
;;; Extra file extensions to support

(nconc
 auto-mode-alist
 '(("/LICENSE\\'" . text-mode)
   ("\\.log\\'" . text-mode)
   ("rc\\'" . conf-mode)
   ("\\.\\(?:hex\\|nes\\)\\'" . hexl-mode)))

;;
;; who am i
;;

(setq user-full-name "David Wagle"
  user-mail-address "david.wagle@gmail.com")

;;
;; Reset GC after init
;;

(defun reset-gc-cons-threshold ()
  "Return the garbage collection threshold to default values."
  (setq gc-cons-threshold
    (car (get 'gc-cons-threshold 'standard-value))))


(add-hook 'after-init-hook 'reset-gc-cons-threshold)

(global-set-key (kbd "C-z") nil)

;; No window decorations

(tool-bar-mode 0)
(menu-bar-mode 0)
(set-scroll-bar-mode nil)
(setq inhibit-startup-screen t)
(fringe-mode '(8 . 8))

;; Nice fairly universal font

(set-frame-font "DejaVu Sans Mono-15")
(add-to-list 'initial-frame-alist
     '(font . "DejaVu Sans Mono-15"))
(add-to-list 'default-frame-alist
     '(font . "DejaVu Sans Mono-15"))

;; utf-8 everywhere

(set-language-environment "UTF-8")
(unless IS-WINDOWS
  (setq selection-coding-system 'utf-8))

;; y or n is sufficient

(defalias 'yes-or-no-p 'y-or-n-p)

;;
;; make isearch wrap around
;;

(defadvice isearch-repeat (after isearch-no-fail activate)
  "Allow isearch to wrap if nothing found searching forawrd.
Deactivates at first failt o prevent an infinite loop."
  (unless isearch-success
(ad-disable-advice 'isearch-repeat 'after 'isearch-no-fail)
(ad-activate 'isearch-repeat)
(isearch-repeat (if isearch-forward 'forward))
(ad-enable-advice 'isearch-repeat 'after 'search-no-fail)
(ad-activate 'isearch-repeat)))



(require 'uniquify)

(setq
 uniquify-buffer-name-style 'forward    ; names use / for delimiter
 uniquify-after-kill-buffer-p t         ; rationalize after kill
 uniquify-ignore-buffers-re "^\\*")     ; ignore system buffers


(setq enable-recursive-minibuffers nil)  ;  allow mb cmds in the mb
(setq max-mini-window-height .25)        ;  max 2 lines
(setq minibuffer-scroll-window nil)      ; no scrolling in mb
(setq resize-mini-windows nil)           ; no resizing the mb

;;
;; this variable needs to be set before
;; loading straight to work around
;; a problem with flycheck

(setq-default straight-fix-flycheck t)

;;
;; Make sure we have Straight intstalled
;;


(defvar bootstrap-version)
(let ((bootstrap-file
   (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
  (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
(with-current-buffer
    (url-retrieve-synchronously
     "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
     'silent 'inhibit-cookies)
  (goto-char (point-max))
  (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;
;; set up straight to use use-package
;;

(straight-use-package 'use-package)
(setq-default straight-use-package-by-default t)
(setq-default straight-check-for-modifications '(watch-files find-when-checking))

(straight-use-package '(setup :type git :host nil :repo "https://git.sr.ht/~pkal/setup"))
(require 'setup)

(setup-define :delay
   (lambda (&rest time)
     `(run-with-idle-timer ,(or time 1)
                           nil ;; Don't repeat
                           (lambda () (require ',(setup-get 'feature)))))
   :documentation "Delay loading the feature until a certain amount of idle time has passed.")

(setup-define :disabled
  (lambda ()
    `,(setup-quit))
  :documentation "Always stop evaluating the body.")

(setup-define :load-after
    (lambda (features &rest body)
      (let ((body `(progn
                     (require ',(setup-get 'feature))
                     ,@body)))
        (dolist (feature (if (listp features)
                             (nreverse features)
                           (list features)))
          (setq body `(with-eval-after-load ',feature ,body)))
        body))
  :documentation "Load the current feature after FEATURES."
  :indent 1)



(defun my/tangle-init ()
  (interactive)
     (lambda ()
       (require 'org)
       (when (and user-init-file
             (equal (file-name-extension user-init-file) "elc"))
         (let* ((source (file-name-sans-extension user-init-file))
     (alt (concat source ".el")))
    (setq source (cond ((file-exists-p alt) alt)
               ((file-exists-p source) source)
               (t nil)))
    (when source
      (when (file-newer-than-file-p source user-init-file)
    (byte-compile-file source)
    (load-file source)
    (eval-buffer nil nil)
        (delete-other-windows) )))))
(message "***my/tangle-init*** complete"))

(setq auto-save-interval 30) ;; how many seconds to go between autosaves



(defun +my-full-auto-save ()
  (interactive)
  (save-excursion
    (dolist (buf (buffer-list))
      (set-buffer buf)
      (if (and (buffer-file-name) (buffer-modified-p))
          (basic-save-buffer)))))
(add-hook 'auto-save-hook '+my-full-auto-save)

(use-package vterm
  :straight t
  :init (setq vterm-always-compile-module t)
  (add-hook 'vterm-mode-hook
            (lambda ()
              (set (make-local-variable 'buffer-face-mode-face) 'fixed-pitch)
              (buffer-face-mode t))))

(eval-when-compile
  (require 'cl-lib)
  (require 'esh-mode)
  (require 'eshell))

(require 'esh-util)

(use-package auto-package-update
  :straight t
  :config (auto-package-update-at-time "05:00"))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-M-u") 'universal-argument)

(defun +my-evil-hook ()
  (dolist (mode '(eshell-mode
                  proced-mode
                  diff-mode
                  dired-mode
                  term-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

(defun +my-dont-arrow-me-bro ()
(interactive)
(message "Arrow keys are bad, you know?"))

(use-package undo-tree
  :straight t
  :init (setq undo-tree-auto-save-history t)
  (global-undo-tree-mode 1))

(setq evil-want-keybinding nil)

(use-package evil
  :straight t
  :config
  (evil-mode t)
  (defvar +evil-repeat-keys (cons ";" ",")
    "The keys to use for universal repeating motions.")
  (defvar +evil-want-o/O-to-continue-comments t
    "If non-nil, the o/O keys will continue comment lines if the point is on a line with a inewise comment.")
  (defvar +evil-preprocessor-regexp "^\\s-*#[a-zA-Z0-9_]"
    "The regexp used by `+evil/next-preproc-directive' and
    `+evil/previous-preproc-directive' on ]# and [#, to jump between preprocessor
    directives. By default, this only recognizes C directives.")

  ;; Set these defaults before `evil'; use `defvar' so they can be changed prior
  ;; to loading.
  (defvar evil-want-C-g-bindings t)
  (defvar evil-want-C-i-jump nil)  ; we do this ourselves
  (defvar evil-want-C-u-scroll t)  ; moved the universal arg to <leader> u
  (defvar evil-want-C-u-delete t)
  (defvar evil-want-C-w-scroll t)
  (defvar evil-want-C-w-delete t)
  (defvar evil-want-Y-yank-to-eol t)
  (defvar evil-want-abbrev-expand-on-insert-exit nil)
  (defvar evil-respect-visual-line-mode nil)
  (setq 
   evil-ex-search-vim-style-regexp t
   evil-ex-visual-char-range t  ; column range for ex commands
   evil-mode-line-format 'nil
   ;; more vim-like behavior
   evil-symbol-word-search t
   ;; if the current state is obvious from the cursor's color/shape, then
   ;; we won't need superfluous indicators to do it instead.
   evil-default-cursor '+evil-default-cursor-fn
   evil-normal-state-cursor 'box
   evil-emacs-state-cursor  '(box +evil-emacs-cursor-fn)
   evil-insert-state-cursor 'bar
   evil-visual-state-cursor 'hollow
   ;; Only do highlighting in selected window so that Emacs has less work
   ;; to do highlighting them all.
   evil-ex-interactive-search-highlight 'selected-window
   ;; It's infuriating that innocuous "beginning of line" or "end of line"
   ;; errors will abort macros, so suppress them:
   evil-kbd-macro-suppress-motion-error t
   evil-undo-system 'undo-tree)
  (evil-select-search-module 'evil-search-module 'evil-search)
  (advice-add #'evil-visual-update-x-selection :override #'ignore)
  (advice-add #'help-with-tutorial :after (lambda (&rest _) (evil-emacs-state +1)))
  (add-hook 'evil-mode-hook '+my-evil-hook))


(evil-global-set-key 'motion "j" 'evil-next-visual-line)
(evil-global-set-key 'motion "k" 'evil-previous-visual-line)


(use-package evil-collection
  :straight t
  :after evil
  :config (evil-collection-init))

;; (use-package evil-snipe
;;   :straight t
;;   :config
;;   (evil-snipe-mode +1)
;;   (evil-snipe-override-mode +1))

(use-package evil-leader
  :straight t
  :config (progn
            (setq evil-leader/in-all-states t)
            (global-evil-leader-mode)))

(setq-default indent-tabs-mode)

(use-package god-mode
  :straight t)

(use-package evil-god-state
  :straight t)

(global-unset-key (kbd "C-w"))
(define-key global-map (kbd "C-w") nil)

(define-key global-map (kbd "C-<escape>") 'evil-normal-state)
(define-key global-map (kbd "C-~") 'evil-normal-state)
(define-key global-map (kbd "M-<escape>") 'god-mode)
(define-key global-map (kbd "C-M-<escape>") 'god-local-mode)
(define-key evil-normal-state-map (kbd "SPC") 'evil-execute-in-god-state)
(define-key evil-visual-state-map (kbd "SPC") 'evil-execute-in-god-state)
(define-key evil-normal-state-map (kbd "l") 'evil-forward-char)
(define-key evil-visual-state-map (kbd "l") 'evil-forward-char)

(use-package evil-magit
  :straight t
  :after (evil magit))

(use-package evil-exchange
  :straight t
  :after evil
  :init (evil-exchange-install))

(use-package general
  :straight t
  :config
  (general-evil-setup t)

  (general-create-definer +my-leader-key-def
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (general-create-definer +my-ctrl-c-keys
    :prefix "C-c"))

(use-package use-package-chords
:straight t
:disabled
:config (key-chord-mode 1))

(use-package aggressive-indent
  :straight t
  :config
  (global-aggressive-indent-mode 1)
  (add-to-list 'aggressive-indent-excluded-modes 'html-mode))

(use-package visual-fill-column
   :straight t
   :config (setq-default visual-fill-column-center-text nil)
           (advice-add  'text-scale-adjust :after #'visual-fill-column-adjust)
           (add-hook 'visual-fill-column-mode-hook #'visual-line-mode))

(use-package all-the-icons
  :straight t
)

(use-package doom-modeline
  :straight t
  :init (doom-modeline-mode 1))

(use-package modus-themes
  :init
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-no-mixed-fonts nil
        modus-themes-subtle-line-numbers t
        modus-themes-success-dueteranopia t
        modus-themes-tabs-accented t
        modus-themes-fringes 'subtle
        modus-themes-language-checkers '(straight-underline
                                         intense
                                         text-also background)
        modus-themes-mode-line nil
        modus-themes-syntax '(faint alt-syntax
                                    green-strings yellow-comments)
        modus-themes-links '(neutral-underline faint italic)
        modus-themes-paren-match '(bold intense underline)
        modus-themes-region '(bg-only no-extend)
        modus-themes-org-blocks 'gray-background    
        modus-themes-headings '((1 . (background  overline))
                                (2 . (rainbow))
                                (t . (rainbow)))
        modus-themes-scale-1 1.1
        modus-themes-scale-2 1.2
        modus-themes-scale-3 1.3
        modus-themes-scale-4 1.4
        modus-themes-scale-title 1.6
        modus-themes-scale-small 0.8
        modus-themes-scale-headings t
        modus-themes-variable-pitch-headings t)
  (modus-themes-load-themes)
  (modus-themes-load-vivendi)
  :bind ("C-c t T" . modus-themes-toggle)
  :config (progn (load-theme 'modus-operandi t t)
                 (load-theme 'modus-vivendi t t)))

(use-package tex-site 
  :straight  auctex
  :defines (TeX-auto-save
    TeX-parse-self
    reftex-plug-into-AUCTex)
  :config
  (setq TeX-auto-save t
    TeX-parse-self t
    reftex-plug-into-AUCTex t
    LaTeX-electric-left-right-brace t))

(setup reftex
  (:load-after auctex)
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
  (add-hook 'latex-mode-hook 'turn-on-reftex))

(use-package ebib
  :straight t
  :init
  :bind (("C-c e" . ebib)))

(use-package company-auctex
       :straight t)

(use-package pdf-tools
    :straight t
    :init (pdf-loader-install)
          (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer))

(use-package ispell
  :straight t   
  :init (setq ispell-dictionary "en_US"
              ispell-program-name "hunspell"))

(use-package flyspell
  :straight t
  :init (dolist (hook '(text-mode-hook))
          (add-hook hook (lambda () (flyspell-mode 1))))
  :bind (("C-c s-;" . flyspell-mode)
         ("C-c s-." . flyspell-check-next-highlighted-word)))

(use-package flycheck
  :straight t
  :config (global-flycheck-mode))

(use-package hydra
  :straight t)

(use-package which-key
  :straight t
  :config (which-key-setup-side-window-bottom)
  (setq which-key-show-early-on-C-h t
        which-key-idle-secondary-delay 0.05)
  :init (which-key-mode)
  (which-key-enable-god-mode-support))

(use-package edit-server
  :ensure t
  :commands edit-server-start
  :init (if after-init-time
              (edit-server-start)
            (add-hook 'after-init-hook
                      #'(lambda() (edit-server-start))))
  :config (setq edit-server-new-frame-alist
                '((name . "Edit with Emacs FRAME")
                  (top . 200)
                  (left . 200)
                  (width . 80)
                  (height . 25)
                  (minibuffer . t)
                  (menu-bar-lines . t)
                  (window-system . x))))

(use-package helm
  :straight t
  :init (helm-mode 1)
  (setq helm-M-x-fuzzy-match t
        helm-buffers-fuzzy-matching t
        helm-recentf-fuzzy-match t
        helm-locate-fuzzy-match t
        helm-apropos-fuzzy-match t)
  :bind (("M-x" . helm-M-x)
         ("C-x r b" . helm-filtered-bookmarks)
         ("C-x C-f" . helm-find-files)
         ("C-x C-d" . helm-browse-project)
         ("C-x C-r" . helm-recentf)
         ("C-x b"   . helm-buffers-list)
         ("M-y"     . helm-show-kill-ring)
         ("M-m"     . helm-mini)
         ("C-h a"   . helm-apropos)))

(use-package helm-bibtex
  :straight t
  :init (setq bibtex-completion-bibliography '("/home/david/Dropbox/Org/References/bibliography.bib")
              bibtex-completion-library-path '("/home/david/Dropbox/Org/References/pdfs")
              bibtex-completion-notes-path "/home/david/Dropbox/Org/roam/"
              bibtex-completion-pdf-symbol "⌘"
              bibtex-completion-notes-symbol "✎")
  :bind-keymap ("<menu>" . helm-command-prefix)
  :bind (:map helm-command-map
              ("b"      . helm-bibtex)
              ("n"      . helm-bibtex-with-notes)
              ("<menu>" . helm-resume)))

(use-package company
  :straight t
  :defines (company-idle-delay
    company-tooltip-limit
    company-minimum-prefix-length
    company-tooltip-flip-when-above)
  :config
  (setq company-idle-delay 0.5
    company-tooltip-limit 10
    company-minimum-prefix-length 2
    company-tooltip-flip-when-above t)
  (add-hook 'after-init-hook 'global-company-mode))


(use-package company-bibtex
 :straight t
  )

(use-package company-jedi
  :straight t
  )

(use-package company-math
  :straight t
  )

(use-package company-shell
  :straight t
  )

(use-package company-try-hard
  :straight    
  :bind ("C-z" . company-try-hard))

(global-unset-key (kbd "C-;"))
  (global-unset-key (kbd "C-'"))

(use-package avy
  :straight t
  :bind (("C-;" . avy-goto-char)
         ("C-'" . avy-goto-char-2)
         ("s-;" . avy-goto-word-1)
         ("s-'" . avy-goto-word-0)))

(use-package evil-avy
  :straight t)

(require 'ibuffer)

(defhydra hydra-ibuffer-main (:color pink :hint nil)
  "
^Mark^         ^Actions^         ^View^          ^Select^              ^Navigation^
_m_: mark      _D_: delete       _g_: refresh    _q_: quit             _k_:   ↑    _h_
_u_: unmark    _s_: save marked  _S_: sort       _TAB_: toggle         _RET_: visit
_*_: specific  _a_: all actions  _/_: filter     _o_: other window     _j_:   ↓    _l_
_t_: toggle    _._: toggle hydra _H_: help       C-o other win no-select
"
  ("m" ibuffer-mark-forward)
  ("u" ibuffer-unmark-forward)
  ("*" hydra-ibuffer-mark/body :color blue)
  ("t" ibuffer-toggle-marks)

  ("D" ibuffer-do-delete)
  ("s" ibuffer-do-save)
  ("a" hydra-ibuffer-action/body :color blue)

  ("g" ibuffer-update)
  ("S" hydra-ibuffer-sort/body :color blue)
  ("/" hydra-ibuffer-filter/body :color blue)
  ("H" describe-mode :color blue)

  ("h" ibuffer-backward-filter-group)
  ("k" ibuffer-backward-line)
  ("l" ibuffer-forward-filter-group)
  ("j" ibuffer-forward-line)
  ("RET" ibuffer-visit-buffer :color blue)

  ("TAB" ibuffer-toggle-filter-group)

  ("o" ibuffer-visit-buffer-other-window :color blue)
  ("q" quit-window :color blue)
  ("." nil :color blue))

      (defhydra hydra-ibuffer-mark (:color teal :columns 5
                                    :after-exit (hydra-ibuffer-main/body))
        "Mark"
        ("*" ibuffer-unmark-all "unmark all")
        ("M" ibuffer-mark-by-mode "mode")
        ("m" ibuffer-mark-modified-buffers "modified")
        ("u" ibuffer-mark-unsaved-buffers "unsaved")
        ("s" ibuffer-mark-special-buffers "special")
        ("r" ibuffer-mark-read-only-buffers "read-only")
        ("/" ibuffer-mark-dired-buffers "dired")
        ("e" ibuffer-mark-dissociated-buffers "dissociated")
        ("h" ibuffer-mark-help-buffers "help")
        ("z" ibuffer-mark-compressed-file-buffers "compressed")
        ("b" hydra-ibuffer-main/body "back" :color blue))

      (defhydra hydra-ibuffer-action (:color teal :columns 4
                                      :after-exit
                                      (if (eq major-mode 'ibuffer-mode)
                                          (hydra-ibuffer-main/body)))
        "Action"
        ("A" ibuffer-do-view "view")
        ("E" ibuffer-do-eval "eval")
        ("F" ibuffer-do-shell-command-file "shell-command-file")
        ("I" ibuffer-do-query-replace-regexp "query-replace-regexp")
        ("H" ibuffer-do-view-other-frame "view-other-frame")
        ("N" ibuffer-do-shell-command-pipe-replace "shell-cmd-pipe-replace")
        ("M" ibuffer-do-toggle-modified "toggle-modified")
        ("O" ibuffer-do-occur "occur")
        ("P" ibuffer-do-print "print")
        ("Q" ibuffer-do-query-replace "query-replace")
        ("R" ibuffer-do-rename-uniquely "rename-uniquely")
        ("T" ibuffer-do-toggle-read-only "toggle-read-only")
        ("U" ibuffer-do-replace-regexp "replace-regexp")
        ("V" ibuffer-do-revert "revert")
        ("W" ibuffer-do-view-and-eval "view-and-eval")
        ("X" ibuffer-do-shell-command-pipe "shell-command-pipe")
        ("b" nil "back"))

      (defhydra hydra-ibuffer-sort (:color amaranth :columns 3)
        "Sort"
        ("i" ibuffer-invert-sorting "invert")
        ("a" ibuffer-do-sort-by-alphabetic "alphabetic")
        ("v" ibuffer-do-sort-by-recency "recently used")
        ("s" ibuffer-do-sort-by-size "size")
        ("f" ibuffer-do-sort-by-filename/process "filename")
        ("m" ibuffer-do-sort-by-major-mode "mode")
        ("b" hydra-ibuffer-main/body "back" :color blue))

      (defhydra hydra-ibuffer-filter (:color amaranth :columns 4)
        "Filter"
        ("m" ibuffer-filter-by-used-mode "mode")
        ("M" ibuffer-filter-by-derived-mode "derived mode")
        ("n" ibuffer-filter-by-name "name")
        ("c" ibuffer-filter-by-content "content")
        ("e" ibuffer-filter-by-predicate "predicate")
        ("f" ibuffer-filter-by-filename "filename")
        (">" ibuffer-filter-by-size-gt "size")
        ("<" ibuffer-filter-by-size-lt "size")
        ("/" ibuffer-filter-disable "disable")
        ("b" hydra-ibuffer-main/body "back" :color blue))

      (define-key ibuffer-mode-map "." 'hydra-ibuffer-main/body)

      (add-hook 'ibuffer-hook #'hydra-ibuffer-main/body)

(use-package treemacs
  :ensure t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   t
          treemacs-file-event-delay                5000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-width                           35
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :after (treemacs dired)
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(use-package org
    :straight t 
    :defer t
    :bind (("C-x o"     . nil)
           ("C-x o l"   . org-store-link)
           ("C-x o a"   . org-agenda)
           ("C-x o c"   . org-capture)))

  (message "*** setting variables ***" )
  (setq-default org-directory (expand-file-name "~/Dropbox/Org")
                org-agenda-files '("~/Dropbox/Org/home.org"
                                   "~/Dropbox/Org/work.org"
                                   "~/Dropbox/Org/index.org"
                                   "~/Dropbox/Org/other.org"
                                   "~/Dropbox/Org/school.org"
                                   "~/Dropbox/Org/personal.org")
                org-todo-keywords '((sequence "IDEA(i)" "TODO(t)"
                                              "STARTED(s)" "NEXT(n)"
                                              "WAITING(w)" "|" "DONE(d)")
                                    (sequence "|" "CANCELLED(C)"
                                              "DELEGATED(l)" "SOMEDAY(m)"))
                org-tag-persistent-alist '((:startgroup . nil)
                                           ("HOME" . ?h)
                                           ("RESEARCH" . ?r)
                                           ("WRITING" . ?w)
                                           ("READING" . ?d)
                                           (:endgroup . nil)
                                           (:startgroup . nil)
                                           ("LISP"    . ?p)
                                           ("PYTHON"  . ?n)
                                           ("R"       . ?r)
                                           (:endgroup . nil))

                org-agenda-ndays 14
                org-agenda-show-all-dates t
                org-agenda-skip-deadlines-if-done t
                org-agenda-skip-scheduled-if-done t
                org-agenda-start-on-weekday nil
                org-deadline-warning-days 3
                org-agenda-with-colors t
                org-agenda-compact-blocks t
                org-agenda-remove-tags nil
                org-startup-indented t)
  (add-to-list 'ispell-skip-region-alist '((":\\(PROPERTIES\\|LOGBOOK\\):" . ":END:")
                                           (
                                            "
       #\\+BEGIN_SRC" . "#\\+END_SRC")
                                           '("#\\+BEGIN_EXAMPLE" . "#\\+END_EXAMPLE")))
(message "**** end of setting variables ****")

(use-package org-contrib
  :after org
  :straight t)

(use-package org-ref
  :straight t
  :after org
  :init (setq reftex-default-bibliography '("/home/david/Dropbox/Org/References/bibliography.bib")
              org-ref-bibliography-notes "/home/david/Dropbox/Org/References/bibliography.bib"
              org-ref-default-bibliogrpahy '("/home/david/Dropbox/Org/References/bibliography.bib")
              org-ref-pdf-directory "/home/david/Dropbox/Org/References/pdfs/"
              bibtex-completion-library-path "/home/david/Dropbox/Org/References/pdfs"
              bibtex-completion-notes-path "/home/david/Dropbox/Org/roam/"
              bitex-completion-pdf-open-function 'org-open-file
              org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f")
              org-ref-get-pdf-filename-function 'org-ref-get-pdf-file-name-helm-bibtex
              org-ref-completion-library 'org-ref-helm-cite))

(use-package deft
  :bind ("<f8>" . deft)
  :commands (deft)
  :config (setq deft-directory "~/Dropbox/"
                deft-extensions '("txt" "tex" "org")
                deft-recursive t
                deft-use-filename-as-title t))

(use-package org-roam
  :after org
  :straight t
  :init (setq org-roam-v2-ack t
              +my-daily-note-filename "%<%Y-%m%-%d>.org"
              +my-daily-note-header "#+title: %<%Y-%m-%d %a>\n\n[[roam:%<Y-%B>]]\n\n"
              org-roam-capture-templates  `(("d" "default" entry
                                             "* %?"
                                             :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                                                "#+title: ${title}\n")
                                             :unnarrowed t)
                                            ("b" "bibliography" entry
                                             "* %?"
                                             :if-new (file+head "${citekey}.org"
                                                                "#+TITLE: ${title}\n#+DATE: %U\n#+KEYWORDS: ${keywords}")
                                             :unnarrowed))
              org-roam-directory "/home/david/Dropbox/Org/roam"
              org-roam-dailies-directory "journal/"
              org-roam-completion-everywhere t
              org-roam-db-location "/home/david/Dropbox/Org/roam/org-roam.db")
  (add-to-list 'display-buffer-alist
               '("\\*org-roam\\*"
                 (display-buffer-in-side-window)
                 (side . right)
                 (slot . 0)
                 (window-width . 0.33)
                 (window-parameters . ((no-other-window . t)
                                       (no-delete-other-windows . t)))))
  (org-roam-db-autosync-mode)
  :bind  (("C-c n l" . org-roam-buffer-toggle)
          ("C-c n f" . org-roam-node-find)
          ("C-c n c" . org-roam-dailies-capture-today)
          ("C-c n g" . org-roam-graph)
          ("C-c n i" . org-roam-node-insert)
          ("C-c n I" . org-roam-node-insert-immediate)))


(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (push arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

(use-package org-roam-bibtex
  :straight t
  :after (org-roam org)
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :config (setq orb-note-actions-interface 'hydra
                orb-preformat-keywords '("citekey" "title" "url"
                                         "doi" "author-or-editor"
                                         "keywords" "file" "date")
                orb-process-file-keywords t
                orb-insert-interface 'helm-bibtex
                orb-file-field-extensions '("pdf"))
  :bind (:map org-mode-map
              (("C-c n a" . orb-note-actions))))

(setq bibtex-completion-notes-path "/home/david/Dropbox/Org/roam/"
      bibtex-completion-bibliography "/home/david/Dropbox/Org/References/bibliography.bib"
      bibtex-compltion-pdf-field "file"
      bibtex-completion-notes-template-multiple-files
      (concat
       "#+TITLE: {title}\n"
       "#+ROAM_KEY: cite:${=key=}\n"
       "* TODO Notes\n"
       ":PROPERTIES:\n"
       ":Custom_ID: ${=key=}\n"
       ":NOTER_DOCUMENT: %(orb-process-file-field \"${=key=}\")\n"
       ":AUTHOR: ${author-abbrev}\n"
       ":JOURNAL: ${journaltitle}\n"
       ":DATE: ${date}\n"
       ":YEAR: ${year}\n"
       ":DOI: ${doi}\n"
       ":URL: ${url}\n"
       ":END:\n\n"))

(use-package websocket
   :straight t
   )

(use-package simple-httpd
   :straight t)

(use-package org-roam-ui
  :straight (:host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out"))
  :after org-roam
  :config (setq org-roam-ui-sync-theme t
                org-roam-ui-follow t
                org-roam-ui-update-on-save t
                org-roam-ui-open-on-start t))

(use-package org-superstar
  :straight t
  :after org
  :init
  (setq org-superstar-leading-bullet ?\s 
        org-superstar-remove-leading-stars t
        org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●")
        org-indent-mode-turns-on-hiding-stars t)
  :hook (org-mode . org-superstar-mode))

(use-package org-tree-slide
  :straight t
  :defines (org-image-actual-width)
  :config (org-image-actual-width nil))

(use-package htmlize
  :straight t
  :init (setq htmlize-output-type 'css))

(use-package projectile
  :straight t)

(use-package rainbow-delimiters
  :straight t 
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package magit
  :straight t 
  :bind (("C-x g" . magit-status)))

(use-package yasnippet
  :straight t
  :config (setq yas-snippet-dirs '(+my-snippets-dir))
  (yas-global-mode 1)
  (yas-reload-all)
  :hook (prog-mode . yas-minor-mode))

(use-package lsp-mode
  :straight t
  :init (setq lsp-keymap-prefix "C-c l")
  :hook 
  (python-mode . lsp)
  (ess-julia-mode . lsp)
  (lsp-mode . lsp-enable-which-key-integration)
  :commands lsp)

(use-package lsp-ui :commands lsp-ui-mode
  :straight t)

(use-package helm-lsp :commands helm-lsp-workspace-symbol
  :straight t)

(use-package lsp-treemacs :commands lsp-treemacs-errors-list
  :straight t)

(use-package lsp-julia
  :straight t)

(use-package lsp-jedi
  :straight t
  :config (with-eval-after-load "lsp-mode"
            (add-to-list 'lsp-disabled-clients 'pyls)
            (add-to-list 'lsp-enabled-clients 'jedi)))

(general-define-key
 :states '(normal visual)
 "L"  '(:ignore t :which-key "lsp")
 "Ld" 'xref-find-definitions
 "Lr" 'xref-find-references
 "Ln" 'lsp-ui-find-next-reference
 "Lp" 'lsp-ui-find-prev-reference
 "Lv" 'counsel-variable-documentation
 "Le" 'lsp-ui-flycheck-list
 "LS" 'lsp-ui-sideline-symbol
 "LX" 'lsp-ui-sideline-code-action)

(setq inferior-lisp-program "/usr/bin/sbcl")

(defun +my-temp-buffer-p (buf)
  "Return non-nil if bufffer is temporary."
  (equal (substring (buffer-name buf) 0 1) " "))

(defun +common-lisp--cleanup-sly-maybe-h ()
  "Kill processes and leftover buffers when killing the last sly buffer."
  (unless (cl-loop for buf in (delq (current-buffer) (buffer-list))
                   if (and (buffer-local-value 'sly-mode buf)
                           (get-buffer-window buf))
                   return t)
    (dolist (conn (sly--purge-connections))
      (sly-quit-lisp-internal conn 'sly-quit-sentinel t))
    (let (kill-buffer-hook kill-buffer-query-functions)
      (mapc #'kill-buffer
            (cl-loop for buf in (delq (current-buffer) (buffer-list))
                     if (buffer-local-value 'sly-mode buf)
                     collect buf)))))



(defun +common-lisp-init-sly-h ()
  "Attempt to auto-start sly when opening a lisp buffer."
  (cond ((or (+my-temp-buffer-p (current-buffer))
             (sly-connected-p)))
        ((executable-find (car (split-string inferior-lisp-program)))
         (let ((sly-auto-start 'always))
           (sly-auto-start)
           (add-hook 'kill-buffer-hook #'+common-lisp--cleanup-sly-maybe-h nil t)))
        ((message "WARNING: Couldn't find `inferior-lisp-program' (%s)"
                  inferior-lisp-program))))

(use-package sly
  :straight t
  :init (setq sly-kill-without-query t
              sly-net-coding-system 'utf-8-unix
              sly-complete-symbol-function 'sly-simple-completions
              )

  :hook (lisp-mode . sly-editing-mode)
  (lisp-mode . rainbow-delimiters-mode)
  (sly-mode .  +common-lisp-init-sly-h)
  (sly-mode . evil-normalize-keymaps))


(use-package sly-repl-ansi-color
  :straight t
  :init (add-to-list 'sly-contribs 'sly-repl-ansi-color))

(use-package page-break-lines
  :straight t)

(use-package dashboard
  :straight t
  :after (projectile)
  :config (dashboard-setup-startup-hook)
  (setq initial-buffer-choice (lambda () get-buffer-create "*dashboard*")
        dashboad-banner-logo-title "Welcome to David's Emacs Dashboard"
        dashboard-startup-banner 'logo
        dashboard-center-content nil
        dashboard-show-shortcuts t
        dashboard-set-init-info t
        dashboard-items '((recents . 5)
                          (bookmarks . 5)
                          (projects . 5)
                          (agenda . 5)
                          (registers . 5))))

(load custom-file)

(setq server-name "frodo")

;;(server-start) I have emacs started by systemd now so this is not needed
