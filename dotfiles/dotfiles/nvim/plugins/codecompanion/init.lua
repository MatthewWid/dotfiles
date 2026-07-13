-- AI productivity tools
return {
	"olimorris/codecompanion.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
	cmd = { "CodeCompanion", "CodeCompanionChat", "CC", "Cc", "CCc", "Ccc", "Ch" },
	config = function()
		require("codecompanion").setup({
			interactions = {
				chat = {
					opts = {
						completion_provider = "nvim-cmp",
					},
				},
			},
			strategies = {
				chat = {
					adapter = "copilot",
				},
				inline = {
					adapter = "copilot",
				},
			},
			display = {
				chat = {
					window = {
						position = "right",
					},
				},
			},
		})

		require("plugins.codecompanion.keymaps").setup_commands()
	end,
}
