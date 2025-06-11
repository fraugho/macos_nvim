-- Example LazyVim config file
-- stylua: ignore
if true then return {} end

return {
    -- UI/Theme Configuration
    -- -----------------------------
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function(_, opts)
            table.insert(opts.sections.lualine_x, "😄")
        end,
    },
    { import = "lazyvim.plugins.extras.ui.mini-starter" }, -- Use mini.starter instead of alpha

    -- LSP Configuration
    -- -----------------------------
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- TypeScript support
            "jose-elias-alvarez/typescript.nvim",
            init = function()
                require("lazyvim.util").lsp.on_attach(function(_, buffer)
                    vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
                    vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
                end)
            end,
        },
        opts = {
            servers = {
                pyright = {}, -- Python support
                tsserver = {}, -- TypeScript support
            },
            setup = {
                tsserver = function(_, opts)
                    require("typescript").setup({ server = opts })
                    return true
                end,
            },
        },
    },

    -- Language Support
    -- -----------------------------
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },

    -- Treesitter Configuration
    -- -----------------------------
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "bash", "html", "javascript", "json", "lua", "markdown",
                "markdown_inline", "python", "query", "regex", "tsx",
                "typescript", "vim", "yaml",
            },
            indent = {
                disable = {
                    "lean",
                    "lean3",
                    "lean4"
                }
            }
        },
    },
    -- Telescope Configuration
    -- -----------------------------
    {
        "nvim-telescope/telescope.nvim",
        keys = {
            {
                "<leader>fp",
                function() 
                    require("telescope.builtin").find_files({ 
                        cwd = require("lazy.core.config").options.root 
                    })
                end,
                desc = "Find Plugin File",
            },
        },
        opts = {
            defaults = {
                layout_strategy = "horizontal",
                layout_config = { prompt_position = "top" },
                sorting_strategy = "ascending",
                winblend = 0,
            },
        },
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                config = function()
                    require("telescope").load_extension("fzf")
                end,
            },
        },
    },

    -- Completion and Snippets
    -- -----------------------------
    {
        "L3MON4D3/LuaSnip",
        keys = function() return {} end, -- Disable default keybindings
    },
    {
        "hrsh7th/nvim-cmp",
        -- dependencies = { "hrsh7th/cmp-emoji" },
        opts = function(_, opts)
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local luasnip = require("luasnip")
            local cmp = require("cmp")

            opts.mapping = vim.tbl_extend("force", opts.mapping, {
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

            table.insert(opts.sources, { name = "emoji" })
            return opts
        end,
    },

    -- Tools and Mason Configuration
    -- -----------------------------
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "stylua",
                "shellcheck",
                "shfmt",
                "flake8",
            },
        },
    },
}
