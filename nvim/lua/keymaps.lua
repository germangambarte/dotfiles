local map = vim.keymap.set

-- map("n", "<leader>v", { ft = "lua", desc = "LÖVE" })
map("n", "<leader>vv", "<cmd>LoveRun<cr>", { desc = "Run LÖVE" })
map("n", "<leader>vs", "<cmd>LoveStop<cr>", { desc = "Stop LÖVE" })

-- Disable Space bar since it will be used as the leader key
map({ "n", "v" }, "<leader>", "<nop>")

-- Redo remap
map("n", "U", "<C-r>")

-- after a search, press escape to clear highlights
map("n", "<Esc>", ":nohl<CR>")

-- Swap between split buffers
map("n", "<C-h>", ":wincmd h<CR>")
map("n", "<C-j>", ":wincmd j<CR>")
map("n", "<C-k>", ":wincmd k<CR>")
map("n", "<C-l>", ":wincmd l<CR>")
map("n", "<leader>rr", ":wincmd r<CR>")

-- Resizing
map("n", "<C-Up>", ":resize +2<CR>")
map("n", "<C-Down>", ":resize -2<CR>")
map("n", "<C-Left>", ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")

-- Save and quit current file quicker
map("n", "<leader>w", ":w<cr>", { silent = false, noremap = true })
map({ "n", "t" }, "<leader>q", ":q<cr>", { silent = false, noremap = true })

-- Little one from Primeagen to mass replace string in a file
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { silent = false })

-- Close currently active buffer
map("n", "<C-c>", ":bwipeout<CR>", { silent = false })

-- Center buffer when navigating up and down
map("n", "<S-k>", "<C-u>zz")
map("n", "<S-j>", "<C-d>zz")

-- Center buffer when progressing through search results
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Indenting (Stay in Visual Mode)
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Standard Operations
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save File" })
map("n", "<C-q>", "<cmd>q!<cr>", { desc = "Force Quit" })
map("n", "<leader>p", '"_dP')
map("n", "Y", "y$", { desc = "Yank to end of line" })
map("n", "W", ":wa<cr>", { desc = "Write All" })
map("n", "Q", ":q<cr>", { desc = "Quit" })

-- Yank to system clipboard
map("n", "<leader>y", '"+y')
map("v", "<leader>y", '"+y')
map("n", "<leader>Y", '"+Y')

-- Open buffer to the right
map("n", "<leader>v", ":vsplit<CR>")

-- Move selection up and down
map("v", "<C-j>", ":m '>+1<CR>gv=gv")
map("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- Exit terminal with Esc
map("t", "<Esc>", "<C-\\><C-N>")

-- open config file and run :Oil
map("n", "<leader>config", function()
	vim.cmd(":e ~/.config/nvim/init.lua")
	vim.cmd(":Oil")
end)

-- toggle inlayhints
map("n", "<leader>i", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	vim.notify(vim.lsp.inlay_hint.is_enabled() and "Inlay Hints Enabled" or "Inlay Hints Disabled")
end)

map("n", "<leader>tn", ":tabnew<CR>")
map("n", "<leader>tq", ":tabclose<CR>")
map("n", "<leader>ts", ":tab split<CR>")
map("n", "<leader><Tab>", ":tabnext<CR>")
map("n", "<leader><S-Tab>", ":tabprevious<CR>")

-- Bad Habits (Disable Arrow Keys)
map({ "n", "i", "x", "v" }, "<Up>", "<Nop>")
map({ "n", "i", "x", "v" }, "<Down>", "<Nop>")
map({ "n", "i", "x", "v" }, "<Left>", "<Nop>")
map({ "n", "i", "x", "v" }, "<Right>", "<Nop>")

-- format
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	require("conform").format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 1000,
	})
end, { desc = "Format file or range (in visual mode)" })

-- Snacks
map("n", "<leader>sF", function()
	require("snacks").picker.smart()
end, { desc = "Smart Find Files" })
map("n", "-", function()
	Snacks.explorer()
end, { desc = "File Explorer" })
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

-- dap
map("n", "<F5>", function()
	require("dap").continue()
end)
map("n", "<F1>", function()
	require("dap").step_into()
end)
map("n", "<F2>", function()
	require("dap").step_over()
end)
map("n", "<F3>", function()
	require("dap").step_out()
end)
map("n", "<leader>b", function()
	require("dap").toggle_breakpoint()
end)
map("n", "<leader>B", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end)
map("n", "<F7>", function()
	require("dapui").toggle()
end)

-- flash

map("n", "<leader>f", function()
	require("flash").jump()
end)
map("n", "<leader>F", function()
	require("flash").treesitter()
end)
