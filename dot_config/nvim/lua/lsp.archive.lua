local opts = { noremap = true, silent = true }
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', '<space>f', vim.lsp.buf.format, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  -- vim.keymap.set('n', 'gd', function() require('telescope.builtin').lsp_definitions() end, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  -- vim.keymap.set('n', 'gr', function() require('telescope.builtin').lsp_references() end, bufopts)
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, bufopts)
  vim.keymap.set({ 'n', 'v' }, '<space>c', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
  -- if client.resolved_capabilities.document_formatting then
  --   vim.cmd("au BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
  -- end

  -- require("aerial").on_attach(client, bufnr)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = false,
  -- update_in_insert = false,
  update_in_insert = true,
  severity_sort = true,
  float = {
    border = "single"
  },
})


-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches

local servers = { 'ts_ls', 'wgsl_analyzer', 'nil_ls', 'gopls', 'templ', 'zls', 'taplo', 'elixirls', 'gleam', 'ruff' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end


require("lspconfig").rescriptls.setup({
  on_attach = function(client, bufnr)
    -- Optional: Add keybindings or other LSP-related setup here
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  end,
  filetypes = { "rescript" },
  root_dir = require("lspconfig").util.root_pattern("bsconfig.json"),
})


-- require("lspconfig").bacon_ls.setup({
--     autostart=true,
--     settings = {
--         -- locationsFile = ".locations",
--         -- waitTimeSeconds = 5
--     },
-- })

require('lspconfig').lua_ls.setup({
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
-- require'lspconfig'.rust_analyzer.setup{
--     on_attach = on_attach,
--     capabilities = capabilities,
--     settings = {
--         ["rust-analyzer"] = {
--             files = {
--                 excludeDirs = { "node_modules" },
--             },
--         },
--     },
-- }

require("lspconfig").tailwindcss.setup({
  filetypes = { 'templ', 'ts', 'js', 'rs' },
  init_options = {
    userLanguages = {
      templ = "html",
      rs = "html"
    }
  }
})
-- require'lspconfig'.nil_ls.setup{
--   -- root_dir = function(fname)
--   --   return os.getenv( "HOME" ) .. "/.local/share/nvim/mason/bin"
--   -- end,
--   cmd = { 'nil' },
--   on_attach = on_attach,
--   capabilities = capabilities,
-- }
require("mason").setup({
  ui = {
    keymaps = {
      apply_language_filter = "<C-s>",
    },
  },
})

require("mason-lspconfig").setup()


-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
}

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettierd,
  },
})

require "fidget".setup {}
