-- Official Copilot plugin
return {
	"github/copilot.vim",
	event = "InsertEnter",
	init = function()
		vim.g.copilot_no_tab_map = true
	end,
	config = function()
		require("plugins.copilot.keymaps").setup()
		-- copilot.vim's own startup logic (which starts its background Node
		-- agent) is wired to VimEnter inside its own plugin script. Since
		-- we lazy-load on InsertEnter, that script isn't sourced until
		-- after VimEnter has already fired, so the real init call is
		-- silently skipped — this is why suggestions previously only
		-- started after manually running :Copilot status. copilot#Init()
		-- is idempotent (safe to call any time), so call it ourselves here.
		vim.fn["copilot#Init"]()
	end,
}
