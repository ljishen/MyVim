set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Keep Plugin commands between vundle#begin/end.

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'google/vim-colorscheme-primary'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


" =================================================================
" vim-airline
" =================================================================

" It will automatically populate the `g:airline_symbols` dictionary with the powerline symbols
" https://github.com/vim-airline/vim-airline#integrating-with-powerline-fonts
let g:airline_powerline_fonts = 1

" Automatically displays all buffers when there's only one tab open.
let g:airline#extensions#tabline#enabled = 1


" =================================================================
" Miscellaneous
" =================================================================

set t_Co=256
set encoding=utf-8

" Switch on syntax highlighting
syntax enable

" Precede each line with its line number
set number

" When there is a previous search pattern, highlight all its matches
set hlsearch

" Start search when you type the first character of the search string
set incsearch

" The screen will not be redrawn while executing macros,
" registers and other commands that have not been typed.
set lazyredraw

" Indentation without hard tabs
set expandtab
set shiftwidth=4
set softtabstop=4

" Always display the status line
set laststatus=2

" No backup made
set nobackup
set nowritebackup

" Enables a menu at the bottom of the window
set wildmenu


" =================================================================
" vim-colorscheme-primary
" =================================================================

set background=light
"#colorscheme primary
