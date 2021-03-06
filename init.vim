
" __  ____   __  _   ___     _____ __  __ ____   ____
"|  \/  \ \ / / | \ | \ \   / /_ _|  \/  |  _ \ / ___|
"| |\/| |\ V /  |  \| |\ \ / / | || |\/| | |_) | |
"| |  | | | |   | |\  | \ V /  | || |  | |  _ <| |___
"|_|  |_| |_|   |_| \_|  \_/  |___|_|  |_|_| \_\\____|
"


filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
syntax enable
syntax on

set autochdir
set nocompatible
set signcolumn=yes
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
set noexpandtab
set shortmess+=c
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set smartindent
set background=dark 
set tw=0
set indentexpr=
set foldmethod=indent
set viewoptions=cursor,folds,slash,unix
set foldlevel=99
set foldenable
"set list
set formatoptions-=tc
set splitright
set splitbelow
set noshowmode
set guifont=FiraCode\ Nerd\ Font:h16
set complete-=i
set complete-=t
set timeout
set ttimeout
set ttimeoutlen=10
set colorcolumn=100
set virtualedit=block
set completeopt=longest,noinsert,menuone,noselect,preview
set ttyfast "should make scrolling faster
set lazyredraw "same as above
set visualbell
set t_Co=256
let g:neovide_cursor_vfx_mode = "railgun"
let mapleader = ' '
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
let g:suda_smart_edit = 1


" airline
let g:airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='vorange'
let g:airline#extensions#tabline#enabled = 1

" devicons 
let g:webdevicons_enable = 1
let g:webdevicons_enable_startify = 1
let g:webdevicons_enable_flagship_statusline = 1


" themes

set filetype=java
let java_highlight_functions = 1
let java_highlight_all = 1
highlight link javaIdentifier NONE
"highlight link javaDelimiter NONE

highlight link javaScopeDecl Statement
highlight link javaType Type
highlight link javaDocTags PreProc
set termguicolors
autocmd vimenter * ++nested colorscheme  vorange


au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
exec "nohlsearch"


map <TAB> <nop>

" Save & quit
map s :<nop>
map S :w<CR>
map Q :q<CR>

" Undo operations
noremap l u

" Insert Key
noremap h i
noremap H I

" make Y to copy till the end of the line
nnoremap Y y$

" Copy to system clipboard
vnoremap Y "+y


"map R :source $MYNVIMRC<CR>
map si :set splitright<CR>:vsplit<CR>
map sn :set nosplitright<CR>:vsplit<CR>
map su :set nosplitbelow<CR>:split<CR>
map se :set splitbelow<CR>:split<CR>
map <LEADER>n <C-w>h 
map <LEADER>u <C-w>k
map <LEADER>e <C-w>j
map <LEADER>i <C-w>l
map <LEADER>N <C-w>h 
map <LEADER>U <C-w>k
map <LEADER>E <C-w>j
map <LEADER>I <C-w>l
map tu :tabe<CR>
map ti :+tabnext<CR>
map tn :-tabnext<CR>


"     ^
"     u
" < n   i >
"     e
"     v
noremap <silent> n h
noremap <silent> e j
noremap <silent> i l
noremap <silent> u k
noremap N 7h
noremap I 7l
noremap U 5k
noremap E 5j

" ===
" === Searching
" ===
noremap K N
noremap k n

noremap ; :
noremap ` ~
noremap <LEADER>rc :e ~/.config/nvim/init.vim<CR>

" N key: go to the start of the line
noremap <silent> <C-n> 0
" I key: go to the end of the line
noremap <silent> <C-i> $


nnoremap - <PageUp>
nnoremap = <PageDown>
nnoremap < <<
nnoremap > >>
noremap <LEADER><CR> :nohlsearch<CR> 
nnoremap tt :CocCommand explorer<CR>
nnoremap <C-s> :Startify<CR>



" Compile function
noremap r :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'cpp'
		set splitbelow
		exec "!g++ -std=c++11 % -Wall -o %<"
		:sp
		:res -15
		:term ./%<
	elseif &filetype == 'java'
		let l:dir = FindRootDirectory()
		if l:dir != ""
			set splitbelow
			:sp
			:res -13
			exec "!echo ".l:dir." > ~/.rooter "
			:term  cd $(cat ~/.rooter) && mvn clean spring-boot:run 
		else
			exec "!javac %"
			exec "!time java %<"
		endif
	elseif &filetype == 'sh'
		:!time bash %
	elseif &filetype == 'python'
		set splitbelow
		:sp
		:term python3 %
	elseif &filetype == 'html'
		silent! exec "!".g:mkdp_browser." % &"
	elseif &filetype == 'markdown'
		exec "InstantMarkdownPreview"
	elseif &filetype == 'tex'
		silent! exec "VimtexStop"
		silent! exec "VimtexCompile"
	elseif &filetype == 'dart'
		exec "CocCommand flutter.run -d ".g:flutter_default_device." ".g:flutter_run_args
		silent! exec "CocCommand flutter.dev.openDevLog"
	elseif &filetype == 'javascript'
		set splitbelow
		:sp
		:term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
	elseif &filetype == 'go'
		:GoRun
	endif
endfunc
	




call plug#begin('~/.config/nvim/plugged')

" ???????????????
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" themes
Plug 'ryanoasis/vim-devicons'
Plug 'Marfisc/vorange'

" vim ????????????
Plug 'mhinz/vim-startify'

" Coc??????
Plug 'neoclide/coc.nvim', {'branch': 'release'}


" debug
Plug 'puremourning/vimspector'

" search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

"" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'APZelos/blamer.nvim'


" ?????????
Plug 'Yggdroot/indentLine'

" ????????????
Plug 'kevinhwang91/rnvimr'


" ?????????
Plug 'liuchengxu/vista.vim'


" autoformat
Plug 'google/vim-codefmt'
Plug 'google/vim-maktaba'
Plug 'google/vim-glaive'


" HTML, CSS, JavaScript, Typescript, PHP, JSON, etc.
Plug 'elzr/vim-json'
Plug 'neoclide/jsonc.vim'
Plug 'othree/html5.vim'
Plug 'alvan/vim-closetag'
Plug 'yuezk/vim-js', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }


Plug 'jiangmiao/auto-pairs'

Plug 'sheerun/vim-polyglot'

" ???????????????
Plug 'airblade/vim-rooter'

" ????????????
Plug 'tpope/vim-surround'
Plug 'gcmt/wildfire.vim'

Plug 'preservim/nerdcommenter'
"Plug 'terryma/vim-multiple-cursors'

Plug 'kdheepak/lazygit.vim', { 'branch': 'nvim-v0.4.3' }

"undo
Plug 'mbbill/undotree'

" Go
Plug 'fatih/vim-go' , { 'for': ['go', 'vim-plug'], 'tag': '*' }

"sudo write
Plug 'lambdalisue/suda.vim' " do stuff like :sudowrite

" copy manager
Plug 'junegunn/vim-peekaboo'

Plug 'yuttie/comfortable-motion.vim'

"Plug 'scrooloose/syntastic'

Plug 'uiiaoo/java-syntax.vim'

Plug 'mg979/vim-xtabline'
Plug 'wincent/terminus'


" DB
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'



call plug#end()
call glaive#Install()

" ===
" === AutoFormat
" ===
Glaive codefmt plugin[mappings]
Glaive codefmt google_java_executable="java -jar /Users/szz/.config/nvim/format/google-java-format-1.10.0-all-deps.jar"




augroup autoformat_settings
	" autocmd FileType bzl AutoFormatBuffer buildifier
	" autocmd FileType c,cpp,proto,javascript,arduino AutoFormatBuffer clang-format
	" autocmd FileType dart AutoFormatBuffer dartfmt
	autocmd FileType go AutoFormatBuffer gofmt
	" autocmd FileType gn AutoFormatBuffer gn
	"autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
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
nmap ba <Plug>VimspectorToggleBreakpoint
nmap be <Plug>VimspectorStepOver
nmap bi <Plug>VimspectorStepInto
nmap bu <Plug>VimspectorStepOut
nmap bc <Plug>VimspectorBalloonEval
xmap bc <Plug>VimspectorBalloonEval

nmap <F1> :CocCommand java.debug.vimspector.start<CR>
function! s:read_template_into_buffer(template)
	" has to be a function to avoid the extra space fzf#run insers otherwise
	execute '0r ~/.config/nvim/sample_vimspector_json/'.a:template
endfunction
command! -bang -nargs=* LoadVimSpectorJsonTemplate call fzf#run({
			\   'source': 'ls -1 ~/.config/nvim/sample_vimspector_json',
			\   'down': 20,
			\   'sink': function('<sid>read_template_into_buffer')
			\ })
noremap <leader>vs :tabe .vimspector.json<CR>:LoadVimSpectorJsonTemplate<CR>
nmap <Leader>vi <Plug>VimspectorBalloonEval
xmap <Leader>vi <Plug>VimspectorBalloonEval

sign define vimspectorBP text=??? texthl=Normal
sign define vimspectorBPDisabled text=??? texthl=Normal
sign define vimspectorPC text=???? texthl=SpellBad

func! StartDebugServer()
	exec "w"
	if &filetype == 'java'
		exec "!openssl rand -base64 8 > ~/.javastdout"
		let l:dir = FindRootDirectory()
		"set splitbelow
		":sp
		":res -13
		if l:dir != ""
			exec "!echo ".l:dir." > ~/.rooter "
			exec "!cp ~/.config/nvim/vimspector_json/java_debug.json  ".l:dir."/.vimspector.json"
			exec "!setsid sh ~/scripts/java-debug-server.sh "
		else
			"exec "!echo % > .debug-info "
			exec "!cp ~/.config/nvim/vimspector_json/java_debug.json ."
			exec "!javac -g %"
			:term java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=5005,suspend=y (cat .debug-info)
		endif
	"exec "!sleep 5"
	"exec "CocCommand java.debug.vimspector.start"
	endif
endfunc


func! StartDebugServer2()
	if &filetype == 'java'
		set splitbelow
		:sp
		:res -13
		exec "term  tail -f /tmp/$(cat ~/.javastdout)"
	endif
endfunc

nmap <Leader>vi <Plug>VimspectorBalloonEval






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
			\"coc-vimlsp",
			\"coc-translator",
			\"coc-highlight",
			\"coc-db",
			\"coc-docker",
			\"coc-yank"]


if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

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
nmap <silent> <LEADER>v <Plug>(coc-implementation)
nmap <silent> <LEADER>r <Plug>(coc-references)

nmap <silent> <LEADER>[ <Plug>(coc-diagnostic-prev)
nmap <silent> <LEADER>] <Plug>(coc-diagnostic-next)

nmap <leader>c <Plug>(coc-rename)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

autocmd CursorHold * silent call CocActionAsync('highlight')

command! -nargs=? Fold :call     CocAction('fold', <f-args>)

command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

set termguicolors

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" ??????
nmap <Leader>t <Plug>(coc-translator-p)
vmap <Leader>t <Plug>(coc-translator-pv)
nmap <Leader>w <Plug>(coc-translator-e)
vmap <Leader>w <Plug>(coc-translator-ev)
"nmap <Leader>r <Plug>(coc-translator-r)
"vmap <Leader>r <Plug>(coc-translator-rv)


" ?????????
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>



" ===
" === rnvimr
" ===
let g:rnvimr_ex_enable = 1
let g:rnvimr_pick_enable = 1
let g:rnvimr_draw_border = 0
" let g:rnvimr_bw_enable = 1
highlight link RnvimrNormal CursorLine
nnoremap <silent> R :RnvimrToggle<CR><C-\><C-n>:RnvimrResize 0<CR>
let g:rnvimr_action = {
            \ '<C-t>': 'NvimEdit tabedit',
            \ '<C-x>': 'NvimEdit split',
            \ '<C-v>': 'NvimEdit vsplit',
            \ 'gw': 'JumpNvimCwd',
            \ 'yw': 'EmitRangerCwd'
            \ }






" ===
" === git
" ===
let g:gitgutter_git_executable = '/usr/bin/git'
let g:gitgutter_map_keys = 0
nnoremap <silent> <C-g> :LazyGit<CR>
let g:lazygit_floating_window_winblend = 0 
let g:lazygit_floating_window_scaling_factor = 0.9 
let g:lazygit_floating_window_corner_chars = ['???', '???', '???', '???'] 
let g:lazygit_floating_window_use_plenary = 0 
let g:lazygit_use_neovim_remote = 1 
let g:blamer_enabled = 1
let g:blamer_show_in_insert_modes = 0







" ===
" === FZF
" ===
" noremap <silent> <C-p> :Files<CR>
noremap <silent> <C-f> :Rg<CR>
noremap <silent> <C-h> :History<CR>
"noremap <silent> <C-g> :GFiles?<CR>
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


let g:vista_icon_indent = ["????????? ", "????????? "]
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }

nnoremap <silent> <LEADER>p :Vista!!<CR>





" ===
" === vim-go
" ===
let g:go_echo_go_info = 0
let g:go_doc_popup_window = 1
let g:go_def_mapping_enabled = 0
let g:go_template_autocreate = 0
let g:go_textobj_enabled = 0
let g:go_auto_type_info = 0
let g:go_def_mapping_enabled = 0
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_functions = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_structs = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_types = 1
let g:go_highlight_variable_assignments = 0
let g:go_highlight_variable_declarations = 0
let g:go_doc_keywordprg_enabled = 0
let g:go_fmt_autosave = 0
let g:go_imports_autosave = 0
let g:go_mod_fmt_autosave = 0
let g:go_auto_sameids = 0




nnoremap <LEADER>g :GoImport 
"autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')



" ===
" === undotree
" ===
nnoremap L :UndotreeToggle<CR>
if has("persistent_undo")
   let target_path = expand('~/.undodir')

    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let &undodir=target_path
    set undofile
endif


let g:comfortable_motion_no_default_key_mappings = 1
nnoremap <silent> <C-e> :call comfortable_motion#flick(100)<CR>
nnoremap <silent> <C-u> :call comfortable_motion#flick(-100)<CR>


" ===
" === vim-rooter
" ===
let g:rooter_patterns = ['.git', 'Makefile', '*.sln', 'pom.xml']



" ===
" === multi_cursor
" ===
let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key      = '<C-k>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'


let g:dbs = {
\ 'local': 'mysql://root:12345678@localhost',
\ }
let g:db_ui_use_nerd_fonts=1


" ===
" === xtabline
" ===
let g:xtabline_settings = {}
let g:xtabline_settings.enable_mappings = 0
let g:xtabline_settings.tabline_modes = ['tabs', 'buffers']
let g:xtabline_settings.enable_persistance = 0
let g:xtabline_settings.last_open_first = 1
let g:xtabline_settings.use_devicons = 1
let g:xtabline_settings.theme = 'slate'
noremap to :XTabCycleMode<CR>
noremap \p :echo expand('%:p')<CRL

