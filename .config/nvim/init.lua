--[[
	PLUGINS (vim-plug)
]]--

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

-- Telescope
-- XXX: Telescope live_grep requires "ripgrep" to be installed
-- https://github.com/BurntSushi/ripgrep
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim", { ["branch"] = "0.1.x" })

vim.call("plug#end")

--[[
	OPTIONS
]]--

--vim.cmd "colorscheme desert"
vim.cmd "colorscheme industry"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.ic = true
vim.opt.termguicolors = true

vim.opt.title = true
vim.cmd "set titlestring=%Y\\ %t%(\\ %M%)%(\\ (%{expand(\\\"%:~:.:h\\\")})%)%(\\ %a%)"

local map = vim.keymap.set

--[[
	KEYMAPS
]]--

-- Insert mode maps
map("i", "<C-Tab>", "<Esc>gti")
map("i", "<C-S-Tab>", "<Esc>gTi")

map("i", "<C-s>", "<Esc>:w!<CR>a")
map("i", "<C-q>", "<Esc>:q<CR>")
map("i", "<C-d>", "<Esc>Vyp$i")
map("i", "<C-x>", "<Esc>Vda")
map("i", "<C-t>", "<Esc>:tabnew ")

-- Same as above, just for normal mode
map("n", "<Tab>", "gt")
map("n", "<S-Tab>", "gT")

map("n", "<C-s>", ":w!<CR>")
map("n", "<C-q>", ":q<CR>")
map("n", "<C-d>", "Vyp$")
map("n", "<C-x>", "Vd")
map("n", "<C-t>", ":tabnew ")

map("n", "<C-Up>", vim.diagnostic.goto_next)
map("n", "<C-j>", vim.diagnostic.goto_next)

map("n", "<C-Down>", vim.diagnostic.goto_prev)
map("n", "<C-k>", vim.diagnostic.goto_prev)

map("n", "?", vim.lsp.buf.hover)

vim.g.mapleader = " "

--[[
	PLUGIN stuff
]]--
local builtin = require("telescope.builtin")
map("n", "<leader>f", builtin.find_files, {})
map("n", "<leader>g", builtin.live_grep, {})
map("n", "<leader>b", builtin.buffers, {})
map("n", "<leader>h", builtin.help_tags, {})

require("telescope").setup({
	defaults = {
		layout_config = {
			horizontal = {width = 0.99}
		}
	}
})

local lsp_zero = require("lsp-zero")
lsp_zero.on_attach(function(client, bufnr)
		lsp_zero.default_keymaps({buffer = bufnr})
end)

require("mason").setup({})

--[[
	LSP SETUP
]]--
local lspconfig = require("lspconfig")
lspconfig.gopls.setup({})    -- Go
lspconfig.clangd.setup({})   -- C/C++
lspconfig.ocamllsp.setup({}) -- OCaml
lspconfig.lua_ls.setup({})   -- Lua
lspconfig.jdtls.setup({})    -- Java (Requires Java 17+ to be used, tldr: `sudo update-alternatives --config java`)

-- Tab for autocomplete key map
local cmp = require("cmp")
cmp.setup({
	mapping = {
		["<Tab>"] = cmp.mapping.confirm({select = true}),
	}
})
