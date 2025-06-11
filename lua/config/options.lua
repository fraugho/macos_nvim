-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.autoformat = false

-- Disable automatic comment insertion
vim.opt.formatoptions:remove({ "o", "r", "c" })

-- Ensure formatoptions are set after buffer load
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "o", "r", "c" })
  end,
})
