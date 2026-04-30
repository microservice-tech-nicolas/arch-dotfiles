-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--

vim.opt.clipboard = "unnamedplus"
-- vim.opt.autoread = true
--
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.termguicolors = true

-- Enable markdown folding
vim.g.markdown_folding = 1

-- Fold settings
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldlevel = 99 -- Open all folds by default
-- vim.opt.foldenable = true
-- vim.opt.foldcolumn = "1" -- Show fold column
-- vim.opt.foldlevelstart = 2 -- Only H1 headings open, rest folded
--

-- Fix issues in tmux lua
vim.opt.swapfile = false
