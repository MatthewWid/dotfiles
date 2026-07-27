local M = {}

M.keys = {
	{ "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
	{ "<C-f>", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
	{ "<C-_>", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search buffer" },
}

return M
