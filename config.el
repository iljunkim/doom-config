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
;;

;; Inherit shell env variables
;;(when (memq window-system '(mac ns x))
;;  (exec-path-from-shell-initialize))

(setq doom-font (font-spec :family "Monaco" :size 14 :weight 'medium)
      doom-big-font (font-spec :family "Monaco" :size 20))

(after! org
  ;; Set the primary directory for your Org files
  (setq org-directory "~/Documents/org_notes")

  ;; Include all .org files in ~/Documents/org_notes in your Org Agenda
  (setq org-agenda-files (list "~/Documents/org_notes"))

  ;; Point default capture target file inside your org_notes folder
  (setq org-default-notes-file (expand-file-name "notes.org" org-directory)))

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

;; ;; Correct path to Homebrew LLVM/LLDB bin
;; (add-to-list 'exec-path "/opt/homebrew/opt/lldb/bin")

;; 1. Use Doom's built-in autoload wrapper for starting the debugger
(map! :leader
      :prefix ("o d" . "debugger")
      :desc "Start Debugger"     "d" #'+debugger/start
      :desc "Toggle Breakpoint"  "b" #'dape-breakpoint-toggle
      :desc "Disconnect"         "q" #'dape-disconnect
      :desc "DAP Hydra Controls" "h" #'dape-hydra)

;; ;; 2. Configure dap-mode settings strictly INSIDE after! dap-mode
;; (after! dap-mode
;;   (dap-ui-mode 1)
;;   (dap-tooltip-mode 1)
;;   (require 'dap-lldb)

;;   ;; Point to Homebrew's lldb-dap executable
;;   (setq dap-lldb-debug-program '("/opt/homebrew/opt/lldb/bin/lldb-dap"))

;;   ;; Register C++ debug template
;;   (dap-register-debug-template
;;    "LLDB: Debug C++ Binary"
;;    (list :type "lldb"
;;          :request "launch"
;;          :name "LLDB: Launch"
;;          :program (lambda ()
;;                     (read-file-name "Select executable: "
;;                                     (concat (projectile-project-root) "build/")))
;;          :cwd "${workspaceFolder}"
;;          :stopOnEntry nil)))



;; Set custom initial width (120 columns) and height (45 lines)
(add-to-list 'initial-frame-alist '(width . 120))
(add-to-list 'initial-frame-alist '(height . 60))

(add-to-list 'default-frame-alist '(width . 120))
(add-to-list 'default-frame-alist '(height . 60))

;; Enable Flycheck integration with Eglot
(use-package! flycheck-eglot
  :after (eglot flycheck)
  :config
  (global-flycheck-eglot-mode 1))

;; Force Flycheck C/C++ checkers to use C++20 for standalone passes
(after! flycheck
  (setq flycheck-gcc-language-standard "c++20"
        flycheck-clang-language-standard "c++20")
  (add-to-list 'flycheck-clang-args "-std=c++20")
  (add-to-list 'flycheck-gcc-args "-std=c++20"))


(after! eglot
  (add-to-list 'eglot-server-programs
               '((c++-mode c-mode) . ("clangd" "--extra-arg=-std=c++20" "--background-index"))))
(after! eglot
  (set-eglot-client! '(c++-mode c-mode)
                     '("clangd"
                       "--extra-arg=-std=c++20"
                       "--background-index"
                       "--clang-tidy")))

;; Use latexmk to compile LaTeX into PDF automatically
(after! ox-latex
  (setq org-latex-pdf-process
        '("latexmk -f -pdf -%latex -interaction=nonstopmode -output-directory=%o %f")))

;; Configure Org-mode inline LaTeX snippet preview to output crisp PDFs/PNGs
(after! org
  (setq org-format-latex-options
        (plist-put org-format-latex-options :scale 1.5)
        org-preview-latex-default-process 'dvisvgm)) ; Uses vector SVGs for crisp previews (or 'dvipng)


(after! projectile
  ;; Set default build directory to 'build' for CMake projects
  (setq projectile-build-dir "build")

  ;; Register CMake as a project type with build commands pointing to build/
  (projectile-register-project-type 'cmake '("CMakeLists.txt")
                                    :configure "cmake -B build -S . -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
                                    :compile "cmake --build build"
                                    :test "ctest --test-dir build"
                                    :run "cmake --build build && ./build/my_program"))

(after! dap-mode
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)

  ;; Specify path to Apple's native lldb-dap binary
  (setq dap-lldb-debug-program '("/Library/Developer/CommandLineTools/usr/bin/lldb-dap"))

  ;; Register C++ debugging template
  (dap-register-debug-template
   "LLDB: Debug C++ Binary"
   (list :type "lldb"
         :request "launch"
         :name "LLDB: Launch"
         :program (lambda ()
                    (read-file-name "Select executable: "
                                    (concat (projectile-project-root) "build/")))
         :cwd "${workspaceFolder}"
         :stopOnEntry nil)))


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
