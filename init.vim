


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
set cursorline
set cursorlineopt=number
"set relativenumber
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


" ======= basic keymap ======= 

"
"     ^
"     u
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
noremap N 0
noremap I $

map <TAB> >
xmap <TAB> >
map <S-TAB> <
xmap <S-TAB> <
nnoremap \ e

" Insert Key
noremap h i
noremap H I

" Save & quit
"map s :<nop>
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
"noremap <up> :res +5<CR>
"noremap <down> :res -5<CR>
"noremap <left> :vertical resize-5<CR>
"noremap <right> :vertical resize+5<CR>


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
Plug 'kevinhwang91/rnvimr'
Plug 'junegunn/vim-peekaboo'
Plug 'lambdalisue/suda.vim' " do stuff like :sudowrite
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'mbbill/undotree'
Plug 'petertriho/nvim-scrollbar'
Plug 'preservim/nerdcommenter'
Plug 'romgrk/barbar.nvim'
Plug 'yianwillis/vimcdoc', {'for': 'vim'}
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'skywind3000/asyncrun.vim'
Plug 'skywind3000/asynctasks.vim'
Plug 'airblade/vim-rooter'
Plug 'ggandor/leap.nvim'



" switch keyboard layout only on macos 
Plug 'ybian/smartim'

" themes
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
"Plug 'ryanoasis/vim-devicons'
Plug 'szzii/vscode.nvim'
Plug 'lunarvim/darkplus.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" tmux
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
nnoremap <silent> tt :CocCommand explorer<CR>
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>

function! s:open_explorer()
	setl cursorlineopt=line
	lua require'bufferline.api'.set_offset(41, 'FileTree')
endfunction

function! s:quit_explorer()
	lua require'bufferline.api'.set_offset(0)
endfunction

augroup CocExplorerCustom
  autocmd!
	autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif
  autocmd User CocExplorerOpenPost  call <SID>open_explorer()
  autocmd User CocExplorerQuitPre  call <SID>quit_explorer()
augroup END

" rooter
let g:rooter_patterns = ['.git', 'Makefile', '*.sln', 'pom.xml','Cargo.toml','go.mod']


" git
"let g:gitgutter_git_executable = '/usr/bin/git'
let g:gitgutter_map_keys = 0
let g:gitgutter_sign_allow_clobber = 1
let g:gitgutter_preview_win_floating = 1
let g:gitgutter_set_sign_backgrounds = 1
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '░'
let g:gitgutter_sign_removed = '▏'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_modified_removed = '▒'

"--
let g:blamer_enabled = 1
let g:blamer_date_format = '%Y-%m-%d %H:%M'
let g:blamer_template = '<committer>: <committer-time> (<summary>)'
"--
nnoremap <silent> <c-g> :LazyGit<CR>
let g:lazygit_floating_window_winblend = 1 " transparency of floating window
let g:lazygit_floating_window_scaling_factor = 0.685 " scaling factor for floating window
let g:lazygit_floating_window_corner_chars = ['╭', '╮', '╰', '╯'] " customize lazygit popup window corner characters
let g:lazygit_use_neovim_remote = 1 " for neovim-remote support



" commenter
let g:NERDCreateDefaultMappings = 0
let g:NERDDefaultAlign = 'left'
nnoremap  <Space>c <Plug>NERDCommenterToggle
xnoremap  <Space>c <Plug>NERDCommenterToggle


" undotree
nnoremap <leader>l :UndotreeToggle<CR>
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
noremap <leader>; :History:<CR>
noremap <c-n> :Notes<CR>
noremap <c-f> :Rg<CR>
noremap <C-h> :Helptags<CR>

let g:fzf_layout = { 'window': { 'width': 0.7, 'height':0.7} }

command! -bang -nargs=* Rg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case " .. shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

command! -bang -nargs=* Notes
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case '' ~/notes", 1,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)


" rnvimr
let g:rnvimr_enable_picker = 1
let g:rnvimr_enable_bw = 1
nnoremap <LEADER>2 :RnvimrToggle<CR>


" startify
nnoremap <LEADER>3 :Startify<CR>
let g:startify_custom_header =
            \ startify#pad(split(system('fortune | cowsay'), '\n'))



" wildfire
let g:wildfire_objects = { "*" : ["i'", 'i"', "i)", "i]", "i}","i>"] }

" multi
let g:VM_leader = ','
let g:VM_maps = {}

let g:VM_maps['i'] = 'k'
let g:VM_maps['I'] = 'K'

let g:VM_maps['Find Under']							= '<C-k>'
let g:VM_maps['Find Subword Under']			= '<C-k>'
"let g:VM_maps['Select All']  						= '<C-f>'
"let g:VM_maps['Visual All']  						= '<C-f>'
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
		call asyncrun#run("", {'save':1}, "python3 $(VIM_FILENAME)")
	elseif &filetype == 'go'
		call s:runGoFiles()
	elseif &filetype == 'java'
		call s:runJavaFiles()
	elseif &filetype == 'rust'
		call s:runRustFiles()
  endif
endfunc


function! s:runRustFiles()
	let l:dir = FindRootDirectory()
	if l:dir != ""
		call asyncrun#run("", {'save': 2}, "cargo run")
	else
		:RustRun
	endif
endfunction

function! s:runGoFiles()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    :GoTestFunc
  elseif l:file =~# '^\f\+\.go$'
		:GoRun
  endif
endfunction

function! s:runJavaFiles()
	let l:dir = FindRootDirectory()
	if l:dir != ""
		let l:file = expand('%')
		if l:file =~# '^\f\+Test\.java$' || l:file =~# '^\f\+Tests\.java$'
			let l:testName = s:getJavaTestFuncName()
			call asyncrun#run("", {'save': 2}, "mvn package -Dtest=".. l:testName .." test" )
		else 
			call asyncrun#run("", {'save': 2}, "mvn -Dmaven.test.skip=true clean spring-boot:run")
		endif
	else 
		call asyncrun#run("", {'save': 1}, "javac -cp . $(VIM_FILENAME) && java $(VIM_FILENAME)")
	endif
endfunction

function s:getJavaTestFuncName()
	if expand("<cword>") != ""
		return expand("%:t:r")  .. "#" .. expand("<cword>")
	else 
		return expand("%:t:r")
	endif
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


" bufferline
" Move to previous/next
nnoremap <silent> tn <Cmd>BufferPrevious<CR>
nnoremap <silent> ti <Cmd>BufferNext<CR>

" Goto buffer in position...
nnoremap <silent>t1 <Cmd>BufferGoto 1<CR>
nnoremap <silent>t2 <Cmd>BufferGoto 2<CR>
nnoremap <silent>t3 <Cmd>BufferGoto 3<CR>
nnoremap <silent>t4 <Cmd>BufferGoto 4<CR>
nnoremap <silent>t5 <Cmd>BufferGoto 5<CR>
nnoremap <silent>t6 <Cmd>BufferGoto 6<CR>
nnoremap <silent>t7 <Cmd>BufferGoto 7<CR>
nnoremap <silent>t8 <Cmd>BufferGoto 8<CR>
nnoremap <silent>t9 <Cmd>BufferGoto 9<CR>
nnoremap <silent>t0 <Cmd>BufferLast<CR>

" close buffers
nnoremap <silent>tq <Cmd>BufferClose<CR>
nnoremap <silent>tQ <Cmd>BufferCloseAllButCurrent<CR>
nnoremap <silent>tr <Cmd>BufferCloseBuffersRight<CR>
nnoremap <silent>tl <Cmd>BufferCloseBuffersLeft<CR>


let g:asyncrun_open = 8


let g:suda_smart_edit = 1




" ==================== nvim-scrollbar ====================
lua <<EOF

require("scrollbar").setup({
    show = true,
    show_in_active_only = true,
    set_highlights = true,
		handle = {
				text = "░",
				hide_if_all_visible = true, -- Hides handle if all lines are visible
    },
		excluded_filetypes = {
        "coc-explorer",
    },
    handlers = {
        cursor = false,
        diagnostic = false,
        gitsigns = false, -- Requires gitsigns
        handle = true,
        search = false, -- Requires hlslens
        ale = false, -- Requires ALE
    },
})



require("indent_blankline").setup {
    show_current_context = true,
}


require('leap').init_highlight(true)
vim.keymap.set({'n', 'x', 'o'}, 'f', '<Plug>(leap-forward-to)')
vim.keymap.set({'n', 'x', 'o'}, 'F', '<Plug>(leap-backward-to)')
vim.keymap.set({'n', 'x', 'o'}, '^', '<Plug>(leap-forward-till)')
vim.keymap.set({'n', 'x', 'o'}, '&', '<Plug>(leap-backward-till)')

-- Set barbar's options
require'bufferline'.setup {
		animation = true,
		tabpages = false,
	  icons = 'both',
		icon_custom_colors = false,
		icon_separator_active = '▎',
		icon_separator_inactive = '▎',
		icon_close_tab = '',
    icon_close_tab_modified = '●',
		icon_pinned = '車',
}


require('nvim-treesitter.configs').setup {
	--ensure_installed = { "java" },
	ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages

  highlight = {
    enable = true,
		disable = { "c", "rust", "go" },
  },
}
-- Set barbar's options

require('vscode').setup({
    -- Enable transparent background
    transparent = true,

		italic_comments = true,

    -- Disable nvim-tree background color
    -- disable_nvimtree_bg = false,

    -- Override highlight groups (see ./lua/vscode/theme.lua)
    group_overrides = {
        -- this supports the same val table as vim.api.nvim_set_hl
        -- use colors from this colorscheme by requiring vscode.colors!

				-- vim
				Search = { bg = "#65FF58", fg = "#26120F",bold = true },
				CursorLineNr = {fg = "white"},

				-- coc.nvim
				CocHighlightText = { bold=true ,bg = "#4B4B4B" },

        -- scrollbar
        ScrollbarHandle = { fg = '#26DAFF' , bg ='NONE' },
				ScrollbarWarnHandle = { fg ='yellow' },
				ScrollbarErrorHandle = { fg ='red' },
				ScrollbarInfoHandle = { fg ='white' },
				ScrollbarHintHandle = { fg ='grey' },
				ScrollbarWarn = { fg ='yellow' },
				ScrollbarError = { fg ='red' },
				ScrollbarInfo = { fg ='white' },
				ScrollbarHint = { fg ='grey' },

				-- barbar
				BufferTabpageFill = { bg = 'NONE' },
				-- BufferTabpages = { fg = 'grey' },


				-- nvim-treesitter
				['@variable'] = { fg = "#F5ECEB" },
				['@parameter'] = { fg = "#F5ECEB" },
				['@field'] = { fg = "#F5ECEB" },
				['@constant'] = { italic = true },
				['@type.qualifier.java'] = { link = "@keyword" },
				['@exception.java'] = { link  = "@keyword" },
		 
				-- leap.nvim
				LeapMatch = { fg = 'yellow' },
				-- LeapLabelPrimary = { fg = 'red' }
				-- LeapLabelSecondary = { fg = 'blue' }
				-- LeapLabelSelected = { fg = 'black' }
				LeapBackdrop = { fg = 'grey' },

				-- Diagnostic 
				DiagnosticWarn = { fg = 'yellow', bg = 'NONE'},
				DiagnosticError = { fg = 'red', bg = 'NONE'},
				DiagnosticHint = { fg = 'grey', bg = 'NONE'},
				DiagnosticInfo = { fg = 'white', bg = 'NONE'},

				-- BufferCurrentIcon = { fg = 'yellow'}
    }
})


require'lualine'.setup {
	options = {
		icons_enabled = true,
		theme = 'vscode',
		component_separators = { left = '', right = ''},
		section_separators = { left = '', right = ''},
		ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
	},
	sections = {
		lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'g:coc_status','searchcount'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}

EOF

