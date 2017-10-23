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
Plugin 'google/vim-colorscheme-primary'
Plugin 'ryanoasis/vim-devicons'

Plugin 'mbbill/undotree'
Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'

Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'terryma/vim-expand-region'

Plugin 'vim-syntastic/syntastic'
Plugin 'elzr/vim-json'
Plugin 'ekalinin/Dockerfile.vim'

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
" Basic Setup
" =================================================================

" Map leader to ,
let mapleader=','

" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

" Switch on syntax highlighting
syntax on

" Precede each line with its line number
set number

" When there is a previous search pattern, highlight all its matches
set hlsearch

" Start search when you type the first character of the search string
set incsearch

" The screen will not be redrawn while executing macros,
" registers and other commands that have not been typed.
set lazyredraw

" Fix backspace indent
set backspace=indent,eol,start

" Indentation with spaces
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

" No backup made
set nobackup
set nowritebackup

" Enables a menu at the bottom of the window
set wildmenu

" Need to set before the colorscheme
set t_Co=256

set fileformats=unix,dos,mac


" =================================================================
" vim-airline
" =================================================================

" Always display the airline statusline
set laststatus=2

" It will automatically populate the `g:airline_symbols` dictionary with the powerline symbols
" https://github.com/vim-airline/vim-airline#integrating-with-powerline-fonts
let g:airline_powerline_fonts = 1

" Automatically displays all buffers when there's only one tab open.
let g:airline#extensions#tabline#enabled = 1

" Enable  displaying index of the buffer
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab

" Enable modified detection
let g:airline_detect_modified = 1

" Enable paste detection
let g:airline_detect_paste = 1

" Enable spell detection
let g:airline_detect_spell = 1

" display spelling language when spell detection is enabled
" (if enough space is available)
let g:airline_detect_spelllang = 1


" =================================================================
" vim-colorscheme-primary
" =================================================================

set background=light
"#colorscheme primary


" =================================================================
" undotree
" =================================================================

" Open undotree with Ctrl+h
map <C-h> :UndotreeToggle<cr>

" Enable the persistent undo
if has("persistent_undo")
  set undodir=~/.undodir/
  set undofile
endif


" =================================================================
" NERDTree
" =================================================================

" Open a NERDTree automatically when vim starts up
" Automatically move the cursor to the file editing area >
" https://stackoverflow.com/questions/24808932/vim-open-nerdtree-and-move-the-cursor-to-the-file-editing-area
autocmd VimEnter * NERDTree | wincmd p

" Open a NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | wincmd p | endif

" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Open NERDTree with Ctrl+n
map <C-n> :NERDTreeToggle<CR>


" =================================================================
" ctrlp.vim
" =================================================================

" Open CtrlP with Ctrl+f
let g:ctrlp_map = '<c-f>'

" Ignore version control folders
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'


" =================================================================
" Indent Guides
" =================================================================

" Have indent guides enabled by default
let g:indent_guides_enable_on_vim_startup = 1

" Start showing guides from indent level 2
let g:indent_guides_start_level = 2

let g:indent_guides_guide_size = 1


" =================================================================
" vim-expand-region
" =================================================================

" Press + to expand the visual selection and _ to shrink it.


" =================================================================
" Syntastic
" =================================================================

set statusline+=%#warningmsg#
"#set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
