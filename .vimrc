set nocompatible       
filetype off               

" set the runtime path to include Vundle and initialize
set backspace=indent,eol,start
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Install from command line
" vim +PluginInstall +qall

Plugin 'VundleVim/Vundle.vim'
Plugin 'morhetz/gruvbox'
Plugin 'vim-airline/vim-airline'
" Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'yggdroot/indentline'
Plugin 'lervag/vimtex'
Plugin 'junegunn/goyo.vim'
Plugin 'JuliaEditorSupport/julia-vim'
" Plugin 'valloric/youcompleteme'

call vundle#end()           
filetype plugin indent on  
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Syntax highlighting
syntax enable
filetype plugin indent on  

set number " show line numbers
set noswapfile " disable swap
set hlsearch " highlight all results
set ignorecase " ignore case in search
set incsearch " show search results as you type
set spell spelllang=en_us " spell check
" Gruvbox colorscheme
autocmd vimenter * ++nested colorscheme gruvbox
colorscheme gruvbox
"set background=dark
"let g:gruvbox_contrast_light="hard"
"highlight Normal ctermbg=NONE

" Remap
nnoremap <buffer> <F9> :w <bar> :exec '!python3' shellescape(@%, 1)<cr>

set tabstop=4
set shiftwidth=4
set expandtab

" Cheatsheet
" ----------
"
"  Actions
"  -------
"  d: delete
"  c: change
"  y: yank (copy)
"  v: visually select (V for line vs. character)

" Custom conceal
syntax match todoCheckbox "\[\ \]" conceal cchar=
syntax match todoCheckbox "\[x\]" conceal cchar=
syntax match todoCheckbox "\[-\]" conceal cchar=☒
syntax match todoCheckbox "\[\.\]" conceal cchar=⊡
syntax match todoCheckbox "\[o\]" conceal cchar=⬕
let b:current_syntax = "todo"
hi! link todoCheckbox normal
" call matchadd('Conceal', '<-\&<', 10, -1, {'conceal':'←'})
" call matchadd('Conceal', '<\zs-', 10, -1, {'conceal':' '})
"hi def link todoCheckbox Todo
set conceallevel=2
