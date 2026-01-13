local api = vim.api
local env_status, env = pcall(require, "config.user_env")
-- --------------------------------------------------------------------------
-- Text Manipulation
-- --------------------------------------------------------------------------
api.nvim_create_user_command("Cls", function()
  require("util.utils").preserve("%s/\\s\\+$//ge")
end, { desc = "Remove trailing whitespace" })

api.nvim_create_user_command("Squeeze", function()
  require("util.utils").squeeze_blank_lines()
end, { desc = "Remove consecutive blank lines" })

api.nvim_create_user_command("Reindent", function()
  require("util.utils").reindent()
end, { desc = "Re-indent the entire file" })

-- --------------------------------------------------------------------------
-- Miscellaneous / System
-- --------------------------------------------------------------------------

api.nvim_create_user_command("Blockwise", function()
  require("util.utils").blockwise_clipboard()
end, { desc = "Set clipboard register to blockwise mode" })

api.nvim_create_user_command("SaveAsRoot", "w !doas tee %", { desc = "Save current file as root (requires doas/sudo)" })

-- Create Command for Editing Snippets
api.nvim_create_user_command("LuaSnipEdit", function()
  require("luasnip.loaders.from_lua").edit_snippet_files()
end, {})

-- --------------------------------------------------------------------------
-- Legacy Realtime (Autoread)
-- --------------------------------------------------------------------------
-- Forces Neovim to detect file changes on disk immediately
api.nvim_create_user_command("Realtime", function()
  vim.opt.autoread = true
  api.nvim_create_autocmd("CursorHold", { pattern = "*", command = "checktime" })
  api.nvim_feedkeys("lh", "n", false) -- Trigger a move to refresh
end, { desc = "Enable realtime autoread (watch file changes)" })

-- --------------------------------------------------------------------------
-- highlight yank
-- --------------------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  pattern = "*",
  desc = "highlight selection on yank",
  callback = function()
    vim.highlight.on_yank({ timeout = 200, visual = true })
  end,
})

-- --------------------------------------------------------------------------
-- restore cursor to file position in previous editing session
-- --------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
      -- defer centering slightly so it's applied after render
      vim.schedule(function()
        vim.cmd("normal! zz")
      end)
    end
  end,
})

-- --------------------------------------------------------------------------
-- open help in vertical split
-- --------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  command = "wincmd L",
})

-- --------------------------------------------------------------------------
-- auto resize splits when the terminal's window is resized
-- --------------------------------------------------------------------------
vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
})

-- --------------------------------------------------------------------------
-- no auto continue comments on new line
-- --------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("no_auto_comment", {}),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- --------------------------------------------------------------------------
-- syntax highlighting for dotenv files
-- --------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufRead", {
  group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
  pattern = { ".env", ".env.*" },
  callback = function()
    vim.bo.filetype = "dosini"
  end,
})

-- --------------------------------------------------------------------------
-- show cursorline only in active window enable
-- --------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

-- --------------------------------------------------------------------------
-- show cursorline only in active window disable
-- --------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = "active_cursorline",
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

-- --------------------------------------------------------------------------
-- ide like highlight when stopping cursor
-- --------------------------------------------------------------------------
vim.api.nvim_create_autocmd("CursorMovedI", {
  -- group = "LspReferenceHighlight",
  group = vim.api.nvim_create_augroup("LspReferenceHighlight", { clear = true }),
  desc = "Clear highlights when entering insert mode",
  callback = function()
    vim.lsp.buf.clear_references()
  end,
})

-- --------------------------------------------------------------------------
-- Custom Filetypes
-- --------------------------------------------------------------------------
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.conf", "config" },
  command = "set filetype=config",
})

api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.ejs",
  command = "set filetype=html",
})

-- --------------------------------------------------------------------------
-- lsp keymaps
-- --------------------------------------------------------------------------
local keymap = vim.keymap -- for conciseness
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf, silent = true }

    opts.desc = "See available code actions"
    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

    opts.desc = "Smart rename"
    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

    -- opts.desc = "Show buffer diagnostics"
    -- keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

    opts.desc = "Show line diagnostics"
    keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

    opts.desc = "Go to previous diagnostic"
    keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, opts) -- jump to previous diagnostic in buffer
    --
    opts.desc = "Go to next diagnostic"
    keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, opts) -- jump to next diagnostic in buffer

    opts.desc = "Show documentation for what is under cursor"
    keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

    opts.desc = "Restart LSP"
    keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
  end,
})

-- vim.lsp.inlay_hint.enable(true)

local severity = vim.diagnostic.severity

vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [severity.ERROR] = " ",
      [severity.WARN] = " ",
      [severity.HINT] = "󰠠 ",
      [severity.INFO] = " ",
    },
  },
  virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == "ruff" then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = "LSP: Disable hover capability from Ruff",
})
