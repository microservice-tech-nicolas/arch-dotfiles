return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local default_model = "minimax/minimax-m2.7"
    local current_model = default_model

    local function select_model()
      local api_key = vim.fn.system("echo $OPENROUTER_API_KEY"):gsub("%s+$", "")
      vim.system({
        "curl",
        "-sf",
        "-H",
        "Authorization: Bearer " .. api_key,
        "https://openrouter.ai/api/v1/models",
      }, { text = true }, function(result)
        vim.schedule(function()
          if result.code ~= 0 or not result.stdout then
            vim.notify("Failed to fetch OpenRouter models", vim.log.levels.ERROR)
            return
          end
          local ok, data = pcall(vim.json.decode, result.stdout)
          if not ok or not data or not data.data then
            vim.notify("Failed to parse OpenRouter models response", vim.log.levels.ERROR)
            return
          end
          local models = vim.tbl_map(function(m)
            return m.id
          end, data.data)
          table.sort(models)
          vim.ui.select(models, {
            prompt = "Select Model:",
          }, function(choice)
            if choice then
              current_model = choice
              vim.notify("Selected model: " .. current_model)
            end
          end)
        end)
      end)
    end

    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "openrouter",
        },
        inline = {
          adapter = "openrouter",
        },
      },
      adapters = {
        http = {
          openrouter = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "https://openrouter.ai/api",
                api_key = "cmd:echo $OPENROUTER_API_KEY",
                chat_url = "/v1/chat/completions",
              },
              schema = {
                model = {
                  default = current_model,
                },
              },
            })
          end,
        },
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

    vim.keymap.set("n", "<leader>am", select_model, { desc = "Select Gemini Model" })
    -- Expand 'cc' into 'CodeCompanion' in the command line
    vim.cmd([[cab cc CodeCompanion]])
  end,
}
