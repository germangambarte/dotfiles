-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local mason_path = "/home/ger/.local/share/nvim/mason/packages/"
local lombok_path = mason_path .. "jdtls/lombok.jar"
local workspace_dir = "/home/ger/dev/java" .. project_name

local config = {
  name = "jdtls",

  cmd = {
    "jdtls",
    "/home/ger/.sdkman/candidates/java/current/bin/java",
    "-javaagent:" .. lombok_path,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    -- ... (Otros argumentos de cmd)
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    mason_path .. "jdtls/plugins/org.eclipse.equinox.launcher_1.7.100.v20251111-0406.jar",
    "-configuration",
    mason_path .. "jdtls/config_linux",
    "-data",
    workspace_dir,
  },
  root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw" }),
  settings = {
    java = {},
  },
  init_options = {
    bundles = {},
  },
}
require("jdtls").start_or_attach(config)
