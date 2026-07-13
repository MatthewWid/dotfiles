local M = {}

M.keys = {
	{ "<C-b>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
}

function M.on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	api.config.mappings.default_on_attach(bufnr)

	-- s or i to open file in horizontal or vertical split
	vim.keymap.set("n", "s", api.node.open.vertical, opts("Open: Vertical Split"))
	vim.keymap.set("n", "i", api.node.open.horizontal, opts("Open: Horizontal Split"))

	-- t to open file in new tab
	vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))

	-- l to open file or directory
	vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))

	-- h to close directory
	vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))

	-- C-e back to default (move view down by 1 line)
	vim.keymap.del("n", "<C-e>", { buffer = bufnr })
end

function M.setup_commands()
	-- Open file explorer to current file
	vim.api.nvim_create_user_command("Nf", "NvimTreeFindFile", {})
end

return M
