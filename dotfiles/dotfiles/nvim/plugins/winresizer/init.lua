-- Easy window/buffer resizing
return {
	"simeji/winresizer",
	event = "VeryLazy",
	init = function()
		-- Enter resize mode with C-w-r
		vim.g.winresizer_start_key = "<C-w>r"
		-- Increase vertical resize increment
		vim.g.winresizer_vert_resize = "5"
	end,
}
