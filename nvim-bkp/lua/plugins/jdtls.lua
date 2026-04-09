local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local mason_path = "/home/ger/.local/share/nvim/mason/packages/"
local lombok_path = mason_path .. "jdtls/lombok.jar"
local workspace_dir = "/home/ger/dev/java/" .. project_name
return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = {
      { "mfussenegger/nvim-dap" },
      { "rcarriga/nvim-dap-ui" },
    },
    config = function()
      vim.lsp.config("jdtls", {

        name = "jdtls",

        cmd = {
          "/home/ger/.sdkman/candidates/java/current/bin/java",
          "-javaagent:" .. lombok_path,
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
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
        root_dir = vim.fs.root(0, {
          ".git",
          "mvnw",
          "gradlew",
          "pom.xml",
          "build.gradle",
        }),
        settings = {
          java = {
            -- ADD THIS SECTION
            compiler = {
              annotationProcessing = {
                enabled = true,
              },
            },
            -- END OF ADDED SECTION
            eclipse = { downloadSources = true },
            configuration = { updateBuildConfiguration = "interactive" },
            maven = { downloadSources = true },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true },
          },
        },
        init_options = {
          bundles = {},
          extendedClientCapabilities = {
            classFileContentsSupport = true,
          },
        },
      })
      vim.lsp.enable("jdtls")
      -- Configuración de DAP
      local dap = require("dap")
      dap.configurations.java = {
        {
          javaExec = "java",
          request = "launch",
          type = "java",
        },
        {
          type = "java",
          request = "attach",
          name = "Debug (Attach) - Remote",
          hostName = "127.0.0.1",
          port = 5005,
        },
      }
    end,
  },
  {
    "elmcgill/springboot-nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-jdtls",
    },
    config = function()
      local springboot_nvim = require("springboot-nvim")
      vim.keymap.set("n", "<leader>Jr", springboot_nvim.boot_run, { desc = "Spring Boot Run Project" })
      vim.keymap.set("n", "<leader>Jc", springboot_nvim.generate_class, { desc = "Java Create Class" })
      vim.keymap.set("n", "<leader>Ji", springboot_nvim.generate_interface, { desc = "Java Create Interface" })
      vim.keymap.set("n", "<leader>Je", springboot_nvim.generate_enum, { desc = "Java Create Enum" })
      springboot_nvim.setup({})
    end,
  },
}
