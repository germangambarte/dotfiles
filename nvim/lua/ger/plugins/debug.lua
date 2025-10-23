return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "leoluz/nvim-dap-go", -- Golang
    "rcarriga/nvim-dap-ui",
    "ramboe/ramboe-dotnet-utils",
    "nvim-neotest/nvim-nio",
    "mason-org/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
    "mfussenegger/nvim-dap-python",
    -- { 'nvim-neotest/neotest', requires = {
    --   'Issafalcon/neotest-dotnet',
    -- } },
    "theHamsta/nvim-dap-virtual-text",
  },
  keys = {
    {
      "<F5>",
      function()
        require("dap").continue()
      end,
      desc = "Debug: Start/Continue",
    },
    {
      "<F1>",
      function()
        require("dap").step_into()
      end,
      desc = "Debug: Step Into",
    },
    {
      "<F2>",
      function()
        require("dap").step_over()
      end,
      desc = "Debug: Step Over",
    },
    {
      "<F3>",
      function()
        require("dap").step_out()
      end,
      desc = "Debug: Step Out",
    },
    {
      "<leader>b",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Debug: Toggle Breakpoint",
    },
    {
      "<leader>B",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Debug: Set Breakpoint",
    },
    {
      "<F7>",
      function()
        require("dapui").toggle()
      end,
      desc = "Debug: See last session result.",
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      automatic_installation = true,
      handlers = {},
      ensure_installed = {},
    })

    -- require('neotest').setup {
    --   adapters = {
    --     require 'neotest-dotnet',
    --   },
    -- }
    -- more minimal ui
    dapui.setup({
      expand_lines = true,
      controls = { enabled = false }, -- no extra play/step buttons
      floating = { border = "rounded" },
      -- Set dapui window
      render = {
        max_type_length = 60,
        max_value_lines = 200,
      },
      -- Only one layout: just the "scopes" (variables) list at the bottom
      layouts = {
        {
          elements = {
            { id = "scopes", size = 1.0 }, -- 100% of this panel is scopes
          }, -- height in lines (adjust to taste)
          size = 50,
          position = "right", -- "left", "right", "top", "bottom"
        },
      },
    })

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    require("dap-python").setup("uv")
    require("nvim-dap-virtual-text").setup({})
    require("dap-go").setup({
      delve = {
        -- Use Mason's delve installation with fallback to system delve
        path = function()
          local mason_delve = vim.fn.stdpath("data") .. "/mason/bin/dlv"
          if vim.fn.executable(mason_delve) == 1 then
            return mason_delve
          end
          -- Fallback to system delve
          return vim.fn.exepath("dlv") ~= "" and vim.fn.exepath("dlv") or "dlv"
        end,

        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        -- detached = vim.fn.has 'win32' == 0,
      },
    })
  end,
}
