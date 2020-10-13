(menu-bar-mode -1)
(tool-bar-mode -1)

(global-nlinum-mode -1)

(when (display-graphic-p)
  (unless (frame-parameter nil 'fullscreen)
    (toggle-frame-maximized))
  (set-frame-font "JetBrains Mono NL:size=12"))

(prelude-require-packages
 '(all-the-icons
   doom-modeline))

(doom-modeline-mode 1)
