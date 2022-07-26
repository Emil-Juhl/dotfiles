augroup EMDJ
    autocmd!
    " Trim trailing whitespace on save
    autocmd BufWritePre * :call TrimWhitespace()
    " Enable wrapping in Telescope preview
    autocmd User TelescopePreviewerLoaded setlocal wrap
augroup END
