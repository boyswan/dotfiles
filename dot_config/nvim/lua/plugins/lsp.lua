return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "j-hui/fidget.nvim",
    },
    config = function()
      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
      vim.keymap.set('n', '<space>f', vim.lsp.buf.format, opts)

      -- LSP settings
      local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, bufopts)
        vim.keymap.set({ 'n', 'v' }, '<space>c', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
      end

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = false,
        update_in_insert = true,
        severity_sort = true,
        float = {
          border = "single"
        },
      })

      -- Server configurations
      local servers = {
        'gopls',
        'zls',
        'taplo',
        'terraformls',
        'nushell',
        'buf_ls'
      }
      for _, lsp in pairs(servers) do
        vim.lsp.config(lsp, {
          on_attach = on_attach,
          capabilities = capabilities,
        })

        vim.lsp.enable({ lsp })
      end

      vim.lsp.config('ruff', {
        init_options = {
          settings = {
            -- Ruff language server settings go here
          }
        }
      })

      vim.lsp.enable('ruff')

      vim.lsp.config('pyright', {
        settings = {
          pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              -- Ignore all files for analysis to exclusively use Ruff for linting
              ignore = { '*' },
            },
          },
        }
      })

      vim.lsp.enable('pyright')

      vim.lsp.config('vtsls', {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          vtsls = {
            autoUseWorkspaceTsdk = true,
            enableMeasurements = false,
            experimental = {
              completion = {
                enableServerSideFuzzyMatch = true,
                entriesLimit = 100,
              },
            },
            tsserver = {
              maxTsServerMemory = 8192,
              watchOptions = {
                watchFile = "useFsEvents",
                watchDirectory = "useFsEvents",
                excludeDirectories = {
                  "**/node_modules",
                  "**/.git",
                  "**/dist",
                  "**/gen",
                },
              },
            },
          },
          typescript = {
            preferences = {
              includePackageJsonAutoImports = "off",
              autoImportFileExcludePatterns = { "**/node_modules/**" }
            },
            updateImportsOnFileMove = { enabled = "always" },
            inlayHints = {
              parameterNames = { enabled = "none" },
              parameterTypes = { enabled = "false" },
              variableTypes = { enabled = "false" },
              propertyDeclarationTypes = { enabled = "false" },
              functionLikeReturnTypes = { enabled = "false" },
              enumMemberValues = { enabled = "false" },
            },
          },
        },
      })

      vim.lsp.enable({ 'vtsls' })


      vim.lsp.config("lua_ls", {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            }
          }
        }
      })

      vim.lsp.enable({ "lua_ls" })

      -- /Users/jack/Desktop/expert_darwin_arm64
      -- require('lspconfig').lexical.setup {
      --   cmd = { vim.fn.expand("~/Desktop/expert_darwin_arm64") },
      --   root_dir = function(fname)
      --     return require('lspconfig').util.root_pattern("mix.exs", ".git")(fname) or vim.loop.cwd()
      --   end,
      --   filetypes = { "elixir", "eelixir", "heex" },
      --   -- optional settings
      --   settings = {}
      -- }

      vim.lsp.config("elixirls", {
        cmd = { vim.fn.expand("~/.local/share/nvim/mason/packages/elixir-ls/language_server.sh") },
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          elixirLS = {
            dialyzerEnabled = false,
            fetchDeps = false,
          }
        }
      })

      vim.lsp.enable({ "elixirls" })
    end
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^5",
  },
  {
    "williamboman/mason.nvim",
    version = "1.10.0",
    config = function()
      require("mason").setup({
        ui = {
          keymaps = {
            apply_language_filter = "<C-s>",
          },
        },
      })
    end
  },

  {
    "williamboman/mason-lspconfig.nvim",
    version = "1.29.0",
    config = function()
      require("mason-lspconfig").setup()
    end
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup {
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        }, {
          { name = 'buffer' },
        })
      }
    end
  },

  {
    "nvimtools/none-ls.nvim",
  },

  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup {}
    end
  },
  "nvim-lua/lsp-status.nvim",
  -- {
  --   "pmizio/typescript-tools.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   opts = {},
  -- }
}
