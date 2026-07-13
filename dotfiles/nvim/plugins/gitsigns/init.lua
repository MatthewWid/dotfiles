-- Show git diff in sign column and blame inline (replaces vim-gitgutter)
return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("gitsigns").setup({
			-- Inline blame disabled, too noisy; re-enable by uncommenting
			-- current_line_blame = true,
			-- current_line_blame_opts = {
			-- 	delay = 300,
			-- 	virt_text_pos = "eol",
			-- },
			on_attach = require("plugins.gitsigns.keymaps").on_attach,
		})
	end,
}
