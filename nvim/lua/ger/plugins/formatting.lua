return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        liquid = { "prettier" },
        lua = { "stylua" },
        php = { "pint" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        python = {
          "ruff_fix",
          "ruff_format",
          "ruff_organize_imports",
        },

        go = { "goimports", "gofmt" },
        cpp = { "clang_format" },
        c = { "clang_format" },
      },
      formatters = {
        clang_format = {
          prepend_args = { "--style=file", "--fallback-style=WebKit" },
        },
      },
      -- format_on_save = {
      --   lsp_fallback = true,
      --   async = false,
      --   timeout_ms = 3000,
      -- },
    })

    vim.keymap.set({ "n", "v" }, "<leader>cf", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
