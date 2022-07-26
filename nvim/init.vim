set nocompatible
set encoding=utf-8

" Allow project specific config by ".exrc" file
" Beware that this is inherently unsafe (you can end up executing some random
" ".exrc" containing weird stuff)
set secure
set exrc

" set <leader> to SpaceBar
let mapleader = " "

" Line numbering
set number relativenumber

" Tab + indentation (probably should move this to per-project config)
set tabstop=4 softtabstop=4 shiftwidth=4
set expandtab
set smartindent

" Show tab characters and trailing spaces
set list
set listchars+=tab:>\ ,trail:⋅

" Keep 8 lines above/below cursor
set scrolloff=8

" Searching
set ignorecase smartcase
set nohlsearch " stop higlight after search
set incsearch " incremental search

" History stuffz
set noswapfile
set nobackup
set undodir=~/.nvim/undodir
set undofile

" Color column
set colorcolumn=80

" Completion stuff
set completeopt=menuone,noinsert,noselect

" Pls no bell
set noerrorbells

" Keep buffers in background
set hidden

" Cmdline and sidebar stuff
set cmdheight=2
set signcolumn=yes

" Finally source the "plugins.vim"
source ~/.config/nvim/plugins.vim
