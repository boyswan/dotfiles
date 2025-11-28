return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    version = "v0.1.0", -- Pin to the old version
    priority = 1000,
    config = function()
      require('onedark').setup {
        style = 'warmer'
      }
      require('onedark').load()
    end
  },

  -- { 'datsfilipe/vesper.nvim' },
  -- { "vague-theme/vague.nvim", },
  -- { "jpwol/thorn.nvim", },
  -- { "ellisonleao/gruvbox.nvim" },
  -- { "catppuccin/nvim",             name = "catppuccin",   priority = 1000 },
  -- { 'projekt0n/github-nvim-theme', name = 'github-theme', priority = 1000 },
  -- { "EdenEast/nightfox.nvim" },
  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  --   config = function()
  --     require('rose-pine').setup {
  --       styles = {
  --         bold = true,
  --         italic = false,
  --         transparency = true,
  --       },
  --     }
  --     -- vim.cmd 'colorscheme rose-pine'
  --   end,
  -- },
  -- { "neanias/everforest-nvim",      name = "everforest" },
  -- { "tiagovla/tokyodark.nvim", },
  -- { "PyGamer0/darc.nvim",           dependencies = "rktjmp/lush.nvim", },
  -- { "zenbones-theme/zenbones.nvim", dependencies = "rktjmp/lush.nvim", },
  -- { "idr4n/github-monochrome.nvim", },
  -- { "blazkowolf/gruber-darker.nvim" },
  -- { 'AlexvZyl/nordic.nvim', }
  -- { 'ribru17/bamboo.nvim', },
}
