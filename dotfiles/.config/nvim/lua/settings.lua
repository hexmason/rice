-- ALE linters
vim.g.ale_linters = {
  python = {'flake8', 'mypy'},
  c      = {'clang'},
  cpp    = {'clang'},
  go     = {'gopls'},
  rust   = {'analyzer'},
  bash   = {'shellcheck'},
  sh     = {'shellcheck'},
}

-- ALE fixers
vim.g.ale_fixers = {
  go     = {'gofmt'},
  python = {'black'},
  -- c      = {'clang-format'},
  bash   = {'shfmt'},
  sh     = {'shfmt'},
}

vim.g.ale_python_flake8_executable = 'flake8'
vim.g.ale_python_black_executable = 'black'
vim.g.ale_fix_on_save = 1

local cmp = require('cmp')
cmp.setup { 
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(), },
}

-- LSP servers
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config("pyright", {
  capabilities = capabilities,
})

vim.lsp.config("kotlin_language_server", {
  capabilities = capabilities,
})

vim.lsp.config("html", {
  capabilities = capabilities,
})

vim.lsp.config("cssls", {
  capabilities = capabilities,
})

vim.lsp.config("jsonls", {
  capabilities = capabilities,
})

vim.lsp.config("gopls", {
  capabilities = capabilities,
})

vim.lsp.config("clangd", {
  capabilities = capabilities,
})

vim.lsp.enable({
  "pyright",
  "kotlin_language_server",
  "html",
  "cssls",
  "jsonls",
  "gopls",
  "clangd",
})

-- Diagnostics
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)

-- Lualine
require('lualine').setup()

-- Telescope
require('telescope').setup {
  defaults = {
    layout_config = { horizontal = { preview_width = 0.6 } },
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    mappings = {
      i = { ["<c-d>"] = require("telescope.actions").delete_buffer },
      n = { ["<c-d>"] = require("telescope.actions").delete_buffer },
    },
  },
  pickers = {
    buffers = {
      sort_mru = true,
      ignore_current_buffer = true,
      previewer = false,
    },
  },
}

vim.keymap.set("n", "<leader>fc", function()
  require("telescope.builtin").lsp_workspace_symbols({
    symbols = { "Class", "Interface", "Struct", "Enum" }
  })
end, { desc = "Search by classes" })

-- Bufferline
require("bufferline").setup {
  options = {
    numbers = "none",
    diagnostics = "nvim_lsp",
    separator_style = "thin",
    show_buffer_close_icons = true,
    show_close_icon = true,
  }
}

-- Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "cpp", "lua", "python", "kotlin", "rust", "go", "javascript", "html", "css", "json", "bash" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  },
  -- indent = {
  --   enable = true
  -- },
}

-- Trouble
require("trouble").setup {}

-- ToggleTerm
require("toggleterm").setup{
  size = 12,
  open_mapping = [[<C-\>]],
  direction = "horizontal",
  shade_terminals = true,
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
}

-- Gitsigns
require('gitsigns').setup()

-- Nvim-tree
require("nvim-tree").setup()

-- DBUI
vim.g.db_ui_save_location = '~/.cache/db_ui'
vim.g.db_ui_use_nerd_fonts = 1

-- Floaterm
vim.g.floaterm_width = 0.85
vim.g.floaterm_height = 0.85
vim.g.floaterm_opener = 'edit'
vim.g.floaterm_wintitle = 1
vim.g.floaterm_autoinsert = true
vim.g.floaterm_borderchars = '─│─│╭╮╯╰'

vim.cmd([[
highlight FloatermBorder guifg=#98971A
]])

local map = vim.keymap.set
local opts = { silent = true }
