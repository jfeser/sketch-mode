(require 'cc-mode)

(eval-when-compile
  (require 'cc-langs)
  (require 'cc-fonts))

(eval-and-compile
  (c-add-language 'sketch-mode 'java-mode))

(c-lang-defconst c-primitive-type-kwds
  sketch '("float" "int" "bit" "char" "double" "void"))

(c-lang-defconst c-modifier-kwds
  sketch '("generator" "harness"))

(c-lang-defconst c-class-decl-kwds
  sketch '("struct" "adt"))

(c-lang-defconst c-block-stmt-1-kwds
  sketch '("do" "else"))

(c-lang-defconst c-block-stmt-2-kwds
  sketch '("for" "if" "switch" "while" "repeat"))

(c-lang-defconst c-opt-cpp-symbol
  sketch "#")

(c-lang-defconst c-simple-stmt-kwds
  sketch '("assert" "assume" "return"))

(defvar sketch-keywords
  '("assert" "new" "include" "extends" "ref"))

(defconst sketch-font-lock-keywords-1 (c-lang-const c-matchers-1 sketch)
  "Minimal highlighting for Sketch mode.")

(defconst sketch-font-lock-keywords-2 (c-lang-const c-matchers-2 sketch)
  "Fast normal highlighting for Sketch mode.")

(defconst sketch-font-lock-keywords-3 (c-lang-const c-matchers-3 sketch)
  "Accurate normal highlighting for Sketch mode.")

(defvar sketch-font-lock-keywords sketch-font-lock-keywords-3
  "Default expressions to highlight in Sketch mode.")

;;;###autoload

;;;###autoload
(defun sketch-mode ()
  "Major mode for editing Sketch code."
  (interactive)
  (kill-all-local-variables)
  (c-initialize-cc-mode t)
  (setq major-mode 'sketch-mode
	mode-name "Sketch")
  (use-local-map c-mode-map)
  (c-init-language-vars sketch-mode)
  (c-common-init 'sketch-mode)
  (c-update-modeline))

(provide 'sketch-mode)
;;; sketch-mode.el ends here
