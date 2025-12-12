return {
  {
    "adibhanna/laravel.nvim",
    ft = { "php", "blade" },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim", -- Optional: for enhanced UI
    },
    keys = {
      { "<leader>la", ":Artisan<cr>", desc = "Laravel Artisan" },
      { "<leader>lc", ":Composer<cr>", desc = "Composer" },
      { "<leader>lr", ":LaravelRoute<cr>", desc = "Laravel Routes" },
      { "<leader>lm", ":LaravelMake<cr>", desc = "Laravel Make" },
      { "gf", ":LaravelGoto<cr>", desc = "Laravel Goto" },
    },
    config = function()
      require("laravel").setup({
        notifications = false,
        debug = false,
        keymaps = true,
      })
    end,
  },
  {
    "adibhanna/phprefactoring.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    ft = "php",
    config = function()
      require("phprefactoring").setup({
        -- UI Configuration
        ui = {
          use_floating_menu = true, -- Use floating windows for dialogs
          border = "rounded", -- Border style: 'rounded', 'single', 'double'
          width = 40, -- Dialog width
          height = nil, -- Auto-calculated height
          highlights = {
            menu_title = "Title",
            menu_border = "FloatBorder",
            menu_item = "Normal",
            menu_selected = "PmenuSel",
            menu_shortcut = "Comment",
          },
        },

        -- Refactoring Options
        refactor = {
          auto_format = true, -- Auto-format after refactoring
        },
      })
    end,
  },
}
