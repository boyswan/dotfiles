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
