;;; prelude-common-lisp.el --- Emacs Prelude: lisp-mode and SLIME config.
;;
;; Copyright (c) 2011 Bozhidar Batsov
;;
;; Author: Bozhidar Batsov <bozhidar.batsov@gmail.com>
;; URL: http://www.emacswiki.org/cgi-bin/wiki/Prelude
;; Version: 1.0.0
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Configuration for lisp-mode and SLIME.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(defgroup common-lisp nil
  "Prelude's Common Lisp support"
  :group 'prelude)

(defcustom prelude-start-slime-automatically t
  "Start SLIME automatically the first time a .list file is opened."
  :type 'boolean
  :group 'common-lisp)

(defcustom prelude-enable-common-lisp-hook t
  "Enable Prelude's Common Lisp hook"
  :type 'boolean
  :group 'common-lisp)

(defcustom prelude-load-common-lisp-slime-automatically nil
  "Load Common Lisp's SLIME by default. Setting this to `t' is not a
very good idea if you're programming on occasion in both Clojure and
Common Lisp."
  :type 'boolean
  :group 'common-lisp)

(require 'prelude-lisp)

;; the SBCL configuration file is in Common Lisp
(add-to-list 'auto-mode-alist '("\\.sbclrc$" . lisp-mode))

;; Use SLIME from Quicklisp
(defun prelude-load-common-lisp-slime ()
  (interactive)
  ;; Common Lisp support depends on SLIME being installed with Quicklisp
  (if (file-exists-p (expand-file-name "~/quicklisp/slime-helper.el"))
      (load (expand-file-name "~/quicklisp/slime-helper.el"))
    (message "%s" "SLIME is not installed. Use Quicklisp to install it.")))

;; a list of alternative Common Lisp implementations that can be
;; used with SLIME. Note that their presence render
;; inferior-lisp-program useless. This variable holds a list of
;; programs and if you invoke SLIME with a negative prefix
;; argument, M-- M-x slime, you can select a program from that list.
(setq slime-lisp-implementations
      '((ccl ("ccl"))
        (clisp ("clisp" "-q"))
        (cmucl ("cmucl" "-quiet"))
        (sbcl ("sbcl" "--noinform") :coding-system utf-8-unix)))

;; select the default value from slime-lisp-implementations
(if (string= system-type "darwin")
    ;; default to Clozure CL on OS X
    (setq slime-default-lisp 'ccl)
  ;; default to SBCL on Linux and Windows
  (setq slime-default-lisp 'sbcl))

(when prelude-enable-common-lisp-hook
  (add-hook 'lisp-mode-hook 'prelude-lisp-coding-hook)
  (add-hook 'slime-repl-mode-hook 'prelude-interactive-lisp-coding-hook))

;; start slime automatically when we open a lisp file
(defun prelude-start-slime ()
  (unless (slime-connected-p)
    (save-excursion (slime))))

(when prelude-start-slime-automatically
  (add-hook 'slime-mode-hook 'prelude-start-slime))

;; Stop SLIME's REPL from grabbing DEL,
;; which is annoying when backspacing over a '('
(defun prelude-override-slime-repl-bindings-with-paredit ()
  (define-key slime-repl-mode-map
    (read-kbd-macro paredit-backward-delete-key) nil))

(add-hook 'slime-repl-mode-hook 'prelude-override-slime-repl-bindings-with-paredit)

(eval-after-load "slime"
  '(progn
     (setq slime-complete-symbol-function 'slime-fuzzy-complete-symbol
           slime-fuzzy-completion-in-place t
           slime-enable-evaluate-in-emacs t
           slime-autodoc-use-multiline-p t)

     (define-key slime-mode-map (kbd "TAB") 'slime-indent-and-complete-symbol)
     (define-key slime-mode-map (kbd "C-c i") 'slime-inspect)
     (define-key slime-mode-map (kbd "C-c C-s") 'slime-selector)))

(provide 'prelude-common-lisp)

;;; prelude-common-lisp.el ends here