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
set background=dark
set number
set relativenumber
set cursorline
syntax off

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

set so=30
set ttyfast

set mouse=a

set wildmode=longest,list

set clipboard=unnamedplus

set splitright
set splitbelow

call plug#begin()

" Themes
Plug 'rafi/awesome-vim-colorschemes'
Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'nvim-tree/nvim-web-devicons'

" File manager
Plug 'nvim-tree/nvim-tree.lua'

" Autocompetions
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

" Formatter
Plug 'dense-analysis/ale'

" Comments
Plug 'tpope/vim-commentary'

Plug 'folke/trouble.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'moll/vim-bbye'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'branch': 'master'}

" Database tools
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'

" Terminal
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'voldikss/vim-floaterm'

" Git
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
Plug 'kdheepak/lazygit.nvim'

call plug#end()

colorscheme gruvbox

lua require('settings')
lua require('keymaps')
