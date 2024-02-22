vim.cmd "colorscheme desert"

vim.opt.tabstop = 4
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.ic = true

local map = vim.keymap.set

-- Insert mode maps
map("i", "<C-s>", "<Esc>:w!<CR>a")
map("i", "<C-q>", "<Esc>:q<CR>")
map("i", "<C-d>", "<Esc>Vyp$i")
map("i", "<C-x>", "<Esc>Vda")
map("i", "<C-t>", "<Esc>:tabnew ")

-- Same as above, just for normal mode
map("n", "<C-s>", ":w!<CR>")
map("n", "<C-q>", ":q<CR>")
map("n", "<C-d>", "Vyp$")
map("n", "<C-x>", "Vd")
map("n", "<C-t>", ":tabnew ")
