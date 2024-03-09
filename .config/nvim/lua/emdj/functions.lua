function kernel_mode(on_off)
    local opt = vim.opt

    local width = 4
    if on_off then
        width = 8
    end

    opt.tabstop = width
    opt.shiftwidth = width
    opt.expandtab = not on_off
end

vim.cmd([[
    command KernelModeEnable :lua kernel_mode(true)<Cr>
    command KernelModeDisable :lua kernel_mode(false)<Cr>
]])
