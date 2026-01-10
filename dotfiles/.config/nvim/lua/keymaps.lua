-- NvimTree
vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>")
vim.g.NvimTreeIgnore = { '^node_modules$', '^__pycache__$' }

-- Buffers
vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { silent = true })
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { silent = true })
vim.keymap.set("n", "<Leader>bc", "<cmd>Bdelete<CR>", { silent = true })

-- Splits
vim.keymap.set("n", "<Leader>sh", "<cmd>split<CR>")
vim.keymap.set("n", "<Leader>sv", "<cmd>vsplit<CR>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<Leader>=", "<C-w>=")
vim.keymap.set("n", "<Leader>sc", "<cmd>close<CR>")
vim.keymap.set("n", "<Leader>sk", "<C-w>K")
vim.keymap.set("n", "<Leader>sj", "<C-w>J")
vim.keymap.set("n", "<Leader>sh", "<C-w>H")
vim.keymap.set("n", "<Leader>sl", "<C-w>L")

-- Hover & signature
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help)

-- Terminal
vim.keymap.set('n', '<Leader>tt', '<cmd>ToggleTerm<CR>', { desc = 'Toggle Terminal' })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

-- Telescope
vim.keymap.set("n", "<Leader>ff", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<Leader>fg", "<cmd>Telescope live_grep<CR>")
vim.keymap.set("n", "<Leader>fb", "<cmd>Telescope buffers<CR>")
vim.keymap.set("n", "<Leader>fh", "<cmd>Telescope help_tags<CR>")

-- Trouble
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", { desc = "Symbols (Trouble)" })

-- Gitsigns
vim.keymap.set('n', ']c', function() require('gitsigns').next_hunk() end)
vim.keymap.set('n', '[c', function() require('gitsigns').prev_hunk() end)
vim.keymap.set('n', '<leader>gp', function() require('gitsigns').preview_hunk() end)
vim.keymap.set('n', '<leader>gr', function() require('gitsigns').reset_hunk() end)

-- LazyGit
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })

-- DBUI
vim.keymap.set('n', '<Leader>db', '<cmd>DBUI<CR>', { silent = true })
