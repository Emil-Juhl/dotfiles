fun! TrimWhitespace()
        let l:save = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:save)
endfun

fun! OpenTerminal()
    let opts = '--wintype=vsplit --width=0.5 --autoclose=1'
    execute 'FloatermNew' opts
endfun
