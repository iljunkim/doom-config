;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;; (setq doom-font (font-spec :family "Fira Code" :size 14 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "Fira Sans" :size 15)
;;       doom-big-font (font-spec :family "Fire Code" :size 22))
;; ;
                                        ;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
;; Specify both a dark and light theme, like so and Doom will choose which one
;; to load based on your system light/dark setting:
;;
;;   (setq doom-theme '(doom-one   . doom-one-light))   ; (DARK . LIGHT)
;;
;; If you want more pro-active theme switching based on OS light/dark mode, look
;; up the `auto-dark' package.

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/org/")

;;
;; Local changes begin
;;

;; Inherit shell env variables
;;(when (memq window-system '(mac ns x))
;;  (exec-path-from-shell-initialize))

;;(setq doom-font (font-spec :family "Monaco" :size 15 :weight 'medium)
;;      doom-big-font (font-spec :family "Monaco" :size 20))

;; Set your monospace and variable-pitch fonts
(setq doom-font (font-spec :family "Monaco" :size 15 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Avenir Next" :size 18))

(after! org
  ;; Do not show emphasis-markers /*=+ ...
  (setq org-hide-emphasis-markers t)

  ;; Set the primary directory for your Org files
  (setq org-directory "~/Documents/org_notes")

  ;; Include all .org files in ~/Documents/org_notes in your Org Agenda
  (setq org-agenda-files (list "~/Documents/org_notes"))

  ;; Point default capture target file inside your org_notes folder
  (setq org-default-notes-file (expand-file-name "notes.org" org-directory)))

(after! org

  ;; Enable mixed-pitch in Org-mode
  (add-hook 'org-mode-hook #'mixed-pitch-mode)

;;  (add-hook! 'org-mode-hook
;;    (setq-local line-spacing 0.35)
;;    (variable-pitch-mode 0))
;;
  (add-hook 'org-mode-hook (lambda () (setq-local line-spacing 0.35)))

;; Configure Org-mode inline LaTeX snippet preview to output crisp PDFs/PNGs
  (setq org-format-latex-options
        (plist-put org-format-latex-options :scale 1.5)
        org-preview-latex-default-process 'dvisvgm)) ; Uses vector SVGs for crisp previews (or 'dvipng)

;; Configure mixed-pitch after it loads
(after! mixed-pitch
  (setq mixed-pitch-set-height t))

;; org-roam configuration
(after! org-roam
  ;; Point Org-roam to your specific notes subfolder
  (setq org-roam-directory (file-truename "~/Documents/org_notes/roam_notes"))

  ;; Automatically sync database on file changes
  (org-roam-db-autosync-mode))
;; Run to sync teh roam notes by ~/.config/emacs/bin/doom sync

;; outside of after! org-roam to make it work when emacs is launched.
(map! :map global-map
      :prefix "C-c n"
      :desc "Find node"          "f" #'org-roam-node-find
      :desc "Insert node"        "i" #'org-roam-node-insert
      :desc "Toggle buffer"      "b" #'org-roam-buffer-toggle
      :desc "Capture to node"    "c" #'org-roam-capture
      :desc "Show graph"         "g" #'org-roam-graph
      :desc "Sync database"      "s" #'org-roam-db-sync
      )

;; Set custom initial width (120 columns) and height (45 lines)
(add-to-list 'initial-frame-alist '(width . 100))
(add-to-list 'initial-frame-alist '(height . 50))

(add-to-list 'default-frame-alist '(width . 100))
(add-to-list 'default-frame-alist '(height . 50))

;; Let buffers always use the real path
(setq find-file-visit-truename t)

;; Use latexmk to compile LaTeX into PDF automatically
(after! ox-latex
;; Set default font size to 12pt (or change "article" to "extarticle" for 14pt+)
  (setq org-latex-default-class "extarticle")
  (add-to-list 'org-latex-classes
               '("extarticle"
                 "\\documentclass[14pt]{extarticle}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
;; Reduce page margins to 0.5 inches
  (add-to-list 'org-latex-packages-alist '("margin=0.5in" "geometry" nil) t)

  ;; To convert native unicodes to pdf
  (setq org-latex-compiler "xelatex")
  (setq org-latex-pdf-process
        '("latexmk -f -pdfxe -interaction=nonstopmode -output-directory=%o %f"))

  (add-to-list 'org-latex-packages-alist '("" "fontspec" t ("xelatex" "lualatex")) t)
  (add-to-list 'org-latex-packages-alist '("\\setmainfont{Lucida Grande}" "" nil) t)
  (add-to-list 'org-latex-packages-alist '("\\setsansfont{Lucida Grande}" "" nil) t)
  (add-to-list 'org-latex-packages-alist '("\\setmonofont{Menlo}" "" nil) t))

;; Redirect all LaTeX and PDF exports to /tmp
(defadvice! +org-export-output-file-name-to-tmp (orig-fn extension &optional subtreep pub-dir)
  :around #'org-export-output-file-name
  (let ((pub-dir (if (member extension '(".tex" ".pdf" ".epub")) "/tmp" pub-dir)))
    (funcall orig-fn extension subtreep pub-dir)))

(after! projectile
  ;; Set default build directory to 'build' for CMake projects
  (setq projectile-build-dir "build")

  ;; Register CMake as a project type with build commands pointing to build/
  (projectile-register-project-type 'cmake '("CMakeLists.txt")
                                    :configure "cmake -B build -S . -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
                                    :compile "cmake --build build"
                                    :test "ctest --test-dir build"
                                    :run "cmake --build build && ./build/my_program"))

(map! :leader
      :prefix "d"
      :desc "Start/restart" "d" #'dape
      :desc "Breakpoint"    "b" #'dape-breakpoint-toggle
      :desc "Continue"      "c" #'dape-continue
      :desc "Step over"     "n" #'dape-next
      :desc "Step in"       "i" #'dape-step-in
      :desc "Step out"      "o" #'dape-step-out
      :desc "REPL"          "r" #'dape-repl
      :desc "Quit"          "q" #'dape-quit)
(after! which-key
  (which-key-add-key-based-replacements "SPC d" "debug"))

;; devdocs, added (package! devdocs) in packages.el
(use-package! devdocs
  :commands (devdocs-lookup
             devdocs-search
             devdocs-install)
  :config
  (setq devdocs-window-select t))
(map! :leader
      :desc "DevDocs lookup" "o d" #'devdocs-lookup
      :desc "DevDocs search" "o D" #'devdocs-search)

;; Codex map
(defun my/codex ()
  "Launch Codex in vterm at the project root."
  (interactive)
  (require 'project)
  (require 'vterm)
  (let ((default-directory
         (if-let* ((project (project-current)))
             (project-root project)
           default-directory)))
    (vterm "*codex*")
    (vterm-send-string "codex")
    (vterm-send-return)))
(map! :leader
      :desc "Launch Codex" "o c" #'my/codex)

;; Anki
(use-package! anki-editor
  :after org
  :config
  ;; Automatically create decks if they don't exist in Anki
  (setq anki-editor-create-decks t)
  ;; Map Org mode tags directly to Anki tags
  (setq anki-editor-org-tags-as-anki-tags t)

  ;; Recommended: Define keybindings for common actions
  (map! :map org-mode-map
        :localleader
        :desc "Push notes to Anki" "a p" #'anki-editor-push-notes
        :desc "Insert Anki note"   "a i" #'anki-editor-insert-note
        :desc "Cloze region"       "a c" #'anki-editor-cloze-region))

;; ----------------------------------------
;; Spell checking: spell-fu + Hunspell
;; ----------------------------------------

;; Dictionary directory
(setenv "DICPATH"
        (expand-file-name "~/Library/Spelling"))

;; Hunspell configuration
(setq ispell-program-name "/opt/homebrew/bin/hunspell"
      ispell-dictionary "en_US"
      ispell-really-hunspell t)

;; spell-fu configuration
(after! spell-fu
  (setq spell-fu-idle-delay 0.5)
  ;; Define the path for your personal dictionary file
  (setq ispell-personal-dictionary (expand-file-name "personal-dict.pws" doom-user-dir))

  ;; Create the file if it doesn't exist yet (required by spell-fu)
  (unless (file-exists-p ispell-personal-dictionary)
    (with-temp-file ispell-personal-dictionary
      (insert "personal_ws-1.1 en 0\n")))

  ;; Register the personal dictionary with spell-fu
  (add-hook 'spell-fu-mode-hook
            (lambda ()
              (spell-fu-dictionary-add
               (spell-fu-get-personal-dictionary "en-personal" ispell-personal-dictionary)))))

;; Using macOS dictionary
(use-package! osx-dictionary
  :commands (osx-dictionary-search-word-at-point
             osx-dictionary-search-input)
  :init
  (map! :leader
        :desc "Dictionary: word at point"
        "s d" #'osx-dictionary-search-word-at-point

        :desc "Dictionary: enter word"
        "s D" #'osx-dictionary-search-input))
;;
;; Local changes end
;;

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
