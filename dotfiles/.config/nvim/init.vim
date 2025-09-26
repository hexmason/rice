""""""""""""""""""""""""""""" 
"                _          "
"    ____ _   __(_)___ ___  "
"   / __ \ | / / / __ `__ \ "
"  / / / / |/ / / / / / / / "
" /_/ /_/|___/_/_/ /_/ /_/  "
"                           "
"""""""""""""""""""""""""""""
set encoding=utf8
set termguicolors

set nocompatible

set ignorecase
set smartcase
set hlsearch
set incsearch

set tabstop=4
set softtabstop=4
set shiftwidth=4

set expandtab
set smarttab

set number
set relativenumber

syntax off

set so=30
set ttyfast

set mouse=a

set wildmode=longest,list

set clipboard=unnamedplus


call plug#begin()

" Themes
Plug 'rafi/awesome-vim-colorschemes'

" File manager
Plug 'nvim-tree/nvim-tree.lua'

" Autocomplete
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'

" LSP config
Plug 'neovim/nvim-lspconfig'

" Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'mfussenegger/nvim-jdtls'
Plug 'nvimtools/none-ls.nvim'

Plug 'dense-analysis/ale'

Plug 'nvim-lualine/lualine.nvim'

" Comments
Plug 'tpope/vim-commentary'

Plug 'folke/trouble.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'moll/vim-bbye'

Plug 'akinsho/bufferline.nvim'
Plug 'nvim-tree/nvim-web-devicons'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Database tools
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'

" Terminal
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}

" Git
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
Plug 'kdheepak/lazygit.nvim'

call plug#end()

colorscheme gruvbox
set background=dark

lua require('settings')

let g:ale_linters = {
\   'python': ['flake8', 'mypy'],
\   'c': ['clang'],
\   'cpp': ['clang'],
\   'go': ['gopls'],
\   'rust': ['analyzer'],
\   'bash': ['shellcheck'],
\   'sh': ['shellcheck'],
\}

let g:ale_fixers = {
\   'python': ['black'],
\   'c': ['clang-format'],
\   'bash': ['shfmt'],
\   'sh': ['shfmt'],
\}

let g:ale_python_flake8_executable = 'flake8'
let g:ale_python_black_executable = 'black'
let g:ale_fix_on_save = 0

" NERDTree
nmap <C-n> :NvimTreeToggle<CR>
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * NERDTree | wincmd p
" nnoremap <leader>n :NERDTreeToggle<CR>
" let g:NERDTreeFileLines = 1
let g:NvimTreeIgnore = ['^node_modules$', '^__pycache__$']
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NvimTree') && b:NvimTree.isTabTree() | quit | endif

" Buffers and splits settings
set splitright
set splitbelow

" Split creation
nnoremap <Leader>sh :split<CR>
nnoremap <Leader>sv :vsplit<CR>

" Navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Alignment
nnoremap <Leader>= <C-w>=

" Close split
nnoremap <Leader>sc :close<CR>

" Move splits
nnoremap <Leader>sk <C-w>K
nnoremap <Leader>sj <C-w>J
nnoremap <Leader>sh <C-w>H
nnoremap <Leader>sl <C-w>L

" Tabs
" nnoremap <Leader>tn :tabnew<CR>:NERDTree<CR>
" nnoremap <Tab> :tabnext<CR>
" nnoremap <S-Tab> :tabprevious<CR>
" nnoremap <Leader>tc :tabclose<CR>

" Buffer controls
nnoremap <silent> <Tab> :BufferLineCycleNext<CR>
nnoremap <silent> <S-Tab> :BufferLineCyclePrev<CR>
nnoremap <silent> <Leader>bc :Bdelete<CR>

" Show docs on hover (K)
nnoremap K :lua vim.lsp.buf.hover()<CR>

" Function parameter snippets
inoremap <C-h> <cmd>lua vim.lsp.buf.signature_help()<CR>

" " Terminal 
" function! OpenTerminalSplit()
"   let height = float2nr(&lines / 4)
"   execute height . "split term://$SHELL"
"   " Make terminal 'unlisted' in buffers
"   setlocal nobuflisted
" endfunction

" nnoremap <Leader>tt :call OpenTerminalSplit()<CR>
autocmd TermClose * if !v:event.status | execute 'bdelete! '..expand('<abuf>') | endif
" Fast exit from terminal to normal mode
tnoremap <Esc> <C-\><C-n>

" Telescope config
nnoremap <Leader>ff <cmd>Telescope find_files<cr>
nnoremap <Leader>fg <cmd>Telescope live_grep<cr>
nnoremap <Leader>fb <cmd>Telescope buffers<cr>
nnoremap <Leader>fh <cmd>Telescope help_tags<cr>

autocmd FileType dbui wincmd L
nnoremap <silent> <Leader>db :DBUI<CR>
autocmd FileType dbui setlocal nobuflisted

autocmd BufReadPost *.kt setlocal filetype=kotlin

let g:LanguageClient_serverCommands = {
    \ 'kotlin': ["kotlin-language-server"],
    \ }
