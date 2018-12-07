call plug#begin('~/.local/share/nvim/plugged')
Plug 'bogado/file-line'
Plug 'bohlender/vim-smt2'
Plug 'burnettk/vim-angular'
Plug 'flazz/vim-colorschemes'
Plug 'itchyny/lightline.vim'
Plug 'jceb/vim-orgmode'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'leafgarland/typescript-vim'
Plug 'luochen1990/indent-detector.vim'
Plug 'matthewsimo/angular-vim-snippets'
Plug 'mhinz/vim-startify'
Plug 'mxw/vim-jsx'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'pangloss/vim-javascript'
Plug 'scrooloose/nerdtree'
Plug 'vim-syntastic/syntastic'
Plug 'wannesm/wmnusmv.vim'
call plug#end()

syntax on
filetype plugin indent on

autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufRead *.py set nocindent
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``

autocmd FileType markdown set wrap|set linebreak
autocmd FileType org set wrap|set linebreak

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Save as root with :Sw
command! -nargs=0 Sw w !sudo tee % > /dev/null

set expandtab
set smartindent
set smarttab
set shiftwidth=4
set nowrap
set number
set backspace=2
set scrolloff=999
set sidescrolloff=999
set linebreak
set foldmethod=manual

colorscheme Monokai

set showcmd		    " Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set hlsearch        " Highlight matches
set hidden		    " Hide buffers when they are abandoned

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

set lazyredraw
set title
set autoread
"set confirm
set noswapfile

" Jump to the last position when reopening a file
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

function! ToggleMouse()
    " check if mouse is enabled
    if &mouse == "a"
        " disable mouse
        set mouse=
        echo "Mouse disabled"
        set scrolloff=999
        set sidescrolloff=999
    else
        " enable mouse everywhere
        set mouse=a
        echo "Mouse enabled"
        set scrolloff=0
        set sidescrolloff=0
    endif
endfunc

" Whitespace/special chars for list
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

function! ToggleWhitespace()
    if &list == 1
        set nolist
        echo "Whitespace highlighting disabled"
    else
        set list
        echo "Whitespace highlighting enabled"
    endif
endfunc

function! ToggleWrap()
    if (&wrap == 1)
        set nowrap
        echo "Wrap disabled"
    else
        set wrap
        echo "Wrap enabled"
    endif
endfunc

nnoremap <F2> :echon "F3: Toggle paste\nF4: Toggle mouse\nF5: Toggle whitespace\nF6: Toggle wrap\nF7: Exec file"<CR>

set showmode
set pastetoggle=<F3>

nnoremap <F3> :set invpaste paste?<CR>
nnoremap <F4> :call ToggleMouse()<CR>
nnoremap <F5> :call ToggleWhitespace()<CR>
nnoremap <F6> :call ToggleWrap()<CR>

au BufRead *.py nmap <F7> :w !clear & python<CR>
"au Bufread *.md nmap <F7> :w<CR>:silent !mdpdf % &<CR>:redraw!<CR>
au Bufread *.md nmap <F7> :w<CR>:silent !grip --quiet --export %<CR>:redraw!<CR>

let g:nerdtree_tabs_open_on_console_startup=2

let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

let g:multi_cursor_quit_key = "<Esc>"

map <silent> <C-o> :NERDTreeTabsToggle<CR>

nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" Simple tab switching
map <Esc>[27;5;9~ <C-Tab>
map <Esc>[27;6;9~ <C-S-Tab>

nmap <C-Tab> :tabnext<CR>
imap <C-Tab> <ESC>:tabnext<CR>
nmap <C-S-Tab> :tabprevious<CR>
imap <C-S-Tab> <ESC>:tabprevious<CR>

map <Esc>1 <A-1>
map <Esc>2 <A-2>
map <Esc>3 <A-3>
map <Esc>4 <A-4>
map <Esc>5 <A-5>
map <Esc>6 <A-6>
map <Esc>7 <A-7>
map <Esc>8 <A-8>
map <Esc>9 <A-9>

nmap <A-1> 1gt
imap <A-1> <ESC>1gt
nmap <A-2> 2gt
imap <A-2> <ESC>2gt
nmap <A-3> 3gt
imap <A-3> <ESC3>gt
nmap <A-4> 4gt
imap <A-4> <ESC>4gt
nmap <A-5> 5gt
imap <A-5> <ESC>5gt
nmap <A-6> 6gt
imap <A-6> <ESC>6gt
nmap <A-7> 7gt
imap <A-7> <ESC>7gt
nmap <A-8> 8gt
imap <A-8> <ESC>8gt
nmap <A-9> :silent tablast<CR>
imap <A-9> <ESC>:tsilent ablast<CR>
