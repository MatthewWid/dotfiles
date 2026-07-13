-- :MarkdownPreview to preview markdown files in your browser
return {
	"iamcco/markdown-preview.nvim",
	ft = { "markdown" },
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
	init = function()
		-- Default to light mode
		vim.g.mkdp_theme = "light"
		-- Don't close preview when closing buffer
		vim.g.mkdp_auto_close = 0
	end,
}
