"system
set nocompatible
set hidden
set encoding=utf-8
set noswapfile

"indentation
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

"folding
"set foldmethod=indent
"set foldlevelstart=99
set nofoldenable

"ui
set number
set linebreak
syntax on
filetype on

"keybinds
set backspace=indent,eol,start

"search
set hlsearch
nnoremap <silent> <space> :nohlsearch<cr><space>
set ignorecase
set incsearch
set smartcase
