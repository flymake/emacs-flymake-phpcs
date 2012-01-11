;;; flymake-phpcs.el --- Flymake handler for PHP to invoke PHP-CodeSniffer
;;
;; Copyright (C) 2011-2012  Free Software Foundation, Inc.
;;
;; Author: Sam Graham <libflymake-phpcs-emacs BLAHBLAH illusori.co.uk>
;; Maintainer: Sam Graham <libflymake-phpcs-emacs BLAHBLAH illusori.co.uk>
;; URL: https://github.com/illusori/emacs-flymake-phpcs
;; Version: 1.0.1
;; Package-Requires: ((flymake "0.3"))
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;
;;; Commentary:
;;
;; flymake-phpcs.el adds support for running PHP_CodeSniffer
;; (http://pear.php.net/package/PHP_CodeSniffer/) to perform static
;; analysis of your PHP file in addition to syntax checking.
;;
;;; Usage:
;; (require 'flymake-phpcs)

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
        (list local-file (concat "--standard="
          ;; Looking for "/" is hardly portable
          (if (string-match "/" flymake-phpcs-standard)
            (expand-file-name flymake-phpcs-standard)
            flymake-phpcs-standard)))))
      )
    (add-hook 'php-mode-hook (lambda() (flymake-mode 1)))
    )
  )

(provide 'flymake-phpcs)
;;; flymake-phpcs.el ends here
