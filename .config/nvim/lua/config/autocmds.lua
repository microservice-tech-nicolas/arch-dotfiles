-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.diagnostic.enable(false)
  end,
})

-- Hide deprecation warnings
vim.g.deprecation_warnings = false

-- Show Snacks dashboard when last buffer is closed
vim.api.nvim_create_autocmd("BufDelete", {
  group = vim.api.nvim_create_augroup("snacks_dashboard_last_buf", { clear = true }),
  callback = function()
    vim.schedule(function()
      local bufs = vim.tbl_filter(function(buf)
        return vim.api.nvim_buf_is_valid(buf)
          and vim.bo[buf].buflisted
          and vim.api.nvim_buf_get_name(buf) ~= ""
      end, vim.api.nvim_list_bufs())
      if #bufs == 0 then
        Snacks.dashboard.open()
      end
    end)
  end,
})
