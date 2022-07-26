" Uncomment to set debug log-level for debugging...
" lua vim.lsp.set_log_level('debug')

lua <<EOF
  -- Clangd
  require'lspconfig'['clangd'].setup {
    cmd={ "clangd",
          "-j=3",
          "--background-index",
          "--header-insertion=never",
          "--completion-style=detailed",
          "--header-insertion-decorators=0",
          "--query-driver=/**/mozart/**/aarch64-mozart-linux-g++"
    }
  }
EOF
