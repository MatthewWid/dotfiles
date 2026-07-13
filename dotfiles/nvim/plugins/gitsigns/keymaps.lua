local M = {}

function M.on_attach(bufnr)
	local gitsigns = require("gitsigns")
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
	end

	-- Jump to next and previous hunks (silently, no "Hunk X of Y" echo)
	map("n", "]g", function()
		gitsigns.nav_hunk("next", { navigation_message = false })
	end, "Next hunk")
	map("n", "[g", function()
		gitsigns.nav_hunk("prev", { navigation_message = false })
	end, "Prev hunk")
end

return M
