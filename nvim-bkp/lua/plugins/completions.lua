return {
  {
    "saghen/blink.compat",
    version = "2.*",
    lazy = true,
    opts = {},
  },
  {
    "Saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
    },
    version = "*", -- Recomendado usar la última release
    config = function()
      local luasnip = require("luasnip")
      luasnip.config.set_config({
        region_check_events = "InsertEnter",
        delete_check_events = "TextChanged,InsertLeave",
      })

      require("luasnip.loaders.from_vscode").lazy_load()

      require("blink.cmp").setup({
        snippets = {
          preset = "luasnip", -- or "friendly" if you prefer friendly snippets
        },
        keymap = {
          preset = "default", -- Usamos el default como base
          ["<C-y>"] = { "accept", "fallback" },
          ["<C-n>"] = { "select_next", "fallback" },
          ["<C-p>"] = { "select_prev", "fallback" },
          ["<C-k>"] = { "snippet_forward", "fallback" },
          ["<C-j>"] = { "snippet_backward", "fallback" },
        },
        completion = {
          ghost_text = { enabled = false },
          list = {
            selection = { preselect = true, auto_insert = true },
          },
          accept = {
            auto_brackets = {
              enabled = true,
            },
          },
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
          default = { "laravel", "lsp", "path", "snippets", "buffer" },
          providers = {
            laravel = {
              name = "laravel",
              module = "blink.compat.source",
              score_offset = 95, -- show at a higher priority than lsp
            },
          },
        },
      })
    end,
  },
}
