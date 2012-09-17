filetype off
call pathogen#infect()
filetype plugin indent on

set nocompatible
set ai
syntax enable
set number
set backspace=indent,eol,start
"set t_kb=ctrl-vBACKSPACE "backspace
"fixdel

"searches
set ignorecase
set smartcase
nnoremap / /\v
vnoremap / /\v
set showmatch
set gdefault
set hlsearch
set incsearch
nnoremap <leader><space> :noh<cr>
"tabs
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab

"remaps
nnoremap ; :
inoremap jj <ESC> 
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

colorscheme torte
set ruler
set scrolloff=5
"set cursorline
"hi CursorLine   cterm=NONE ctermbg=darkgray
"hi TODO ctermfg=red ctermbg=darkgray
set modelines=10
" Disable syntax highlight for files larger than 50 MB
autocmd BufWinEnter * if line2byte(line("$") + 1) > 50000000 | syntax clear | endif
"set mouse=a
set ttyfast


""""""""""""""""""""""""""""""""""""""""""""""""""
" Tell vim to remember certain things when we exit
" http://vim.wikia.com/wiki/VimTip80
""""""""""""""""""""""""""""""""""""""""""""""""""

"  '10 : marks will be remembered for up to 10 previously edited files
"  "100 : will save up to 100 lines for each register
"  :20 : up to 20 lines of command-line history will be remembered
"  % : saves and restores the buffer list
"  n... : where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

" when we reload, tell vim to restore the cursor to the saved position
augroup JumpCursorOnEdit
 au!
 autocmd BufReadPost *
 \ if expand("<afile>:p:h") !=? $TEMP |
 \ if line("'\"") > 1 && line("'\"") <= line("$") |
 \ let JumpCursorOnEdit_foo = line("'\"") |
 \ let b:doopenfold = 1 |
 \ if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
 \ let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
 \ let b:doopenfold = 2 |
 \ endif |
 \ exe JumpCursorOnEdit_foo |
 \ endif |
 \ endif
 " Need to postpone using "zv" until after reading the modelines.
 autocmd BufWinEnter *
 \ if exists("b:doopenfold") |
 \ exe "normal zv" |
 \ if(b:doopenfold > 1) |
 \ exe "+".1 |
 \ endif |
 \ unlet b:doopenfold |
 \ endif

"save folds on exit
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview


let g:myLang = 0
let g:myLangList = ['nospell', 'en_us', 'es_es']
function! MySpellLang()
    "loop through languages
    if g:myLang == 0 | setlocal nospell | endif
    if g:myLang == 1 | let &l:spelllang = g:myLangList[g:myLang] |
        setlocal spell | endif
    if g:myLang == 2 | let &l:spelllang = g:myLangList[g:myLang] |
        setlocal spell | endif
    echomsg 'language:' g:myLangList[g:myLang]
    let g:myLang = g:myLang + 1
    if g:myLang >= len(g:myLangList) | let g:myLang = 0 | endif
endfunction
map <F4> :<C-U>call MySpellLang()<CR>
map <F11> :<C-U>call WritingMode()<CR>

function! WritingMode()
    if (&foldcolumn != 12)
"        set laststatus=0
        set numberwidth=10
        set foldcolumn=12
        set noruler
        hi FoldColumn ctermbg=none
        hi LineNr ctermfg=0 ctermbg=none
        hi NonText ctermfg=0
    else
"        set laststatus=2
        set numberwidth=4
        set foldcolumn=0
        set ruler
        execute 'colorscheme ' . g:colors_name
    endif
endfunction

map <F8> :TagbarToggle<CR>
