local function keymap(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

keymap("n", "<leader>y", "\"_dP")
keymap("n", "<leader>q", "<cmd>:bd<cr>")
keymap("n", "<leader>w", "<C-w>c")
keymap("n", "<leader>o", "<cmd>vsp<cr><cr>")
keymap("n", "<leader>i", "<cmd>sp<cr><cr>")

-- Window navigation (works in normal mode)
keymap("n", "<C-h>", "<C-W><C-h>")
keymap("n", "<C-l>", "<C-W><C-l>")
keymap("n", "<C-j>", "<C-W><C-j>")
keymap("n", "<C-k>", "<C-W><C-k>")

-- Window navigation from terminal mode (escape to normal mode first, then navigate)
keymap("t", "<C-h>", "<C-\\><C-n><C-W><C-h>")
keymap("t", "<C-l>", "<C-\\><C-n><C-W><C-l>")
keymap("t", "<C-j>", "<C-\\><C-n><C-W><C-j>")
keymap("t", "<C-k>", "<C-\\><C-n><C-W><C-k>")

vim.cmd [[nnoremap <silent> <leader>k <cmd>lua vim.diagnostic.open_float()<CR>]]

local function get_path(absolute)
  if absolute then
    local file = vim.fn.expand("%:p")
    local home = vim.fn.expand("$HOME")
    return file:gsub("^" .. vim.pesc(home), "~")
  end
  return vim.fn.expand("%")
end

local function yank_path(absolute)
  vim.fn.setreg("+", get_path(absolute))
end

local function yank_path_with_lines(absolute)
  local file = get_path(absolute)
  local line_start = vim.fn.line("v")
  local line_end = vim.fn.line(".")
  if line_start > line_end then
    line_start, line_end = line_end, line_start
  end
  vim.fn.setreg("+", file .. ":" .. line_start .. "-" .. line_end)
end

vim.keymap.set('n', '<leader>yp', function() yank_path(false) end)
vim.keymap.set('v', '<leader>yp', function() yank_path_with_lines(false) end)
vim.keymap.set('n', '<leader>yP', function() yank_path(true) end)
vim.keymap.set('v', '<leader>yP', function() yank_path_with_lines(true) end)
