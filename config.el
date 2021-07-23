;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Matt McFadden"
      user-mail-address "matt.mcfadden@tealdrones.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(map! "C-z" #'undo)

(map! "<kp-right>"         #'windmove-right)
(map! "<kp-left>"          #'windmove-left)
(map! "<kp-up>"            #'windmove-up)
(map! "<kp-down>"          #'windmove-down)

;(map! "<kp-divide><kp-divide>" #'buffer---menu)
(map! "<kp-divide><kp-divide>" #'ibuffer)

(map! "<kp-divide><up>" #'split-window-vertically)
(map! "<kp-divide><down>" #'split-window-vertically)
(map! "<kp-divide><right>" #'split-window-horizontally)
(map! "<kp-divide><left>" #'split-window-horizontally)

(map! "<kp-divide><deletechar>" #'delete-window)

(map! "<C-kp-down>"  #'shrink-window)
(map! "<C-kp-up>"    #'enlarge-window)
(map! "<C-kp-right>" #'enlarge-window-horizontally)
(map! "<C-kp-left>"  #'shrink-window-horizontally)

(map! "M-n" #'scroll-up-line)
(map! "M-p" #'scroll-down-line)

(map! "<kp-divide><kp-subtract>" #'kill-whole-line)
(map! "<kp-subtract>" #'kill-whole-line)
(map! "<kp-multiply>" #'yank)


;;  copy-line
;;====================================================================
;;(defun copy-line (&optional arg)
;;  "Do a kill-line but copy rather than kill.  This function directly calls
;;kill-line, so see documentation of kill-line for how to use it including prefix
;;argument and relevant variables.  This function works by temporarily making the
;;buffer read-only, so I suggest setting kill-read-only-ok to t."
;;  (interactive "P")
;;  (toggle-read-only 1)
;;  (kill-line arg)
;;  (toggle-read-only 0))

(defun copy-line (arg)
    "Copy lines (as many as prefix argument) in the kill ring.
      Ease of use features:
      - Move to start of next line.
      - Appends the copy on sequential calls.
      - Use newline as last char even on the last line of the buffer.
      - If region is active, copy its lines."
    (interactive "p")
    (let ((beg (line-beginning-position))
          (end (line-end-position arg)))
      (when mark-active
        (if (> (point) (mark))
            (setq beg (save-excursion (goto-char (mark)) (line-beginning-position)))
          (setq end (save-excursion (goto-char (mark)) (line-end-position)))))
      (if (eq last-command 'copy-line)
          (kill-append (buffer-substring beg end) (< end beg))
        (kill-ring-save beg end)))
    (kill-append "\n" nil)
    (beginning-of-line (or (and arg (1+ arg)) 2))
    (if (and arg (not (= 1 arg))) (message "%d lines copied" arg)))

(map! "<kp-add>" #'copy-line)
