local M = {}

function M.setup_commands()
	-- :Prettier to force formatting only with Prettier
	vim.api.nvim_create_user_command("Prettier", function()
		require("conform").format({ formatters = { "prettier" } })
	end, {})

	-- :P to format the currently open file
	vim.api.nvim_create_user_command("P", function()
		require("conform").format({ lsp_format = "fallback" })
	end, {})
end

return M
