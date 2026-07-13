local M = {}

function M.setup_commands()
	-- Shortcuts to CodeCompanion commands
	vim.api.nvim_create_user_command("CC", "CodeCompanion", {})
	vim.api.nvim_create_user_command("Cc", "CodeCompanion", {})
	vim.api.nvim_create_user_command("CCc", "CodeCompanionChat", {})
	vim.api.nvim_create_user_command("Ccc", "CodeCompanionChat", {})
	vim.api.nvim_create_user_command("Ch", "CodeCompanionChat", {})
end

return M
