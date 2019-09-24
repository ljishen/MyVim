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
Plugin 'morhetz/gruvbox'
Plugin 'ryanoasis/vim-devicons'
Plugin 'RRethy/vim-illuminate'

Plugin 'mbbill/undotree'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'MattesGroeger/vim-bookmarks'
Plugin 'vim-syntastic/syntastic'
Plugin 'tpope/vim-commentary'
Plugin 'google/vim-searchindex'
Plugin 'Yggdroot/indentLine'
Plugin 'terryma/vim-expand-region'
Plugin 'Raimondi/delimitMate'
Plugin 'sheerun/vim-polyglot'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'elzr/vim-json'
Plugin 'majutsushi/tagbar'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'Valloric/YouCompleteMe'

" ======================================================================================
" Add maktaba and codefmt to the runtimepath.
" (The latter must be installed before it can be used.)
Plugin 'google/vim-maktaba'
Plugin 'google/vim-codefmt'
" Also add Glaive, which is used to configure codefmt's maktaba flags. See
" `:help :Glaive` for usage.
Plugin 'google/vim-glaive'
" ======================================================================================

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


" ======================================================================================
" Basic Setup
" ======================================================================================

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

" Configure indentation for filetypes
" https://tedlogan.com/techblog3.html
autocmd FileType * set softtabstop=4 | set shiftwidth=4 | set expandtab
autocmd FileType c,make set tabstop=8 | set softtabstop=8 | set shiftwidth=8 | set noexpandtab

" No backup made
set nobackup
set nowritebackup

" Enables a menu at the bottom of the window
set wildmenu

" Enable 24-bit color
"   See https://github.com/tmux/tmux/issues/1246
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Need to set before the colorscheme
set t_Co=256

set fileformats=unix,dos,mac


" ======================================================================================
" vim-airline
" ======================================================================================

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

" Enable syntastic integration
let g:airline#extensions#syntastic#enabled = 1

" Syntastic error_symbol
let airline#extensions#syntastic#error_symbol = 'E:'

" Syntastic statusline error format (see |syntastic_stl_format|)
let airline#extensions#syntastic#stl_format_err = '%E{[%e(#%fe)]}'

" Syntastic warning
let airline#extensions#syntastic#warning_symbol = 'W:'

" Syntastic statusline warning format (see |syntastic_stl_format|)
let airline#extensions#syntastic#stl_format_err = '%W{[%w(#%fw)]}'


" ======================================================================================
" gruvbox
" ======================================================================================

set background=light
"#colorscheme gruvbox


" ======================================================================================
" undotree
" ======================================================================================

" Open undotree with Ctrl+h
map <C-h> :UndotreeToggle<CR>

" Enable the persistent undo
set undodir=~/.undodir/
set undofile


" ======================================================================================
" NERDTree
" ======================================================================================

" Open a NERDTree automatically when vim starts up
" Automatically move the cursor to the file editing area >
" https://stackoverflow.com/questions/24808932/vim-open-nerdtree-and-move-the-cursor-to-the-file-editing-area
"autocmd VimEnter * NERDTree | wincmd p

" Open a NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | wincmd p | endif

" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Open NERDTree with Ctrl+n
map <C-n> :NERDTreeToggle<CR>


" ======================================================================================
" ctrlp.vim
" ======================================================================================

" Open CtrlP with Ctrl+f
let g:ctrlp_map = '<c-f>'

" Ignore version control folders
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

" Overcome limit imposed by max height
let g:ctrlp_match_window = 'results:100'


" ======================================================================================
" vim-bookmarks
" ======================================================================================

highlight BookmarkSign ctermbg=NONE ctermfg=160
highlight BookmarkLine ctermbg=194 ctermfg=NONE
let g:bookmark_sign = '♥'
let g:bookmark_highlight_lines = 1

let g:bookmark_manage_per_buffer = 1

" Finds the Git super-project directory based on the file passed as an argument.
function! g:BMBufferFileLocation(file)
  let filename = 'vim-bookmarks'
  let location = ''
  if isdirectory(fnamemodify(a:file, ":p:h").'/.git')
    " Current work dir is git's work tree
    let location = fnamemodify(a:file, ":p:h").'/.git'
  else
    " Look upwards (at parents) for a directory named '.git'
    let location = finddir('.git', fnamemodify(a:file, ":p:h").'/.;')
  endif
  if len(location) > 0
    return simplify(location.'/.'.filename)
  else
    return simplify(fnamemodify(a:file, ":p:h").'/.'.filename)
  endif
endfunction


" ======================================================================================
" Syntastic
" ======================================================================================

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Aggregates errors found by all checkers in a single list
let g:syntastic_aggregate_errors = 1

" Add shortcut mappings for errors navigation
nmap <leader>n :lnext<CR>
nmap <leader>p :lprevious<CR>
nmap <leader>e :Errors<CR>
nmap <leader>q :lclose<CR>
nmap <F7> :SyntasticToggleMode<CR>

" Classpath to use
let g:syntastic_java_checkstyle_classpath = $CHECKSTYLE_JAR

" Path to the configuration file for the "-c" option (cf.
" http://checkstyle.sourceforge.net/cmdline.html#Command_line_usage)
let g:syntastic_java_checkstyle_conf_file = $CHECKSTYLE_CONFIG

" Tell syntastic which checker you want to run for .java file
let g:syntastic_java_checkers = ['checkstyle', 'javac']

" Include directories to be passed to the linter
let g:syntastic_c_include_dirs = ["includes", "headers"]

" Tell syntastic which checker you want to run for .c file
let g:syntastic_c_checkers = ['checkpatch', 'clang_check', 'cppcheck', 'gcc', 'make']

" File containing additional compilation flags to be passed to the GCC checker
" See
"   https://github.com/vim-syntastic/syntastic/blob/master/doc/syntastic-checkers.txt
let g:syntastic_c_config_file = '.syntastic_c_config'

" Use/Search compilation databases instead of passing compilation flags explicitly
" Check out the ClangCheck section from
"   https://github.com/vim-syntastic/syntastic/blob/master/doc/syntastic-checkers.txt
let g:syntastic_c_clang_check_post_args = ""

" Tell syntastic which checker you want to run for .cpp file
let g:syntastic_cpp_checkers = ['cppcheck', 'gcc']

" Tell syntastic which checker you want to run for .py file
let g:syntastic_python_checkers = ['bandit', 'flake8', 'python', 'pylint',
                                 \ 'pycodestyle', 'pydocstyle', 'mypy']

" Tell syntastic which checker you want to run for Dockerfile
let g:syntastic_filetype_map = { "Dockerfile": "dockerfile" }
let g:syntastic_dockerfile_checkers = ['hadolint']

" Tell syntastic which checker you wnat to run for sh
let g:syntastic_sh_checkers = ['sh', 'shellcheck']

" Tell syntastic which checker you wnat to run for ansible
let g:syntastic_ansible_checkers = ['ansible_lint']


" ======================================================================================
" vim-expand-region
" ======================================================================================

" Press + to expand the visual selection and _ to shrink it.


" ======================================================================================
" Vim Better Whitespace Plugin
" ======================================================================================

" Enable highlighting and stripping whitespace on save by default
let g:better_whitespace_enabled = 1
let g:strip_whitespace_on_save = 1

" Strip white lines at the end of the file when stripping whitespace
let g:strip_whitelines_at_eof=1

" Highlight space characters that appear before or in-between tabs
let g:show_spaces_that_precede_tabs=1


" ======================================================================================
" codefmt
" ======================================================================================

" Type :FormatCode <TAB> to list Formatters that apply to the current filetype.
" To use a particular formatter, type :FormatCode FORMATTER-NAME.

" the glaive#Install() should go after the "call vundle#end()"
"#call glaive#Install()
" Optional: Enable codefmt's default mappings on the <Leader>= prefix.
"#Glaive codefmt plugin[mappings]
"#Glaive codefmt google_java_executable=`"java -jar " . $GOOGLE_JAVA_FORMAT_JAR`

augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer yapf
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
augroup END


" ======================================================================================
" Tagbar
" ======================================================================================

nmap <F8> :TagbarToggle<CR>


" ======================================================================================
" YouCompleteMe
" ======================================================================================

" By default "YouCompleteMe" disables syntastic's checkers for the "c", "cpp", "objc",
" and "objcpp" filetypes, in order to allow its own checkers to run.
" Set this options to 0 to turns off YCM's diagnostic display features.
" See
"   https://github.com/vim-syntastic/syntastic/blob/master/doc/syntastic.txt
"   https://github.com/Valloric/YouCompleteMe#the-gycm_show_diagnostics_ui-option
let g:ycm_show_diagnostics_ui = 0
