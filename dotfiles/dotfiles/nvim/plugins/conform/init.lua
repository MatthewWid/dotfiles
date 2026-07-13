-- Formatting
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "Prettier" },
	config = function()
		local prettier_filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.tsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
			"json",
			"jsonc",
			"css",
			"html",
		}

		local formatters_by_ft = {}
		for _, ft in ipairs(prettier_filetypes) do
			formatters_by_ft[ft] = { "prettier" }
		end

		require("conform").setup({
			formatters_by_ft = formatters_by_ft,
			format_on_save = function(bufnr)
				if vim.tbl_contains(prettier_filetypes, vim.bo[bufnr].filetype) then
					return { timeout_ms = 500, lsp_format = "fallback" }
				end
			end,
		})

		require("plugins.conform.keymaps").setup_commands()
	end,
}
