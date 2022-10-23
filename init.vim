


" ======= basic set ======= 



let mapleader = ' '

filetype plugin on
syntax on

set nocompatible
set autoread
set autowrite
set autochdir
set exrc
set secure
set encoding=utf-8

" line number
set scrolloff=10
set number
set relativenumber
set wrap
let &showbreak='+++ '
"set list        
"set listchars=tab:\|\ ,trail:▫

" search
set hlsearch
set incsearch
set ignorecase
set smartcase

if has("nvim")
	set inccommand=split
endif

" indent 
set autoindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set noexpandtab
set smartindent
set foldmethod=indent
set nofoldenable

"spilt
set splitright
set nosplitbelow

" system
set mouse=a
set hidden
set signcolumn=yes
set noshowcmd
set noshowmode
set timeout
set nottimeout
set timeoutlen=1000
set updatetime=0
set virtualedit=block
set ttyfast 
set tw=0
set viewoptions=cursor,folds,unix

augroup QuickNotes
	au!
	autocmd BufWinLeave *.* execute "mkview! " . "~/.vim/view" . "/" . expand('<afile>:t') . ".view"
	autocmd BufWinEnter *.* execute "silent! source " . "~/.vim/view" . "/" . expand('%:t') . ".view"
augroup END 



exec "nohlsearch"


" ======= basic keymap ======= 

"
"     ^
"e    u
" < n   i >
"     e
"     v
noremap <silent> n h
noremap <silent> e j
noremap <silent> i l
noremap <silent> u k
noremap U 5k
noremap E 5j
nnoremap < <<
nnoremap > >>

" go to the start or end of the line
noremap  N 0
noremap  I $

" Insert Key
noremap h i
noremap H I

" Save & quit
map s :<nop>
map S :w<CR>
map Q :q<CR>

" move line
nnoremap  <C-u> ddkP
nnoremap  <C-e> ddp

" Undo operations
nnoremap l u

" select  searching
noremap K N
noremap k n

" change key
noremap ; :
noremap ` ~

" Copy to system clipboard
vnoremap Y "+y

" vimrc open & reload 
nmap <LEADER>rc :e $HOME/.config/nvim/init.vim<CR>
nmap R :source $MYVIMRC<CR>

" split screen
nmap si :set splitright<CR>:vsplit<CR>
nmap sn :set nosplitright<CR>:vsplit<CR>
nmap su :set nosplitbelow<CR>:split<CR>
nmap se :set splitbelow<CR>:split<CR>
noremap <LEADER>n <C-w>h 
noremap <LEADER>u <C-w>k
noremap <LEADER>e <C-w>j
noremap <LEADER>i <C-w>l
noremap <LEADER>q <C-w>o
noremap <LEADER>w <C-w>w
noremap sh <C-w>t<C-w>K
noremap sv <C-w>t<C-w>H
noremap <up> :res +5<CR>
noremap <down> :res -5<CR>
noremap <left> :vertical resize-5<CR>
noremap <right> :vertical resize+5<CR>



" switch tab
nmap tu :tabe<CR>
nmap ti :+tabnext<CR>
nmap tn :-tabnext<CR>

" insert mode
inoremap <C-a> <ESC>A
noremap  <C-a> A
inoremap <C-o> <ESC>A {}<ESC>i<CR><ESC>ko

" command mode 
"cnoremap <C-a> <Home>
"cnoremap <C-e> <End>
"cnoremap <C-p> <Up>
"cnoremap <C-n> <Down>
"cnoremap <C-b> <Left>
"cnoremap <C-f> <Right>
"cnoremap <M-b> <S-Left>
"cnoremap <M-w> <S-Right>

" other
noremap <LEADER><CR> :nohlsearch<CR>
map <TAB> <nop>
noremap <LEADER><LEADER> zz



" ================ plugin =============== 
call plug#begin('~/.config/nvim/plugged')

" themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'nanotech/jellybeans.vim'

" I favorite
Plug 'mhinz/vim-startify'

" tmux line
Plug 'edkolev/tmuxline.vim'

" code Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" git
Plug 'airblade/vim-gitgutter'
Plug 'APZelos/blamer.nvim'
Plug 'lambdalisue/gina.vim'




"chinese vimdoc
Plug 'yianwillis/vimcdoc'

call plug#end()



"===================
"====== coc configration ======
"===================
inoremap <silent><expr> <TAB>
     \ pumvisible() ? "\<C-n>" :
     \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
     \ <SID>check_back_space() ? "\<TAB>" :
     \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
       	let col = col('.') - 1
       	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                             \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"


" document
nnoremap <silent> <LEADER>m :call <SID>show_documentation()<CR>

function! s:show_documentation()
 if (index(['vim','help'], &filetype) >= 0)
   execute 'h '.expand('<cword>')
 elseif (coc#rpc#ready())
   call CocActionAsync('doHover')
 else
   execute '!' . &keywordprg . " " . expand('<cword>')
 endif
endfunction


inoremap <silent><expr> <c-@> coc#refresh()
nmap <leader>z  <Plug>(coc-codeaction)
nmap <leader>x  <Plug>(coc-fix-current)
nmap <leader>k  <Plug>(coc-rename)
nmap <silent> <LEADER>f <Plug>(coc-definition)
nmap <silent> <LEADER>d <Plug>(coc-type-definition)
nmap <silent> <LEADER>r <Plug>(coc-references)
nmap <silent> <LEADER>v <Plug>(coc-implementation)
nmap <silent> <LEADER>[ <Plug>(coc-diagnostic-prev)
nmap <silent> <LEADER>] <Plug>(coc-diagnostic-next)

augroup mygroup
 autocmd!
 " Setup formatexpr specified filetype(s).
 "autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
 " Update signature help on jump placeholder.
 autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

autocmd CursorHold * silent call CocActionAsync('highlight')

command! -nargs=? Fold :call     CocAction('fold', <f-args>)

command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" colorsheme
let g:jellybeans_overrides = {
\    'background': { 'guibg': '000000' },
\    'SignColumn': { 'guibg': '000000' },
\}
colorscheme jellybeans


" airline
let g:airline_theme='dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_extensions = ['branch', 'tabline']
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#format = 2






let g:tmuxline_separators = {
    \ 'left' : '',
    \ 'left_alt': '>',
    \ 'right' : '',
    \ 'right_alt' : '<',
    \ 'space' : ' '}
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'win'  : '#I #W',
      \'cwin' : '#I #W #F',
      \'x'    : '%Y-%m-%d %H:%M:%S'}


 

" coc-trnaslator
map <LEADER>t <Plug>(coc-translator-p)


" git
"let g:gitgutter_git_executable = '/usr/bin/git'
let g:gitgutter_map_keys = 0
let g:gitgutter_sign_allow_clobber = 0
let g:gitgutter_preview_win_floating = 1
let g:gitgutter_set_sign_backgrounds = 1
" Thanks for @theniceboy
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '░'
let g:gitgutter_sign_removed = '▏'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_modified_removed = '▒'




let g:blamer_enabled = 1
let g:blamer_date_format = '%Y-%m-%d %H:%M'
let g:blamer_template = '<committer>: <committer-time> (<summary>)'



