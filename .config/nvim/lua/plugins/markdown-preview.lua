return {
  "iamcco/markdown-preview.nvim",
  build = function()
    -- The plugin ships a stale bundled mermaid. Replace it with the latest stable.
    local static = vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim/app/_static/mermaid.min.js"
    local url = "https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"
    vim.fn.system({ "curl", "-sL", url, "-o", static })
    vim.notify("markdown-preview: mermaid updated to latest", vim.log.levels.INFO)
  end,
  init = function()
    vim.g.mkdp_open_to_the_world = 1 -- bind to 0.0.0.0, reachable on LAN
    vim.g.mkdp_port = "8090"
    vim.g.mkdp_echo_preview_url = 1 -- print URL in cmdline when preview opens
    vim.g.mkdp_browser = "" -- use system default browser
    vim.g.mkdp_preview_options = {
      maid = {
        theme = "dark", -- or dark, forest,  neutral, base, default
      },
    }
  end,
}
