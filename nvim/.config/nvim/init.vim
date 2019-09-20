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
Plug 'chrisbra/Colorizer'
Plug 'bronson/vim-trailing-whitespace'
Plug 'terryma/vim-multiple-cursors'
Plug 'mechatroner/rainbow_csv'
Plug 'vitalk/vim-shebang'
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
set tabstop=4
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

" Change width of split
noremap <A-h> <C-w>5<
noremap <A-j> <C-w>5+
noremap <A-k> <C-w>5-
noremap <A-l> <C-w>5>
noremap <A-left> <C-w>5<
noremap <A-down> <C-w>5+
noremap <A-up> <C-w>5-
noremap <A-right> <C-w>5>

nnoremap <C-S-g> :!grep -rn <cword> 2>/dev/null<CR>

set lazyredraw
set title
set autoread
set noswapfile

let g:lightline = {
  \ 'tab_component_function': {
  \   'filename': 'MyTabFilename',
  \ },
  \}

function! MyTabFilename(n)
  let tabs = BuildTabs()
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let bufnum = buflist[winnr - 1]
  let bufname = expand('#'.bufnum.':t')
  return tabs[a:n - 1].uniq_name
endfunction

function! BuildTabs()
  let tabs = []
  for i in range(tabpagenr('$'))
    let tabnum = i + 1
    let buflist = tabpagebuflist(tabnum)
    let file_path = ''
    let tab_name = bufname(buflist[0])
    if tab_name =~ 'NERD_tree' && len(buflist) > 1
      let tab_name = bufname(buflist[1])
    end
    let is_custom_name = 0
    if tab_name == ''
      let tab_name = '[No Name]'
      let is_custom_name = 1
    elseif tab_name =~ 'fzf'
      let tab_name = 'FZF'
      let is_custom_name = 1
    else
      let file_path = fnamemodify(tab_name, ':p')
      let tab_name = fnamemodify(tab_name, ':p:t')
    end
    let tab = {
      \ 'number': tabnum,
      \ 'name': tab_name,
      \ 'uniq_name': tab_name,
      \ 'file_path': file_path,
      \ 'is_custom_name': is_custom_name
      \ }
    call add(tabs, tab)
  endfor
  call CalculateTabUniqueNames(tabs)
  return tabs
endfunction

function! CalculateTabUniqueNames(tabs)
  for tab in a:tabs
    if tab.is_custom_name | continue | endif
    let tab_common_path = ''
    for other_tab in a:tabs
      if tab.name != other_tab.name || tab.file_path == other_tab.file_path
        \ || other_tab.is_custom_name
        continue
      endif
      let common_path = GetCommonPath(tab.file_path, other_tab.file_path)
      if tab_common_path == '' || len(common_path) < len(tab_common_path)
        let tab_common_path = common_path
      endif
    endfor
    if tab_common_path == '' | continue | endif
    let common_path_has_immediate_child = 0
    for other_tab in a:tabs
      if tab.name == other_tab.name && !other_tab.is_custom_name
        \ && tab_common_path == fnamemodify(other_tab.file_path, ':h')
        let common_path_has_immediate_child = 1
        break
      endif
    endfor
    if common_path_has_immediate_child
      let tab_common_path = fnamemodify(common_path, ':h')
    endif
    let path = tab.file_path[len(tab_common_path)+1:-1]
    let path = fnamemodify(path, ':~:.:h')
    let dirs = split(path, '/', 1)
    if len(dirs) >= 5
      let path = dirs[0] . '/.../' . dirs[-1]
    endif
    let tab.uniq_name = path . '/' . tab.name
  endfor
endfunction

function! GetCommonPath(path1, path2)
  let dirs1 = split(a:path1, '/', 1)
  let dirs2 = split(a:path2, '/', 1)
  let i_different = 0
  for i in range(len(dirs1))
    if get(dirs1, i) != get(dirs2, i)
      let i_different = i
      break
    endif
  endfor
  return join(dirs1[0:i_different-1], '/')
endfunction

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

function! ShowTabSettings()
  if (&expandtab == 1)
    echon 'Indenting using spaces: ' &shiftwidth ' '
  else
    echon 'Indenting using tabs. '
  endif
  echon '(Tabwidth: ' &tabstop ')'
endfunc

nnoremap <F8> :call ShowTabSettings()<CR>

let g:nerdtree_tabs_open_on_console_startup=2
let g:nerdtree_tabs_autofind=1

let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

map <silent> <C-o> :NERDTreeTabsToggle<CR>

let g:multi_cursor_exit_from_insert_mode = 0

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
