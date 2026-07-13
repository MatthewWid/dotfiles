-- Show colours next to hex strings
return {
	"rrethy/vim-hexokinase",
	build = "make hexokinase",
	event = "VeryLazy",
	init = function()
		-- Put colour in square next to code
		vim.g.Hexokinase_highlighters = { "virtual" }
		-- Match patterns for colours
		vim.g.Hexokinase_optInPatterns = "full_hex,rgb,rgba,hsl,hsla,colour_names,triple_hex"
	end,
}
