(setq gc-cons-threshold (expt 10 8)
	  read-process-output-max (expt 10 6))

(setq-default frame-inhibit-implied-resize t
			  mode-line-format nil)

(setq inhibit-compacting-font-caches t)

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
(push '(horizontal-scroll-bars . nil) default-frame-alist)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
