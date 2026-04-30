local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- main function
  s("main", fmt("#include <stdio.h>\n\nint main(void) {{\n\t{}\n\treturn 0;\n}}", { i(1) })),

  -- for loop
  s("for", fmt("for (int {} = 0; {} < {}; {}++) {{\n\t{}\n}}", { i(1, "i"), i(1), i(2, "n"), i(1), i(3) })),

  -- printf
  s("pf", fmt('printf("{}\\n"{});', { i(1, "%s"), i(2) })),
}
