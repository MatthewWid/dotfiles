local M = {}

M.keys = {
	{ "<leader>H", function() require("grug-far").open() end, desc = "Search and replace" },
	-- May not register as distinct from <C-f> in some terminals — Shift
	-- doesn't change the control byte sent for Ctrl+letter unless the
	-- terminal/tmux support the Kitty keyboard protocol or similar
	{ "<C-S-f>", function() require("grug-far").open() end, desc = "Search and replace" },
	{
		"<leader>hw",
		function()
			require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
		end,
		desc = "Search and replace word",
	},
	{
		"<leader>hw",
		function()
			require("grug-far").with_visual_selection()
		end,
		mode = "v",
		desc = "Search and replace selection",
	},
	{
		"<leader>h",
		function()
			require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
		end,
		desc = "Search and replace in buffer",
	},
}

return M
