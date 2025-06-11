return {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
        -- Disable indent modules for Lean
        opts.indent = opts.indent or {}
        opts.indent.enable = true
        opts.indent.disable = opts.indent.disable or {}
        table.insert(opts.indent.disable, "lean")
        table.insert(opts.indent.disable, "lean3")
        table.insert(opts.indent.disable, "lean4")
        
        return opts
    end,
}
