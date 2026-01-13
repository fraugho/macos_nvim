return {
  -- Active colorscheme
  {
    "yorumicolors/yorumi.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("yorumi")
    end,
  },
  -- Disable unused colorschemes (from LazyVim defaults)
  { "catppuccin/nvim", enabled = false },
  { "folke/tokyonight.nvim", enabled = false },
}
