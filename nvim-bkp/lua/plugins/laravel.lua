return {
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
    },
    ft = { "php", "blade" },
    event = {
      "BufEnter composer.json",
    },
    cmd = { "Laravel" },
    keys = {
      {
        "<leader>ll",
        function()
          Laravel.pickers.laravel()
        end,
        desc = "Laravel: Open Laravel Picker",
      },
      {
        "<c-g>",
        function()
          Laravel.commands.run("view:finder")
        end,
        desc = "Laravel: Open View Finder",
      },
      {
        "<leader>la",
        function()
          Laravel.pickers.artisan()
        end,
        desc = "Laravel: Open Artisan Picker",
      },
      {
        "<leader>lt",
        function()
          Laravel.commands.run("actions")
        end,
        desc = "Laravel: Open Actions Picker",
      },
      {
        "<leader>lr",
        function()
          Laravel.pickers.routes()
        end,
        desc = "Laravel: Open Routes Picker",
      },
      {
        "<leader>lh",
        function()
          Laravel.run("artisan docs")
        end,
        desc = "Laravel: Open Documentation",
      },
      {
        "<leader>lm",
        function()
          Laravel.pickers.make()
        end,
        desc = "Laravel: Open Make Picker",
      },
      {
        "<leader>lc",
        function()
          Laravel.pickers.commands()
        end,
        desc = "Laravel: Open Commands Picker",
      },
      {
        "<leader>lo",
        function()
          Laravel.pickers.resources()
        end,
        desc = "Laravel: Open Resources Picker",
      },
      {
        "<leader>lp",
        function()
          Laravel.commands.run("command_center")
        end,
        desc = "Laravel: Open Command Center",
      },
      {
        "gf",
        function()
          local ok, res = pcall(function()
            if Laravel.app("gf").cursorOnResource() then
              return "<cmd>lua Laravel.commands.run('gf')<cr>"
            end
          end)
          if not ok or not res then
            return "gf"
          end
          return res
        end,
        expr = true,
        noremap = true,
      },
    },
    opts = {
      features = {
        pickers = {
          provider = "snacks", -- "snacks | telescope | fzf-lua | ui-select"
        },
      },
    },
  },
  -- {
  --   "adibhanna/laravel.nvim",
  --   ft = { "php", "blade" },
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "folke/snacks.nvim", -- Optional: for enhanced UI
  --   },
  --   keys = {
  --     { "<leader>la", ":Artisan<cr>", desc = "Laravel Artisan" },
  --     { "<leader>lc", ":Composer<cr>", desc = "Composer" },
  --     { "<leader>lr", ":LaravelRoute<cr>", desc = "Laravel Routes" },
  --     { "<leader>lm", ":LaravelMake<cr>", desc = "Laravel Make" },
  --     { "gf", ":LaravelGoto<cr>", desc = "Laravel Goto" },
  --   },
  --   config = function()
  --     require("laravel").setup({
  --       notifications = false,
  --       debug = false,
  --       keymaps = true,
  --     })
  --   end,
  -- },
  {
    "gbprod/phpactor.nvim",
    ft = "php",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- If the update/install notification doesn't show properly,
      -- you should also add here UI plugins like "folke/noice.nvim" or "stevearc/dressing.nvim"
    },
    opts = {
      install = {
        path = vim.fn.stdpath("data") .. "/opt/",
        branch = "master",
        bin = vim.fn.stdpath("data") .. "/opt/phpactor/bin/phpactor",
        php_bin = "php",
        composer_bin = "composer",
        git_bin = "git",
        check_on_startup = "none",
      },
      lspconfig = {
        enabled = true,
        options = {},
      },
    },
  },
  -- {
  --   "adibhanna/phprefactoring.nvim",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --   },
  --   ft = "php",
  --   config = function()
  --     require("phprefactoring").setup({
  --       -- UI Configuration
  --       ui = {
  --         use_floating_menu = true, -- Use floating windows for dialogs
  --         border = "rounded", -- Border style: 'rounded', 'single', 'double'
  --         width = 40, -- Dialog width
  --         height = nil, -- Auto-calculated height
  --         highlights = {
  --           menu_title = "Title",
  --           menu_border = "FloatBorder",
  --           menu_item = "Normal",
  --           menu_selected = "PmenuSel",
  --           menu_shortcut = "Comment",
  --         },
  --       },
  --
  --       -- Refactoring Options
  --       refactor = {
  --         auto_format = true, -- Auto-format after refactoring
  --       },
  --     })
  --   end,
  -- },
}
