return {
  -- {
  --   "A7Lavinraj/fyler.nvim",
  --   dependencies = { "echasnovski/mini.icons" },
  --   branch = "stable",
  --   opts = {} -- check the default options in the README.md
  -- },
  {
    "dmtrKovalenko/fff.nvim",
    build = "cargo build --release",
    -- or if you are using nixos
    -- build = "nix run .#release",
    opts = {
      keymaps = {
        move_up = { '<Up>', '<C-p>', '<C-k>' },
        move_down = { '<Down>', '<C-n>', '<C-j>' },
      },
    },
    keys = {
      {
        "ff",                         -- try it if you didn't it is a banger keybinding for a picker
        function()
          require("fff").find_files() -- or find_in_git_root() if you only want git files
        end,
        desc = "Open file picker",
      },
    },
  }
}
