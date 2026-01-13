return {
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
      -- vim.cmd("colorscheme rose-pine")
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({})
      vim.cmd("colorscheme tokyonight")
    end,
  },
}
