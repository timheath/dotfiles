-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", ";", ":", { desc = "Command-line" })

-- Scroll viewport without moving cursor (overrides LazyVim window nav on C-j/C-k)
vim.keymap.set("n", "<C-j>", "<C-e>", { desc = "Scroll down" })
vim.keymap.set("n", "<C-k>", "<C-y>", { desc = "Scroll up" })
