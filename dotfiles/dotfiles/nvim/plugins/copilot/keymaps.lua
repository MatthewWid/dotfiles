local M = {}

function M.setup()
	-- Remap accept Copilot suggestion to <C-\>
	vim.keymap.set("i", "<C-\\>", 'copilot#Accept("\\<CR>")', { silent = true, expr = true, script = true })
end

return M
