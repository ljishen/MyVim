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
Plugin 'mbbill/undotree'
Plugin 'scrooloose/nerdtree'
Plugin 'terryma/vim-expand-region'
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
" vim-airline
" =================================================================

" Always display the airline statusline
set laststatus=2

" It will automatically populate the `g:airline_symbols` dictionary with the powerline symbols
" https://github.com/vim-airline/vim-airline#integrating-with-powerline-fonts
let g:airline_powerline_fonts = 1

" Automatically displays all buffers when there's only one tab open.
let g:airline#extensions#tabline#enabled = 1

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
" Indent Guides
" =================================================================

" Have indent guides enabled by default
let g:indent_guides_enable_on_vim_startup = 1


" =================================================================
" undotree
" =================================================================

nnoremap <F5> :UndotreeToggle<cr>

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
" vim-expand-region
" =================================================================

" Press + to expand the visual selection and _ to shrink it.


" =================================================================
" vim-colorscheme-primary
" =================================================================

set background=light
"#colorscheme primary


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

" No backup made
set nobackup
set nowritebackup

" Enables a menu at the bottom of the window
set wildmenu
