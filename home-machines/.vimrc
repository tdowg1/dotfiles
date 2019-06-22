"
" SEE ALSO : /etc/vim/*
"
"

" 2012-08-07 use Vundle ( src : https://github.com/gmarik/vundle/blob/master/doc/vundle.txt )
"set nocompatible               " be iMproved
filetype off                   " required!


" GOTTA RUN :PluginInstall whenever Bundle/Plugins are added to this file and for each machine that I havent ran it on after doing the same thing.
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

"
" tdowg1's Bundles here:
" Solarized : http://ethanschoonover.com/solarized/vim-colors-solarized
Bundle 'Solarized'


"" [Vundle Developer's] Bundles here:
""
"" original repos on github
"Bundle 'Lokaltog/vim-easymotion'
"Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
"Bundle 'tpope/vim-rails.git'
"" vim-scripts repos
"Bundle 'L9'
"Bundle 'FuzzyFinder'
"Bundle 'rails.vim'
"" non github repos
"Bundle 'git://git.wincent.com/command-t.git'
"" ...

"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after ('after'? you mean, 'trailing'?) Bundle command are not allowed..
" /2012-08-07 use Vundle


" 2019-05-11: following write up at : https://realpython.com/vim-and-python-a-match-made-in-heaven/
" this makes code folding work the way youd expect it to:
Plugin 'tmhedberg/SimpylFold'

" The best plugin for Python auto-complete is YouCompleteMe:
Bundle 'Valloric/YouCompleteMe'
" ^^^Under the hood, YouCompleteMe uses a few different auto-completers
" (including Jedi for Python), and it needs some C libraries to be installed
" for it to work correctly. The docs have very good installation instructions:
"    https://github.com/Valloric/YouCompleteMe#mac-os-x-super-quick-installation
" so be sure you follow them.
"    for most of my machines, this should work:
"       sudo apt install build-essential cmake python3-dev
"       cd ~/.vim/bundle/YouCompleteMe
"       python3 install.py --clang-completer


" The first line ensures that the auto-complete window goes away when you’re
" done with it, and the second defines a shortcut for goto definition.
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>


" One issue with the goto definition above is that VIM, by default, doesnt
" know anything about virtualenv, so you have to make VIM and YouCompleteMe
" aware of your virtualenv by adding the following lines of code to .vimrc:

" python with virtualenv support
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

" ^^^This determines if you are running inside a virtualenv, switches to
" that specific virtualenv, and then sets up your system path so that
" YouCompleteMe will find the appropriate site packages.


" You can have VIM check your syntax on each save with the syntastic
" extension:
Plugin 'vim-syntastic/syntastic'

" Also add PEP 8 checking with this nifty little plugin:
Plugin 'nvie/vim-flake8'


let python_highlight_all=1



" Color schemes work in conjunction with the basic color scheme that you are
" using. Check out solarized for GUI mode, and Zenburn for terminal mode:
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'

" Then, just add a bit of logic to define which scheme to use based upon the
" VIM mode:
if has('gui_running')
  set background=dark
  colorscheme solarized
else
  colorscheme zenburn
endif


" Solarized also ships with a dark and light theme. To make switching between
call togglebg#map("<F5>")   " them very easy with F5


" If you want a proper file tree, then NERDTree is the way to go:
Plugin 'scrooloose/nerdtree'  " :NERDTree [startdirectory | bookmark]
" https://www.pkimber.net/howto/vim/plugin/nerd-tree.html
map <F2> :NERDTreeToggle<CR>


" If you want to use tabs, utilize vim-nerdtree-tabs:
Plugin 'jistr/vim-nerdtree-tabs'

" Want to hide .pyc files? Then add the following line:
let NERDTreeIgnore=['\.pyc$', '\~$']   " ignore files in NERDTree



" Want to search for basically anything from VIM? Check out ctrlP:  (initiate
" with c-p, duh)::
Plugin 'kien/ctrlp.vim'
" ^^^See it in action: http://www.youtube.com/watch?v=9XrHk3xjYsw


" Want to perform basic git commands without leaving the comfort of VIM? Then
" vim-fugitive is the way to go:
Plugin 'tpope/vim-fugitive'
" ^^^See it in action on VIMcasts:
" http://vimcasts.org/episodes/fugitive-vim---a-complement-to-command-line-git/


" Powerline is a status bar that displays things like the current virtualenv,
" git branch, files being edited, and much more.  Its written in Python, and
" it supports a number of other environments like zsh, bash, tmux, and
" IPython:
"Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
" ^^^Take a look at the official docs for all the configuration options.
"   http://powerline.readthedocs.org/en/latest/


" Vim usually has its own clipboard and ignores the system keyboards, but
" sometimes you might want to cut, copy, and/or paste to/from other
" applications outside of VIM. On OS X, you can access your system clipboard
" with this line:
set clipboard=unnamed




" from the comments section...
" https://news.ycombinator.com/item?id=11780824
Plugin 'majutsushi/tagbar'
Plugin 'xolox/vim-easytags'
Plugin 'xolox/vim-misc'
nnoremap <silent> <Leader>b :TagbarToggle<CR>
" F8 will toggle the tagbar:
nmap <F8> :TagbarToggle<CR>



" /2019-05-11




" :help pymode
" https://github.com/python-mode/python-mode
" https://github.com/python-mode/python-mode/wiki
Plugin 'klen/python-mode'
" howtodo Code refactoring: specifically just a variable rename??
"    pymode-rope-refactoring
" Keymap for rename method/function/class/variables under cursor:
let g:pymode_rope = 1
":PymodeRopeNewProject
":PymodeRopeRegenerate
let g:pymode_rope_lookup_project = 0
let g:pymode_rope_project_root = ""
let g:pymode_rope_ropefolder='.ropeproject'
let g:pymode_rope_show_doc_bind = '<C-c>d'
let g:pymode_rope_regenerate_on_write = 1

let g:pymode_rope_rename_bind = '<C-c>rr'

set completeopt=menuone,noinsert
let g:pymode_rope_completion = 1
let g:pymode_rope_complete_on_dot = 1
let g:pymode_rope_completion_bind = '<C-Space>'
let g:pymode_rope_autoimport = 0
let g:pymode_rope_autoimport_modules = ['os', 'shutil', 'datetime']
let g:pymode_rope_autoimport_import_after_complete = 0




"
" Format code with one button press (or automatically on save).
" https://vimawesome.com/plugin/vim-autoformat
"
" First you should install an external program that can format code of the
" programming language you are using.
"
" astyle - c*, java
" autopep8 - python
" yapf - python
" black - python
" fixjson - json
" js-beautify - javascript, json
" JSCS - javascript
" standard - javascript
" ESlint - javascript
" xo - javascript
" html-beautify - html
" css-beautify - css
" tidy - html, xhtml, xml
" remark - markdown
" rbeautify - ruby
" rubocop - ruby
" gofmt - golang
" rustfmt - rust
" dartfmt - dart
" perltity - pearl
" stylish-haskell - haskell
" shfmt - shell  ( https://github.com/mvdan/sh )
"     sudo apt install golang-go
"     go get -u mvdan.cc/sh/cmd/shfmt
" sqlformat - sql
"
Plugin 'Chiel92/vim-autoformat'

" To use, do
" :Autoformat
"   (or assign shortcut key:
"      noremap <F3> :Autoformat<CR>
"   )
"   (or format upon save:
"      au BufWrite * :Autoformat
"   )
"
" To disable the fallback to vim's indent file, retabbing and removing
" trailing whitespace, set the following variables to 0.
"
"   let g:autoformat_autoindent = 0
"   let g:autoformat_retab = 0
"   let g:autoformat_remove_trailing_spaces = 0
"




syntax on


set relativenumber
set nu   " regular numbering after relative numbering sets curr line to actual file line number.


" Prevents vim from replacing spaces with tabs whenever autoindent is on:
set expandtab
set shiftwidth=3
set softtabstop=3
"set tabstop=3

" smarttab affects how <TAB> key presses are interpretted depending on whwhere
" the cursor is.  There is seldom any need to set this option, unless it is
" necessary to use hard TAB characters in body text or code.
"set smarttab

set autoindent

set shiftround

highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
colors ron
set hlsearch
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2
au BufReadPost,FileReadPost * syntax match Tab /        /
hi Tab gui=underline guifg=blue ctermbg=blue
syntax enable
set history=475


source $VIMRUNTIME/menu.vim
set wildmenu
set cpo-=<
set wcm=<C-Z>
map <F4> :emenu <C-Z>


" (me!) add from gVim
set gfn=Terminus\ 9

" shows visual line under the cursor's current line
set cursorline


set bg=light

" 2012-12-06 Search[/Replace]: show more context when reviewing matches:
se scrolloff=5


se colorcolumn=0
se cc=


" 2012-04-04 phisata comment this out, it was preventing autoindent and such
"set paste


" 2012-03-02 from /etc/vim/vimrc
" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"" Uncomment the following to have Vim load indentation rules and plugins
"" according to the detected filetype.
"if has("autocmd")
"  filetype plugin indent on
"endif
" /2012-03-02 from /etc/vim/vimrc


" src : http://effectif.com/vim/host-specific-vim-config
"let hostfile = $HOME . '/.vim/gvimrc-' . substitute(hostname(), "\\..*", "", "")
let hostfile = $HOME . '/.vim/vimrc-' . substitute(hostname(), "\\..*", "", "")
if filereadable(hostfile)
  exe 'source ' . hostfile
endif


" make ':W' ':WQ' ':Wq' ':Q' ':Qa' ':QA' actually do
" stuffs:
:command W w
:command WQ wq
:command Wq wq
:command Q q
":command Q! q!
:command Qa qa
:command QA qa
":command Qa! qa
":command QA! qa!


let g:DeleteTrailingWhitespace = 1

:command Dw :execute  ':DeleteTrailingWhitespace' | :w
:command Dwq :execute ':DeleteTrailingWhitespace' | :wq



" split navigations...
" c-k to move to split below
nnoremap <C-J> <C-W><C-J>
" c-k to move to split above
nnoremap <C-K> <C-W><C-K>
" c-k to move to split to the right
nnoremap <C-L> <C-W><C-L>
" c-k to move to split to the left
nnoremap <C-H> <C-W><C-H>



" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za





" THESE MUST BE LAST!  DO NOT ADD STUFF AFTER THIS!
"
" All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on     " required!
" or
" filetype plugin on          " to not use the indentation settings set by plugins



