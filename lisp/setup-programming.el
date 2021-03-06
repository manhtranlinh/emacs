;; package --- Summary
;;; Commentary:
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGE: yasnippet* ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package yasnippet
  ;; :init
  ;; if put snippets at the custom directories, need to define yas-snippet-dirs explicitly
  ;; (add-to-list 'load-path "~/.emacs.d/snippets")
  ;; (setq yas-snippet-dirs '("~/.emacs.d/snippets") ;; personal snippets
  ;; )
  :hook ((prog-mode . yas-minor-mode)
         (snippet-mode . yas-minor-mode)
         (text-mode . yas-minor-mode)
         (conf-mode . yas-minor-mode))
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :after yasnippet)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PACKAGE: company              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package company
  :diminish company-mode
  :init
  (setq company-minimum-prefix-length 2)
  (setq company-idle-delay 0.2)
  (setq company-transformers '(company-sort-prefer-same-case-prefix))
  :config (global-company-mode) (with-eval-after-load 'yasnippet
    (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends)))
  )

(use-package company-box
  :diminish company-box-mode
  :hook (company-mode . company-box-mode)
  :after company)

;; Add yasnippet support for all company backends
;; https://github.com/syl20bnr/spacemacs/pull/179
(defvar company-mode/enable-yas t "Enable yasnippet for all backends.")

(defun company-mode/backend-with-yas (backend)
  (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
      backend
    (append (if (consp backend) backend (list backend))
            '(:with company-yasnippet))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; config helm* packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package helm
  :demand t
  :diminish helm-mode
  :init
  (setq helm-M-x-fuzzy-match t
        helm-buffers-fuzzy-matching t
        helm-apropos-fuzzy-match t
        helm-recentf-fuzzy-match t)
  :bind (("M-x" . helm-M-x)
         ("M-y" . helm-show-kill-ring)
         ("C-x b" . helm-mini)
         ("C-x r b" . helm-filtered-bookmarks)
         ("C-x C-f" . helm-find-files)
         ("C-x f" . helm-recentf)
         ("C-h a" . helm-apropos)
         :map helm-map
         ("TAB" . helm-execute-persistent-action)
         ("C-i" . helm-execute-persistent-action)
         ("C-z" . helm-select-action))
  :bind-keymap ("C-c h" . helm-command-prefix)
  :config
  (setq helm-scroll-amount 4 ; scroll 4 lines other window using M-<next>/M-<prior>
        helm-split-window-in-side-p t ;;open helm buffer inside current window, not occupy whole other window
        helm-ff-filename-history-use-recentf t
        helm-ff-search-library-in-sexp t
        helm-move-to-line-cycle-in-source t) ;;move to end or beginning of source when reaching top or bottom of source.
  (helm-mode 1)
  (helm-autoresize-mode 1)
  (global-unset-key (kbd "C-x c")))

;;Config Helm-ag
(use-package helm-ag
  :bind ("s-f" . helm-ag))

(use-package helm-icons
  :config
  (helm-icons-enable))

;; Hook mode vi du nhu paredit-mode khoi dong cung emacs
(use-package paredit
  :hook (emacs-lisp-mode . paredit-mode)
  :hook (scheme-mode . paredit-mode))

;;Cau hinh Magit
(use-package magit
  :bind ("C-x g" . magit-status))

;; Hook helm variable-pitch-mode
(use-package org
  :hook (org-mode . variable-pitch-mode))

;; Config package search rg 
(use-package rg
  :bind ("s-r" . rg))

;; Config for Scheme in course SICP
(setq scheme-program-name "/usr/local/bin/stk-simply")

(define-key global-map (kbd "s-c") 'kill-ring-save)

(use-package flycheck
  :hook (prog-mode . flycheck-mode))

(use-package elixir-mode
  :mode ("\\.ex\\'" "\\.exs\\'" "mix\\.lock\\'")
  :bind (:map elixir-mode-map
              ("C-c C-f" . elixir-format))
  )

;; Config for elixir and eex 
(use-package lsp-mode
  :commands lsp
  :ensure t
  :diminish lsp-mode
  :hook
   (elixir-mode . lsp)
  :init
  (add-to-list 'exec-path "/home/linh/bin/elixir-ls-1.10.4"))

(add-hook 'elixir-mode-hook 'electric-pair-mode)

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-file-watch-ignored ".elixir_ls$")
  (add-to-list 'lsp-file-watch-ignored "deps$")
  (add-to-list 'lsp-file-watch-ignored "_build$"))
(add-hook 'lsp-after-initialize-hook
	  (lambda () (lsp-register-custom-settings '(("elixirLS.projectDir" lsp-elixir-project-dir)))))

(use-package web-mode
  :mode (("\\.html\\.erb\\'" . web-mode)
         ("\\.eex\\'" . web-mode))
  :config (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2))


;;Config for org-mode
(defconst *is-a-mac* (eq system-type 'darwin))
(load "~/.emacs.d/lisp/init-org.el")

(use-package json-mode)
(global-set-key (kbd "C-c C-c") 'comment-region)
(global-set-key (kbd "C-c C-u") 'uncomment-region)

(provide 'setup-programming)
;;; setup-programming.el ends here
