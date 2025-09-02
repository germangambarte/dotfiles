-- Function to get TypeScript SDK path (prefer local, fallback to global)
local function get_typescript_sdk()
  local local_sdk = vim.fn.getcwd() .. '/node_modules/typescript/lib'
  if vim.fn.isdirectory(local_sdk) == 1 then
    return local_sdk
  end

  -- Try global installation
  local global_root = vim.fn.system('npm root -g'):gsub('\n', ''):gsub('\r', '')
  local global_sdk = global_root .. '/typescript/lib'
  if vim.fn.isdirectory(global_sdk) == 1 then
    return global_sdk
  end

  -- If both fail, return nil to let vue-language-server find it automatically
  return nil
end
return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      { 'saghen/blink.cmp' },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          -- map('gd', require('fzf-lua').lsp_definitions, '[G]oto [D]efinition')
          -- map('gr', require('fzf-lua').lsp_references, '[G]oto [R]eferences')
          -- map('gI', require('fzf-lua').lsp_implementations, '[G]oto [I]mplementation')
          -- map('gt', require('fzf-lua').lsp_typedefs, 'Type [D]efinition')
          -- map('gO', require('fzf-lua').lsp_document_symbols, '[D]ocument [S]ymbols')
          -- map('gW', require('fzf-lua').lsp_live_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>cr', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            -- [vim.diagnostic.severity.ERROR] = '󰅚 ',
            -- [vim.diagnostic.severity.WARN] = '󰀪 ',
            -- [vim.diagnostic.severity.INFO] = '󰋽 ',
            -- [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        },
        virtual_text = {
          source = 'if_many',
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
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())

      local servers = {
        clangd = {},
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = false,
                functionTypeParameters = false,
                parameterNames = false,
                rangeVariableTypes = false,
              },
              analyses = {
                -- NOTE: To temporarily enable disabled analyzers for specific debugging:
                -- :lua vim.lsp.stop_client(vim.lsp.get_clients({name = "gopls"}))
                -- Then edit this file and save, LSP will restart with new settings

                -- Essential analyzers for catching common issues
                nilness = true, -- Check for nil pointer dereferences
                unusedparams = true, -- Find unused function parameters
                unusedwrite = true, -- Find unused writes to variables
                useany = true, -- Suggest using 'any' instead of 'interface{}'
                unreachable = true, -- Find unreachable code
                unusedresult = true, -- Check for unused results of calls to certain functions

                -- Helpful but not critical (enable as needed)
                simplifyslice = true, -- Simplify slice expressions
                simplifyrange = true, -- Simplify range loops
                simplifycompositelit = true, -- Simplify composite literals

                -- Performance-intensive analyzers (disabled for better performance)
                shadow = false, -- Check for shadowed variables (can be slow)
                printf = false, -- Check printf-style functions (can be slow)
                structtag = false, -- Check struct tags (can be slow)
                -- fieldalignment = false,  -- Check struct field alignment (very slow)
                -- unusedvariable = false,  -- Can be slow on large codebases

                -- Less commonly needed analyzers (disabled)
                modernize = false,
                stylecheck = false,
                appends = false,
                asmdecl = false,
                assign = false,
                atomic = false,
                atomicalign = false,
                bools = false,
                buildtag = false,
                cgocall = false,
                composite = false,
                composites = false,
                contextcheck = false,
                copylocks = false,
                deba = false,
                deepequalerrors = false,
                defers = false,
                deprecated = false,
                directive = false,
                embed = false,
                errorsas = false,
                fillreturns = false,
                framepointer = false,
                gofix = false,
                hostport = false,
                httpresponse = false,
                ifaceassert = false,
                infertypeargs = false,
                loopclosure = false,
                lostcancel = false,
                nilfunc = false,
                nonewvars = false,
                noresultvalues = false,
                shift = false,
                sigchanyzer = false,
                slog = false,
                sortslice = false,
                stdmethods = false,
                stdversion = false,
                stringintconv = false,
                testinggoroutine = false,
                tests = false,
                timeformat = false,
                unmarshal = false,
                unsafeptr = false,
                unusedfunc = false,
                unusedvariable = false,
                waitgroup = false,
                yield = false,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
              semanticTokens = false,
            },
          },
        },
        cssls = {
          settings = {
            css = { validate = true },
            scss = { validate = true },
            less = { validate = true },
          },
        },
        tailwindcss = {
          settings = {
            tailwindCSS = {
              emmetCompletions = true,
              validate = true,
              lint = {
                cssConflict = 'warning',
                invalidApply = 'error',
                invalidScreen = 'error',
                invalidVariant = 'error',
                invalidConfigPath = 'error',
                invalidTailwindDirective = 'error',
                recommendedVariantOrder = 'warning',
              },
              -- Tailwind class attributes configuration
              classAttributes = { 'class', 'className', 'classList', 'ngClass', ':class' },

              -- Experimental regex patterns to detect Tailwind classes in various syntaxes
              experimental = {
                classRegex = {
                  -- tw`...` or tw("...")
                  'tw`([^`]*)`',
                  'tw\\(([^)]*)\\)',

                  -- @apply directive inside SCSS / CSS
                  '@apply\\s+([^;]*)',

                  -- class and className attributes (HTML, JSX, Vue, Blade with :class)
                  'class="([^"]*)"',
                  'className="([^"]*)"',
                  ':class="([^"]*)"',

                  -- Laravel @class directive e.g. @class([ ... ])
                  '@class\\(([^)]*)\\)',
                },
              },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
              },
            },
          },
        },
        vue_ls = {
          init_options = {
            vue = {
              hybridMode = false, -- Disable for inlay hints support
            },
            -- Only set typescript config if we have a valid TypeScript installation
            typescript = get_typescript_sdk() and {
              tsdk = get_typescript_sdk(),
            } or nil,
          },
        },
        ts_ls = {
          settings = {
            typescript = {
              -- Remove tsdk setting to allow auto-detection
              tsserver = {
                useSyntaxServer = false,
              },
              inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              -- Remove tsdk setting to allow auto-detection
            },
          },
        },
        ruff = {
          init_options = {
            settings = {
              logLevel = 'debug',
            },
          },
        },
        html = {
          init_options = { provideFormatter = true },
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                disable = { 'missing-fields' },
                globals = {
                  'vim',
                  'Snacks',
                },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = 'Disable',
                semicolon = 'Disable',
                arrayIndex = 'Disable',
              },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {},
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
  },
}
