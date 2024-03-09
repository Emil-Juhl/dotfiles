local telescope = require("telescope")
telescope.load_extension("zf-native")
-- truncate paths if they are too long
telescope.setup {
    defaults = {
        path_display = {
            "truncate"
        },
        layout_strategy = "bottom_pane",
        layout_config = {
            height = 0.25,
        },
    },
}

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>ps", builtin.live_grep, {})
vim.keymap.set("n", "<leader>pS", builtin.grep_string, {})
