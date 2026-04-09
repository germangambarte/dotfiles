return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    heading = {
      -- border = { true, false },
      -- border_virtual = { true, false },
      -- sign = false,
      -- position = "overlay",
      -- width = { "block", "full" },
      -- left_margin = { 0.5, 0 },
      -- left_pad = { 0.2, 0 },
      -- right_pad = { 0.2, 0 },
    },
    indent = { enabled = true },
  },
}
