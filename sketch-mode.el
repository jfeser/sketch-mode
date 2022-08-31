;;; derived-mode-ex.el --- example of a CC Mode derived mode for a new language

;; Author:     2002 Martin Stjernholm
;; Maintainer: Unmaintained
;; Created:    October 2002
;; Version:    See cc-mode.el
;; Keywords:   c languages oop

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; This is a simple example of a separate mode derived from CC Mode
;; for a hypothetical language called C: (pronounced "big nose") that
;; is similar to Java.  It's provided as a guide to show how to use CC
;; Mode as the base in a clean way without depending on the internal
;; implementation details.
;;
;; Currently it only shows the bare basics in mode setup and how to
;; use the language constant system to change some of the keywords
;; that are recognized in various situations.

;; Note: The interface used in this file requires CC Mode 5.30 or
;; later.

;;; Code:

(require 'cc-mode)

;; These are only required at compile time to get the sources for the
;; language constants.  (The cc-fonts require and the font-lock
;; related constants could additionally be put inside an
;; (eval-after-load "font-lock" ...) but then some trickery is
;; necessary to get them compiled.)
(eval-when-compile
  (require 'cc-langs)
  (require 'cc-fonts))

(eval-and-compile
  ;; Make our mode known to the language constant system.  Use Java
  ;; mode as the fallback for the constants we don't change here.
  ;; This needs to be done also at compile time since the language
  ;; constants are evaluated then.
  (c-add-language 'sketch-mode 'java-mode))

(c-lang-defconst c-opt-cpp-symbol
  sketch (c-lang-const c-opt-cpp-symbol c))

(c-lang-defconst c-opt-cpp-prefix
  sketch (c-lang-const c-opt-cpp-prefix c))

(c-lang-defconst c-anchored-cpp-prefix
  sketch (c-lang-const c-anchored-cpp-prefix c))

(c-lang-defconst c-opt-cpp-start
  sketch (c-lang-const c-opt-cpp-start c))

(c-lang-defconst c-cpp-include-directives
  sketch (c-lang-const c-cpp-include-directives c))

(c-lang-defconst c-primitive-type-kwds
  sketch '("float" "int" "bit" "char" "double" "void"))

(c-lang-defconst c-modifier-kwds
  sketch '("harness" "generator"))

(c-lang-defconst c-type-modifier-prefix-kwds
  sketch '("global" "ref"))

(c-lang-defconst c-simple-stmt-kwds
  sketch '("assert" "assume" "return" "include" "pragma"))

(c-lang-defconst c-block-stmt-2-kwds
  sketch '("for" "if" "switch" "while" "repeat"))

(c-lang-defconst c-primary-expr-kwds
  sketch '("??"))

(c-lang-defconst c-class-decl-kwds
  sketch '("struct"))

(defcustom sketch-font-lock-extra-types nil
  "*List of extra types (aside from the type keywords) to recognize in SKETCH mode.
Each list item should be a regexp matching a single identifier.")

(defconst sketch-font-lock-keywords-1 (c-lang-const c-matchers-1 sketch)
  "Minimal highlighting for SKETCH mode.")

(defconst sketch-font-lock-keywords-2 (c-lang-const c-matchers-2 sketch)
  "Fast normal highlighting for SKETCH mode.")

(defconst sketch-font-lock-keywords-3 (c-lang-const c-matchers-3 sketch)
  "Accurate normal highlighting for SKETCH mode.")

(defvar sketch-font-lock-keywords sketch-font-lock-keywords-3
  "Default expressions to highlight in SKETCH mode.")

(defvar sketch-mode-syntax-table nil
  "Syntax table used in sketch-mode buffers.")
(or sketch-mode-syntax-table
    (setq sketch-mode-syntax-table
	      (funcall (c-lang-const c-make-mode-syntax-table sketch))))

(defvar sketch-mode-abbrev-table nil
  "Abbreviation table used in sketch-mode buffers.")
(c-define-abbrev-table
 'sketch-mode-abbrev-table
 ;; Keywords that if they occur first on a line might alter the
 ;; syntactic context, and which therefore should trig reindentation
 ;; when they are completed.
 '(("else" "else" c-electric-continued-statement 0)
   ("while" "while" c-electric-continued-statement 0)
   ("catch" "catch" c-electric-continued-statement 0)
   ("finally" "finally" c-electric-continued-statement 0)))

(defvar sketch-mode-map
  (let ((map (c-make-inherited-keymap)))
	;; Add bindings which are only useful for SKETCH
	map)
  "Keymap used in sketch-mode buffers.")

(easy-menu-define sketch-menu sketch-mode-map "SKETCH Mode Commands"
  ;; Can use `sketch' as the language for `c-mode-menu'
  ;; since its definition covers any language.  In
  ;; this case the language is used to adapt to the
  ;; nonexistence of a cpp pass and thus removing some
  ;; irrelevant menu alternatives.
  (cons "SKETCH" (c-lang-const c-mode-menu sketch)))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.sk\\'" . sketch-mode))

;;;###autoload
(defun sketch-mode ()
  "Major mode for editing SKETCH (pronounced \"big nose\") code.
This is a simple example of a separate mode derived from CC Mode to
support a language with syntax similar to C/C++/ObjC/Java/IDL/Pike.

The hook `c-mode-common-hook' is run with no args at mode
initialization, then `sketch-mode-hook'.

Key bindings:
\\{sketch-mode-map}"
  (interactive)
  (kill-all-local-variables)
  (c-initialize-cc-mode t)
  (set-syntax-table sketch-mode-syntax-table)
  (setq major-mode 'sketch-mode
	    mode-name "Sketch"
	    local-abbrev-table sketch-mode-abbrev-table
	    abbrev-mode t)
  (use-local-map c-mode-map)
  ;; `c-init-language-vars' is a macro that is expanded at compile
  ;; time to a large `setq' with all the language variables and their
  ;; customized values for our language.
  (c-init-language-vars sketch-mode)
  ;; `c-common-init' initializes most of the components of a CC Mode
  ;; buffer, including setup of the mode menu, font-lock, etc.
  ;; There's also a lower level routine `c-basic-common-init' that
  ;; only makes the necessary initialization to get the syntactic
  ;; analysis and similar things working.
  (c-common-init 'sketch-mode)
  (easy-menu-add sketch-menu)
  (run-hooks 'c-mode-common-hook)
  (run-hooks 'sketch-mode-hook)
  (c-update-modeline))

(provide 'sketch-mode)

;;; derived-mode-ex.el ends here
