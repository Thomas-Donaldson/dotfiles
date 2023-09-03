#!/bin/bash

ln -sbft "/home/trd/.emacs.d/" \
         "/home/trd/dotfiles/early-init.el" \
	     "/home/trd/dotfiles/init.el"


ln -sbft "/home/trd/" \
	     "/home/trd/dotfiles/.vimrc" \
	     "/home/trd/dotfiles/.inputrc" \
	     "/home/trd/dotfiles/.bashrc" \
	     "/home/trd/dotfiles/.gitconfig"
