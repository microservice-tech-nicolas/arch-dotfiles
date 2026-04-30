return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")

      -- Disable automatic completion
      opts.completion = {
        autocomplete = false, -- This disables auto-popup
      }

      -- Update keymaps to manually trigger completion with Ctrl+Space
      opts.mapping = cmp.mapping.preset.insert({
        -- Ctrl+Space to manually trigger completion
        ["<C-Space>"] = cmp.mapping.complete(),

        -- Navigate through completion items
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

        -- Scroll documentation
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        -- Confirm selection with Enter (only when menu is visible)
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- select = false means it won't auto-select first item

        -- Cancel completion with Escape
        ["<C-e>"] = cmp.mapping.abort(),

        -- Tab/Shift-Tab for snippet navigation (if using snippets)
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
      })

      return opts
    end,
  },
}
