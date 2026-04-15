return {
  {
    'dmtrKovalenko/fff.nvim',
    -- build = function()
    --   -- this will download prebuild binary or try to use existing rustup toolchain to build from source
    --   -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
    --   require("fff.download").download_or_build_binary()
    -- end,
    -- if you are using nixos
    build = "nix run .#release",
    -- No need to lazy-load with lazy.nvim.
    -- This plugin initializes itself lazily.
    opts = {
      keymaps = {
        move_up = { '<Up>', '<C-k>' },
        move_down = { '<Down>', '<C-j>' },
      },
    },
    lazy = false,
    keys = {
      {
        "fe", -- try it if you didn't it is a banger keybinding for a picker
        function() require('fff').find_files() end,
        desc = 'FFFind files',
      },
      {
        "fl",
        function() require('fff').live_grep() end,
        desc = 'LiFFFe grep',
      },
      {
        "fk",
        function() require('fff').live_grep({
          grep = {
            modes = { 'fuzzy', 'plain' }
          }
        }) end,
        desc = 'Live fffuzy grep',
      },
      {
        "fw",
        function() require('fff').live_grep({ query = vim.fn.expand("<cword>") }) end,
        desc = 'Search current word',
      },
    }
  }
  -- {
  --   "A7Lavinraj/fyler.nvim",
  --   dependencies = { "echasnovski/mini.icons" },
  --   branch = "stable",
  --   opts = {} -- check the default options in the README.md
  -- },
  -- {
  --   'dmtrKovalenko/fff.nvim',
  --   build = function(plugin)
  --     local f = io.open("/etc/NIXOS", "r")
  --     if f then
  --       f:close()
  --       vim.fn.system({ "nix", "run", ".#release" }, { cwd = plugin.dir })
  --     else
  --       require("fff.download").download_or_build_binary()
  --     end
  --   end,
  --   lazy = false,
  --   keys = {
  --     {
  --       "<leader.fj", -- try it if you didn't it is a banger keybinding for a picker
  --       function() require('fff').find_files() end,
  --       desc = 'FFFind files',
  --     },
  --     {
  --       "ff", -- try it if you didn't it is a banger keybinding for a picker
  --       function() require('fff').find_files() end,
  --       desc = 'FFFind files',
  --     },
  --     {
  --       "fg",
  --       function() require('fff').live_grep() end,
  --       desc = 'LiFFFe grep',
  --     },
  --     {
  --       "fz",
  --       function() require('fff').live_grep({
  --         grep = {
  --           modes = { 'fuzzy', 'plain' }
  --         }
  --       }) end,
  --       desc = 'Live fffuzy grep',
  --     },
  --     {
  --       "fc",
  --       function() require('fff').live_grep({ query = vim.fn.expand("<cword>") }) end,
  --       desc = 'Search current word',
  --     },
  --   }
  -- }
}
