-- Official Copilot plugin
return {
	"github/copilot.vim",
	event = "InsertEnter",
	init = function()
		vim.g.copilot_no_tab_map = true
	end,
	config = function()
		require("plugins.copilot.keymaps").setup()
	end,
}
