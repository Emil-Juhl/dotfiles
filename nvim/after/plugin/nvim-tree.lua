-- disable netrw at the very start of your init.lua
--vim.g.loaded_netrw = 1
--vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
--vim.opt.termguicolors = true

-- empty setup using defaults
--require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
    respect_buf_cwd = true,
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
    },
    filters = {
        dotfiles = false,
    },
    renderer = {
        full_name = true,
        add_trailing = true,
        indent_markers = {
            enable = true,
        },
        icons = {
            git_placement = "signcolumn",
            show = {
                file = false,
                folder = false,
                folder_arrow = false,
                git = true,
            },
        },
    },
})
