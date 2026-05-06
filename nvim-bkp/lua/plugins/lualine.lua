return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- opcional, pero recomendable
  event = "VeryLazy", -- carga diferida

  config = function()
    local lualine = require("lualine")

    -- Condiciones útiles
    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
    }

    -- Config base (sin colores fijos)
    local config = {
      options = {
        theme = "auto",               -- detecta colores del colorscheme activo
        globalstatus = true,          -- una sola barra de estado para toda la ventana
        component_separators = "",    -- sin separadores
        section_separators = "",
        icons_enabled = true,
        disabled_filetypes = { "alpha", "dashboard", "neo-tree", "NvimTree" },
      },

      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },

      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    }

    -- Helpers
    local function ins_left(component)
      table.insert(config.sections.lualine_c, component)
    end

    local function ins_right(component)
      table.insert(config.sections.lualine_x, component)
    end

    -- 🡒 COMPONENTES IZQUIERDA
    ins_left({
      "filename",
      cond = conditions.buffer_not_empty,
      path = 1, -- 0 = solo nombre, 1 = relativo, 2 = absoluto
      symbols = { modified = " ", readonly = " 🔒" },
    })

    ins_left({
      "branch",
      icon = "",
      cond = conditions.buffer_not_empty,
      separator = " ",
    })

    ins_left({
      "diff",
      symbols = { added = " ", modified = " ", removed = " " },
      cond = conditions.hide_in_width,
    })

    ins_left({
      "diagnostics",
      sources = { "nvim_diagnostic" },
      symbols = {
              error = " ",
              warn = " ",
              hint = "󰠠 ",
              info = " ",
      }
    })


    -- Separador central para empujar al lado derecho
    ins_left({
      function()
        return "%="
      end,
    })

    -- 🡒 COMPONENTES DERECHA
    ins_right({
      "filetype",
      icon_only = false,
      cond = conditions.buffer_not_empty,
    })

    ins_right({
      "encoding",
      cond = conditions.hide_in_width,
    })

    ins_right({
      "fileformat",
      cond = conditions.hide_in_width,
    })

    ins_right({
      "location",
    })

    ins_right({
      "progress",
    })

    -- Inicializa Lualine
    lualine.setup(config)
  end,
}
