return {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    opts = {
        server = {
            cmd = { vim.fn.expand("~/.rustup/toolchains/stable-aarch64-apple-darwin/bin/rust-analyzer") },
            on_attach = function(client, bufnr)
                vim.lsp.inlay_hint.enable()
            end,
            settings = {
                ["rust-analyzer"] = {
                    inlayHints = { enable = true },
                },
            },
        },
    },
    config = function(_, opts)
        vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
    end,
}
