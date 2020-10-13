;; https://github.com/FelipeLema/emacs-counsel-gtags
;;
;; (prelude-require-packages
;;  '(counsel-gtags))
;;
;; (add-hook 'c-mode-hook 'counsel-gtags-mode)
;;
;; (with-eval-after-load 'counsel-gtags
;;   ;;(define-key counsel-gtags-mode-map (kbd "M-.") 'counsel-gtags-find-definition)
;;   (define-key counsel-gtags-mode-map (kbd "M-.") 'counsel-gtags-dwim)
;;   (define-key counsel-gtags-mode-map (kbd "M-r") 'counsel-gtags-find-reference)
;;   (define-key counsel-gtags-mode-map (kbd "M-s") 'counsel-gtags-find-symbol)
;;   (define-key counsel-gtags-mode-map (kbd "M-,") 'counsel-gtags-go-backward))

;; https://github.com/leoliu/ggtags

(prelude-require-packages
 '(ggtags))

(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              (ggtags-mode 1))))
