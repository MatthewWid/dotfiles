local M = {}

M.keys = {
	{ "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
	{ "<C-f>", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
	{ "<C-_>", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search buffer" },
}

function M.setup_commands()
	-- :B to :Buffers
	vim.api.nvim_create_user_command("B", "Telescope buffers", {})
	-- :G to git modified files
	vim.api.nvim_create_user_command("G", "Telescope git_status", {})
end

return M
