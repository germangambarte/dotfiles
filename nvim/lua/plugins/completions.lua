return {
  {
    "saghen/blink.compat",
    -- use v2.* for blink.cmp v1.*
    version = "2.*",
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
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

      -- Configuración de Autopairs (Blink lo maneja nativamente mejor)
      require("blink.cmp").setup({
        snippets = {
          preset = "luasnip", -- or "friendly" if you prefer friendly snippets
        },
        keymap = {
          preset = "default", -- Usamos el default como base
          -- Confirmar la selección
          ["<C-y>"] = { "accept", "fallback" },

          -- Navegar por la lista de sugerencias (Completions)
          ["<C-n>"] = { "select_next", "fallback" },
          ["<C-p>"] = { "select_prev", "fallback" },
          -- Configuramos Ctrl-k para ir hacia adelante y Ctrl-j hacia atrás
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
        -- sources = {
        --         default = { 'lsp', 'snippets', 'buffer', 'path' },
        --       },
        sources = {
          -- Remove 'buffer' if you don't want text completions, by default it's only enabled when LSP returns no items
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

-- ==========================================================================
-- COMPLETION & SNIPPETS CONFIGURATION
-- ==========================================================================
-- lua/plugins/completion.lua
-- This file sets up the autocompletion engine (nvim-cmp), snippet engine (LuaSnip),
-- and related utilities like auto-pairs and AI assistants.

-- return {
--   -- ==========================================================================
--   -- 1. SNIPPET ENGINE (LuaSnip)
--   -- ==========================================================================
--   {
--     "L3MON4D3/LuaSnip",
--     version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first is v2)
--     build = "make install_jsregexp",
--     dependencies = { "rafamadriz/friendly-snippets" },
--     event = "InsertEnter", -- Load early for snippets
--
--     config = function()
--       local ls = require("luasnip")
--       local types = require("luasnip.util.types")
--       local config_path = vim.fn.stdpath("config") -- Cache path for speed
--
--       -- 1. LOAD SNIPPETS
--       -- ----------------------------------------------------------------------
--       -- Load custom snippets from config path (Legacy SnipMate support)
--       require("luasnip.loaders.from_snipmate").lazy_load({
--         paths = { config_path .. "/bin/snippets" },
--       })
--       require("luasnip.loaders.from_lua").lazy_load({
--         paths = { config_path .. "/bin/node_snippets/" },
--       })
--
--       -- Load standard community snippets (friendly-snippets) as fallback
--       require("luasnip.loaders.from_vscode").lazy_load()
--
--       -- 2. CONFIGURATION
--       -- ----------------------------------------------------------------------
--       ls.config.setup({
--         history = true, -- Keep around last snippet local to jump back
--         update_events = "TextChanged,TextChangedI", -- Update dynamic snippets as you type
--         enable_autosnippets = true, -- Enable auto-trigger snippets
--         store_selection_keys = "<A-p>", -- Key to store selection for visual snippets
--
--         -- Visual feedback for Choice Nodes (multiple options in a snippet)
--         ext_opts = {
--           [types.choiceNode] = {
--             active = {
--               virt_text = { { "●", "GruvboxOrange" } },
--             },
--           },
--         },
--       })
--     end,
--   },
--
--   -- ==========================================================================
--   -- 2. COMPLETION ENGINE (Cmp)
--   -- ==========================================================================
--   {
--     "hrsh7th/nvim-cmp",
--     version = false,
--     event = { "InsertEnter", "CmdlineEnter" },
--     dependencies = {
--       "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
--       "hrsh7th/cmp-buffer", -- Buffer source for nvim-cmp
--       "hrsh7th/cmp-path", -- Path source for nvim-cmp
--       "hrsh7th/cmp-cmdline", -- Cmdline source for nvim-cmp
--       "hrsh7th/cmp-nvim-lua", -- Neovim Lua API source
--       "saadparwaiz1/cmp_luasnip", -- LuaSnip source
--       "notomo/cmp-neosnippet", -- NeoSnippet source
--       "windwp/nvim-autopairs",
--       -- "zbirenbaum/copilot-cmp",        -- Copilot source (Optional)
--       -- "tzachar/cmp-tabnine",           -- Tabnine source (Optional)
--     },
--
--     config = function()
--       local cmp = require("cmp")
--       local luasnip = require("luasnip")
--
--       local cmp_autopairs = require("nvim-autopairs.completion.cmp")
--       cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
--
--       -- 1. ICONS (Custom Set)
--       -- ----------------------------------------------------------------------
--       -- local kind_icons = {
--       --   Copilot = "",
--       --   Text = "",
--       --   Method = "",
--       --   Function = "",
--       --   Constructor = "",
--       --   Field = "ﰠ",
--       --   Variable = "",
--       --   Class = "ﴯ",
--       --   Interface = "",
--       --   Module = "",
--       --   Property = "ﰠ",
--       --   Unit = "塞",
--       --   Value = "",
--       --   Enum = "",
--       --   Keyword = "",
--       --   Snippet = "",
--       --   Color = "",
--       --   File = "",
--       --   Reference = "",
--       --   Folder = "",
--       --   EnumMember = "",
--       --   Constant = "",
--       --   Struct = "פּ",
--       --   Event = "",
--       --   Operator = "",
--       --   TypeParameter = "",
--       --   Table = " ",
--       --   Object = "",
--       --   Tag = " ",
--       --   Array = " ",
--       --   Boolean = "蘒",
--       --   Number = "",
--       --   String = "",
--       --   Calendar = " ",
--       --   Watch = "",
--       -- }
--
--       -- 2. SETUP
--       -- ----------------------------------------------------------------------
--       cmp.setup({
--         -- Snippet Expansion Logic
--         snippet = {
--           expand = function(args)
--             luasnip.lsp_expand(args.body)
--           end,
--         },
--
--         -- UI Customization
--         window = {
--           completion = cmp.config.window.bordered(),
--           documentation = cmp.config.window.bordered(),
--         },
--
--         -- Key Mappings
--         mapping = cmp.mapping.preset.insert(require("config.keymaps").cmp(cmp, luasnip)),
--
--         -- Formatting (Icons + Text)
--         formatting = {
--           fields = { "abbr", "kind", "menu" },
--           -- format = function(_, vim_item)
--           --   -- Concatenate icon with kind name
--           --   vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
--           --   return vim_item
--           -- end,
--         },
--
--         -- Sources (Order determines priority)
--         sources = {
--           -- { name = "copilot"   , group_index = 2 },
--           -- { name = "cmp_tabnine", group_index = 2 },
--           { name = "nvim_lsp", group_index = 2 },
--           { name = "luasnip", group_index = 2 },
--           { name = "buffer", group_index = 2 }, -- Text in the current Buffer
--           { name = "path", group_index = 2 },
--         },
--
--         -- Experimental Features
--         experimental = {
--           ghost_text = true,
--           native_menu = false,
--         },
--       })
--     end,
--   },
-- }
