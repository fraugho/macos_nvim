return {
    "mfussenegger/nvim-dap",
    -- Lazy load DAP until actually needed
    event = "VeryLazy",
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            -- Lazy load UI only when DAP is loaded
            lazy = true,
            dependencies = { "nvim-neotest/nvim-nio" },
            keys = {
                { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
                { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
            },
            opts = {
                -- Optimize UI layout with minimal components
                layouts = {
                    {
                        elements = {
                            -- Include only essential elements
                            "scopes",
                            "breakpoints",
                            "stacks",
                        },
                        size = 40,
                        position = "left",
                    },
                    {
                        elements = {
                            "repl",
                            "console",
                        },
                        size = 10,
                        position = "bottom",
                    },
                },
                render = {
                    max_value_lines = 100, -- Limit long values
                },
            },
            config = function(_, opts)
                local dap = require("dap")
                local dapui = require("dapui")
                dapui.setup(opts)
                
                -- Use a single table for listeners to reduce memory usage
                local function setup_listeners()
                    dap.listeners.after.event_initialized["dapui_config"] = function()
                        dapui.open({})
                    end
                    dap.listeners.before.event_terminated["dapui_config"] = function()
                        dapui.close({})
                    end
                    dap.listeners.before.event_exited["dapui_config"] = function()
                        dapui.close({})
                    end
                end
                
                -- Defer listener setup until needed
                vim.api.nvim_create_autocmd("User", {
                    pattern = "DapStarted",
                    callback = setup_listeners,
                    once = true,
                })
            end,
        },

        {
            "theHamsta/nvim-dap-virtual-text",
            lazy = true,
            opts = {
                -- Optimize virtual text settings
                enabled = true,
                enabled_commands = true,
                highlight_duration = 100,
                highlight_changed_variables = true,
                highlight_new_as_changed = false,
                show_stop_reason = true,
                commented = false,
                virt_text_pos = 'eol',
                all_frames = false,
                virt_lines = false,
                virt_text_win_col = nil
            },
        },

        {
            "folke/which-key.nvim",
            optional = true,
            lazy = true,
            opts = {
                defaults = {
                    ["<leader>d"] = { name = "+debug" },
                },
            },
        },

        {
            "jay-babu/mason-nvim-dap.nvim",
            dependencies = "mason.nvim",
            cmd = { "DapInstall", "DapUninstall" },
            opts = {
                -- Disable automatic installation for better startup
                automatic_installation = false,
                handlers = {},
                ensure_installed = {},
            },
        },
    },

    -- Reduced keybindings to essential ones for better startup time
    keys = {
        { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
        { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
        { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
        { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
        { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
        { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    },

    config = function()
        local Config = require("lazyvim.config")
        
        -- Defer sign definition until debugging starts
        local signs_loaded = false
        vim.api.nvim_create_autocmd("User", {
            pattern = "DapStarted",
            callback = function()
                if not signs_loaded then
                    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
                    for name, sign in pairs(Config.icons.dap) do
                        sign = type(sign) == "table" and sign or { sign }
                        vim.fn.sign_define(
                            "Dap" .. name,
                            { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
                        )
                    end
                    signs_loaded = true
                end
            end,
        })
    end,
}
