return {
  {
    "folke/ts-comments.nvim",
    opts = {
      lang = {
        nu = {
          "# %s"
        },
        tf = {
          "# %s"
        },
        rust = {
          "// %s",
          "/* %s */",
          macro_definition = "// %s",
          attribute_item = "// %s",
          attribute = "// %s"
        }
      },
    },
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },
  {
    "folke/todo-comments.nvim",
    optional = true,
    keys = {
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
      {
        "<leader>sT",
        function() Snacks.picker.todo_comments({ keywords = { "TODO" } }) end,
        desc = "Todo"
      },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      picker = {
        enabled = true,
        sources = {
          -- explorer = {
          --   layout = { preset = "", preview = false },
          -- },
          files = {
            actions = {
              up = {
                action = function(picker, selected)
                  local parent = vim.loop.fs_realpath(picker:cwd() .. '/..')
                  picker:set_cwd(parent)
                  picker:find()
                end,
              },
            },
            win = {
              input = {
                keys = {
                  ["<c-h>"] = { "up", mode = { "n", "i" }, desc = "Go up directory" },
                }
              }
            }
          }
        }
      },
      -- bigfile = { enabled = false },
      -- dashboard = { enabled = false },
      -- indent = { enabled = false },
      -- input = { enabled = false },
      -- notifier = { enabled = false },
      -- quickfile = { enabled = false },
      -- scroll = { enabled = false },
      -- statuscolumn = { enabled = false },
      -- words = { enabled = false },
    },
    keys = {
      -- { "<leader>z",       function() Snacks.zen() end,                                          desc = "Toggle Zen Mode" },
      { "<C-f>",           function() Snacks.zen.zoom() end,                                     desc = "Toggle Zoom" },
      { "<C-c>",           function() Snacks.zen({ toggles = { dim = false } }) end,             desc = "Toggle Zen" },
      { "<leader>fb",      function() Snacks.picker.buffers() end,                               desc = "Buffers" },
      { "<leader>fl",      function() Snacks.picker.grep() end,                                  desc = "Grep" },
      { "<leader>fc",      function() Snacks.picker.command_history() end,                       desc = "Command History" },
      { "<leader>e",       function() Snacks.picker.files({ cwd = vim.fn.expand('%:p:h') }) end, desc = "Current Dir Files" },
      { "<leader>fe",      function() Snacks.picker.files() end,                                 desc = "Files" },
      { "<leader>fa",      function() Snacks.picker.explorer() end,                              desc = "Explorer" },
      { "<leader><space>", function() Snacks.picker.files() end,                                 desc = "Find Files" },
      -- find
      -- { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      -- { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,
      --   desc = "Find Config File" },
      -- { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg",      function() Snacks.picker.git_files() end,                             desc = "Find Git Files" },
      { "<leader>fr",      function() Snacks.picker.recent() end,                                desc = "Recent" },
      -- git
      { "<leader>gl",      function() Snacks.picker.git_log() end,                               desc = "Git Log" },
      { "<leader>gs",      function() Snacks.picker.git_status() end,                            desc = "Git Status" },
      -- Grep
      { "<leader>fi",      function() Snacks.picker.lines() end,                                 desc = "Buffer Lines" },
      { "<leader>sB",      function() Snacks.picker.grep_buffers() end,                          desc = "Grep Open Buffers" },
      { "<leader>sg",      function() Snacks.picker.grep() end,                                  desc = "Grep" },
      -- { "<C-j>",           function() Snacks.zen() end,                                          desc = "Zen" },
      {
        "<leader>sw",
        function() Snacks.picker.grep_word() end,
        desc = "Visual selection or word",
        mode = { "n", "x" }
      },
      -- search
      -- { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      -- { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      -- { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      -- { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end,          desc = "Diagnostics" },
      -- { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      -- { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      -- { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      -- { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      -- { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      -- { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      -- { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      -- { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>sq", function() Snacks.picker.qflist() end,               desc = "Quickfix List" },
      { "<leader>uC", function() Snacks.picker.colorschemes() end,         desc = "Colorschemes" },
      -- { "<leader>qp", function() Snacks.picker.projects() end, desc = "Projects" },
      -- LSP
      { "gd",         function() Snacks.picker.lsp_definitions() end,      desc = "Goto Definition" },
      { "gr",         function() Snacks.picker.lsp_references() end,       nowait = true,                  desc = "References" },
      { "gI",         function() Snacks.picker.lsp_implementations() end,  desc = "Goto Implementation" },
      { "gy",         function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end,          desc = "LSP Symbols" },
    },
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    -- optional = true,
    keys = {
      {
        "<leader>fd",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>fD",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
    },

    -- specs = {
    --   "folke/snacks.nvim",
    --   opts = function(_, opts)
    --     return vim.tbl_deep_extend("force", opts or {}, {
    --       picker = {
    --         actions = require("trouble.sources.snacks").actions,
    --         win = {
    --           input = {
    --             keys = {
    --               ["<c-t>"] = {
    --                 "trouble_open",
    --                 mode = { "n", "i" },
    --               },
    --             },
    --           },
    --         },
    --       },
    --     })
    --   end,
    -- },
  }
}
