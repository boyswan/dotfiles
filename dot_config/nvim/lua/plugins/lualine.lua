local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "Recording @" .. recording_register
  end
end

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local function ins_left(opts, component)
  table.insert(opts.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(opts, component)
  table.insert(opts.sections.lualine_x, component)
end

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      { "navarasu/onedark.nvim", lazy = false },
    },
    opts = {
      options = {
        globalstatus = true,
        -- Disable sections and component separators
        component_separators = '',
        section_separators = '',
        theme = {},
      },
      sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
      },
      inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
    },
    config = function(_, opts)

      local colors = require('onedark.colors')
      -- local colors = {}

      opts.options.theme.normal = { c = { bg = "#202020", fg = colors.fg } }
      opts.options.theme.inactive = { c = { bg = "#202020", fg = colors.fg } }

      ins_left(opts, {
        --  mode component
        function()
          -- return '● ' .. vim.fn.mode()
          return '●'
        end,
        'mode',
        fmt = string.lower,
        color = function()
          -- auto change color according to neovims mode
          local mode_color = {
            n = colors.blue,
            i = colors.green,
            v = colors.purple,
            [''] = colors.orange,
            V = colors.purple,
            c = colors.magenta,
            no = colors.red,
            s = colors.orange,
            S = colors.orange,
            [''] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.red,
            ce = colors.red,
            r = colors.cyan,
            rm = colors.cyan,
            ['r?'] = colors.cyan,
            ['!'] = colors.red,
            t = colors.red,
          }
          return { bg = "#313131", fg = mode_color[vim.fn.mode()], gui = "bold" }
        end,
        padding = { left = 1, right = 1 },
      })

      -- ins_left {
      --   -- filesize component
      --   'filesize',
      --   cond = conditions.buffer_not_empty,
      -- }

      ins_left(opts, {
        'filename',
        path = 1,
        cond = conditions.buffer_not_empty,
      })

      ins_left(opts, {
        'branch',
        icon = '',
        color = { fg = "#747474" },
      })

      ins_left(opts, {
        'diff',
        symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
        diff_color = {
          added = { fg = colors.green },
          modified = { fg = colors.orange },
          removed = { fg = colors.red },
        },
        cond = conditions.hide_in_width,
      })

      ins_left(opts, {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ' },
        diagnostics_color = {
          color_error = { fg = colors.red },
          color_warn = { fg = colors.yellow },
          color_info = { fg = colors.cyan },
        },
      })

      ins_left(opts, {
        "macro-recording",
        fmt = show_macro_recording,
        color = { fg = colors.red },
      })
      -- Insert mid section. You can make any number of sections in neovim :)
      -- for lualine it's any number greater then 2

      -- ins_left {
      --   function()
      --     return '%='
      --   end,
      -- }


      -- Add components to right sections
      ins_right(opts, {
        'o:encoding', -- option component same as &encoding in viml
        cond = conditions.hide_in_width,
        color = { fg = colors.green },
      })

      ins_right(opts, {
        -- Lsp server name .
        function()
          local msg = '-'
          local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
          local clients = vim.lsp.get_active_clients()
          if next(clients) == nil then
            return msg
          end
          for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
              return client.name
            end
          end
          return msg
        end,
        icon = ' ',
        color = { fg = colors.purple },
      })

      ins_right(opts, {
        'fileformat',
        icons_enabled = true, -- I think icons are cool but Eviline doesn't have them. sigh
        color = { fg = colors.blue },
      })


      ins_right(opts, { 'location' })

      ins_right(opts, { 'progress', color = { fg = colors.fg } })

      require("lualine").setup(opts)

    end,

  }
}
