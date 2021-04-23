
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
set guifont=FiraCode\ Nerd\ Font:h16
set complete-=i 
set complete-=t
let g:neovide_cursor_vfx_mode = "railgun"
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline
let mapleader = ' '
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" ale 
let g:airline#extensions#ale#enabled = 1
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚡'
let g:ale_disable_lsp = 1
let g:ale_java_javac_options = "/home/szz/.config/coc/extensions/coc-java-data/lombok.jar"
nnoremap <LEADER>a :ALEComplete<CR>

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
noremap <C-l> g_
noremap <C-j> 0
noremap <LEADER><CR> :nohlsearch<CR> 
noremap J 7h
noremap L 7l
noremap I 5k
noremap K 5j
noremap <C-k> 5<C-e>
noremap ; :
noremap ` ~
noremap <LEADER>rc :e ~/.config/nvim/init.vim<CR>


nnoremap - <PageUp>
nnoremap = <PageDown>
nnoremap tt :CocCommand explorer<CR>
nnoremap TT :CocCommand explorer<CR>
nnoremap < <<
nnoremap > >>
nnoremap <C-s> :Startify<CR>

inoremap <C-j> <Left>
inoremap <C-l> <Right>
inoremap <C-b> <BS>
inoremap <C-c> <ESC>

nnoremap Y y$
vnoremap Y "+y

cnoremap <c-k> <down>
cnoremap <c-i> <up>
nnoremap <c-i>  :<c-u>execute 'move -1-'. v:count1<cr>
nnoremap <c-k>  :<c-u>execute 'move +'. v:count1<cr>

func! StartDebugServer()
	exec "w"
	if &filetype == 'java'
		set splitbelow
		:sp
		:res -13
		let l:dir = FindRootDirectory()
		if l:dir != ""
			exec "!echo ".l:dir." > /home/szz/.rooter "
			:term  cd (cat /home/szz/.rooter) && mvn spring-boot:run -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005"
		else
			exec "!echo % > .debug-info "
			exec "!javac -g %"
			:term java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=5005,suspend=y (cat .debug-info)
		endif
	endif
endfunc

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
		set splitbelow
		:sp
		:res -13
		let l:dir = FindRootDirectory()
		if l:dir != ""
			exec "!echo ".l:dir." > /home/szz/.rooter "
			:term  cd (cat /home/szz/.rooter) && mvn clean spring-boot:run 
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
Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle', 'for': ['text', 'markdown', 'vim-plug'] }
Plug 'mzlogin/vim-markdown-toc', { 'for': ['gitignore', 'markdown', 'vim-plug'] }
Plug 'dkarter/bullets.vim'

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

" HTML, CSS, JavaScript, Typescript, PHP, JSON, etc.
Plug 'elzr/vim-json'
Plug 'neoclide/jsonc.vim'
Plug 'othree/html5.vim'
Plug 'alvan/vim-closetag'
Plug 'yuezk/vim-js', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }


Plug 'jiangmiao/auto-pairs'

Plug 'sheerun/vim-polyglot'

Plug 'airblade/vim-rooter'

Plug 'tpope/vim-surround'
Plug 'preservim/nerdcommenter'
Plug 'terryma/vim-multiple-cursors'
Plug 'kdheepak/lazygit.vim', { 'branch': 'nvim-v0.4.3' }

Plug 'itchyny/calendar.vim'

Plug 'mbbill/undotree'
" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

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
nnoremap <silent> <C-g> :LazyGit<CR>
let g:lazygit_floating_window_winblend = 0 
let g:lazygit_floating_window_scaling_factor = 0.9 
let g:lazygit_floating_window_corner_chars = ['╭', '╮', '╰', '╯'] 
let g:lazygit_floating_window_use_plenary = 0 
let g:lazygit_use_neovim_remote = 1 




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

nnoremap <LEADER>g :GoImport 



" ===
" === undotree
" ===
nnoremap U :UndotreeToggle<CR>
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

