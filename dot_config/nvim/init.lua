require("vim")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "MunifTanjim/nui.nvim",
  "NoahTheDuke/vim-just",
  "jose-elias-alvarez/null-ls.nvim",
  "junegunn/fzf",
  "kevinhwang91/nvim-bqf",
  "kyazdani42/nvim-web-devicons",
  "lewis6991/gitsigns.nvim",
  "nvim-lua/plenary.nvim",
  "romainl/vim-cool",
  'isobit/vim-caddyfile',
  {
    'ggandor/leap.nvim',
    config = function()
      vim.keymap.set({ 'n', 'v' }, 'gw', '<Plug>(leap)')
    end
  },
  require("./plugins.lualine"),
  require("./plugins.folke"),
  require("./plugins.mini"),
  require("./plugins.treesitter"),
  require("./plugins.lsp"),
  require("./plugins.colorscheme"),
  require("./plugins.navigation"),
})

require("keymaps")

vim.filetype.add({
  extension = {
    nomad = "hcl",
    prompt = "yaml",
    gotmpl = 'gotmpl',
  },
})
