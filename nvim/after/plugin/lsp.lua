local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    "clangd",
})

local cmp = require("cmp")
local luasnip = require("luasnip")

-- Helpers
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
        vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        elseif has_words_before() then
            cmp.complete()
        else
            fallback()
        end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, { "i", "s" }),
})

lsp.setup_nvim_cmp({
    preselect = "none",
    completion = {
        completeopt = "menu,menuone,noselect",
    },
    mapping = cmp_mappings,
})

lsp.on_attach(function(client, bufnr)
    vim.opt.signcolumn = 'yes'

    vim.keymap.set("n", "<leader>cd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "<leader>ci", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "<leader>cr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>ch", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>cci", function() vim.lsp.buf.incoming_calls() end, opts)
    vim.keymap.set("n", "<leader>cco", function() vim.lsp.buf.outgoing_calls() end, opts)
end)

lsp.configure("clangd", {
    cmd = {
        "clangd",
        "-j=3",
        "--background-index",
        "--header-insertion=never",
        "--completion-style=detailed",
        "--header-insertion-decorators=0",
        "--query-driver=/**/mozart/**/x86_64-mozart-linux-g++,/**/arm-none-eabi-*",
    }
})

--lsp.nvim_workspace()
lsp.setup()
