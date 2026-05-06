return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile", "VeryLazy" },
  opts = {
    -- Asegúrate de incluir los lenguajes que usas habitualmente
    ensure_installed = {
      "json",
      "javascript",
      "typescript",
      "tsx",
      "yaml",
      "html",
      "css",
      "prisma",
      "markdown",
      "markdown_inline",
      "svelte",
      "graphql",
      "bash",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "query",
      "vimdoc",
      "c",
      "php",
    },
    highlight = {
      enable = true,
      -- Desactivar esto es clave para que Treesitter tenga prioridad total
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
  },
  config = function(_, opts)
    local configs = require("nvim-treesitter.config")
    configs.setup(opts)

    -- SOLUCIÓN RADICAL: Autocomando global para forzar Treesitter
    -- Esto garantiza que se active en CUALQUIER lenguaje que tenga un parser instalado
    vim.api.nvim_create_autocmd({ "FileType" }, {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang then
          pcall(vim.treesitter.start, args.buf, lang)
        end
      end,
    })

    -- Mantener la configuración de Blade que querías
    pcall(function()
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.blade = {
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "blade",
      }
    end)

    vim.filetype.add({
      pattern = { [".*%.blade%.php"] = "blade" },
    })
  end,
}
