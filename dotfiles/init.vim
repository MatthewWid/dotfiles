" ------------------------------------------------------------ Install Plugins

" Install plugins
call plug#begin()

" Utility functions needed by other plugins
Plug 'nvim-lua/plenary.nvim', { 'branch': 'master' }

" Nord colour scheme for NeoVim
Plug 'shaunsingh/nord.nvim'

" Sidebar file explorer with icons and git diff signs
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

" \ca to auto-comment one or many lines in any language
Plug 'preservim/nerdcommenter'

" Easy window/buffer resizing
Plug 'simeji/winresizer'

" :MarkdownPreview to preview markdown files in your browser
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" \ww to swap windows/buffers
Plug 'wesQ3/vim-windowswap'

" Show git diff in sign column
Plug 'airblade/vim-gitgutter'

" Jump between corresponding ', ", `, | pairs
Plug 'airblade/vim-matchquote'

" Find and replace
Plug 'nvim-lua/plenary.nvim'
Plug 'windwp/nvim-spectre'

" Extremely fast fuzzy finder for files, text and everything else
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Fast semantic auto-completion and LSP integration
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" Show coc.nvim diagnostics in lightline
Plug 'josa42/vim-lightline-coc'

" Status line customisation
Plug 'itchyny/lightline.vim'

" Retrieve current git branch for lightline.vim
Plug 'itchyny/vim-gitbranch'

" git-vim integration
Plug 'tpope/vim-fugitive'

" Show colours next to hex strings
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

" Quickly temporarily toggle-maximize split windows
Plug 'szw/vim-maximizer'

" Smarter syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

" Official Copilot plugin
Plug 'github/copilot.vim'

" AI productivity tools
Plug 'olimorris/codecompanion.nvim'

call plug#end()

" ------------------------------------------------------------ Plugin Settings 

" ------------------------------ vim-plug

" :Pins installs plugins
command Pins PlugInstall

" :Pclean cleans unused plugins
command Pclean PlugClean

" ------------------------------ nvim-tree.lua

lua <<EOF
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  -- s or i to open file in horizontal or vertical split
  vim.keymap.set('n', 's', api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', 'i', api.node.open.horizontal, opts('Open: Horizontal Split'))

  -- t to open file in new tab
  vim.keymap.set('n', 't', api.node.open.tab, opts('Open: New Tab'))

  -- l to open file or directory
  vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))

  -- h to close directory
  vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
end

require("nvim-tree").setup({
  on_attach = on_attach,
  view = {
    number = true,
    relativenumber = true,
  },
  ui = {
    confirm = {
      remove = false,
      trash = false,
    },
  },
	actions = {
		open_file = {
			resize_window = true
		}
	}
})
EOF

" Open file explorer to current file
command Nf NvimTreeFindFile

" Toggle open file explorer
nmap <silent> <C-b> :NvimTreeToggle<CR>

" ------------------------------ copilot.vim
" 
" " Remap accept Copilot suggestion to <C-\>
imap <silent><script><expr> <C-\> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" ------------------------------ codecompanion.nvim

lua <<EOF
require("codecompanion").setup({
	strategies = {
		chat = {
			adapter = "copilot"
		},
		inline = {
			adapter = "copilot"
		},
	},
})
EOF

" Shortcuts to CodeCompanion commands
command CC CodeCompanion
command Cc CodeCompanion
command CCc CodeCompanionChat
command Ccc CodeCompanionChat
command Ch CodeCompanionChat

" ------------------------------ nerdcommenter

" \cc to comment out a highlighted section of code
vmap <leader>cc :NerdCommenterToggle<CR> 

" Add spaces after comment delimiters
let g:NERDSpaceDelims = 1

" Add comment delimiters to empty lines, too
let g:NERDCommentEmptyLines = 1

" ------------------------------ vim-devicons

" Fix icon alignment when combined with Git diff icons
let g:WebDevIconsNerdTreeGitPluginForceVAlign=1

" ------------------------------ nvim-treesitter

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
		"json",
		"json5",
		"jsonc",
		"jsonnet",
		"javascript",
		"jsdoc",
		"lua",
		"typescript",
		"vim",
		"terraform",
		"regex",
		"nginx",
		"markdown",
		"markdown_inline",
		"git_rebase",
		"gitcommit",
		"dockerfile",
		"csv",
		"c_sharp",
		"bash",
		"bash",
		"astro",
	},
  sync_install = true,
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
  },
}
EOF

" ------------------------------ lsp-zero.nvim

" lua <<EOF
" local lsp_zero = require('lsp-zero')
" 
" vim.g.lsp_zero_ui_float_border = 'shadow'
" 
" lsp_zero.on_attach(function(client, bufnr)
	" lsp_zero.default_keymaps({buffer = bufnr})
" end)
" 
" require('lspconfig').tsserver.setup({})
" 
" EOF

" ------------------------------ coc.nvim

" Extensions
let g:coc_global_extensions = [
	\ 'coc-tsserver',
	\ 'coc-json',
	\ 'coc-json',
	\ 'coc-html',
	\ 'coc-css',
	\ 'coc-prettier',
	\ 'coc-eslint',
	\ 'coc-calc',
	\ 'coc-yaml',
	\ 'coc-toml',
	\ 'coc-go',
	\ 'coc-snippets',
	\ 'coc-clangd',
	\ 'coc-lua',
	\ 'coc-pyright',
	\ 'coc-sh',
	\ 'coc-rust-analyzer',
	\ 'coc-styled-components',
	\ 'coc-emmet',
	\ 'coc-pairs',
	\ 'coc-angular',
	\ 'coc-biome',
	\ 'coc-deno',
	\ '@yaegassy/coc-ansible',
	\ '@yaegassy/coc-tailwindcss3',
	\ ]

let g:coc_filetype_map = {
	\ 'yaml.ansible': 'ansible',
	\ }

" Use C-d and C-u to scroll hover description fields
map <nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
map <nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"

" Use \rn to rename the hovered symbol
nmap <leader>rn <Plug>(coc-rename)

" Use tab for trigger completion with typed characters
function! s:check_back_space() abort
	let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "\<C-x>\<C-z>"
" remap for complete to use tab and <cr>
inoremap <silent><expr> <TAB>
			\ coc#pum#visible() ? coc#pum#next(1):
			\ <SID>check_back_space() ? "\<Tab>" :
			\ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(0) : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()

hi CocSearch ctermfg=12 guifg=#18A3FF
hi CocMenuSel ctermbg=109 guibg=#3da2e0

" Triggers auto-import and snippet expand
imap <expr> <C-l> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Jump to next marker in snippet
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Press K over a symbol to view CoC documentation
nnoremap <silent> K :call <SID>show_documentation()<CR>
set keywordprg=:call\ CocActionAsync('doHover')
function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	elseif (coc#rpc#ready())
		call CocActionAsync('doHover')
	else
		execute '!' . &keywordprg . " " . expand('<cword>')
	endif
endfunction

" Jump to definition
nmap <silent> gd <Plug>(coc-definition)

" Jump to type declaration
nmap <silent> gt <Plug>(coc-type-definition)

" Jump to implementation
nmap <silent> gi <Plug>(coc-implementation)

" View references to symbol
nmap <silent> gr <Plug>(coc-references)

" Select down in coc-snippets
vmap <C-j> <Plug>(coc-snippets-select)

" :Prettier to force formatting only with Prettier
command! Prettier :CocCommand prettier.formatFile

" :P to format the currently open file
command! P :call CocAction('format') 

" :F to fix fixable linting errors
nmap F <Plug>(coc-fix-current)

" Edit CoC configuration file
command Ccs e ~/.config/nvim/coc-settings.json

" Restart CoC LSPs
command Ccr silent !CocRestart

" Jump to next and previous problems
nmap <silent> ]c :call CocAction('diagnosticNext')<CR>
nmap <silent> [c :call CocAction('diagnosticPrevious')<CR>

" ------------------------------ winresizer

" Enter resize mode with C-w-r
let g:winresizer_start_key='<C-w>r'

" Increase vertical resize increment
let g:winresizer_vert_resize='5'


" ------------------------------ markdown-preview.nvim

" Default to light mode
let g:mkdp_theme = 'light'

" Don't close preview when closing buffer
let g:mkdp_auto_close=0

" ------------------------------ nvim-spectre

" Search all files
nmap <leader>H :lua require('spectre').open()<CR>

" Search current word
nmap <leader>hw :lua require('spectre').open_visual({select_word=true})<CR>
vmap <leader>hw :lua require('spectre').open_visual()<CR>

" Search current buffer
nmap <leader>h viw:lua require('spectre').open_file_search()<CR>

lua <<EOF
require('spectre').setup({
  live_update = true,
})
EOF

" ------------------------------ fzf.vim

" C-p to search all files in current directory
nmap <silent> <C-p> :Files<CR>

" C-f to search all text in all files in current dirtectory
nmap <silent> <C-f> :Ag<CR>

" C-/ to search all text in current buffer
nmap <silent> <C-_> :BLines<CR>

" :B to :Buffers
command! B :Buffers

" C-i and C-v to open selected fzf result in horizontal and vertical splits
let g:fzf_action = {
  \ 'ctrl-i': 'split',
  \ 'ctrl-v': 'vsplit',
  \ }

" Position fzf window in the center of the screen
" let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.6, 'yoffset': 0.4 } }

" ------------------------------ lightline.vim

" lightline.vim configuration
let g:lightline = {
  \ 'colorscheme': 'nord',
  \ 'tabline': {
  \ 	'left': [ [ 'tabs' ] ],
  \ 	'right': [ [ ] ],
  \ },
  \ 'active': {
  \ 	'left': [
  \ 		[ 'mode', 'paste' ],
  \ 		[ 'readonly', 'filename' ],
  \ 	],
  \ 	'right': [
  \ 		[ 'lineinfo' ],
  \ 		[ 'percent' ],
  \ 		[ 'gitbranch', 'filetype' ],
  \ 	],
  \ },
  \ 'component_function': {
  \ 	'gitbranch': 'gitbranch#name',
  \   'filename': 'LightlineFilename',
  \ },
  \ }

" Get truncated filename and change symbol
function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return filename . modified
endfunction

" ------------------------------ vim-hexokinase

" Put colour in square next to code
let g:Hexokinase_highlighters = [ 'virtual' ]

" Match patterns for colours
let g:Hexokinase_optInPatterns = 'full_hex,rgb,rgba,hsl,hsla,colour_names,triple_hex'

" ------------------------------ vim-maximizer

" Ctrl+W + Z toggle-maximizes active split window
nmap <silent> <C-w>z :MaximizerToggle<CR>

" ------------------------------------------------------------ General Settings

" Ignore files and folders in autocomplete and file explorer
set wildignore+=*.pyc,*.o,*.obj,*.svn,*.swp,*.swo,*.swn,*.class,*.hg,*.DS_Store,*.min.*,.git,.cache,node_modules,dist,build,out
set wildignorecase

" Always set newline encoding to Unix
set fileformat=unix

" 24-bit RGB terminal colours 
set termguicolors

" Don't show mode as text to let lightline.vim handle it
set noshowmode

" Keep closed buffers in memory
set hidden

" Prevent commands requiring pressing Enter to continue after execution
set cmdheight=2

" Nord theme
colorscheme nord

" Disable cursor-styling for different modes
set guicursor=

" Disable cursor blinking
:set guicursor+=a:blinkon0

" Enable line numbers, relative numbers and lint sign gutter
set number
set signcolumn=yes
set relativenumber

" Allow jumping between < and >
set matchpairs+=<:>

" Background highlight on current line
set cursorline

" Always show tabs
set showtabline=2

" Disable all mouse interaction
set mouse=

" Fold based on indentation and set minimum and maximum fold-level
set foldmethod=indent
set foldlevelstart=99
set foldminlines=0

" Use the same indentation as the previous/next line being moved from
" set smartindent

" Allow cursor to move past the last character of a line
set virtualedit+=onemore

" Remove timeout to wait for a key combination to fix Esc-o and Esc-O combos
set notimeout nottimeout

" Shift indentation two characters
set shiftwidth=2
set tabstop=2

" Enable plugin autocommands based on file type
filetype plugin on

" Case insensitive searching
set ignorecase
set smartcase

" Disable backups of original file content
set nobackup
set nowritebackup

" Speed up swap file updates and buffer to disk syncing
set updatetime=300

" Grey out 
highlight Folded guifg=#666666

" Format binary files
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

" Scroll to center of screen if search result is off screen
function s:MaybeMiddle()
  if winline() == 1 || winline() == winheight(0)
    normal! zz
  endif
endfunction
nnoremap <silent> n n:call <SID>MaybeMiddle()<CR>
nnoremap <silent> N N:call <SID>MaybeMiddle()<CR>

" Disable netrw (in-built file explorer) because we use a plugin instead
lua <<EOF
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
EOF

" Auto-reload buffer as soon as file updates on disk
set autoread
au CursorHold * checktime

" ------------------------------------------------------------ Keybindings 

" Set leader key to backslash
let mapleader = '\'

" w goes to the end of the word instead of the beginning of the next word
vmap <silent> w e
nmap <silent> w e
nmap <silent> dw de
nmap <silent> yw ye

" Double-escape to hide search highlights
nmap <silent> <esc><esc> :let @/ = ""<CR>

" Do no unselect after indenting or de-indenting
vmap > >gv
vmap < <gv

" Do not re-yank when pasting over a selected portion of text
vmap p pgvy

" c and C to shallow and deep fold
nmap c za
nmap C zA

" r to redo
nmap r <C-R>

" Enable spell-checking in markdown and text files
autocmd FileType markdown,text
	\ setlocal spell |
	\ set wrap |
	\ set linebreak

" Switch to fold markers for vim configuration files
autocmd FileType vim setlocal foldmethod=marker

" ; to enter commands
nnoremap ; :
vnoremap ; :

" Search for currently highlighted text
vmap * y/\V<C-R>=escape(@",'/\')<CR><CR>
vmap # y?\V<C-R>=escape(@",'/\')<CR><CR>

" Offset screen center with zz up by a few lines
nnoremap zz zz10<c-e>

" ------------------------------ Windowing 

" Split windows with C-w and - or |
nmap <silent> <C-w>- :sp<CR>
nmap <silent> <C-w>\| :vs<CR>

" Write current buffer with C-w-s
nmap <C-w>s :w<CR>

" ------------------------------ Tabbing 

" t-n creates a new tab
nmap <silent> tn :tabedit %<CR>

" t-c closes the current tab
nmap <silent> tc :tabclose<CR> :tabprevious<CR>

" t-l and t-h to move between next and previous tabs
nmap <silent> tl :tabnext<CR>
nmap <silent> th :tabprevious<CR>

" t-o closes all but the current tab
nmap <silent> to :tabonly<CR>

" t-m-l and t-m-h move the current tab right and left
nmap <silent> tml :+tabmove<CR>
nmap <silent> tmh :-tabmove<CR>

" 1-t-g goes to the first tab
nmap <silent> 1tg 1gt

" ------------------------------------------------------------ Commands

" Edit NeoVim configuration
command Vrc e ~/.config/nvim/init.vim

" Reload NeoVim configuration
command Svrc so ~/.config/nvim/init.vim

" Edit Zsh aliases
command Za e ~/.oh-my-zsh/custom/aliases.zsh

" Edit Zsh configuration
command Zrc e ~/.zshrc

" Echo the full path of the current file
command Path echo @%
command Pa echo @%
command PA echo @%

" Toggle line breaking
command Nr set wrap!

" ------------------------------------------------------------ Re-map file types

autocmd BufNewFile,BufRead *.json set filetype=jsonc
autocmd BufNewFile,BufRead *.jsx,*.js.hbs set filetype=javascript.tsx
autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx
autocmd BufNewFile,BufRead .eslintrc,.prettierrc,.parcelrc set filetype=json
autocmd BufNewFile,BufRead .eslintignore,.prettierignore,.gitignore set filetype=conf
autocmd BufNewFile,BufRead .env,.env.defaults,.env.sample,.env.example,.env.template set filetype=bash
autocmd BufNewFile,BufRead *.cnf,*.conf set filetype=dosini
autocmd BufNewFile,BufRead *.dockerfile set filetype=dockerfile
autocmd BufNewFile,BufRead .localrc set filetype=zsh
autocmd BufNewFile,BufRead *.mdx set filetype=markdown
autocmd BufNewFile,BufRead *.tf,*.tfvars set filetype=terraform
autocmd BufNewFile,BufRead inventory.yaml,inventory.yml,playbook.yaml,playbook.yml set filetype=yaml.ansible
