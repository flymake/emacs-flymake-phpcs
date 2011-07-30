;; A replcement flymake handler for PHP to invoke PHP-CodeSniffer
;;
;; This makes use of features in my fork of flymake.el found at:
;;   https://github.com/illusori/emacs-flymake
;;
;; Author: Sam Graham <libflymake-phpcs-emacs BLAHBLAH illusori.co.uk>
;; Homepage: https://github.com/illusori/emacs-flymake-phpcs
;;
;; Usage:
;;   (require 'flymake-phpcs)

(defcustom flymake-phpcs-command "phpcs_flymake"
  "If phpcs_flymake isn't in your $PATH, set this to the command needed to run it."
  :group 'flymake-phpcs
  :type 'string)

(defcustom flymake-phpcs-standard "PEAR"
  "The coding standard to pass to phpcs via --standard."
  :group 'flymake-phpcs
  :type 'string)

(eval-after-load "flymake"
  '(progn
    ;; Add a new error pattern to catch PHP-CodeSniffer output
    (add-to-list 'flymake-err-line-patterns
                 '("\\(.*\\):\\([0-9]+\\):\\([0-9]+\\): \\(.*\\)" 1 2 3 4))
    (defun flymake-php-init ()
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
                          (if (fboundp 'flymake-create-temp-copy)
                            'flymake-create-temp-copy
                            'flymake-create-temp-inplace)))
             (local-file (file-relative-name temp-file
                           (file-name-directory buffer-file-name))))
      (list flymake-phpcs-command
        (list local-file (concat "--standard=" flymake-phpcs-standard))))
      )
    (add-hook 'php-mode-hook (lambda() (flymake-mode 1)))
    )
  )

(provide 'flymake-phpcs)
