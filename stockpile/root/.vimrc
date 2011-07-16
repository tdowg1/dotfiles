" .vimrc
" cayla fauver <cayla@wehavenoproduct.com>
" Created: Sat Sep 17, 2005  08:02PM
" Last modified: Thu Feb 22, 2007 10:30PM
" Description: a work in progress
"

autocmd!
if has('syntax') && (&t_Co > 2)
  syntax on
endif

if &term =~ 'xterm'
  if $COLORTERM == 'gnome-terminal'
    execute 'set t_kb=' . nr2char(8)
    fixdel
    set t_RV=
  elseif $COLORTERM == ''
    execute 'set t_kb=' . nr2char(8)
    fixdel
  endif
endif

colorscheme pablo
set title
set background=light
set nocompatible
set showmatch
set nobackup
set history=50
set undolevels=50
set viminfo=/10,'10,r/mnt/zip,r/mnt/floppy,f0,h,\"100
set wildmode=list:longest,full
set shortmess+=r
set showmode
set showcmd
set mouse=a
" set modeline
set nowrap
set expandtab
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set formatoptions-=t
" start next line of comment with comment delimiter
set formatoptions+=ro
set textwidth=79
set ignorecase
set smartcase
set incsearch
set gdefault
set whichwrap=h,l,~,[,]
set matchpairs+=<:>
" set list listchars=tab:>-,trail:·,eol:$
set backspace=eol,start,indent
set comments-=s1:/*,mb:*,ex:*/
set comments+=s:/*,mb:**,ex:*/
set comments+=fb:*
set comments+=b:\"
set comments+=b:#
set comments+=n::

filetype on
augroup filetype
  autocmd BufNewFile,BufRead */.Postponed/* set filetype=mail
  autocmd BufNewFile,BufRead *.txt set filetype=human
augroup END

" autocmd FileType mail,human set formatoptions+=t textwidth=72
autocmd FileType mail,human set formatoptions-=r textwidth=72
autocmd FileType c,cpp,slang set cindent
autocmd FileType c set formatoptions+=ro
autocmd FileType perl set smartindent
autocmd FileType css set smartindent
autocmd FileType html set formatoptions+=tl
autocmd FileType html,css set noexpandtab tabstop=2
autocmd FileType make set noexpandtab shiftwidth=8

noremap <Space> <PageDown>
noremap <BS> <PageUp>
" noremap <C-N> :w<CR>:bn<CR>
" noremap <C-P> :w<CR>:bp<CR>
noremap <C-Tab> :bn<CR>
noremap <S-C-Tab> :bp<CR>
noremap Q gqap
map Q gqGgg

ab cef cayla fauver <cayla@wehavenoproduct.com>
ab fh # <C-R>%<CR>cayla fauver <cayla@wehavenoproduct.com><CR>Created: <ESC>"=strftime("%a %b %d, %Y %I:%M%p")<CR>p<ESC>oLast modified: <CR>Description:
ab pfh #!/usr/bin/perl -w<CR> <C-R>%<CR>cayla fauver <cayla@wehavenoproduct.com><CR>Created: <ESC>"=strftime("%a %b %d, %Y %I:%M%p")<CR>p<ESC>oLast modified: <CR>Description:
" map T "=strftime("%a %b %d, %Y  %I:%M%p")<CR>p

let IspellLang = 'american'
let PersonalDict = '~/.ispell_' . IspellLang
execute 'set dictionary+=' . PersonalDict
set dictionary+=/usr/dict/words
set complete=.,w,k
set infercase

" abbreviate teh the

au FileType haskell,vhdl,ada            let b:comment_leader = '-- ' 
au FileType vim                         let b:comment_leader = '" ' 
au FileType c,cpp,java                  let b:comment_leader = '// ' 
au FileType sh,make,perl                let b:comment_leader = '# ' 
au FileType tex                         let b:comment_leader = '% ' 
noremap <silent> ,c :<C-B>sil <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:noh<CR> 
noremap <silent> ,u :<C-B>sil <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:noh<CR> 

nnoremap <F1> :help<Space>
vmap <F1> <C-C><F1>
omap <F1> <C-C><F1>
map! <F1> <C-C><F1>

" \si ("spelling interactive") saves the current file then spell checks it
" interactively through `Ispell' and reloads the corrected version:
execute 'nnoremap \si :w<CR>:!ispell -x -d ' . IspellLang . ' %<CR>:e<CR><CR>'
nmap <F2> \si

map <F3> :%s/<.\{-}>//<CR>QQ

nnoremap \tp :set invpaste paste?<CR>
nmap <F6> \tp
imap <F6> <C-O>\tp
set pastetoggle=<F6>

map <F9> :w<CR>:!perl %<CR>
map <F10> :TOhtml<CR>:1<CR>/body bg<CR>:s/ffffff/tmp/<CR>:s/000000/FFFFFF/<CR>:s/tmp/000000/<CR>:wq<CR>:1<CR>
map <F12> :!wc -w %; sleep 3 <Enter><Enter>

au BufNewFile,BufRead snd.*,.letter,.followup,.article,.article.[0-9]\+,pico.[0-9]\+,mutt*[0-9]          set noautoindent
au BufNewFile,BufRead snd.*,.letter,.followup,.article,.article.[0-9]\+,pico.[0-9]\+,mutt*[0-9]          set nosmartindent
au BufNewFile,BufRead snd.*,.letter,.followup,.article,.article.[0-9]\+,pico.[0-9]\+,mutt*[0-9]          set textwidth=70
au BufNewFile,BufRead snd.*,.letter,.followup,.article,.article.[0-9]\+,pico.[0-9]\+,mutt*[0-9]          set formatoptions-=r

" This auto command will call LastMod function everytime you save a file 
autocmd BufWrite *.pl ks|call LastMod()|'s
autocmd BufWrite *rc ks|call LastMod()|'s

"
" FUNCTIONS
"

" Search the first 20 lines for Last modified: and update the current datetime. 
function! LastMod()
    if line("$") > 20 
let l = 20 
    else 
let l = line("$") 
    endif 
    exe "1," . l . "g/Last modified: /s/Last modified: .*/Last modified: " . 
\ strftime("%a %b %d, %Y %I:%M%p") 
endfun


