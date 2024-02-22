vim.cmd "colorscheme desert"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.ic = true

vim.lsp.set_log_level("debug")

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

local Plug = vim.fn["plug#"]

vim.call("plug#begin")

-- LSP Support
Plug("neovim/nvim-lspconfig")
-- Autocompletion
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("L3MON4D3/LuaSnip")

Plug("VonHeikemen/lsp-zero.nvim", {["branch"] = "v3.x"})

-- Mason
Plug("williamboman/mason.nvim")

-- Mason-lspconfig
Plug("williamboman/mason-lspconfig.nvim")

vim.call("plug#end")

local lsp_zero = require("lsp-zero")
lsp_zero.on_attach(function(client, bufnr)
		lsp_zero.default_keymaps({buffer = bufnr})
end)

require("lspconfig").gopls.setup({})
require("mason").setup()
