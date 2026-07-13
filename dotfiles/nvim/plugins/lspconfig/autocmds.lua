local M = {}

function M.setup()
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			require("plugins.lspconfig.keymaps").on_attach(args.buf)
		end,
	})
end

return M
