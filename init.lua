-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.colorcolumn = "100"

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lean",
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true
    vim.bo.autoindent = true
    -- Set a simple indent expression that just preserves previous line's indent
    vim.bo.indentexpr = 'indent(prevnonblank(v:lnum))'
  end
})
