vim.g.mapleader = " "
--vim.keymap.set("n", "<leader>fb", vim.cmd.Ex)
vim.keymap.set("n", "<leader>fb", ':NvimTreeFindFile<Cr>')

-- Move visual selection up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Center cursor on jumps
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste on-top of selection, bin the old stuff
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Yank to system register
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- Paste from system register
vim.keymap.set("n", "<leader>p", "\"+p")
vim.keymap.set("v", "<leader>p", "\"+p")
vim.keymap.set("n", "<leader>P", "\"+P")
vim.keymap.set("v", "<leader>P", "\"+P")

-- Delete to void register
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- Make "ctrl + c" equivalent to "Esc" in insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Search-replace word under cursor
vim.keymap.set("n", "<leader>sr", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
-- Search-replace visual selection
vim.keymap.set("v", "<leader>sr", 'y<Esc>:%s/<C-r>"//gI<Left><Left><Left>')

-- Quickfix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Get current filepath to system register
vim.keymap.set("n", "<leader><C-g>", ":let @+ = expand(\"%\")<CR><C-g>")
