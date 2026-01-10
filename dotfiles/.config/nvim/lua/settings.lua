local lspconfig = require('lspconfig')

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
  c      = {'clang-format'},
  bash   = {'shfmt'},
  sh     = {'shfmt'},
}

vim.g.ale_python_flake8_executable = 'flake8'
vim.g.ale_python_black_executable = 'black'
vim.g.ale_fix_on_save = 0

-- LSP servers
lspconfig.pyright.setup{}
lspconfig.clangd.setup{
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
}
lspconfig.kotlin_language_server.setup{}
lspconfig.html.setup {}
lspconfig.cssls.setup {}
lspconfig.jsonls.setup {}

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
    separator_style = "slant",
    show_buffer_close_icons = true,
    show_close_icon = true,
  }
}

-- Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "cpp", "lua", "python", "kotlin", "rust", "go", "javascript", "html", "css", "json", "bash" },
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true },
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
