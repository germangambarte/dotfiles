return {
  "b0o/incline.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-treesitter/nvim-treesitter",
    "SmiteshP/nvim-navic",
  },
  event = "VeryLazy",
  config = function()
    -- Create custom highlight groups for transparent background
    vim.api.nvim_set_hl(0, "InclineNormalTransparent", {
      fg = vim.api.nvim_get_hl(0, { name = "Comment" }).fg,
      bg = "NONE",
    })

    local devicons = require("nvim-web-devicons")
    local navic = require("nvim-navic")

    require("incline").setup({
      hide = {
        cursorline = true,
      },
      highlight = {
        groups = {
          InclineNormal = "InclineNormalTransparent",
          InclineNormalNC = "InclineNormalTransparent",
        },
      },
      window = {
        padding = 0,
        margin = { vertical = 0, horizontal = 0 },
        placement = {
          horizontal = "right",
          vertical = "top",
        },
      },
      render = function(props)
        if props.focused then
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)
          local modified = vim.bo[props.buf].modified
          local function get_git_diff()
            local icons = { removed = "", changed = "", added = "" }
            icons["changed"] = icons.modified
            local signs = vim.b[props.buf].gitsigns_status_dict
            local labels = {}
            if signs == nil then
              return labels
            end
            for name, icon in pairs(icons) do
              if tonumber(signs[name]) and signs[name] > 0 then
                table.insert(labels, { " " .. icon .. " " .. signs[name] .. " ", group = "Diff" .. name })
                -- table.insert(labels, { ' ' .. icon .. ' ' .. signs[name] .. ' '})
              end
            end
            if #labels > 0 then
              table.insert(labels, { "┊ " })
            end
            return labels
          end
          local function get_diagnostic_label()
            local icons = { error = "", warn = "", info = "", hint = "󰌵" }
            local label = {}

            for severity, icon in pairs(icons) do
              local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
              if n > 0 then
                table.insert(label, { icon .. " " .. n .. " ", group = "DiagnosticSign" .. severity })
              end
            end
            if #label > 0 then
              table.insert(label, { "┊ " })
            end
            return label
          end

          local res = {
            { get_diagnostic_label() },
            { get_git_diff() },
            { modified and { "[+]", gui = "bold" } or "" },
            { (ft_icon or "") .. " ", guifg = ft_color, guibg = "none" },
            { filename },
            guibg = "NONE",
          }
          if props.focused then
            for _, item in ipairs(navic.get_data(props.buf) or {}) do
              table.insert(res, {
                { " ➜ ", group = "NavicSeparator" },
                { item.icon, group = "NavicIcons" .. item.type },
                { item.name, group = "NavicText" },
              })
            end
          end
          table.insert(res, " ")
          return res
        end

        return nil
      end,
    })
  end,
}
