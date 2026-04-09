return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- image = { enabled = true, inline = false, float = true, max_width = 80, max_height = 40 },
    indent = {
      animate = {
        enabled = true,
        style = "out",
        easing = "linear",
        duration = {
          step = 20, -- ms per step
          total = 250, -- maximum duration
        },
      },
    },
    input = { enabled = true },
    picker = {
      sources = {
        explorer = {
          auto_close = true,
          jump = { close = true },
          layout = { preset = "sidebar", preview = false, layout = { position = "right" } },
        },
        files = {
          exclude = { "vendor", ".venv", "node_modules" },
        },
      },
      enabled = true,
      layout = "ivy",
      matcher = {
        frecuency = true,
      },
    },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    terminal = { enabled = true },
    notifier = { enable = true },
    notify = { enable = true },
    explorer = {
      enable = true,
      replace_netrw = true, -- Replace netrw with the snacks explorer
      trash = true, -- Use the system trash when deleting files
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.inlay_hints():map("<leader>uh")
      end,
    })
  end,
}
