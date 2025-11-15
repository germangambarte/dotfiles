return {
  {
    "olivercederborg/poimandres.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- require("poimandres").setup({
      --   -- leave this setup function empty for default config
      --   -- or refer to the configuration section
      --   -- for configuration options
      -- })
      require("poimandres").setup({
        bold_vert_split = false, -- use bold vertical separators
        dim_nc_background = false, -- dim 'non-current' window backgrounds
        disable_background = false, -- disable background
        disable_float_background = false, -- disable background for floats
        disable_italics = false, -- disable italics
      })
    end,

    -- optionally set the colorscheme within lazy config
    init = function()
      -- vim.cmd.colorscheme("poimandres")
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
      vim.cmd.colorscheme("catppuccin")
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

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
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
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      local transparent = false -- set to true if you would like to enable transparency

      local bg = "#011628"
      local bg_dark = "#011423"
      local bg_highlight = "#143652"
      local bg_search = "#0A64AC"
      local bg_visual = "#275378"
      local fg = "#CBE0F0"
      local fg_dark = "#B4D0E9"
      local fg_gutter = "#627E97"
      local border = "#547998"

      require("tokyonight").setup({
        style = "storm",
        transparent = transparent,
        styles = {
          sidebars = transparent and "transparent" or "dark",
          floats = transparent and "transparent" or "dark",
        },
        on_colors = function(colors)
          colors.bg = bg
          colors.bg_dark = transparent and colors.none or bg_dark
          colors.bg_float = transparent and colors.none or bg_dark
          colors.bg_highlight = bg_highlight
          colors.bg_popup = bg_dark
          colors.bg_search = bg_search
          colors.bg_sidebar = transparent and colors.none or bg_dark
          colors.bg_statusline = transparent and colors.none or bg_dark
          colors.bg_visual = bg_visual
          colors.border = border
          colors.fg = fg
          colors.fg_dark = fg_dark
          colors.fg_float = fg
          colors.fg_gutter = fg_gutter
          colors.fg_sidebar = fg_dark
        end,
      })

      -- vim.cmd("colorscheme tokyonight")
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({})

      -- vim.cmd("colorscheme rose-pine-moon")
      -- vim.cmd("colorscheme rose-pine-dawn")
      -- vim.cmd("colorscheme rose-pine")
    end,
  },
  -- {
  --   "jpwol/thorn.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("thorn").setup({
  --       theme = "light", -- 'light' or 'dark' - defaults to vim.o.background if unset
  --       background = "cold", -- options are 'warm' and 'cold'
  --
  --       styles = {
  --         keywords = { italics = true, bold = true },
  --         comments = { italics = true, bold = true },
  --         strings = { italics = true, bold = true },
  --
  --         diagnostic = {
  --           underline = false, -- if true, flat underlines will be used. Otherwise, undercurls will be used
  --
  --           -- true will apply the bg highlight, false applies the fg highlight
  --           error = { highlight = true },
  --           hint = { highlight = true },
  --           info = { highlight = true },
  --           warn = { highlight = true },
  --         },
  --       },
  --
  --       transparent = false, -- transparent background
  --     })
  --     -- after plugin is loaded by your manager
  --     -- vim.cmd([[colorscheme thorn]])
  --   end,
  -- },
}
