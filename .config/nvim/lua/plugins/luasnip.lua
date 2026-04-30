return {
  "L3MON4D3/LuaSnip",
  config = function(_, opts)
    require("luasnip").setup(opts)
    -- Load filetype snippets from ~/.config/nvim/snippets/<filetype>.lua
    require("luasnip.loaders.from_lua").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/snippets" },
    })
  end,
}
