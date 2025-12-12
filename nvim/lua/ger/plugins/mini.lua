return {
  "nvim-mini/mini.nvim",
  version = false,
  config = function()
    require("mini.pairs").setup({})

    local hipatterns = require("mini.hipatterns")
    hipatterns.setup({
      highlighters = {
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    })
  end,
}
