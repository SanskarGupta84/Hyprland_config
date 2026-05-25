-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.keymap.set("n", "<leader>uw", function()
  dofile(vim.fn.expand("~/.cache/wal/colors-wal.vim"))
  vim.cmd.colorscheme("neopywal")
end, { desc = "Reload pywal colors" })

vim.keymap.set(
  "n",
  "<leader>tf",
  [[:s/\v(true|false)/\=submatch(1) == 'true' ? 'false' : 'true'/<CR>]],
  { desc = "Toggle true/false" }
)
