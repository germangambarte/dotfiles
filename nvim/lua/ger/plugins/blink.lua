return {
  {
    "Saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets", -- useful snippets
    },
    config = function()
      require("blink.cmp").setup({
        -- Your desired configuration options here
        -- For example:
        snippets = {
          preset = "default", -- or "friendly" if you prefer friendly snippets
        },
        completion = {
          list = {
            selection = { preselect = true, auto_insert = true },
          },
          accept = {
            auto_brackets = {
              enabled = true,
            },
          },
        },
        appearance = {
          -- Adjust if your theme doesn't fully support blink.cmp
          -- use_nvim_cmp_as_default = false,
        },
        menu = {
          -- Don't automatically show the completion menu
          auto_show = false,

          -- nvim-cmp style menu
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
          },
        },
        signature = { enabled = true },

        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        sources = {
          -- Remove 'buffer' if you don't want text completions, by default it's only enabled when LSP returns no items
          default = { "lsp", "path", "snippets", "buffer" },
        },
      })
    end,
  },
  {
    "saghen/blink.indent",
    --- @module 'blink.indent'
    --- @type blink.indent.Config
    config = function()
      require("blink.indent").setup({
        blocked = {
          -- default: 'terminal', 'quickfix', 'nofile', 'prompt'
          buftypes = { include_defaults = true },
          -- default: 'lspinfo', 'packer', 'checkhealth', 'help', 'man', 'gitcommit', 'dashboard', ''
          filetypes = { include_defaults = true },
        },
        static = {
          enabled = true,
          char = "▎",
          priority = 1,
          -- specify multiple highlights here for rainbow-style indent guides
          -- highlights = { 'BlinkIndentRed', 'BlinkIndentOrange', 'BlinkIndentYellow', 'BlinkIndentGreen', 'BlinkIndentViolet', 'BlinkIndentCyan' },
          highlights = { "BlinkIndent" },
        },
        scope = {
          enabled = true,
          char = "▎",
          priority = 1000,
          -- set this to a single highlight, such as 'BlinkIndent' to disable rainbow-style indent guides
          -- highlights = { 'BlinkIndentScope' },
          -- optionally add: 'BlinkIndentRed', 'BlinkIndentCyan', 'BlinkIndentYellow', 'BlinkIndentGreen'
          highlights = { "BlinkIndentOrange", "BlinkIndentViolet", "BlinkIndentBlue" },
          -- enable to show underlines on the line above the current scope
          underline = {
            enabled = false,
            -- optionally add: 'BlinkIndentRedUnderline', 'BlinkIndentCyanUnderline', 'BlinkIndentYellowUnderline', 'BlinkIndentGreenUnderline'
            highlights = { "BlinkIndentOrangeUnderline", "BlinkIndentVioletUnderline", "BlinkIndentBlueUnderline" },
          },
        },
      })
    end,
  },
}
