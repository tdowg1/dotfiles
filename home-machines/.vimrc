" 
" SEE ALSO : /etc/vim/*
" 
syntax on
se nu
set tabstop=3

" set expandtab
set smarttab
set shiftwidth=3
set shiftround
set autoindent
highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
colors ron
set hlsearch
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2
au BufReadPost,FileReadPost * syntax match Tab /        /
hi Tab gui=underline guifg=blue ctermbg=blue
filetype plugin indent on
syntax enable

:source $VIMRUNTIME/menu.vim
:set wildmenu
:set cpo-=<
:set wcm=<C-Z>
:map <F4> :emenu <C-Z>


" (me!) add from gVim
set gfn=Terminus\ 13


set bg=light

set paste

" 2012-03-02 from /etc/vim/vimrc
" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif
" /2012-03-02 from /etc/vim/vimrc

