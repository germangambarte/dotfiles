return {
  "nvim-mini/mini.nvim",
  version = false,
  config = function()
    require("mini.ai").setup()

    require("mini.surround").setup()

    require("mini.hipatterns").setup({
      highlighters = {
        hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
      },
    })

    -- require("mini.files").setup()
    -- vim.keymap.set("n", "-", ":lua MiniFiles.open()<CR>")
  end,
}
