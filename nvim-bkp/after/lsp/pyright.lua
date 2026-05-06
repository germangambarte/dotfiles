return {
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        useLibraryCodeForTypes = true,
        diagnosticSeverityOverrides = {
          reportUnusedVariable = "warning",
        },
        typeCheckingMode = "on", -- Set type-checking mode to off
        diagnosticMode = "on", -- Disable diagnostics entirely
      },
      -- analysis = {
      --   ignore = { "*" },
      -- },
    },
  },
}
