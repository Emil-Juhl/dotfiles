vim.cmd([[
    fun! TrimWhitespace()
            let l:save = winsaveview()
            keeppatterns %s/\s\+$//e
            call winrestview(l:save)
    endfun
]])

vim.cmd([[
    augroup EMDJ
        autocmd!
        " Trim trailing whitespace on save
        autocmd BufWritePre * :call TrimWhitespace()
        " Enable wrapping in Telescope preview
        autocmd User TelescopePreviewerLoaded setlocal wrap
        " Reload treesitter folding (workaround)
        autocmd BufEnter * normal zxzR
    augroup END
]])

function au_lsp_fmt(enable)
    vim.cmd([[
        augroup LSP_FMT
            autocmd!
        augroup END
    ]])
    if enable then
        vim.cmd([[
            augroup LSP_FMT
                " Lsp auto-format
                autocmd BufWritePre * :lua vim.lsp.buf.format({ async = false })
            augroup END
        ]])
    end
end

au_lsp_fmt(true)

vim.cmd([[
    command AutoFormatEnable :lua au_lsp_fmt(true)<Cr>
    command AutoFormatDisable :lua au_lsp_fmt(false)<Cr>
]])

--vim.cmd([[
--augroup LSP_HIGHLIGHT
--    autocmd!
--    autocmd CursorHold <buffer> lua require'vim.lsp'.buf.document_highlight()
--    autocmd CursorHoldI <buffer> lua require'vim.lsp'.buf.document_highlight()
--    autocmd CursorMoved <buffer> lua require'vim.lsp'.buf.clear_references()
--    autocmd CursorMovedI <buffer> lua require'vim.lsp'.buf.clear_references()
--augroup END
--]])
