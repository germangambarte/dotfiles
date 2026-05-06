local function gh(repo)
	return "https://github.com/" .. repo
end

vim.pack.add({
	gh("neovim/nvim-lspconfig"),
	gh("nvim-treesitter/nvim-treesitter"),
	gh("folke/flash.nvim"),
})

vim.pack.add({
	{
		src = gh("jpwol/thorn.nvim"),
		version = "refactor/theme-change",
	},
})
require("thorn").setup({
	-- theme = nil, -- 'forest' or 'field' - defaults to vim.o.background if unset

	transparent = false, -- transparent background
	terminal = true, -- terminal colors

	on_highlights = function(hl, palette)
		hl.Whitespace = { fg = palette.green_5 }
		hl.CursorLine = { bg = palette.cursorline }
	end,
	styles = {
		keywords = { italic = true, bold = true },
		comments = { italic = true, bold = false },
		strings = { italic = true, bold = false },

		diagnostic = {
			-- 	underline = true, -- if true, flat underlines will be used. Otherwise, undercurls will be used
			--
			-- 	-- true will apply the bg highlight, false applies the fg highlight
			-- error = { highlight = true },
			hint = { highlight = false },
			info = { highlight = false },
			warn = { highlight = false },
		},
	},
})
vim.cmd("colorscheme thorn")

vim.pack.add({
	"https://github.com/rebelot/kanagawa.nvim",
})
require("kanagawa").setup({
	compile = false, -- enable compiling the colorscheme
	undercurl = true, -- enable undercurls
	commentStyle = { italic = true },
	functionStyle = {},
	keywordStyle = { italic = true },
	statementStyle = { bold = true },
	typeStyle = {},
	transparent = false, -- do not set background color
	dimInactive = false, -- dim inactive window `:h hl-NormalNC`
	terminalColors = true, -- define vim.g.terminal_color_{0,17}
	colors = {
		theme = {
			all = {
				ui = {
					bg_gutter = "none",
				},
			},
		},
	},
	overrides = function(colors)
		local theme = colors.theme
		local makeDiagnosticColor = function(color)
			local c = require("kanagawa.lib.color")
			return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
		end
		return {
			NormalFloat = { bg = "none" },
			FloatBorder = { bg = "none" },
			FloatTitle = { bg = "none" },
			NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
			LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
			MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
			Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
			PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
			PmenuSbar = { bg = theme.ui.bg_m1 },
			PmenuThumb = { bg = theme.ui.bg_p2 },
			DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
			DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
			DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
			DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),
		}
	end,
	theme = "wave", -- Load "wave" theme
	background = { -- map the value of 'background' option to a theme
		dark = "wave", -- try "dragon" !
		light = "lotus",
	},
})

-- vim.cmd("colorscheme kanagawa")

vim.pack.add({
	{ src = "https://github.com/alexghergh/nvim-tmux-navigation" },
})
local nvim_tmux_nav = require("nvim-tmux-navigation")

nvim_tmux_nav.setup({
	disable_when_zoomed = true, -- defaults to false
})

vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)

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

require("gitsigns").setup({
	signs = {
		add = { text = "+" }, ---@diagnostic disable-line: missing-fields
		change = { text = "~" }, ---@diagnostic disable-line: missing-fields
		delete = { text = "_" }, ---@diagnostic disable-line: missing-fields
		topdelete = { text = "‾" }, ---@diagnostic disable-line: missing-fields
		changedelete = { text = "~" }, ---@diagnostic disable-line: missing-fields
	},
})

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

local function custom_filename()
	local path = vim.fn.expand("%:.")
	if path == "" then
		return ""
	end

	local dir = path:match("(.*[/\\])")
	local filename = vim.fn.expand("%:t")
	-- Lógica de símbolos
	local modified = vim.bo.modified and " [+]" or ""
	local readonly = vim.bo.readonly and " 🔒" or ""

	if dir then
		-- Retorna: carpeta/ + Resaltado(nombre) + Símbolos
		return string.format("%s%%#LualineFilename#%s%%#Lualine#%s%s", dir, filename, modified, readonly)
	else
		return string.format("%%#LualineFilename#%s%%#Lualine#%s%s", filename, modified, readonly)
	end
end

vim.api.nvim_set_hl(0, "LualineFilename", { fg = "#f2a597", bold = true })
-- 🡒 COMPONENTES IZQUIERDA
ins_left({
	custom_filename, -- Usamos nuestra función en lugar de "filename"
	cond = conditions.buffer_not_empty,
	symbols = { modified = "[+]", readonly = "🔒" },
})
-- ins_left( -- 🡒 COMPONENTES IZQUIERDA
-- 	{
-- 		"filename",
-- 		cond = conditions.buffer_not_empty,
-- 		path = 1, -- 0 = solo nombre, 1 = relativo, 2 = absoluto
-- 		symbols = { modified = "[+]", readonly = " 🔒" },
-- 	}
-- )

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
	"diff",
	symbols = { added = " ", modified = " ", removed = " " },
	cond = conditions.hide_in_width,
})

ins_right({
	"branch",
	icon = "",
	cond = conditions.buffer_not_empty,
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
	-- "https://github.com/altermo/ultimate-autopair.nvim",
})
require("nvim-ts-autotag").setup({
	opts = {
		-- Enable auto-close and rename for rust filetype
		enable_close = true,
		enable_rename = true,
		enable_close_on_slash = true,
	},
	-- If rust is not auto-detected, add it manually
	filetypes = { "html", "javascript", "typescript", "rust", "xml" },
})
require("fidget").setup({})
-- require("ultimate-autopair").setup({})

-- using lazy.nvim
vim.pack.add({
	"https://github.com/S1M0N38/love2d.nvim",
})
require("love2d").setup({
	path_to_love = "/usr/bin/love",
	restart_on_save = true,
})
