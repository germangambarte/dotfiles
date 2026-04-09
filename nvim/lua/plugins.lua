vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/folke/flash.nvim",
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
})

vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
})
vim.cmd.colorscheme("catppuccin")

vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.nvim" },
})
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
	highlighters = {
		-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

		-- Highlight hex color strings (`#rrggbb`) using that color
		hex_color = hipatterns.gen_highlighter.hex_color(),
	},
})

vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
})

local luasnip = require("luasnip")
luasnip.config.set_config({
	region_check_events = "InsertEnter",
	delete_check_events = "TextChanged,InsertLeave",
})
require("luasnip.loaders.from_vscode").lazy_load()
require("blink.cmp").setup({
	fuzzy = { implementation = "prefer_rust_with_warning" },
	snippets = {
		preset = "luasnip", -- or "friendly" if you prefer friendly snippets
	},
	signature = { enabled = true },
	keymap = {
		preset = "default",
		["<C-y>"] = { "accept", "fallback" },
		["<C-n>"] = { "select_next", "fallback" },
		["<C-p>"] = { "select_prev", "fallback" },
		["<C-k>"] = { "snippet_forward", "fallback" },
		["<C-j>"] = { "snippet_backward", "fallback" },
	},
	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "normal",
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
	},
	cmdline = {
		keymap = {
			preset = "inherit",
			["<CR>"] = { "accept_and_enter", "fallback" },
		},
	},
	documentation = { auto_show = true, auto_show_delay_ms = 500 },
	menu = {
		auto_show = false,
		draw = {
			columns = {
				{ "label", "label_description", gap = 1 },
				{ "kind_icon", "kind" },
			},
		},
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
})

vim.pack.add({
	{ src = "https://github.com/mason-org/mason.nvim" },
})

require("mason").setup({})

vim.pack.add({
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("gitsigns").setup({ signcolumn = false })

vim.pack.add({
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
})
local lualine = require("lualine")
local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
}
local config = {
	options = {
		theme = "auto", -- detecta colores del colorscheme activo
		globalstatus = true, -- una sola barra de estado para toda la ventana
		component_separators = "", -- sin separadores
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
	},
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
lualine.setup(config)

vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
})
---@type snacks.Config
require("snacks").setup({
	-- image = { enabled = true, inline = false, float = true, max_width = 80, max_height = 40 },
	indent = {
		animate = {
			enabled = true,
			style = "out",
			easing = "linear",
			duration = {
				step = 20, -- ms per step
				total = 250, -- maximum duration
			},
		},
	},
	input = { enabled = true },
	picker = {
		sources = {
			explorer = {
				auto_close = true,
				jump = { close = true },
				layout = { preset = "sidebar", preview = false, layout = { position = "right" } },
			},
			files = {
				exclude = { "vendor", ".venv", "node_modules" },
			},
		},
		enabled = true,
		layout = "ivy",
		matcher = {
			frecuency = true,
		},
	},
	scope = { enabled = true },
	statuscolumn = { enabled = true },
	words = { enabled = true },
	terminal = { enabled = true },
	notifier = { enable = true },
	notify = { enable = true },
	explorer = {
		enable = true,
		replace_netrw = true, -- Replace netrw with the snacks explorer
		trash = true, -- Use the system trash when deleting files
	},
})

vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})
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
		sh = { "shfmt" },
		bash = { "shfmt" },
		php = { "pint" },
		blade = { "blade-formatter" },
		python = {
			"ruff_fix",
			"ruff_format",
			"ruff_organize_imports",
		},
		go = { "goimports", "gofmt" },
		cpp = { "clang_format" },
		c = { "clang_format" },
		rust = { "rustfmt" },
	},
	formatters = {
		clang_format = {
			prepend_args = { "--style=file", "--fallback-style=WebKit" },
		},
	},
})

vim.pack.add({
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/leoluz/nvim-dap-go", -- Golang
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/ramboe/ramboe-dotnet-utils",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/jay-babu/mason-nvim-dap.nvim",
	"https://github.com/mfussenegger/nvim-dap-python",
	"https://github.com/theHamsta/nvim-dap-virtual-text",
})

local dap = require("dap")
local dapui = require("dapui")

require("mason-nvim-dap").setup({
	automatic_installation = true,
	handlers = {},
	ensure_installed = {},
})

dapui.setup({
	expand_lines = true,
	controls = { enabled = false }, -- no extra play/step buttons
	floating = { border = "rounded" },
	-- Set dapui window
	render = {
		max_type_length = 60,
		max_value_lines = 200,
	},
	-- Only one layout: just the "scopes" (variables) list at the bottom
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 1.0 }, -- 100% of this panel is scopes
			}, -- height in lines (adjust to taste)
			size = 50,
			position = "right", -- "left", "right", "top", "bottom"
		},
	},
})

dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

require("dap-python").setup("uv")
require("nvim-dap-virtual-text").setup({})
require("dap-go").setup({
	delve = {
		path = function()
			local mason_delve = vim.fn.stdpath("data") .. "/mason/bin/dlv"
			if vim.fn.executable(mason_delve) == 1 then
				return mason_delve
			end
			return vim.fn.exepath("dlv") ~= "" and vim.fn.exepath("dlv") or "dlv"
		end,
	},
})

vim.pack.add({
	"https://github.com/windwp/nvim-ts-autotag",
	"https://github.com/j-hui/fidget.nvim",
	"https://github.com/altermo/ultimate-autopair.nvim",
})
require("nvim-ts-autotag").setup({})
require("fidget").setup({})
require("ultimate-autopair").setup({})
