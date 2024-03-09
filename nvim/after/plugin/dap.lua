require("dapui").setup({
    icons = { expanded = "v", collapsed = ">", current_frame = ">" },
    mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    expand_lines = vim.fn.has("nvim-0.7") == 1,
    layouts = {
        {
            elements = {
                "console",
                "repl",
                "breakpoints",
                "stacks",
            },
            size = 40, -- 40 columns
            position = "left",
        },
        {
            elements = {
                "scopes",
            },
            size = 0.25, -- 25% of total lines
            position = "bottom",
        },
    },
    controls = {
        enabled = true,
        -- Display controls in this element
        element = "console",
        icons = {
            pause = "||",
            play = "|>",
            step_into = "-[>]",
            step_over = "-[]>",
            step_out = "[-]>",
            step_back = "<-",
            run_last = "↻",
            terminate = "STOP",
        },
    },
    floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = "single", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    windows = { indent = 1 },
    render = {
        max_type_length = nil, -- Can be integer or nil.
        max_value_lines = 100, -- Can be integer or nil.
    }
})

-- Setup of the actual debug adapter
local dapui = require("dapui")
local dap = require("dap")

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_disconnect["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

--require('dap.ext.vscode').json_decode = require('json5').parse
--require('dap.ext.vscode').load_launchjs('.vscode/launch.json', {
--    cppdbg = { 'cpp', 'c' }, ["cortex-debug"] = { 'cpp', 'c' }
--})

dap.adapters = {
    ["cppdbg"] = {
        id = 'cppdbg',
        type = 'executable',
        command = '/home/emdj/.vscode-wayland/extensions/ms-vscode.cpptools-1.11.5-linux-x64/debugAdapters/bin/OpenDebugAD7',
    },
    ["cortex-debug"] = {
        id = 'cppdbg',
        type = 'executable',
        command = '/home/emdj/.vscode-wayland/extensions/ms-vscode.cpptools-1.11.5-linux-x64/debugAdapters/bin/OpenDebugAD7',
    }
}
dap.adapters.cpp_jlink_fep = function(callback, config)
    callback({
        type = 'executable',
        id = 'cpp_jlink_fep',
        command = 'JLinkGDBServerCLExe -device nRF5340_xxAA_APP -if swd'
    })
end

local setupCommands = {
    {
        text = "-enable-pretty-printing",
        description = "enable pretty printing",
        ignoreFailures = false,
    },
}

local mozart_imx8m_cmds = {
    {
        description = "Set sysroot path to enable loading shared library symbols",
        text = "set sysroot ${workspaceFolder}/sdk/imx8m/sysroots/cortexa53-crypto-mozart-linux",
        ignoreFailures = true,
    },
    {
        description = "Set the timeout for establishing a TCP connection to the remote target to infinity",
        text = "set tcp connect-timeout unlimited",
        ignoreFailures = true,
    },
    {
        description = "Import pretty-printers",
        text = "python import sys;sys.path.insert(0, '/usr/share/gcc-10/python');from libstdcxx.v6.printers import register_libstdcxx_printers;register_libstdcxx_printers(None)",
        ignoreFailures = true,
    },
    {
        text = "set print pretty on",
        description = "enable pretty printing",
        ignoreFailures = false,
    },
}

dap.configurations.cpp = {
    {
        name = "Launch file x86 (FEP docker)",
        type = "cppdbg",
        request = "launch",
        pipeTransport = {
            debuggerPath = "/usr/bin/gdb",
            pipeProgram = "docker",
            pipeArgs = {
                "run", "-i", "-v",
                "${workspaceFolder}:${workspaceFolder}",
                "audiostreamingplatform/mozart-fep:1.41",
                "bash", "-c"
            },
            pipeCwd = "${workspaceFolder}",
        },
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
    },
    {
        name = 'Launch gdbserver mozart-fep',
        type = 'cppdbg',
        request = 'launch',
        MIMode = 'gdb',
        miDebuggerServerAddress = 'localhost:2331',
        miDebuggerPath = '/usr/bin/arm-none-eabi-gdb',
        cwd = "/workspaces/mozart-fep/",
        program = function()
            return vim.fn.input('/workspaces/mozart-fep/')
        end,
        stopAtEntry = true,
        setupCommands = setupCommands,
    },
    {
        name = "Launch file x86 (Mozart)",
        type = "cppdbg",
        request = "launch",
        debuggerPath = "${workspaceFolder}/sdk/x86/sysroots/x86_64-mozartsdk-linux/usr/bin/x86_64-mozart-linux/x86_64-mozart-linux-gdb",
        --    pipeTransport = {
        --        debuggerPath ="${workspaceFolder}/sdk/x86/sysroots/x86_64-mozartsdk-linux/usr/bin/x86_64-mozart-linux/x86_64-mozart-linux-gdb",
        --        pipeProgram = "${workspaceFolder}/task.sh",
        --        pipeArgs = { "-x", "do_ctest_select", "-t", "debug" },
        --        pipeCwd = "${workspaceFolder}",
        --    },
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
    },
    {
        name = "Mozart imx8m (attach)",
        MIMode = "gdb",
        type = "cppdbg",
        request = "launch",
        stopAtEntry = false,
        cwd = "${workspaceFolder}",
        setupCommands = mozart_imx8m_cmds,
        miDebuggerPath = "${workspaceFolder}/sdk/imx8m/sysroots/x86_64-mozartsdk-linux/usr/bin/aarch64-mozart-linux/aarch64-mozart-linux-gdb",

        additionalSOLibSearchPath = function()
            local install_dir = "${workspaceFolder}/.build-kirkstone-imx8m/relwithdebinfo/.install"
            local lib = install_dir .. "/usr/lib"
            local lib64 = install_dir .. "/usr/lib64"
            return lib .. ";" .. lib64
        end,

        miDebuggerServerAddress = function()
            return vim.fn.input({ prompt = "Server IP:Port: " })
        end,

        program = function()
            local prog_name = vim.fn.input({ prompt = "Program: " })
            return "${workspaceFolder}/.build-kirkstone-imx8m/relwithdebinfo/.install/usr/bin/" .. prog_name
        end,
    },
    {
        name = "Mozart coredump",
        MIMode = "gdb",
        type = "cppdbg",
        request = "launch",
        cwd = "${workspaceFolder}",
        setupCommands = mozart_imx8m_cmds,
        miDebuggerPath = "${workspaceFolder}/sdk/imx8m/sysroots/x86_64-mozartsdk-linux/usr/bin/aarch64-mozart-linux/aarch64-mozart-linux-gdb",
        additionalSOLibSearchPath = function()
            local install_dir = "${workspaceFolder}/.build-kirkstone-imx8m/relwithdebinfo/.install"
            local lib = install_dir .. "/usr/lib"
            local lib64 = install_dir .. "/usr/lib64"
            return lib .. ";" .. lib64
        end,
        program = function()
            return vim.fn.input({
                prompt = "program: ",
                default = vim.fn.getcwd() .. "/.build-kirkstone-imx8m/relwithdebinfo/.install/usr/bin/",
                completion = "file",
            })
        end,
        coreDumpPath = function()
            return vim.fn.input({
                prompt = "coredump: ",
                default = vim.fn.getcwd() .. "/",
                completion = "file",
            })
        end,
    }
}
dap.configurations.c = dap.configurations.cpp
