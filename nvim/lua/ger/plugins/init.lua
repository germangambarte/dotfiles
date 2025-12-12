return {
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },
  "nvim-lua/plenary.nvim", -- lua functions that many plugins use
  "christoomey/vim-tmux-navigator", -- tmux & split window navigation
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },
  {
    "j-hui/fidget.nvim",
    config = function ()
      require("fidget").setup({})
    end,
  },
}
