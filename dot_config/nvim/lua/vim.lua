vim.opt.relativenumber = true
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.cmdheight = 0
vim.opt.showmode = false
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.clipboard = "unnamedplus"
vim.opt.shortmess:append("c")
vim.opt.laststatus = 3
vim.opt.formatoptions:remove("cro")
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true

vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd([[
command! Q q
command! X x
command! W w
]])

-- Cursorline settings
vim.opt.cursorline = true
vim.cmd([[
hi cursorline cterm=none term=none
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

autocmd ModeChanged * lua vim.schedule(function() vim.cmd('redraw') end)
]])

-- Filetype settings
vim.cmd("au BufNewFile,BufRead *.wgsl set filetype=wgsl")

-- Key mappings
vim.api.nvim_set_keymap("", "<PageUp>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "<PageDown>", "<Nop>", { noremap = true, silent = true })

vim.api.nvim_set_hl(0, 'LeapLabelPrimary', { bold = true, nocombine = true })
vim.keymap.set('n', '<leader>yp', ':let @+ = expand("%")<CR>')

vim.cmd [[hi TSParameter gui=NONE]]
vim.cmd [[hi TSNamespace gui=NONE]]
vim.cmd [[hi TSTagAttribute gui=NONE]]
vim.cmd [[hi TSParameter gui=NONE]]
vim.cmd [[hi TSConditional gui=NONE]]

vim.cmd [[sign define DiagnosticSignError texthl=DiagnosticSignError text=]]
vim.cmd [[sign define DiagnosticSignWarn texthl=DiagnosticSignWarn text=]]
vim.cmd [[sign define DiagnosticSignHint texthl=DiagnosticSignHint text=]]
vim.cmd [[sign define DiagnosticSignInfo texthl=DiagnosticSignInfo text=]]
