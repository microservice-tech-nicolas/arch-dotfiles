-- pywal16.nvim — reads ~/.cache/wal/colors.json and applies it as a colorscheme.
-- Colors update automatically every time neovim starts (wal regenerates the file on wallpaper change).
-- To refresh inside a running session: :colorscheme pywal16
-- To go back to spaceduck: re-enable lua/plugins/theme.lua and remove this file.

return {
  {
    "uZer/pywal16.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("pywal16").setup()
      vim.cmd("colorscheme pywal16")

      local function apply_snacks_hl()
        local c = require("pywal16.core").get_colors()

        -- Dashboard
        vim.api.nvim_set_hl(0, "SnacksDashboardNormal",  { fg = c.foreground, bg = c.background })
        vim.api.nvim_set_hl(0, "SnacksDashboardTitle",   { fg = c.color4, bg = c.background, bold = true })
        vim.api.nvim_set_hl(0, "SnacksDashboardHeader",  { fg = c.color4, bg = c.background, bold = true })
        vim.api.nvim_set_hl(0, "SnacksDashboardIcon",    { fg = c.color5, bg = c.background })
        vim.api.nvim_set_hl(0, "SnacksDashboardKey",     { fg = c.color2, bg = c.background, bold = true })
        vim.api.nvim_set_hl(0, "SnacksDashboardDesc",    { fg = c.color8, bg = c.background })
        vim.api.nvim_set_hl(0, "SnacksDashboardFooter",  { fg = c.color8, bg = c.background, italic = true })

        -- Explorer/picker: directories via Directory group (color4), files get color8 (teal contrast)
        vim.api.nvim_set_hl(0, "SnacksPickerFile", { fg = c.color8 })

        -- which-key popup
        vim.api.nvim_set_hl(0, "WhichKeyNormal",  { fg = c.foreground, bg = c.background })
        vim.api.nvim_set_hl(0, "WhichKeyBorder",  { fg = c.color4,     bg = c.background })
        vim.api.nvim_set_hl(0, "WhichKeyTitle",   { fg = c.color4,     bg = c.background, bold = true })
        vim.api.nvim_set_hl(0, "WhichKey",        { fg = c.color2,     bg = c.background, bold = true })
        vim.api.nvim_set_hl(0, "WhichKeyGroup",   { fg = c.color4,     bg = c.background })
        vim.api.nvim_set_hl(0, "WhichKeyDesc",    { fg = c.color8,     bg = c.background })
        vim.api.nvim_set_hl(0, "WhichKeySeparator", { fg = c.color8,   bg = c.background })

        -- render-markdown: code blocks (RenderMarkdownCode links to ColorColumn = background = invisible)
        vim.api.nvim_set_hl(0, "RenderMarkdownCode",       { bg = c.color0 })
        vim.api.nvim_set_hl(0, "RenderMarkdownCodeBorder", { fg = c.color8, bg = c.color0 })
        vim.api.nvim_set_hl(0, "RenderMarkdownCodeInfo",   { fg = c.color8, bg = c.color0 })

        -- Picker: search input border — use accent instead of red
        vim.api.nvim_set_hl(0, "SnacksPickerInputBorder", { fg = c.color4, bg = c.background })
        vim.api.nvim_set_hl(0, "SnacksPickerInputTitle",  { fg = c.color4, bg = c.background, bold = true })

        -- Picker: hovered item in file list — dark bg + bright fg for contrast
        -- Blend background with color1 at 25% to get a subtle highlight bg
        local function blend(hex1, hex2, t)
          local r1,g1,b1 = tonumber(hex1:sub(2,3),16), tonumber(hex1:sub(4,5),16), tonumber(hex1:sub(6,7),16)
          local r2,g2,b2 = tonumber(hex2:sub(2,3),16), tonumber(hex2:sub(4,5),16), tonumber(hex2:sub(6,7),16)
          return string.format("#%02x%02x%02x", r1+math.floor((r2-r1)*t), g1+math.floor((g2-g1)*t), b1+math.floor((b2-b1)*t))
        end
        local cursor_bg = blend(c.background, c.color1, 0.25)
        vim.api.nvim_set_hl(0, "SnacksPickerListCursorLine", { fg = c.foreground, bg = cursor_bg, bold = true })
      end

      apply_snacks_hl()

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "pywal16",
        callback = apply_snacks_hl,
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "pywal16-nvim",
      },
    },
  },
}
