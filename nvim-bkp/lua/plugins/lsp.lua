return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- list of servers for mason to install
      ensure_installed = {
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
        "eslint",
        "clangd",
        "ruff",
        -- "intelephense",
        "marksman",
        "jdtls",
        "zls",
        "yamlls",
        "phpactor",
        "rust_analyzer",
      },
    },
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "pylint",
        "eslint_d",
        "pint",
        "blade-formatter",
        "gopls",
        "goimports",
        "golangci-lint",
        "delve",
        "codelldb",
        "xmlformatter",
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
