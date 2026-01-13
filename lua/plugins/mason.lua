return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSPs
        "gopls",
        "clangd",
        "rust-analyzer",
        "zls",
        -- Formatters
        "stylua",
        "gofumpt",
        "goimports",
      },
    },
  },
}
