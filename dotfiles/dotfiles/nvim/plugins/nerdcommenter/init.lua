-- \cc to comment out a highlighted section of code
return {
	"preservim/nerdcommenter",
	keys = require("plugins.nerdcommenter.keymaps").keys,
	init = function()
		-- Add spaces after comment delimiters
		vim.g.NERDSpaceDelims = 1
		-- Add comment delimiters to empty lines, too
		vim.g.NERDCommentEmptyLines = 1
	end,
}
