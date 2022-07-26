" Sorter which weighs filename matches higher
lua require'telescope'.load_extension('zf-native')

" When the floating view is not wide enough, truncate the paths
lua require'telescope'.setup{defaults={path_display={"truncate"}}}

" Enable the file_browser extension
lua require'telescope'.load_extension('file_browser')

" Custom cmd to use `git_files()` when available, fallback to `find_files()`
command TeleScopeProjectFiles
\       :lua
\       local ok = pcall(require'telescope.builtin'.git_files)
\       if not ok then require'telescope.builtin'.find_files() end
