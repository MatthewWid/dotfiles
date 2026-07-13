-- Extremely fast fuzzy finder for files, text and everything else
return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	cmd = "Telescope",
	keys = require("plugins.telescope.keymaps").keys,
	config = function()
		local actions = require("telescope.actions")
		require("telescope").setup({
			defaults = {
				sorting_strategy = "ascending",
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top" },
				file_ignore_patterns = {
					"%.pyc",
					"%.o",
					"%.obj",
					"%.svn",
					"%.class",
					"%.hg",
					"%.DS_Store",
					"%.min%.",
					"%.git/",
					"%.cache/",
					"node_modules/",
					"dist/",
					"build/",
					"out/",
				},
				-- C-i and C-v to open selected result in horizontal and vertical splits
				-- C-j and C-k to move down and up the results list (fzf-style)
				mappings = {
					i = {
						["<C-i>"] = actions.select_horizontal,
						["<C-v>"] = actions.select_vertical,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
					},
				},
			},
		})
		require("telescope").load_extension("fzf")

		require("plugins.telescope.keymaps").setup_commands()
	end,
}
