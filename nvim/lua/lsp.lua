-- Lista de servidores que quieres habilitar
local servers = {
	"cssls",
	"emmet_ls",
	"eslint",
	"gopls",
	"graphql",
	"html",
	"lua_ls",
	"pyright",
	"ruff",
	"svelte",
	"tailwindcss",
	"prismals",
	"marksman",
	"ts_ls",
	"yamlls",
	"zls",
	"clangd",
	"rust_analyzer",
}

-- Configuración específica para servidores que la necesiten
-- (Esto reemplaza los .setup({ settings = ... }) antiguos)
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
		},
	},
})

-- Habilitar todos los servidores de la lista
for _, server in ipairs(servers) do
	vim.lsp.enable(server)
end

-- Configuración de diagnósticos (esto sigue igual)
vim.diagnostic.config({ virtual_text = true })
