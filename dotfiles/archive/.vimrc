" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

" Plugins
call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree' |
	\ Plug 'Xuyuanp/nerdtree-git-plugin' |
	\ Plug 'ryanoasis/vim-devicons' |
	\ Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'preservim/nerdcommenter'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'joshdick/onedark.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'wesQ3/vim-windowswap'
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd ./app && yarn install' }
Plug 'posva/vim-vue'
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-matchquote'
Plug 'simeji/winresizer'
Plug 'neoclide/jsonc.vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'brooth/far.vim'
Plug 'guns/xterm-color-table.vim'
Plug 'bagrat/vim-buffet'
Plug 'itchyny/vim-gitbranch'

call plug#end()

packloadall

" Settings
set hidden
set number
set signcolumn=yes
set tabstop=2
set virtualedit+=onemore
set shiftwidth=2
set smartindent
set autoindent
set encoding=utf-8
set pythonthreedll=python38.dll
set backspace=indent,eol,start
set cursorline
set laststatus=2
set relativenumber
set shortmess=a
set cmdheight=1
set showcmd
set noshowmode
set wildignorecase
set updatetime=300
set ignorecase
set nobackup
set nowritebackup
set foldmethod=indent
set foldlevelstart=99
set timeout timeoutlen=1000 ttimeoutlen=100
set wildmenu
"set fillchars+=vert:│
set matchpairs+=<:>
set showtabline=2
set hlsearch
syntax enable
scriptencoding utf-8

" Colours
colorscheme nord
hi LineNr ctermfg=242
hi Title ctermfg=237 ctermbg=237 gui=bold

" Key Bindings
let mapleader = '\'
map <silent> <C-h> :Farr<CR>
imap <C-BS> <C-W>
imap <C-l> <Plug>(coc-snippets-expand)
imap <C-j> <Plug>(coc-snippets-expand-jump)
vmap <C-j> <Plug>(coc-snippets-select)
vmap <leader>cc :NerdCommenterToggle<CR> 
vmap <silent> w e
vmap > >gv
vmap < <gv
vmap p pgvy
nmap <C-BS> <C-w>
nmap <C-h> <C-w>
nmap <C-w>s :w<CR>
nmap r <C-R>
nmap c za
nmap C zA
nmap <silent> w e
nmap <silent> <C-w>- :sp<CR>
nmap <silent> <C-w>\| :vs<CR>
nmap <silent> tn :tabedit %<CR>
nmap <silent> tc :tabclose<CR> :tabprevious<CR>
nmap <silent> th :tabprevious<CR>
nmap <silent> tl :tabnext<CR>
nmap <silent> to :tabonly<CR>
nmap <silent> tml :+tabmove<CR>
nmap <silent> tmh :-tabmove<CR>
nmap <silent> 1tg 1gt
nmap <silent> <C-b> :NERDTreeToggle<CR>
nmap <silent> <C-p> :Files<CR>
nmap <silent> <C-f> :Ag<CR>
nmap <silent> <C-_> :BLines<CR>
nmap <silent> <esc><esc> :let @/ = ""<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> <leader>rn <Plug>(coc-rename)

" Command Aliases
command B NERDTreeToggle
command P Prettier
command Pins PlugInstall
command Pclean PlugClean
command Vrc e ~/.vimrc
command Svrc so ~/.vimrc
command Path echo @%
command! -nargs=0 Prettier :CocCommand prettier.formatFile
command! -nargs=0 P :call CocAction('format') 
command! -nargs=0 Format :call CocAction('format')
command! -nargs=0 F :CocFix 

" Autocommands
autocmd FileType markdown,text
	\ setlocal spell |
	\ set wrap |
	\ set linebreak

if exists("g:loaded_webdevicons")
	call webdevicons#refresh()
endif

" File types
autocmd BufNewFile,BufRead *.json set filetype=jsonc
autocmd BufNewFile,BufRead *.jsx set filetype=javascript.tsx
autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx
autocmd BufNewFile,BufRead .eslintrc,.prettierrc,.parcelrc set filetype=json
autocmd BufNewFile,BufRead .eslintignore,.prettierignore,.gitignore set filetype=conf
autocmd BufNewFile,BufRead .env,.env.sample,.env.example set filetype=bash

" coc.nvim
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
	\ 'coc-go',
	\ 'coc-snippets',
	\ 'coc-clangd',
	\ ]
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
set keywordprg=:call\ CocActionAsync('doHover')
nnoremap <nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
nnoremap <nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"

" NERDTree
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
let NERDTreeRespectWildIgnore=1
let NERDTreeAutoDeleteBuffer=1
let g:WebDevIconsNerdTreeGitPluginForceVAlign=1
set wildignore+=*.pyc,*.o,*.obj,*.svn,*.swp,*.swo,*.swn,*.class,*.hg,*.DS_Store,*.min.*,.git,.cache
filetype plugin on
autocmd FileType nerdtree setlocal relativenumber
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"autocmd BufEnter NERD_tree_* | execute 'normal R'

function! s:check_back_space() abort
	let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

" Lightline
let g:lightline = {
	\ 'colorscheme': 'nord',
	\ 'tabline': {
	\ 	'left': [ [ 'tabs' ] ],
	\ 	'right': [ [ ] ],
	\ },
	\ 'active': {
	\ 	'left': [
	\ 		[ 'mode', 'paste' ],
	\ 		[ 'readonly', 'filename', 'modified' ],
	\ 	],
	\ 	'right': [
	\ 		[ 'lineinfo' ],
	\ 		[ 'percent' ],
	\ 		[ 'gitbranch', 'filetype' ],
	\ 	],
	\ },
	\ 'component_function': {
	\ 	'gitbranch': 'gitbranch#name',
	\ },
	\ }
let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
let s:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
let s:palette.inactive.middle = s:palette.normal.middle
let s:palette.tabline.middle = s:palette.normal.middle

" fzf.vim
let g:fzf_action = {
	\ 'ctrl-i': 'split',
	\ 'ctrl-v': 'vsplit',
	\ }
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.7, 'yoffset': 0.4 } }

" winresizer
let g:winresizer_start_key='<C-w>r'
let g:winresizer_vert_resize='5'

" markdown-preview.nvim
let g:mkdp_auto_close=0
let g:mkdp_open_to_the_world=1
