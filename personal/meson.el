;; https://github.com/wentasah/meson-mode

(prelude-require-packages
 '(meson-mode))

(add-hook 'meson-mode-hook 'company-mode)
