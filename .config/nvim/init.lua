--[[
	PLUGINS (vim-plug)
	Installing vim-plug: https://github.com/junegunn/vim-plug?tab=readme-ov-file#unix-linux
]] --
local Plug = vim.fn["plug#"]
vim.call("plug#begin")
--Plug("/home/kivah/main/projects/fen.nvim")
Plug("kivattt/fen.nvim")

Plug("nvim-lua/plenary.nvim") -- Some utility library many Neovim lua plugins use
Plug("neovim/nvim-lspconfig") -- LSP Support
-- Autocompletion
Plug("hrsh7th/nvim-cmp")
Plug("hrsh7th/cmp-nvim-lsp")
Plug("L3MON4D3/LuaSnip")
Plug("VonHeikemen/lsp-zero.nvim", { ["branch"] = "v3.x" })
Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")
-- Telescope
-- XXX: Telescope live_grep requires "ripgrep" to be installed
-- https://github.com/BurntSushi/ripgrep
Plug("nvim-telescope/telescope.nvim", { ["branch"] = "0.1.x" })
Plug("rmagatti/goto-preview") -- Ctrl+Shift+I
Plug("rhysd/git-messenger.vim") -- See git blames with :GitMessenger
Plug("folke/todo-comments.nvim") -- Highlighting for comments
Plug("tranvansang/octave.vim") -- GNU Octave language highlighting
vim.call("plug#end")

--[[
	OPTIONS
]] --
--vim.cmd "colorscheme desert"
--vim.cmd "colorscheme industry"
vim.cmd "colorscheme vim"

-- For some reason I can't set the color specifically, but this resets the background color of popups
vim.cmd "hi NormalFloat guibg=None"
vim.cmd "hi Pmenu ctermbg=Gray"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.ic = true
vim.opt.scrolloff = 15
vim.cmd "set mps+=<:>"
vim.cmd "set splitright"
vim.opt.title = true
vim.cmd "set titlestring=%Y\\ %t%(\\ %M%)%(\\ (%{expand(\\\"%:~:.:h\\\")})%)%(\\ %a%)"

--[[
	KEYMAPS
]] --
local map = vim.keymap.set
vim.g.mapleader = " "

-- Insert mode maps
map("i", "<C-Tab>", "<Esc>gti")
map("i", "<C-S-Tab>", "<Esc>gTi")
map("i", "<C-s>", "<Esc>:w!<CR>a")
map("i", "<C-q>", "<Esc>:q<CR>")
map("i", "<C-d>", "<Esc>yyp$i")
map("i", "<C-x>", "<Esc>Vdi")
map("i", "<C-t>", "<Esc>:tabnew ")
map("i", "<F18>", vim.lsp.buf.rename) -- Shift + F6

-- Same as above, just for normal mode
map("n", "<Tab>", "gt")
map("n", "<S-Tab>", "gT")
map("n", "<C-s>", ":w!<CR>")
map("n", "<C-q>", ":q<CR>")
map("n", "<C-d>", "Vyp$")
map("n", "<C-x>", "Vd")
map("n", "<C-t>", ":tabnew ")
map("n", "<F18>", vim.lsp.buf.rename) -- Shift + F6

map("n", "?", vim.lsp.buf.hover)
map("n", "-", "/")
map("n", "<C-Down>", vim.diagnostic.goto_next)
map("n", "<C-j>", vim.diagnostic.goto_next)
map("n", "<C-Up>", vim.diagnostic.goto_prev)
map("n", "<C-k>", vim.diagnostic.goto_prev)

--[[
	PLUGIN stuff
]] --
local fen = require("fen")
fen.setup({
	no_write = false
})
map("n", "<Leader>f", fen.show)

local builtin = require("telescope.builtin")
map({"n", "i"}, "<C-S-n>", builtin.find_files, {})
map({"n", "i"}, "<C-S-f>", builtin.live_grep, {})
map({"n", "i"}, "<F54>", builtin.lsp_references, {}) -- Alt+F6

require("telescope").setup({
	defaults = {
		layout_config = {
			horizontal = { width = 0.99 }
		}
	}
})

local lsp_zero = require("lsp-zero")
lsp_zero.on_attach(function(_, bufnr)
	lsp_zero.default_keymaps({ buffer = bufnr })
end)

require("todo-comments").setup()
require("mason").setup({})

local gotoPreview = require("goto-preview")
map("n", "<C-S-i>", gotoPreview.goto_preview_definition, {noremap = true})
map("i", "<C-S-i>", gotoPreview.goto_preview_definition, {noremap = true})
gotoPreview.setup({
	border = {"╭", "─" ,"╮", "│", "╯", "─", "╰", "│"},
	stack_floating_preview_windows = false,
	width = 150,
	height = 30,
	post_open_hook = function (_, win)
		vim.api.nvim_feedkeys("0", 'n', false) -- Hack to make it always show the window instantly
		map("n", "<Esc>", -- Escape to close
			function ()
				vim.api.nvim_win_close(win, true)
			end,
			{buffer = true}
		)
	end
})


--[[
	LSP SETUP
]]
local lspconfig = require("lspconfig")
lspconfig.gopls.setup({})         -- Go
--lspconfig.clangd.setup({})      -- C/C++
lspconfig.ocamllsp.setup({})      -- OCaml
lspconfig.jdtls.setup({})         -- Java (Requires Java 17+ to be used, tldr: `sudo update-alternatives --config java`)
lspconfig.rust_analyzer.setup({}) -- Rust
lspconfig.elp.setup({})           -- Erlang (consumes heaps of memory! and pollutes the /tmp directory!)
lspconfig.lua_ls.setup({          -- Lua
	settings = {
		Lua = {
			diagnostics = { globals = { "vim", "fen" } }
		}
	}
})

-- Tab for autocomplete key map
local luasnip = require("luasnip")
local cmp = require("cmp")
cmp.setup({
	mapping = {
		["<Enter>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}
})
