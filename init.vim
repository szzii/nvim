


" ======= basic set ======= 

" ==================== Auto load for first time uses ====================
"if empty(glob('~/.config/nvim' . '/autoload/plug.vim'))
"	silent execute '!curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
"	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
"endif


let mapleader = ' '

filetype plugin on
syntax on
set termguicolors " enable true colors support
let $NVIM_TUI_ENABLE_TRUE_COLOR=1


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
set inccommand=split

" indent 
set autoindent
set smartindent
set indentexpr=
set tabstop=2
set shiftwidth=2
set softtabstop=2
set noexpandtab
set foldmethod=indent
set nofoldenable

"spilt
set splitright
set nosplitbelow

" system
set mouse=a
set concealcursor=nc
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
set laststatus=2

"augroup QuickNotes
"  au!
"  autocmd BufWinLeave *.* execute "mkview! " . "~/.vim/view" . "/" . expand('<afile>:t') . ".view"
"  autocmd BufWinEnter *.* execute "silent! source " . "~/.vim/view" . "/" . expand('%:t') . ".view"
"augroup END 
" last-position-jump
autocmd BufRead * autocmd FileType <buffer> ++once
      \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif
exec "nohlsearch"




map <TAB> <nop>
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
"nmap ti :+tabnext<CR>
"nmap tn :-tabnext<CR>

" insert mode
inoremap <C-a> <ESC>A
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
noremap <LEADER><LEADER> zz



" ================ plugin =============== 
call plug#begin('~/.config/nvim/plugged')

" Base Tools
Plug 'mhinz/vim-startify'
Plug 'junegunn/vim-peekaboo'
Plug 'lambdalisue/suda.vim' " do stuff like :sudowrite
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'mbbill/undotree'
Plug 'petertriho/nvim-scrollbar'
Plug 'preservim/nerdcommenter'
Plug 'romgrk/barbar.nvim'
Plug 'yianwillis/vimcdoc', {'for': 'vim'}
Plug 'skywind3000/asyncrun.vim'
Plug 'skywind3000/asynctasks.vim'



" switch keyboard layout only on macos 
Plug 'ybian/smartim'

" themes
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'Mofiqul/vscode.nvim'
Plug 'lunarvim/darkplus.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" tmux
Plug 'edkolev/tmuxline.vim'
Plug 'wellle/tmux-complete.vim'

" git
Plug 'airblade/vim-gitgutter'
Plug 'kdheepak/lazygit.nvim'
"Plug 'APZelos/blamer.nvim'


" code Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'SirVer/ultisnips'


" fzf search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" pair range
Plug 'tpope/vim-surround'
Plug 'gcmt/wildfire.vim'

" mulit cursor
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" language
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'rust-lang/rust.vim'



call plug#end()

set t_Co=256
set t_ut=
colorscheme vscode


"===================
"====== coc configration ======
"===================
let g:coc_global_extensions = [
       		\"coc-explorer",
       		\"coc-highlight",
       		\"coc-java",
       		\"coc-json",
       		\"coc-xml",
       		\"coc-rust-analyzer",
       		\"coc-yaml",
       		\"coc-html",
				  \"coc-pairs",
					\"coc-yank",
          \"coc-translator",
       		\"coc-clangd",
       		\"coc-pyright",
       		\"coc-sh",
          \"coc-sumneko-lua",
       		\"coc-vimlsp",
       		\"coc-ultisnips",
       		\"coc-diagnostic",
          \"coc-marketplace"]

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" document
"nnoremap <silent> <LEADER>m :call ShowDocumentation()<CR>
"function! ShowDocumentation()
"  if CocAction('hasProvider', 'hover')
"    call CocActionAsync('doHover')
"  else
"    call feedkeys('K', 'in')
"  endif
"endfunction

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



nmap <LEADER>z  <Plug>(coc-codeaction)
nmap <LEADER>x  <Plug>(coc-fix-current)
nmap <LEADER>k  <Plug>(coc-rename)
nmap <silent> <LEADER>b <Plug>(coc-refactor)
nmap <silent> <LEADER>f <Plug>(coc-definition)
nmap <silent> <LEADER>d <Plug>(coc-type-definition)
nmap <silent> <LEADER>r <Plug>(coc-references)
nmap <silent> <LEADER>v <Plug>(coc-implementation)
nmap <silent> <LEADER>[ <Plug>(coc-diagnostic-prev)
nmap <silent> <LEADER>] <Plug>(coc-diagnostic-next)
nmap <silent> <LEADER>p :CocOutline<CR>


" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-e> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
 autocmd!
 " Setup formatexpr specified filetype(s).
 autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
 " Update signature help on jump placeholder.
 autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')


" coc-plugin keymaps
autocmd! FileType json syntax match Comment +\/\/.\+$+
autocmd! VimLeavePre * if get(g:, 'coc_process_pid', 0)
		\	| call system('kill -9 '.g:coc_process_pid) | endif
map <LEADER>t <Plug>(coc-translator-p)
vmap <LEADER>t <Plug>(coc-translator-pv)
nnoremap tt :CocCommand explorer<CR>
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>




" tmuxline

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


" git
"let g:gitgutter_git_executable = '/usr/bin/git'
let g:gitgutter_map_keys = 0
let g:gitgutter_sign_allow_clobber = 1
let g:gitgutter_preview_win_floating = 1
let g:gitgutter_set_sign_backgrounds = 1
" Thanks for @theniceboy
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '░'
let g:gitgutter_sign_removed = '▏'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_modified_removed = '▒'
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1

"--
let g:blamer_enabled = 1
let g:blamer_date_format = '%Y-%m-%d %H:%M'
let g:blamer_template = '<committer>: <committer-time> (<summary>)'
"--
nnoremap <silent> <LEADER>1 :LazyGit<CR>
let g:lazygit_floating_window_winblend = 0 " transparency of floating window
let g:lazygit_floating_window_scaling_factor = 1.0 " scaling factor for floating window
let g:lazygit_floating_window_corner_chars = ['╭', '╮', '╰', '╯'] " customize lazygit popup window corner characters
let g:lazygit_use_neovim_remote = 1 " for neovim-remote support



" commenter
let g:NERDCreateDefaultMappings = 0
let g:NERDDefaultAlign = 'left'
nnoremap  <Space>c <Plug>NERDCommenterToggle
xnoremap  <Space>c <Plug>NERDCommenterToggle




" undotree
nnoremap L :UndotreeToggle<CR>
let g:undotree_WindowLayout = 3
let g:undotree_RelativeTimestamp = 1
let g:undotree_HelpLine = 1
let g:undotree_ShortIndicators = 1
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_DiffCommand = "diff"
"--
function g:Undotree_CustomMap()
    nmap <buffer> u <plug>UndotreeNextState
    nmap <buffer> e <plug>UndotreePreviousState
	  nmap <buffer> U <plug>UndotreeNextSavedState
    nmap <buffer> E <plug>UndotreePreviousSavedState
    nmap <buffer> q <plug>UndotreeClose
endfunc
"--
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



" fzf
noremap <leader>2 :Rg<CR>
noremap <leader>; :History:<CR>
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9} }


" startify
nnoremap <LEADER>3 :Startify<CR>
let g:startify_custom_header = [
        \ '                                 ________  __ __        ',
        \ '            __                  /\_____  \/\ \\ \       ',
        \ '    __  __ /\_\    ___ ___      \/___//''/''\ \ \\ \    ',
        \ '   /\ \/\ \\/\ \ /'' __` __`\        /'' /''  \ \ \\ \_ ',
        \ '   \ \ \_/ |\ \ \/\ \/\ \/\ \      /'' /''__  \ \__ ,__\',
        \ '    \ \___/  \ \_\ \_\ \_\ \_\    /\_/ /\_\  \/_/\_\_/  ',
        \ '     \/__/    \/_/\/_/\/_/\/_/    \//  \/_/     \/_/    ',
        \ ]





" wildfire
let g:wildfire_objects = { "*" : ["i'", 'i"', "i)", "i]", "i}","i>"] }

" multi
let g:VM_leader = ','
let g:VM_maps = {}

let g:VM_maps['i'] = 'k'
let g:VM_maps['I'] = 'K'

let g:VM_maps['Find Under']							= '<C-k>'
let g:VM_maps['Find Subword Under']			= '<C-k>'
let g:VM_maps['Select All']  						= '<C-f>'
let g:VM_maps['Visual All']  						= '<C-f>'
let g:VM_maps['Skip Region']						= '<c-n>'
let g:VM_maps['Remove Region']					= 'q'


" auto switch keylayout
let g:smartim_default = 'com.apple.keylayout.Colemak'
function! Multiple_cursors_before()
	let g:smartim_disable = 1
endfunction
function! Multiple_cursors_after()
	unlet g:smartim_disable
endfunction

" vim-go
let g:go_gopls_enabled = 0
let g:go_fmt_autosave = 0
let g:go_imports_autosave = 0
let g:go_fmt_command = 'goimports'
let g:go_addtags_transform = "camelcase"
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_fields = 1
"let g:go_highlight_extra_types = 1
"let g:go_highlight_operators = 1
"let g:go_alternate_mode = "vsplit"


autocmd FileType go nmap <LEADER><LEADER> :GoAlternate!<CR>
autocmd Filetype go command! -bang T call go#coverage#BufferToggle(<bang>0)

autocmd Filetype go nmap <LEADER>0 :GoDebugStart<CR>
autocmd Filetype go nmap <LEADER>q :GoDebugStop<CR>

let g:go_debug_breakpoint_sign_text = '>'
let g:go_debug_mappings = {
   \ '(go-debug-breakpoint)': {'key': '1'},
   \ '(go-debug-stepout)':    {'key': '7'},
   \ '(go-debug-next)':       {'key': '8'},
   \ '(go-debug-step)':       {'key': '9'},
   \ '(go-debug-continue)':   {'key': '0'},
\ }



" Compile function
noremap <leader><esc> :AsyncStop<CR>
noremap r :call CompileRun()<CR>
func! CompileRun()
  exec "w"
  if &filetype == 'python'
		call asyncrun#run("", {}, "python3 $(VIM_FILENAME)")
	elseif &filetype == 'go'
		call s:runGoFiles()
	elseif &filetype == 'java'
		call s:runJavaFiles()
  endif
endfunc

function! s:runGoFiles()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    :GoTestFunc
  elseif l:file =~# '^\f\+\.go$'
		:GoRun
  endif
endfunction

function! s:runJavaFiles()
	let l:pom = findfile("pom.xml",".;")
	if l:pom != ""
		let l:file = expand('%')
		if l:file =~# '^\f\+Test\.java$' || l:file =~# '^\f\+Tests\.java$'
			let l:funcName = s:getClassPath()
			call asyncrun#run("", {'cwd' :'<root>','save': 2}, "mvn -DskipTests clean package && \
					\java -jar ~/.config/nvim/junit-platform-console-standalone-1.9.1.jar \
		 			\-cp target/test-classes \
		 			\--disable-ansi-colors \
		 			\-m ".. l:funcName)
		else 
			call asyncrun#run("", {'cwd' :'<root>','save': 2}, "mvn clean spring-boot:run")
		endif
	else 
		call asyncrun#run("", {'save': 1}, "javac $(VIM_FILENAME) && java $(VIM_FILENAME)")
	endif
endfunction

command! Cp call s:getClassPath()

function s:getClassPath() abort
	let l:line = substitute(getline(1),"package ","","")
	let l:line = strpart(l:line,0,strlen(l:line) - 1)
	return l:line .. "." .. expand("%:r")  .. "#" .. expand("<cword>")
endfunction



let g:UltiSnipsExpandTrigger            = '<c-I>'
let g:UltiSnipsListSnippets             = '<c-N>'
let g:UltiSnipsJumpForwardTrigger       = '<c-i>'
let g:UltiSnipsJumpBackwardTrigger      = '<c-n>'

let g:UltiSnipsSnippetDirectories=["UltiSnips", "MySnippets"]



"TS
nnoremap <LEADER>h :TSHighlightCapturesUnderCursor<CR>


" indentline
let g:indent_blankline_filetype_exclude = ['help','startify','markdown','json','jsonc','qf']


"barbar
" Move to previous/next
nnoremap <silent>    tn <Cmd>BufferPrevious<CR>
nnoremap <silent>    ti <Cmd>BufferNext<CR>

" Re-order to previous/next
nnoremap <silent>    tN <Cmd>BufferMovePrevious<CR>
nnoremap <silent>    tI <Cmd>BufferMoveNext<CR>

" Goto buffer in position...
nnoremap <silent>    t1 <Cmd>BufferGoto 1<CR>
nnoremap <silent>    t2 <Cmd>BufferGoto 2<CR>
nnoremap <silent>    t3 <Cmd>BufferGoto 3<CR>
nnoremap <silent>    t4 <Cmd>BufferGoto 4<CR>
nnoremap <silent>    t5 <Cmd>BufferGoto 5<CR>
nnoremap <silent>    t6 <Cmd>BufferGoto 6<CR>
nnoremap <silent>    t7 <Cmd>BufferGoto 7<CR>
nnoremap <silent>    t8 <Cmd>BufferGoto 8<CR>
nnoremap <silent>    t9 <Cmd>BufferGoto 9<CR>
nnoremap <silent>    t0 <Cmd>BufferLast<CR>

" Pin/unpin buffer
nnoremap <silent>    tp <Cmd>BufferPin<CR>

" Close buffer
nnoremap <silent>    tq <Cmd>BufferClose<CR>
nnoremap <silent>    tQ <Cmd>BufferCloseAllButCurrent<CR>

" Wipeout buffer
"                          :BufferWipeout
" Close commands
"                          :BufferCloseAllButCurrent
"                          :BufferCloseAllButVisible
"                          :BufferCloseAllButPinned
"                          :BufferCloseAllButCurrentOrPinned
"                          :BufferCloseBuffersLeft
"                          :BufferCloseBuffersRight

" Sort automatically by...
nnoremap <silent> to <Cmd>BufferOrderByBufferNumber<CR>

let g:asyncrun_open = 8
let g:asyncrun_rootmarks = ['.git','pom.xml', '.svn', '.root', '.project', '.hg','.vscode','.project']

" ==================== nvim-scrollbar ====================
lua <<EOF
require'nvim-treesitter.configs'.setup {
	--ensure_installed = { "java" },
	ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages


  highlight = {
    enable = true,
		disable = { "c", "rust", "go" },

  },
}


require("scrollbar").setup({
    show = true,
    show_in_active_only = true,
    set_highlights = true,
})

require'lualine'.setup {
  options = {
    theme = 'vscode'
  },
	sections = { lualine_c = { 'g:coc_status' } }
}

require("indent_blankline").setup {
    show_current_context = true,
}

--vim.o.background = 'light'

require('vscode').setup({
    -- Enable transparent background
    transparent = true,

    -- Disable nvim-tree background color
    --disable_nvimtree_bg = true,

    -- Override highlight groups (see ./lua/vscode/theme.lua)
    group_overrides = {
        -- this supports the same val table as vim.api.nvim_set_hl
        -- use colors from this colorscheme by requiring vscode.colors!
        CocHighlightText = { bold=true ,bg = "#4B4B4B" },
        --ScrollbarHandle = { bold=true ,bg = "#26DAFF" },
    }
})

-- java
vim.api.nvim_set_hl(0, "@type.qualifier.java", { link = "@keyword" })
vim.api.nvim_set_hl(0, "@exception.java", { link = "@keyword" })
-- vim.api.nvim_set_hl(0, "@type.java", { bold = true })
-- vim.api.nvim_set_hl(0, "@constant.java", { bold = true })
-- common
vim.api.nvim_set_hl(0, "@variable", { fg = "#F5ECEB" })
vim.api.nvim_set_hl(0, "@parameter", { fg = "#F5ECEB" })
vim.api.nvim_set_hl(0, "@field", { fg = "#F5ECEB" })

EOF
