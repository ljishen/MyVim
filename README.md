# MyVim [![](https://images.microbadger.com/badges/version/ljishen/my-vim:1.3.svg)](https://microbadger.com/images/ljishen/my-vim:1.3)

## Screenshot

![screenshot](https://user-images.githubusercontent.com/468515/71551293-d3004700-2998-11ea-8b9b-54cb4f062966.png)


## Usage

1. Choose and install any one of patched-fonts from [ryanoasis/nerd-fonts/patched-fonts/](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts)

2. Run within docker container
   ```bash
   docker run --rm -ti ljishen/my-vim
   ```

3. You can also install to local host
   ```bash
   source scripts/debian_install.sh
   ```


## Bundled Plugins

- [[vim-airline](https://github.com/vim-airline/vim-airline)] Lean & mean status/tabline for vim that's light as air.
- [[vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)] A collection of themes for vim-airline.
- [[onedark.vim](https://github.com/joshdick/onedark.vim)] A dark Vim/Neovim color scheme inspired by Atom's One Dark syntax theme.
- [[vim-devicons](https://github.com/ryanoasis/vim-devicons)] Adds file type glyphs/icons to popular Vim plugins.
- [[vim-illuminate](https://github.com/RRethy/vim-illuminate)] Vim plugin for selectively illuminating other uses of current word under the cursor.
- [[undotree](https://github.com/mbbill/undotree)] The ultimate undo history visualizer for VIM.
- [[nerdtree](https://github.com/scrooloose/nerdtree)] A tree explorer plugin for vim.
- [[nerdtree-git-plugin](https://github.com/Xuyuanp/nerdtree-git-plugin)] A plugin of NERDTree showing git status flags.
- [[ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim)] Full path fuzzy file, buffer, mru, tag, ... finder for Vim.
- [[vim-bookmarks](https://github.com/MattesGroeger/vim-bookmarks)] This vim plugin allows toggling bookmarks per line. A quickfix window gives access to all bookmarks. Annotations can be added as well.
- [[syntastic](https://github.com/vim-syntastic/syntastic)] Syntax checking hacks for vim.
- [[vim-polyglot](https://github.com/sheerun/vim-polyglot)] A collection of language packs for Vim.
- [[vim-json](https://github.com/elzr/vim-json)] Distinct highlighting of keywords vs values, JSON-specific (non-JS) warnings, quote concealing.
- [[indentLine](https://github.com/Yggdroot/indentLine)] Show vertical lines for indent with conceal feature.
- [[auto-pairs](https://github.com/jiangmiao/auto-pairs)] Insert or delete brackets, parens, quotes in pair.
- [[vim-better-whitespace](https://github.com/ntpeters/vim-better-whitespace)] Better whitespace highlighting for Vim.
- [[vim-expand-region](https://github.com/terryma/vim-expand-region)] Vim plugin that allows you to visually select increasingly larger regions of text using the same key combination.
- [[tagbar](https://github.com/majutsushi/tagbar)] Vim plugin that displays tags in a window, ordered by scope.
- [[vim-gutentags](https://github.com/ludovicchabant/vim-gutentags)] A Vim plugin that manages your tag files.
- [[gutentags_plus](https://github.com/skywind3000/gutentags_plus)] The right way to use gtags with gutentags.
- [[YouCompleteMe](https://github.com/Valloric/YouCompleteMe)] A code-completion engine for Vim.
- [[YCM-Generator](https://github.com/rdnetto/YCM-Generator)] Generates config files for YouCompleteMe.
- [[vim-commentary](https://github.com/tpope/vim-commentary)] Comment stuff out.
- [[vim-searchindex](https://github.com/google/vim-searchindex)] Display number of search matches & index of a current match.
- [[vim-smoothie](https://github.com/psliwka/vim-smoothie)] Smooth scrolling for Vim done right.
- [[vim-startify](https://github.com/mhinz/vim-startify)] It provides dynamically created headers or footers and uses configurable lists to show recently used or bookmarked files and persistent sessions.
- [[vim-visual-star-search](https://github.com/nelstrom/vim-visual-star-search)] Allow you to select some text using Vim's visual mode and then hit *
and # to search for it elsewhere in the file.
- [[vim-fugitive](https://github.com/tpope/vim-fugitive)] A Git wrapper written as a plugin for the Vim text editor.
- [[vim-codefmt](https://github.com/google/vim-codefmt)] codefmt is a utility for syntax-aware code formatting.
