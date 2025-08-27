local lspconfig = require('lspconfig')

lspconfig.pyright.setup{}

lspconfig.clangd.setup{
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

lspconfig.kotlin_language_server.setup{
  cmd = { "kotlin-language-server" },
  initializationOptions = {},
  on_attach = function(client, bufnr)
  end,
}

lspconfig.html.setup {}
lspconfig.cssls.setup {}
lspconfig.jsonls.setup {}

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)

local cmp = require'cmp'
cmp.setup({
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
  },
})

require('lualine').setup()

require('telescope').setup{
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
end, { desc = "Поиск по классам" })

require("bufferline").setup{
  options = {
    numbers = "none",
    diagnostics = "nvim_lsp",
    separator_style = "slant",
    show_buffer_close_icons = true,
    show_close_icon = true,
  }
}

require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "cpp", "lua", "python", "kotlin", "rust", "go", "javascript", "html", "css", "json", "bash" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
}

require("trouble").setup {}

require("toggleterm").setup{
  size = 12,
  open_mapping = [[<C-\>]],
  direction = "horizontal",
  shade_terminals = true,
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
}

require('gitsigns').setup()

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",
  { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>",
  { desc = "Symbols (Trouble)" })

vim.g.db_ui_save_location = '~/.db_ui'
vim.g.db_ui_use_nerd_fonts = 1
vim.keymap.set('n', '<Leader>tt', '<cmd>ToggleTerm<CR>', { desc = 'Toggle Terminal' })

vim.keymap.set('n', ']c', function() require('gitsigns').next_hunk() end)
vim.keymap.set('n', '[c', function() require('gitsigns').prev_hunk() end)
vim.keymap.set('n', '<leader>gp', function() require('gitsigns').preview_hunk() end)
vim.keymap.set('n', '<leader>gr', function() require('gitsigns').reset_hunk() end)

vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })
