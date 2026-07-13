-- Smarter syntax highlighting
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"json",
				"json5",
				"jsonc",
				"jsonnet",
				"javascript",
				"typescript",
				"tsx",
				"jsdoc",
				"lua",
				"vim",
				"terraform",
				"regex",
				"nginx",
				"markdown",
				"markdown_inline",
				"git_rebase",
				"gitcommit",
				"dockerfile",
				"csv",
				"c_sharp",
				"bash",
				"astro",
			},
			sync_install = true,
			auto_install = false,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
			},
		})
	end,
}
