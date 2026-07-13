local M = {}

function M.on_attach(bufnr)
	local gitsigns = require("gitsigns")
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
	end

	-- Jump to next and previous hunks
	map("n", "]g", function()
		gitsigns.nav_hunk("next")
	end, "Next hunk")
	map("n", "[g", function()
		gitsigns.nav_hunk("prev")
	end, "Prev hunk")
end

return M
