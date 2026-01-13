return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    CustomOilBar = function()
      local path = vim.fn.expand("%")
      path = path:gsub("oil://", "")

      return "  " .. vim.fn.fnamemodify(path, ":.")
    end

    require("oil").setup({
      default_file_explorer = true,
      columns = {
        "icon",
      },
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-k>"] = false,
        ["<C-j>"] = false,
        ["<C-v>"] = { "actions.select_split" },
        ["q"] = { "actions.close", mode = "n" },
      },
      win_options = {
        winbar = "%{v:lua.CustomOilBar()}",
      },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          local folder_skip = { "dev-tools.locks", "dune.lock", "_build" }
          return vim.tbl_contains(folder_skip, name)
        end,
      },
      float = {
        padding = 2,
        max_width = 0.4,
        max_height = 0.8,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
        get_win_title = nil,
        -- preview_split: Split direction: "auto", "left", "right", "above", "below".
        preview_split = "auto",
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        override = function(conf)
          return conf
        end,
      },
      skip_confirm_for_simple_edits = true,
    })

    -- Open parent directory in floating window
    vim.keymap.set("n", "-", require("oil").toggle_float)
  end,
}
