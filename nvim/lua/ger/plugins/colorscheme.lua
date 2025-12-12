return {
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanso").setup({})
      -- vim.cmd.colorscheme("kanso")
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
            ok = { "undercurl" },
          },
        },
      })
      -- setup must be called before loading
      -- vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      -- Default options:
      require("kanagawa").setup({
        overrides = function(colors)
          local theme = colors.theme
          local makeDiagnosticColor = function(color)
            local c = require("kanagawa.lib.color")
            return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
          end
          return {
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
            DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
            DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
            DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
            DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),
            BlinkCmpMenu = { bg = colors.palette.dragonBlack3 },
            BlinkCmpLabelDetail = { bg = colors.palette.dragonBlack3 },
            BlinkCmpMenuSelection = { bg = colors.palette.waveBlue1 },
          }
        end,
        theme = "dragon", -- Load "wave" theme
        background = { -- map the value of 'background' option to a theme
          dark = "wave", -- "lotus" | "dragon¨
          light = "lotus",
        },
      })
      -- setup must be called before loading
      -- vim.cmd("colorscheme kanagawa")
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        highlight_groups = {
          Whitespace = { fg = "#403d52" },
        },
      })
      vim.cmd("colorscheme rose-pine")
    end,
  },
  -- {
  --   "jpwol/thorn.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("thorn").setup({
  --       theme = "dark", -- 'light' or 'dark' - defaults to vim.o.background if unset
  --       background = "warm", -- options are 'warm' and 'cold'
  --       styles = {
  --         keywords = { italics = true, bold = true },
  --         comments = { italics = true, bold = true },
  --         strings = { italics = true, bold = true },
  --         diagnostic = {
  --           underline = false, -- if true, flat underlines will be used. Otherwise, undercurls will be used
  --           error = { highlight = true },
  --           hint = { highlight = true },
  --           info = { highlight = true },
  --           warn = { highlight = true },
  --         },
  --       },
  --
  --       transparent = false, -- transparent background
  --       on_highlights = function(hl, palette)
  --         hl.Whitespace = { fg = "#38524F" }
  --       end,
  --     })
  --     -- after plugin is loaded by your manager
  --     -- vim.cmd([[colorscheme thorn]])
  --   end,
  -- },
}
