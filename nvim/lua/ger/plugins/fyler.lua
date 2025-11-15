return {
  "A7Lavinraj/fyler.nvim",
  dependencies = { "nvim-mini/mini.icons" },
  config = function()
    require("fyler").setup({})
    vim.keymap.set("n", "-", "<CMD>Fyler kind=split_right_most <CR>")
  end,
}
