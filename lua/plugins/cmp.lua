return {
    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            local cmp = require("cmp")
            opts.mapping = vim.tbl_extend("force", opts.mapping, {
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.confirm({ select = true })
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                -- Remove the <CR> mapping from cmp
                ["<CR>"] = cmp.mapping.close(),
            })

            -- Disable automatic selection
            opts.completion = vim.tbl_extend("force", opts.completion or {}, {
                completeopt = "menu,menuone,noinsert,noselect"
            })

            return opts
        end,
    },
}
