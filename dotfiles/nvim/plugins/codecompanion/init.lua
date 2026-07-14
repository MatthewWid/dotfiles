-- AI productivity tools
return {
	"olimorris/codecompanion.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
	cmd = { "CodeCompanion", "CodeCompanionChat", "CC", "Cc", "C", "CCc", "Ccc", "Ch", "Ccl" },
	config = function()
		require("codecompanion").setup({
			interactions = {
				chat = {
					opts = {
						completion_provider = "nvim-cmp",
					},
				},
			},
			-- claude_code, copilot_acp, etc. are all pre-registered presets;
			-- no explicit `adapters` config needed unless overriding one
			strategies = {
				chat = {
					adapter = "copilot_acp",
				},
				inline = {
					adapter = "copilot_acp",
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
