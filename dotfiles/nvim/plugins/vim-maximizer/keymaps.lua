local M = {}

M.keys = {
	-- Ctrl+W + Z toggle-maximizes active split window
	{ "<C-w>z", "<cmd>MaximizerToggle<CR>", desc = "Toggle maximize split" },
}

return M
