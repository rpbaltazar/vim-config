" bring in the bundles for mac and windows
set rtp+=~/.vim/vundle.git/
call vundle#rc()

runtime! common_config/*.vim
runtime! custom_config/*.vim

" for git, add spell checking and automatic wrapping at 72 columns
autocmd Filetype gitcommit setlocal spell textwidth=72

colorscheme Tomorrow-Night-Eighties
set gfn=Inconsolata:h15

au BufNewFile,BufRead *.ejs set filetype=html

" https://github.com/suan/vim-instant-markdown
filetype plugin on
