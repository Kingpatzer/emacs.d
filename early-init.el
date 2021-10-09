;;; early-init.el -*- lexical-binding: t; -*-

(setq gc-cons-threshold most-positive-fixnum)

;;(setq warning-minimum-level :emergency)

(setq user-emacs-directory (file-name-directory load-file-name))

(setq enable-local-eval t
      safe-local-eval-forms (list))
(add-to-list 'safe-local-eval-forms '(progn (my/tangle-init)))
