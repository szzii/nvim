
" __  ____   __  _   ___     _____ __  __ ____   ____
"|  \/  \ \ / / | \ | \ \   / /_ _|  \/  |  _ \ / ___|
"| |\/| |\ V /  |  \| |\ \ / / | || |\/| | |_) | |
"| |  | | | |   | |\  | \ V /  | || |  | |  _ <| |___
"|_|  |_| |_|   |_| \_|  \_/  |___|_|  |_|_| \_\\____|
"



syntax enable
syntax on
set nocompatible
set exrc
set secure
set number
set relativenumber
set wrap
set showcmd
set wildmenu
set hlsearch
set incsearch
set ignorecase
set smartcase
set mouse+=a
set scrolloff=10
set encoding=utf-8
set hidden
set updatetime=100
set shortmess+=c
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set smartindent
set background=dark 

let mapleader = ' '
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" ale 
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚡'
let g:ale_disable_lsp = 1
let g:ale_java_javac_options = "/home/szz/.config/coc/extensions/coc-java-data/lombok.jar"

" airline
let g:airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='yowish'
let g:airline#extensions#tabline#enabled = 1

" devicons 
let g:webdevicons_enable = 1
let g:webdevicons_enable_startify = 1
let g:webdevicons_enable_flagship_statusline = 1


" themes
let java_highlight_functions = 1
let java_highlight_all = 1
" If you are trying this at runtime, you need to reload the syntax file
set filetype=java

" Some more highlights, in addition to those suggested by cmcginty
highlight link javaScopeDecl Statement
highlight link javaType Type
highlight link javaDocTags PreProc
set termguicolors
autocmd vimenter * ++nested colorscheme base16-woodland


au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
exec "nohlsearch"

filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

map <TAB> <nop>
map s :<nop>
map S :w<CR>
map Q :q<CR>
"map R :source $MYNVIMRC<CR>
map sl :set splitright<CR>:vsplit<CR>
map sj :set nosplitright<CR>:vsplit<CR>
map si :set nosplitbelow<CR>:split<CR>
map sk :set splitbelow<CR>:split<CR>
map <LEADER>j <C-w>h 
map <LEADER>i <C-w>k
map <LEADER>k <C-w>j
map <LEADER>l <C-w>l
map <LEADER>J <C-w>h 
map <LEADER>I <C-w>k
map <LEADER>K <C-w>j
map <LEADER>L <C-w>l
"map <UP> :res +5<CR>
"map <down> :res -5<CR>
"map <left> :vertical resize-5<CR>
"map <right> :vertical resize+5<CR>
map tu :tabe<CR>
map tl :+tabnext<CR>
map tj :-tabnext<CR>
map <C-p> :set paste<CR>
map <C-n> :set nopaste<CR>

noremap j h
noremap i k
noremap k j
noremap H I
noremap h i
noremap <C-l> $
noremap <C-J> 0
noremap <LEADER><CR> :nohlsearch<CR> 
noremap J 7h
noremap L 7l
noremap I 5k
noremap K 5j
noremap <C-h> 5<C-y>
noremap <C-k> 5<C-e>
noremap <silent> <LEADER>g  :table :term lazygit<CR>

nnoremap - <PageUp>
nnoremap = <PageDown>
nnoremap tt :CocCommand explorer<CR>
nnoremap TT :CocCommand explorer<CR>
nnoremap < <<
nnoremap > >>

inoremap <C-i> <Up>
inoremap <C-j> <Left>
inoremap <C-k> <Down>
inoremap <C-l> <Right>
inoremap <C-d> <DELETE>
inoremap <C-b> <BS>
inoremap <C-c> <ESC>

vnoremap Y "+y

	




call plug#begin('~/.config/nvim/plugged')

" 底部状态栏
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" vim 开始导航
Plug 'mhinz/vim-startify'

" Coc系列
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Error checking
Plug 'w0rp/ale'

" themes
Plug 'morhetz/gruvbox'
Plug 'ryanoasis/vim-devicons'
Plug 'tomasr/molokai'
Plug 'KabbAmine/yowish.vim'
Plug 'chriskempson/base16-vim'


Plug 'sbdchd/neoformat'

" markdown
Plug 'iamcco/markdown-preview.nvim', {'do': 'cd app && yarn install'  }

" debug
Plug 'puremourning/vimspector'

" search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" 对称行
Plug 'Yggdroot/indentLine'

" 文件管理
Plug 'kevinhwang91/rnvimr'

" 语法树
Plug 'liuchengxu/vista.vim'

" autoformat
Plug 'google/vim-codefmt'
Plug 'google/vim-maktaba'
Plug 'google/vim-glaive'

" json
Plug 'elzr/vim-json'
Plug 'neoclide/jsonc.vim'

Plug 'jiangmiao/auto-pairs'

Plug 'sheerun/vim-polyglot'

call plug#end()
call glaive#Install()

" ===
" === AutoFormat
" ===
Glaive codefmt plugin[mappings]
Glaive codefmt google_java_executable="java -jar /home/szz/.config/nvim/format/google-java-format-1.10.0-all-deps.jar"


augroup autoformat_settings
	" autocmd FileType bzl AutoFormatBuffer buildifier
	" autocmd FileType c,cpp,proto,javascript,arduino AutoFormatBuffer clang-format
	" autocmd FileType dart AutoFormatBuffer dartfmt
	" autocmd FileType go AutoFormatBuffer gofmt
	" autocmd FileType gn AutoFormatBuffer gn
	autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
	autocmd FileType java AutoFormatBuffer google-java-format
	" autocmd FileType python AutoFormatBuffer yapf
	" Alternative: autocmd FileType python AutoFormatBuffer autopep8
	" autocmd FileType rust AutoFormatBuffer rustfmt
	" autocmd FileType vue AutoFormatBuffer prettier
augroup END



" ===
" === vimspector
" ===
let g:vimspector_enable_mappings = 'HUMAN'
nmap <F1> :CocCommand java.debug.vimspector.start<CR>
function! s:read_template_into_buffer(template)
    " has to be a function to avoid the extra space fzf#run insers otherwise
    execute '0r ~/.config/nvim/vimspector_json/'.a:template
endfunction
command! -bang -nargs=* LoadVimSpectorJsonTemplate call fzf#run({
            \   'source': 'ls -1 ~/.config/nvim/vimspector_json',
            \   'down': 20,
            \   'sink': function('<sid>read_template_into_buffer')
            \ })
noremap <leader>vs :tabe .vimspector.json<CR>:LoadVimSpectorJsonTemplate<CR>




" ===
" === coc
" ===
let g:coc_global_extensions = [
			\"coc-markdownlint",
			\"coc-explorer",
			\"coc-java",
			\"coc-java-debug",
			\"coc-xml",
			\"coc-json",
			\"coc-html",
			\"coc-yaml",
			\"coc-translator",
			\"coc-highlight"]


" <TAB>键代码补全
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
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

nmap <silent> <LEADER>f <Plug>(coc-definition)
nmap <silent> <LEADER>d <Plug>(coc-type-definition)
nmap <silent> <LEADER>e <Plug>(coc-implementation)
nmap <silent> <LEADER>r <Plug>(coc-references)

nmap <silent> <LEADER>[ <Plug>(coc-diagnostic-prev)
nmap <silent> <LEADER>] <Plug>(coc-diagnostic-next)

nmap <leader>n <Plug>(coc-rename)

autocmd CursorHold * silent call CocActionAsync('highlight')
set termguicolors

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" 翻译
nmap <Leader>t <Plug>(coc-translator-p)
vmap <Leader>t <Plug>(coc-translator-pv)
nmap <Leader>w <Plug>(coc-translator-e)
vmap <Leader>w <Plug>(coc-translator-ev)
"nmap <Leader>r <Plug>(coc-translator-r)
"vmap <Leader>r <Plug>(coc-translator-rv)





" ===
" === rnvimr
" ===
let g:rnvimr_urc_path = "/home/szz/.config/ranger/"
highlight link RnvimrNormal CursorLine
nnoremap <silent> <C-a> :RnvimrToggle<CR><C-\><C-n>:RnvimrResize 1<CR>






" ===
" === git
" ===
let g:gitgutter_git_executable = '/usr/bin/git'





" ===
" === markdown
" ===
nmap <C-m> :MarkdownPreviewToggle<CR>





" ===
" === FZF
" ===
" noremap <silent> <C-p> :Files<CR>
noremap <silent> <C-f> :Rg<CR>
noremap <silent> <C-h> :History<CR>
"noremap <C-t> :BTags<CR>
"noremap <silent> <C-l> :Lines<CR>
noremap <silent> <C-b> :Buffers<CR>
noremap <leader>; :History:<CR>

let g:fzf_preview_window = 'right:60%'
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))

noremap <c-b> :BD<CR>

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }

