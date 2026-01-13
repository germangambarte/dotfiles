-- ==========================================================================
-- KEYMAPPINGS CONFIGURATION
-- ==========================================================================
-- lua/config/keymaps.lua
-- This file handles global keybindings and plugin-specific shortcuts.

-- 1. SETUP & IMPORTS
-- --------------------------------------------------------------------------
local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local Keys = {}

-- Load User Environment (safely)
local env_status, env = pcall(require, "config.user_env")
local env_config = env_status and env.config or {}

-- ==========================================================================
-- GENERAL KEYMAPS
-- ==========================================================================

-- Bad Habits (Disable Arrow Keys)
-- --------------------------------------------------------------------------
if env_config.bad_habbits then
  map({ "n", "i", "x", "v" }, "<Up>", "<Nop>", opts)
  map({ "n", "i", "x", "v" }, "<Down>", "<Nop>", opts)
  map({ "n", "i", "x", "v" }, "<Left>", "<Nop>", opts)
  map({ "n", "i", "x", "v" }, "<Right>", "<Nop>", opts)
end

-- Insert Mode Navigation
-- --------------------------------------------------------------------------
map("i", "<C-h>", "<Left>", opts)
map("i", "<C-l>", "<Right>", opts)
map("i", "<C-j>", "<Down>", opts)
map("i", "<C-k>", "<Up>", opts)

-- Window Management
-- --------------------------------------------------------------------------
-- Navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window Left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window Down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window Up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window Right" })

-- Resizing
map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Buffer Management
-- --------------------------------------------------------------------------
map("n", "<S-l>", ":bnext<CR>", { desc = "Next Buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Prev Buffer" })

-- Text Manipulation
-- --------------------------------------------------------------------------
-- Move Lines (Visual Mode)
map("v", "<A-j>", ":m .+1<CR>==", opts)
map("v", "<A-k>", ":m .-2<CR>==", opts)
map("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)
map("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)

map("i", "<C-;>", "<ESC><cmd>nohl<CR>", { desc = "Exit insert mode" })
map("n", "<esc>", "<ESC><cmd>nohl<CR>", { desc = "Escape + nohl" })

-- Indenting (Stay in Visual Mode)
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Standard Operations
-- --------------------------------------------------------------------------
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save File" })
map("n", "<C-q>", "<cmd>q!<cr>", { desc = "Force Quit" })

-- Clipboard Operations
-- --------------------------------------------------------------------------
map("n", "x", '"_x', opts) -- Delete char without yanking
map("n", "<leader>y", "ggVGy", { desc = "Yank Whole File" })
map("n", "Y", "y$", { desc = "Yank to end of line" })

map("i", "jk", "<Esc><cmd>noh<CR>", { desc = "Fast Exit Insert" })
map("n", "U", "<C-r>", { desc = "Redo" }) -- Undo is 'u', Redo is 'U'

-- ==========================================================================
-- PLUGIN SPECIFIC KEYMAPS
-- ==========================================================================

-- LuaSnip (Snippet Engine)
-- --------------------------------------------------------------------------
-- We do NOT require "luasnip" here. We require it inside the functions.

-- Jump to next placeholder
map({ "i", "s" }, "<C-k>", function()
  local ls = require("luasnip")
  if ls.jumpable(1) then
    ls.jump(1)
  end
end, opts)

-- Jump to prev placeholder
map({ "i", "s" }, "<C-j>", function()
  local ls = require("luasnip")
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, opts)

-- Cycle through choice nodes
map({ "i", "s" }, "<A-l>", function()
  local ls = require("luasnip")
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, opts)

map({ "i", "s" }, "<A-h>", function()
  local ls = require("luasnip")
  if ls.choice_active() then
    ls.change_choice(-1)
  end
end, opts)

-- Snacks.nvim (Telescope Replacement)
-- --------------------------------------------------------------------------
-- Main Pickers
map("n", "<leader>sF", function()
  require("snacks").picker.smart()
end, { desc = "Smart Find Files" })
map("n", "<leader>sf", function()
  require("snacks").picker.files()
end, { desc = "Find Files" })
map("n", "<leader>sr", function()
  require("snacks").picker.recent()
end, { desc = "Recent Files" })
map("n", "<leader>,", function()
  require("snacks").picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>:", function()
  require("snacks").picker.command_history()
end, { desc = "Command History" })

-- Config Shortcut
map("n", "<leader>fc", function()
  require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config" })

-- Search & Grep
map("n", "<leader>sg", function()
  require("snacks").picker.grep()
end, { desc = "Grep Project" })
map("n", "<leader>sw", function()
  require("snacks").picker.grep_word()
end, { desc = "Grep Word" })
map("x", "<leader>sw", function()
  require("snacks").picker.grep_word()
end, { desc = "Grep Selection" })

-- LSP & Diagnostics
map("n", "gd", function()
  require("snacks").picker.lsp_definitions()
end, { desc = "Goto Definition" })
map("n", "gr", function()
  require("snacks").picker.lsp_references()
end, { desc = "References", nowait = true })
map("n", "gI", function()
  require("snacks").picker.lsp_implementations()
end, { desc = "Goto Implementation" })
map("n", "gy", function()
  require("snacks").picker.lsp_type_definitions()
end, { desc = "Goto Type Def" })
map("n", "<leader>ss", function()
  require("snacks").picker.lsp_symbols()
end, { desc = "LSP Symbols" })
map("n", "<leader>sd", function()
  require("snacks").picker.diagnostics()
end, { desc = "Diagnostics" })

-- 5. Meta
map("n", '<leader>s"', function()
  require("snacks").picker.registers()
end, { desc = "Registers" })
map("n", "<leader>sh", function()
  require("snacks").picker.help()
end, { desc = "Help Pages" })
map("n", "<leader>sk", function()
  require("snacks").picker.keymaps()
end, { desc = "Keymaps" })
map("n", "<leader>su", function()
  require("snacks").picker.undo()
end, { desc = "Undo History" })
map("n", "<leader>sR", function()
  require("snacks").picker.resume()
end, { desc = "Resume Picker" })
map("n", "<leader>sn", function()
  require("snacks").picker.notifications()
end, { desc = "Notifications" })
map("n", "<leader>si", function()
  require("snacks").picker.icons()
end, { desc = "Icons" })

-- ==========================================================================
-- COMMANDS & ABBREVIATIONS
-- ==========================================================================
-- CMD Abbreviations (Fix typos, quick commands)
vim.cmd([[cnoreab cls Cls]])
vim.cmd([[cnoreab W w]])
vim.cmd([[cnoreab W! w!]])

-- Insert Mode Abbreviations
vim.cmd([[inoreab idate <C-R>=strftime("%b %d %Y %H:%M")<CR>]])

-- Function Keys (Timestamp insertion)
map("n", "<F1>", 'oThis file was created on <C-R>=strftime("%b %d %Y %H:%M")<CR><ESC>', opts)
map("i", "<F1>", 'This file was created on <C-R>=strftime("%b %d %Y %H:%M")<CR><ESC>', opts)

-- -- window management
-- map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
-- map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
-- map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
-- map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
--

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")


return Keys
