" Sai Warang's vimrc, original work by Douglas Black
" Splits {{{
set splitbelow
set splitright
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l
map <C-H> <C-W>h
" }}}
" Colors {{{
let hour = strftime("%H")
if 6 <= hour && hour < 18
  set background=light
else
  set background=dark
endif
let g:solarized_termcolors=256
colorscheme solarized 
" }}}
" Misc {{{
set ttyfast                     " faster redraw
set updatetime=250
set backspace=indent,eol,start
set shell=bash\ -l
set autoread
" }}}
" Spaces & Tabs {{{
set tabstop=2           " 2 space tab
set expandtab           " use spaces for tabs
set softtabstop=2       " 2 space tab
set shiftwidth=2
set modelines=1
filetype indent on
filetype plugin on
set autoindent
" }}}
" UI Layout {{{
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
set wildmenu
"set lazyredraw
set showmatch           " higlight matching parenthesis
" }}}
" Searching {{{
set ignorecase           " ignore case when searching
set incsearch            " search as characters are entered
set hlsearch             " highlight all matches
" // to search for visually selected text
vnoremap // y/<C-R>"<CR>
" }}}
" Folding {{{
"=== folding ===
set foldmethod=indent   " fold based on indent level
set foldnestmax=10      " max 10 depth
set foldenable          " don't fold files by default on open
nnoremap <space> za
set foldlevelstart=10    " start with fold level of 1
" }}}
" Line Shortcuts {{{
nnoremap j gj
nnoremap k gk
nnoremap B ^
nnoremap E $
nnoremap $ <nop>
nnoremap ^ <nop>
nnoremap gV `[v`]

noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
" }}}
" Leader Shortcuts {{{
nnoremap ; :
vnoremap ; :
let mapleader=","
nnoremap <leader>m :silent make\|redraw!\|cw<CR>
nnoremap <leader>w :NERDTree<CR>
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader><space> :noh<CR>
nnoremap <leader>s *<C-O>:%s///gn<CR>
nnoremap <leader>a :Ag
nnoremap <leader>d "_d
nmap <leader>r :e!<CR>
vnoremap <leader>y "+y
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
inoremap jk <esc>
vmap r "_dP
" }}}
" NERDTree {{{
let NERDTreeIgnore = ['\.pyc$', 'build', 'venv', 'egg', 'egg-info/', 'dist', 'docs']
" }}}
" Launch Config {{{
set nocompatible
call plug#begin('~/.vim/bundle')
Plug 'VundleVim/Vundle.vim'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'airblade/vim-gitgutter'

Plug 'tpope/vim-endwise', { 'for': 'ruby' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'

Plug 'altercation/vim-colors-solarized'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'blueyed/vim-diminactive'

" Languages
Plug 'nickhutchinson/vim-systemtap'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'kchmck/vim-coffee-script'
Plug 'pangloss/vim-javascript', { 'for': 'javascript'}
Plug 'fatih/vim-go', { 'for': 'go' } 

Plug 'rizzatti/dash.vim'

call plug#end()
" }}}
"" Tmux {{{
"if exists('$TMUX') " allows cursor change in tmux mode
"    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
"else
"    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
"endif
"" }}}
" Backups {{{
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup
" }}}
"  Auto paste mode {{{
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
" }}}
"
" vim:foldmethod=marker:foldlevel=0
