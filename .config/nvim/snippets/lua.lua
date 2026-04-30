local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- local function
  s("lf", fmt("local {} = function({})\n\t{}\nend", { i(1, "name"), i(2), i(3) })),

  -- require
  s("req", fmt('local {} = require("{}")', { i(1), i(2) })),

  -- if block
  s("if", fmt("if {} then\n\t{}\nend", { i(1, "condition"), i(2) })),
}
