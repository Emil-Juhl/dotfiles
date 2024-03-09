local toggleterm = require('toggleterm')

local close_focused_terminal = function()
    local term = require('toggleterm.terminal')
    local focused = term.get_focused_id()
    local buf = term.get(focused, false)
    buf:close()
end

local toggle_terminal = function()
    toggleterm.toggle(vim.v.count or 1)
end

toggleterm.setup({
    size = function() return vim.o.lines * 0.15 end,
    start_in_insert = true,
    persist_mode = false,
    persist_size = false,
})

vim.keymap.set('n', '<leader>t', toggle_terminal)

vim.keymap.set('t', '<C-Space>d', close_focused_terminal) -- assume <Space> is <leader>
vim.keymap.set('t', '<C-Space>t', close_focused_terminal) -- assume <Space> is <leader>
vim.keymap.set('t', '<C-Space>c', [[<C-\><C-n>]]) -- assume <Space> is  <leader>
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])
vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]])
