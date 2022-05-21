
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
set autowrite
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
set virtualedit=block
set completeopt=longest,noinsert,menuone,noselect,preview
set ttyfast "should make scrolling faster
set lazyredraw "same as above
set visualbell

set t_Co=256
let mapleader = ' '
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
let g:suda_smart_edit = 1


" airline
let g:airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts = 1
"let g:airline_theme='vorange'
let g:airline#extensions#tabline#enabled = 1

" devicons 
let g:webdevicons_enable = 1
let g:webdevicons_enable_startify = 1
let g:webdevicons_enable_flagship_statusline = 1


" themes
"set filetype=java
let java_highlight_functions = 1
let java_highlight_all = 1
highlight link javaIdentifier NONE
highlight link javaDelimiter NONE

highlight link javaScopeDecl Statement
highlight link javaType Type
"highlight link javaDocTags PreProc


"let g:rehash256 = 1
set termguicolors
"set background=dark
autocmd vimenter * ++nested colorscheme jellybeans
"colorscheme deus



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
noremap <LEADER>n <C-w>h 
map <LEADER>u <C-w>k
map <LEADER>e <C-w>j
map <LEADER>i <C-w>l
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

" Open the vimrc file anytime
noremap <LEADER>rc :e $HOME/.config/nvim/init.vim<CR>

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
nnoremap <LEADER>3 :Startify<CR>



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
       elseif &filetype == 'rust'
       	let l:dir = FindRootDirectory()
       	if l:dir != ""
          set splitbelow
       		:sp
       		:res -13
       		exec "!echo ".l:dir." > ~/.rooter "
       		:term  cd $(cat ~/.rooter) && cargo run
        else
          :RustRun
        endif
       elseif &filetype == 'lua'
       	set splitbelow
       	:sp
       	:term lua %
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

" 底部状态栏
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" themes
Plug 'ryanoasis/vim-devicons'
Plug 'uiiaoo/java-syntax.vim'
Plug 'Iron-E/nvim-highlite'
"Plug 'Th3Whit3Wolf/one-nvim'
"Plug 'tandy1229/nvim-deus'
"Plug 'theniceboy/nvim-deus'
Plug 'nanotech/jellybeans.vim'

" c 语法高亮
Plug 'jackguo380/vim-lsp-cxx-highlight'




" vim 开始导航
Plug 'mhinz/vim-startify'

" Coc系列
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}



" debug
Plug 'puremourning/vimspector'

" search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

"" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'APZelos/blamer.nvim'



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


" HTML, CSS, JavaScript, Typescript, PHP, JSON, etc.
Plug 'elzr/vim-json'
Plug 'neoclide/jsonc.vim'
Plug 'othree/html5.vim'
Plug 'alvan/vim-closetag'
Plug 'yuezk/vim-js', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }


Plug 'sheerun/vim-polyglot'

" 根目录搜索
Plug 'airblade/vim-rooter'

" 环绕增强
Plug 'tpope/vim-surround'
Plug 'gcmt/wildfire.vim'

" 注视
Plug 'preservim/nerdcommenter'

" 多光标
Plug 'mg979/vim-visual-multi'

Plug 'kdheepak/lazygit.vim'

"undo
Plug 'mbbill/undotree'

" Go
Plug 'fatih/vim-go' 

"sudo write
Plug 'lambdalisue/suda.vim' " do stuff like :sudowrite

" copy manager
Plug 'junegunn/vim-peekaboo'

"平滑滚动！
Plug 'yuttie/comfortable-motion.vim'



Plug 'mg979/vim-xtabline'
Plug 'wincent/terminus'


" DB
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'

Plug 'sbdchd/neoformat'




call plug#end()
call glaive#Install()

" ===
" === AutoFormat
" ===
Glaive codefmt plugin[mappings]
Glaive codefmt google_java_executable="java -jar /Users/szz/.config/nvim/format/google-java-format-1.10.0-all-deps.jar"




augroup autoformat_settings
       "" autocmd FileType bzl AutoFormatBuffer buildifier
       "" autocmd FileType c,cpp,proto,javascript,arduino AutoFormatBuffer clang-format
       "" autocmd FileType dart AutoFormatBuffer dartfmt
       ""autocmd FileType go AutoFormatBuffer gofmt
       "" autocmd FileType gn AutoFormatBuffer gn
       ""autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
        autocmd FileType java AutoFormatBuffer google-java-format
       "" autocmd FileType python AutoFormatBuffer yapf
       "" Alternative: autocmd FileType python AutoFormatBuffer autopep8
        autocmd FileType rust AutoFormatBuffer rustfmt
       "" autocmd FileType vue AutoFormatBuffer prettier
augroup END



" ===
" === vimspector
" ===
let g:vimspector_enable_mappings = 'HUMAN'
nmap bb <Plug>VimspectorContinue	
nmap ba <Plug>VimspectorToggleBreakpoint
nmap bx <Plug>VimspectorRunToCursor	
nmap be <Plug>VimspectorStepOver
nmap bi <Plug>VimspectorStepInto
nmap bu <Plug>VimspectorStepOut
nmap bc <Plug>VimspectorBalloonEval
xmap bc <Plug>VimspectorBalloonEval
nmap <Leader>vi <Plug>VimspectorBalloonEval
xmap <Leader>vi <Plug>VimspectorBalloonEval
nmap <Leader>b :CocList mainClassListRun<CR>

nmap <F1> :CocCommand java.debug.vimspector.start<CR>
function! s:read_template_into_buffer(template)
       "" has to be a function to avoid the extra space fzf#run insers otherwise
       "execute '0r ~/.config/nvim/sample_vimspector_json/'.a:template
endfunction
command! -bang -nargs=* LoadVimSpectorJsonTemplate call fzf#run({
       		"\   'source': 'ls -1 ~/.config/nvim/sample_vimspector_json',
       		"\   'down': 20,
       		"\   'sink': function('<sid>read_template_into_buffer')
       		"\ })
noremap <leader>vs :tabe .vimspector.json<CR>:LoadVimSpectorJsonTemplate<CR>


sign define vimspectorBP text=☛ texthl=Normal
sign define vimspectorBPDisabled text=☞ texthl=Normal
sign define vimspectorPC text=🔶 texthl=SpellBad








" ===
" === coc
" ===
let g:coc_global_extensions = [
       		\"coc-markdownlint",
       		\"coc-explorer",
       		\"coc-java",
       		\"coc-java-vimspector",
       		\"coc-xml",
       		\"coc-html",
       		\"coc-yaml",
       		\"coc-vimlsp",
       		\"coc-highlight",
       		\"coc-db",
       		\"coc-sh",
          \"coc-pairs",
       		\"coc-docker",
          \"coc-rust-analyzer",
       		\"coc-clangd",
          \"coc-sumneko-lua",
       		\"coc-go",
       		\"coc-translator",
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

nmap <leader>k <Plug>(coc-rename)

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

" 翻译
nmap <Leader>t <Plug>(coc-translator-p)
vmap <Leader>t <Plug>(coc-translator-pv)
nmap <Leader>w <Plug>(coc-translator-e)
vmap <Leader>w <Plug>(coc-translator-ev)
"nmap <Leader>r <Plug>(coc-translator-r)
"vmap <Leader>r <Plug>(coc-translator-rv)


" 剪切版
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>



" ===
" === rnvimr
" ===
let g:rnvimr_ex_enable = 1
let g:rnvimr_pick_enable = 1
let g:rnvimr_draw_border = 0
" let g:rnvimr_bw_enable = 1
highlight link RnvimrNormal CursorLine
nnoremap <silent> <LEADER>2 :RnvimrToggle<CR><C-\><C-n>:RnvimrResize 0<CR>
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
let g:blamer_enabled = 1
let g:blamer_show_in_insert_modes = 0
nnoremap <silent> <LEADER>1 :LazyGit<CR>
let g:lazygit_floating_window_winblend = 0 " transparency of floating window
let g:lazygit_floating_window_scaling_factor = 1.0 " scaling factor for floating window
let g:lazygit_floating_window_corner_chars = ['╭', '╮', '╰', '╯'] " customize lazygit popup window corner characters
let g:lazygit_use_neovim_remote = 1 " for neovim-remote support

"let g:lazygit_floating_window_winblend = 0 
"let g:lazygit_floating_window_scaling_factor = 0.9 
"let g:lazygit_floating_window_corner_chars = ['╭', '╮', '╰', '╯'] 
"let g:lazygit_floating_window_use_plenary = 0 
"let g:lazygit_use_neovim_remote = 1 







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


let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
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
let g:go_auto_type_info = 1
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
let g:go_fmt_command = "gopls"
let g:go_test_timeout = '20s'
let g:go_gopls_enabled = 1
let g:go_info_mode = 'guru'



"let g:go_fmt_fail_silently = 1


" key mapping
autocmd FileType go nmap gr  <Plug>(go-test)
autocmd FileType go nmap gb  <Plug>(go-build)
autocmd FileType go nmap gc  <Plug>(go-coverage-toggle)
" tags
autocmd FileType go nmap gta :CocCommand go.tags.add 
autocmd FileType go nmap gtl :CocCommand go.tags.line 
autocmd FileType go nmap gtr :CocCommand go.tags.remove 
autocmd FileType go nmap gtd :CocCommand go.tags.remove.line 
autocmd FileType go nmap gtc :CocCommand go.tags.clear<cr>
" test
autocmd FileType go nmap <LEADER>g :CocCommand go.test.generate.function<cr>
autocmd FileType go nmap <LEADER><LEADER> :CocCommand go.test.toggle<cr>






nnoremap <LEADER>g :GoImport 
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')



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
let g:rooter_patterns = ['.git', 'Makefile', '*.sln', 'pom.xml','Cargo.toml']



" ===
" === multi_cursor
" ===
let g:VM_default_mappings = 0
"let g:VM_leader = ','
let g:VM_maps = {}
let g:VM_maps['Find Under']                  = '<C-k>'
let g:VM_maps['Find Subword Under']          = '<C-k>'




let g:dbs = {
\ 'local-mysql': 'mysql://root:123456@localhost',
\ 'tyg-mysql': 'mysql://root:123456abc@xycm.mysql.com',
\ 'local-mongo': 'mongodb://192.168.116.8:27017/test',
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
let g:xtabline_settings.theme = 'seoul'
noremap to :XTabCycleMode<CR>
noremap \p :echo expand('%:p')<CRL



xmap <leader>s  <Plug>(coc-convert-snippet)



