-- Nord colour scheme for NeoVim
return {
	"shaunsingh/nord.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd.colorscheme("nord")
	end,
}
