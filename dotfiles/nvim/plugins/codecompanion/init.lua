-- AI productivity tools
return {
	"olimorris/codecompanion.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
	cmd = { "CodeCompanion", "CodeCompanionChat", "CC", "Cc", "CCc", "Ccc", "Ch", "Ccl" },
	config = function()
		require("codecompanion").setup({
			interactions = {
				chat = {
					opts = {
						completion_provider = "nvim-cmp",
					},
				},
			},
			adapters = {
				acp = {
					-- Spawns the `claude` CLI via ACP. No auth config needed:
					-- it inherits whatever `claude login` session is already
					-- active, same as running `claude` in a terminal.
					claude_code = function()
						return require("codecompanion.adapters").extend("claude_code", {})
					end,
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
