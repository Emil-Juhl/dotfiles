augroup MOZ
    autocmd!
    " Format on save
    autocmd BufWritePre * :lua vim.lsp.buf.formatting_sync()
augroup END

function MozartTask(task)
    let term = 'FloatermNew --wintype=vsplit --width=0.5 --autoclose=1 --name=Mozart'
    let cmd = 'cd /home/emdj/mozart && ./task.sh'
    execute term cmd a:task
endfunction

command Build :call MozartTask("build")
command Deploy :call MozartTask("deploy")
