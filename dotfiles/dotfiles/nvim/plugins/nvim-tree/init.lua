-- Sidebar file explorer with icons and git diff signs
return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
	keys = require("plugins.nvim-tree.keymaps").keys,
	init = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
	end,
	config = function()
		require("nvim-tree").setup({
			on_attach = require("plugins.nvim-tree.keymaps").on_attach,
			view = {
				number = true,
				relativenumber = true,
			},
			ui = {
				confirm = {
					remove = false,
					trash = false,
				},
			},
			actions = {
				open_file = {
					resize_window = true,
				},
			},
		})

		require("plugins.nvim-tree.keymaps").setup_commands()
	end,
}
