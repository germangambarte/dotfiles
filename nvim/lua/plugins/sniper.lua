return {
  'leath-dub/snipe.nvim',
  keys = {
    {
      '-',
      function()
        require('snipe').open_buffer_menu()
      end,
      desc = 'Open Snipe buffer menu',
    },
  },
  -- config = function ()
  --   require("snipe").setup()
  -- end
  opts = {
    ui = {

      position = 'bottomright',
      open_win_override = {
        border = 'rounded',
      },
    },
    hints = {
      -- Charaters to use for hints (NOTE: make sure they don't collide with the navigation keymaps)
      ---@type string
      dictionary = 'asdfghjkl;',
      prefix_key = '.',
    },
    navigate = {
      leader = '-',
      leader_map = {
        ['d'] = function(m, i)
          require('snipe').close_buf(m, i)
        end,
        ['v'] = function(m, i)
          require('snipe').open_vsplit(m, i)
        end,
        ['h'] = function(m, i)
          require('snipe').open_split(m, i)
        end,
      },
      --
      -- -- When the list is too long it is split into pages
      -- -- `[next|prev]_page` options allow you to navigate
      -- -- this list
      -- next_page = "J",
      -- prev_page = "K",
      --
      -- -- You can also just use normal navigation to go to the item you want
      -- -- this option just sets the keybind for selecting the item under the
      -- -- cursor
      -- under_cursor = "<cr>",
      --
      -- -- In case you changed your mind, provide a keybind that lets you
      -- -- cancel the snipe and close the window.
      -- ---@type string|string[]
      -- cancel_snipe = "<esc>",
      --
      -- -- Close the buffer under the cursor
      -- -- Remove "j" and "k" from your dictionary to navigate easier to delete
      -- -- NOTE: Make sure you don't use the character below on your dictionary
      -- close_buffer = "D",
      --
      -- -- Open buffer in vertical split
      -- open_vsplit = "V",
      --
      -- -- Open buffer in split, based on `vim.opt.splitbelow`
      -- open_split = "H",
      --
      -- -- Change tag manually (note only works if `persist_tags` is not enabled)
      -- -- change_tag = "C",
    },
  },
}
